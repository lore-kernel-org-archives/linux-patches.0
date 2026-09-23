Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7E153A3BF;
	Wed, 23 Sep 2026 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174994; cv=none; b=PeeWS/KM8uVI8HDt0SJ1yHen/pYKqVn9Uq9C970TN89GSJyKxyOooWOvpF/7AD3XyAfUkFUCQNj6zb8UwBsqE4tIoHq0tHjMFxB+9GTXTVmZKR9pjREo9+vQvsimTgyVkAB1xJ01zoXyKIIJ+fBInABRSXeo5XUBMocdsVAwOH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174994; c=relaxed/simple;
	bh=U72FDhcDJWXhPHvU6NMpoQItu8A945zUxRykofYWhCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYg+Joxw4saaGFdJgtrhVzo/U35K96mBvoD6VLIf+Z9mvFk81tGzBMgSw8f1GyWVizmRxGGzEex6SrmTmRQldYPxt/j/lJSVo7lALfyXCp/qjklVe3rhjvj1kCppoi4N6XD+D80FGQaLYCPzG2az8zEhobIu2i0n9ZAVbGo46/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwCphHYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwCphHYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A723B1F00893;
	Wed, 23 Sep 2026 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174993;
	bh=mu33MEXs/drqmWX0+FQkqZbxqUO34o3PUt18Gvtpx7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwCphHYB0juWifJJReTRtISDkpyyeQ3Pn8JxCvb1sxKXTkX4JnoKXIsxfnu7k4S2Z
	 3dNPvyfFnII8fjT3XWHhlwT+ulcPRTYoqpHsBHNdb9Hw7WM40XngylaQNrAFpNA6+t
	 w93rzQD/7r6yKYoWrnyvmA0kfscjt2pWEErAhvhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 289/398] mmc: spi: reset bytes_xfered before retrying CRC failures
Date: Wed, 23 Sep 2026 16:06:03 +0200
Message-ID: <20260923140650.912306723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 8b0cc8707f65e0f51912e764e1b309b2559db1ec upstream.

mmc_spi_data_do() updates data->bytes_xfered after each block has been
transferred successfully.  If a later block in the same data request
fails with a CRC error, data->bytes_xfered may therefore contain the
number of bytes completed before the failing block.

mmc_spi_request() has a private recovery path for such CRC failures.  It
sends STOP_TRANSMISSION, clears data->error and jumps back to
crc_recover to issue the same command and data request again.  However,
it does not clear data->bytes_xfered before the retry.

If the retry succeeds, the request is completed with the bytes from the
failed attempt still included in data->bytes_xfered.  For a multi-block
request this can make the completed request report more bytes than were
transferred by the successful retry, and can even exceed the request size
when most blocks completed before the CRC error.

This is most likely to be observed on MMC-over-SPI systems where long
multi-block transfers occasionally hit a data CRC error but the
mmc_spi-internal retry succeeds.  The data itself is retried, but the
completion accounting is not.

Clear data->bytes_xfered together with data->error before repeating the
request so the final completion reports only the bytes transferred by the
successful attempt.

Fixes: 061c6c847eeb ("mmc_spi: Recover from CRC errors for r/w operation over SPI.")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmc_spi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -952,6 +952,7 @@ crc_recover:
 			status = mmc_spi_command_send(host, mrq, &stop, 0);
 			crc_retry--;
 			mrq->data->error = 0;
+			mrq->data->bytes_xfered = 0;
 			goto crc_recover;
 		}
 


