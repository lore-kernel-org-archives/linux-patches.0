Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9F725522E;
	Tue, 25 Mar 2025 12:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905993; cv=none; b=rNaOvjrir75OWWZqbG8bJE0eXC6iIF26AXhBSPAq54g7opP9FvqeRmtW/d9s/b2eQPUpBu4yWjxesUFYatm+9mFcDkdMnzWFpk8lMc9wn2630F+ND5l05g6KdGHQtT70MbE1OW9o0BmxkTHawDbyF9UTxdYj6AIlEQ0F6oFd6UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905993; c=relaxed/simple;
	bh=YhBt0Ktrk6qRwT95rTa5TnX6Bs8W+zPSD2GKqdb0BiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7l10KmrInrXyFa8SdufSjYxXyc7sHOc1zcNNFif3k4MNI4QOTr874qltCG1/CCLu38Vo/otFJvxWjuPcd6PKMn+Dm1HD3VnhcSdjkpntT0tVU7Lc76oZARRKBOCM/FDJgLUqnJk1DBGxf0926ibyt4ndSa86w5SDK7eZcyoy5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXcB7W4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXcB7W4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389BFC4CEE4;
	Tue, 25 Mar 2025 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905993;
	bh=YhBt0Ktrk6qRwT95rTa5TnX6Bs8W+zPSD2GKqdb0BiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXcB7W4oNf56OdaDSCf1VoyM6HMHGRpWXr7xmdKu3qKMP9KH7qW8TKGjZZkfFuEYV
	 7rAV0Bh3GlW14mhdLCZUj/YYOf2U2pScl0dSnpA0fX8ZfZX2ABgsqwcnaaVc3u6w5x
	 TD/9/jYDXmlrtUNQaB0C8paJYThyDEUYia+DNEeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.13 076/119] mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops
Date: Tue, 25 Mar 2025 08:22:14 -0400
Message-ID: <20250325122150.997359607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -503,8 +503,15 @@ static int sdhci_brcmstb_suspend(struct
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
 
@@ -529,6 +536,9 @@ static int sdhci_brcmstb_resume(struct d
 			ret = clk_set_rate(priv->base_clk, priv->base_freq_hz);
 	}
 
+	if (host->mmc->caps2 & MMC_CAP2_CQE)
+		ret = cqhci_resume(host->mmc);
+
 	return ret;
 }
 #endif


