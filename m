Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D5851DAEC;
	Wed, 23 Sep 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173800; cv=none; b=iuHajB8Z+YkGJnZSky1wUYY96U1uDCVUx0YmdLnG1mOIxuuP1qjp7ARrKPt/aOJtloSEYssCspVA1DEaoM3xKZuYGtmDb/YQ2LhKxTB1d2u5NCZGUh61yYtdgClWJAfmgM/U7k9dIcvgO6ef9f91bqg/24djMp4o9UplJJRsSV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173800; c=relaxed/simple;
	bh=HhKNJ5Er8QrnuVVpiu4a3gW1aAj7UEGKA3DqvBjYdzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqifXNG7h7yMG8Z6q0pIkca7DmieUCF5fyDcnVEJKbOo+dD+f0nogm2kOvXKxP9FmNzJd6i31YOuV9RKOZ5o8kLT8dGhrwlUj5DXf4+WGhaWavaQIIj4Zyv1rwj64Xy4/SoW7PdBW47DbAZk4PCESCpCB9IdGOz4kOv3CWjU0SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o2MnsLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o2MnsLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538041F000FF;
	Wed, 23 Sep 2026 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173798;
	bh=UQaXfMjg4fyU5xyNS7dYc7rMULrrIGI/6F+Nt5Rq/e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o2MnsLEgMehIUhrdjipoFs2Fni8LKzRX+hde23YPieR9FnIJ8ioQZely5OY4mNB+
	 XPJtK4QuuBSR+8HgJpL94aaB8NuavPwZfSShIbcgFg8IZp5hkAhLGkf5a5fvhnQRxj
	 xz16Jpq+TQhmqkj/CJnY0fdEvGafSEPlMbRhxxM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 348/438] mmc: spi: reset bytes_xfered before retrying CRC failures
Date: Wed, 23 Sep 2026 16:06:09 +0200
Message-ID: <20260923140653.838538032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


