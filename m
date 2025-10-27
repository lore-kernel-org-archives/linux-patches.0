Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B390F31E0F2;
	Mon, 27 Oct 2025 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590633; cv=none; b=KJamRGiG2Dm1DIc6Vc5PA4F0QMtL1Oewqxzc5uWnas4g6CTzi+6DHhxBAwS+KjY3vTG9xakPYtu3Kyk4ZK1EhlUPHzzC2tveUzvW3WaN33UyuQZOUVIXFTZ0pc9k3owsIYR9Xh1Emv13ucn/0m7ZfHlgwhnO7vyhqcYCkbnZNDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590633; c=relaxed/simple;
	bh=eLJoAI8eJrAnUH2Q4Aw+HwfLKBRGv4rQ1rTFkkxJuJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWyW1xTU0wEdlR3PL6PkrvdSsaysrahnTRLpYerRkf/mTE0/n9IRVlc5wNzBH40oHKEGVF25/HGoXTk5G5Vczet8H0yefv4U7cm3EaQUe0JcIXVlyDhu8XWZY4OoUh6bfazDzIBe2ohRkKelXrKb8tPek6NmNFkeHNc3vDsqLm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px5sxAwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px5sxAwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479A2C4CEF1;
	Mon, 27 Oct 2025 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590633;
	bh=eLJoAI8eJrAnUH2Q4Aw+HwfLKBRGv4rQ1rTFkkxJuJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px5sxAwp7twgqyjxObqysk4bkuZP1cNu6VWn1u6D6YZh0XiYxaaDWUrjdvhCv54MS
	 D7JfH3H9Ushk9pERcTEqPnhXxqf7vlGGEtn/gJqRhioRR37U2Ue1cXIYQCj475lmHO
	 C62V6sTqt+dmnGfB0c4kRsbkkR71gjSoIPT2tOmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 119/224] mmc: core: SPI mode remove cmd7
Date: Mon, 27 Oct 2025 19:34:25 +0100
Message-ID: <20251027183512.170147864@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -868,7 +868,11 @@ static void mmc_sdio_remove(struct mmc_h
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


