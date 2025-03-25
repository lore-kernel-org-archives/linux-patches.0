Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C036426A0BF;
	Tue, 25 Mar 2025 12:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906151; cv=none; b=u6EPIU9pHCpUa3vZUrwqCa6oa5nDanGsO6LyBUBo8KpCiNTNb48+OnZhnLSiciECgC/LPbzW9qla15GsUtXzmuSG+GgsZL15HsqqVz8a5kLDzs4G8i3QjZ5gdMmjF0QtyJGVB8r3ezUyXThAqjRjIner6ZTPne2KgMBtIyhNXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906151; c=relaxed/simple;
	bh=Or6D7Dk+G1fpS13+ryBfAnhHtXo5hSmk6m+v23ouIZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I67rJ1Tcq8zidcRmLCgsK5QdZLmyL2CiOZ0Tw8ipxwGjTxYeDc3gFaBWTfGbJQx/ibyPnLSi0Sz4gCPFzDdiCPKKgleqywuP2s18nvvOW1VJW3oQVJZ2pXai/JKA7sbxU/FITKzz36jBzG+kKpFI3L6+s34F4YE0rVeDTn/WLNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3+hpvz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3+hpvz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1B2C4AF09;
	Tue, 25 Mar 2025 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906151;
	bh=Or6D7Dk+G1fpS13+ryBfAnhHtXo5hSmk6m+v23ouIZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3+hpvz+rigb9lyVCEEQ2b6GH9Grc5trHwaMyGrj45hZfch/M7EEpgv7U/wxSqIcU
	 RTMXkDwQ2jWHjkoamx/LBNBirFTVvsyCjCu213h/kBaA9dK6tZMmnAZ6mcjUdP5RqV
	 uINrN9lpqfapgvpLZMqRpQ3vsGs4XMIVTEaAZI50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 43/77] mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops
Date: Tue, 25 Mar 2025 08:22:38 -0400
Message-ID: <20250325122145.479841155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kamal Dasu <kamal.dasu@broadcom.com>

commit 723ef0e20dbb2aa1b5406d2bb75374fc48187daa upstream.

cqhci timeouts observed on brcmstb platforms during suspend:
  ...
  [  164.832853] mmc0: cqhci: timeout for tag 18
  ...

Adding cqhci_suspend()/resume() calls to disable cqe
in sdhci_brcmstb_suspend()/resume() respectively to fix
CQE timeouts seen on PM suspend.

Fixes: d46ba2d17f90 ("mmc: sdhci-brcmstb: Add support for Command Queuing (CQE)")
Cc: stable@vger.kernel.org
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20250311165946.28190-1-kamal.dasu@broadcom.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-brcmstb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -384,8 +384,15 @@ static int sdhci_brcmstb_suspend(struct
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_brcmstb_priv *priv = sdhci_pltfm_priv(pltfm_host);
+	int ret;
 
 	clk_disable_unprepare(priv->base_clk);
+	if (host->mmc->caps2 & MMC_CAP2_CQE) {
+		ret = cqhci_suspend(host->mmc);
+		if (ret)
+			return ret;
+	}
+
 	return sdhci_pltfm_suspend(dev);
 }
 
@@ -410,6 +417,9 @@ static int sdhci_brcmstb_resume(struct d
 			ret = clk_set_rate(priv->base_clk, priv->base_freq_hz);
 	}
 
+	if (host->mmc->caps2 & MMC_CAP2_CQE)
+		ret = cqhci_resume(host->mmc);
+
 	return ret;
 }
 #endif


