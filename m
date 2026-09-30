Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9153BB138;
	Wed, 30 Sep 2026 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796378; cv=none; b=LeZcJ9PCYK90FEw2sS8mAZJcl0yk4d2TsP5yfV6AEZY6QNDnFWCaFRi79t+BaeQB7Yy8T1YqDxjtifJaWAnzRAit9NaSPkcBZ03SoW8ehaexcGfVROUUXJKo8MvPmtLVAVnWIeyGBW2cciA6zyXR91hDuqZYhIMfVHJQZHPGzpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796378; c=relaxed/simple;
	bh=jBMYCMOwwHjZyxJ92KeOa0pV2/6Tao2iVCs54SXkePc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaBaN95QsYHPsYDeHib9dJL8NRuGtlhYcjsClmmesqlueEtQYhZ4Q3QsD9PCCQoTZ793xsLvt2MZr/abO7i6mpauKICVadzzP6sYennhtd9ke2XcgC80xnSyHbaJ1W3jmMpcw+0t1QqkAg+anMM8hSLBmJezUK00pdJiFhHRahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZwsgiOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZwsgiOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B7E1F000FF;
	Wed, 30 Sep 2026 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796377;
	bh=lNK7aDtY9pY8vpZh1uvRzNgkY/4hgq6ExAwjtXMtAyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZwsgiOLp09Ontnr/4IAryG8y9vatcHdXRvuDi/TiPdYvISTEMAyndROXXgH6nw4T
	 5ryfMjH0m9n0p4eHkuv96f23KzJSpJn88Yr52l5jRFq0ROzey4ID2e8olu0xwdDsaN
	 YdL1wh/MYgL5PgdLuiWMuALwiPpcXC08KyVAPt68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0891/1193] mmc: spi: reset bytes_xfered before retrying CRC failures
Date: Wed, 30 Sep 2026 17:26:15 +0200
Message-ID: <20260930152454.041199149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -954,6 +954,7 @@ crc_recover:
 			status = mmc_spi_command_send(host, mrq, &stop, 0);
 			crc_retry--;
 			mrq->data->error = 0;
+			mrq->data->bytes_xfered = 0;
 			goto crc_recover;
 		}
 


