Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4E324B2F;
	Mon, 27 Oct 2025 18:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591426; cv=none; b=hSpjap2/j78eokEkHOZQ5ScR6X1GN4OqDnpa4bL3jduVVU/rviCPdkTHmmpYfGZPUJlFGn7Pe+vd8MFWKVuIK7Tav8CBtZbjf0UxQoYGi+Aftw2ps5WBL3Bm0rkpclahHRenxrQbnZQpyQUUUyXCRFA60wd+49XbxPvsSsxmEUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591426; c=relaxed/simple;
	bh=eLZg7lAiZ3cbCpNDPlHW+9I2joBvgDMlIU9QrRoB3Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc0BuBGxbhJcNH6+GHPAL0CDR99TUSGrc4QdGRcqV0nL1DFdPTX343DwJ5xscU4ZsLIghXg8BYLPzzur31DPAJp28I44yyptARMBiIGPIkOhXs7Ynsp/MJgHRviS3HNBC9pTDuq9QFvIV+eUHdbcotrtL8iqSY2DClhfDPhwZ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csro5jqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csro5jqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DEBC4CEF1;
	Mon, 27 Oct 2025 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591426;
	bh=eLZg7lAiZ3cbCpNDPlHW+9I2joBvgDMlIU9QrRoB3Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csro5jqPZ7nEfDTBC8nGaHImCqG9QZojL4psJZ8XSi1vkF5fWTl+cT/67zA6ASmZo
	 iZZg3oL/C0fMzMBmJMV6mXZfUnhM/kGMMFa94Cp/oZcY30kH6qBB6XpWy/8hoGWmMo
	 Lo82pjTaZt/nhpGtUzISkbz2UyGVoHiCkJVBC8Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 152/332] mmc: core: SPI mode remove cmd7
Date: Mon, 27 Oct 2025 19:33:25 +0100
Message-ID: <20251027183528.645832378@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Chen <rex.chen_1@nxp.com>

commit fec40f44afdabcbc4a7748e4278f30737b54bb1a upstream.

SPI mode doesn't support cmd7, so remove it in mmc_sdio_alive() and
confirm if sdio is active by checking CCCR register value is available
or not.

Signed-off-by: Rex Chen <rex.chen_1@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250728082230.1037917-2-rex.chen_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -929,7 +929,11 @@ static void mmc_sdio_remove(struct mmc_h
  */
 static int mmc_sdio_alive(struct mmc_host *host)
 {
-	return mmc_select_card(host->card);
+	if (!mmc_host_is_spi(host))
+		return mmc_select_card(host->card);
+	else
+		return mmc_io_rw_direct(host->card, 0, 0, SDIO_CCCR_CCCR, 0,
+					NULL);
 }
 
 /*


