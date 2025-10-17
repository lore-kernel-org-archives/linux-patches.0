Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58568330B35;
	Fri, 17 Oct 2025 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716466; cv=none; b=MAKJAbwv2atC+KMWpPi4jcBMSXI/q+7OTko0om36wL2JlzCSjWngdGPJgo+NWDUSgHyESsLTqB37KHDsNFebjxMAPSM438hNyJSJrkMa2kfCPUhhm2Y/hcIO0bjKsgsx+rO+xpe1rrHpb1WBfCosfdDCIu2z3L1BiM/vxOCbIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716466; c=relaxed/simple;
	bh=hw8Xef75fcu+3caB9MD7llnN53Gvw0rFbhxc/M9BHZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKBRAygk862XeBNnPyxk/JpG0ScWi1PI7aGolPmGXuttWOjMdJI/ZhIIXb0a6nW/wuNw2/PAxU1RSM54m9LLI02Iy0WlSGdaP1gcdXTSVRXesh9sV2Wg/pnobx8JO4BWcpp/bc2OKePDLNlK+j6FxgOL032a/MEOHpSPgzjO6Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxB7qgXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxB7qgXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA426C4CEE7;
	Fri, 17 Oct 2025 15:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716466;
	bh=hw8Xef75fcu+3caB9MD7llnN53Gvw0rFbhxc/M9BHZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxB7qgXrC5hhHIivNVWzK73HmeAFSXYsMHyYuY9de9OyNOElCQC5rXpPi0hXxz+FS
	 oB5rZt4I5+R9+Su96lvFypf3Ja5b4fuYcpzR9XhRrvhR6dlQtWEbBryBdBMvp9pqxo
	 DZvWEylicjzz3+AQ0gtpTUPJiux0qIE3lpA63I3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Chen <rex.chen_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 200/276] mmc: core: SPI mode remove cmd7
Date: Fri, 17 Oct 2025 16:54:53 +0200
Message-ID: <20251017145149.771084458@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


