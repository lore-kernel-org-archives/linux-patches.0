Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A545825DD12;
	Tue, 25 Mar 2025 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906409; cv=none; b=CAQa7E419Zt+axs1Yw9qOT8Z9PviwDpb2w9z08agM9MSY8w+unAoOc4/pvjgfSjJCHLP9f1qVXbYsH8iDZdK2l0l79aGzMdJM8u4KrR9AeXvTI/Of+bvbVnutZ600BanxqShlj3XNekSFSVeDmR6RLG7rD7dbFITWEEAereEW0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906409; c=relaxed/simple;
	bh=G68uwORXpDNBiDQGHeilvzG2VtA+ZTT4PQ7JBf3z+H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGh8XIYBc3mrMyQQp+3N6Ihy9Tn5blt8wFBAhMjVmT3j/0pn42CdSe3KLZJNzuvq2+zG44XXx5xNJqOFwZxmkvi11DHNbhdT0Iidp9rWjua1stWgIg+uiqrxLaiYBRzJ7KQpHQ68v/lPMKdF42uUi/1TBSsB7g27TSgyw+Cqg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUhJD3Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUhJD3Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C79DC4CEE4;
	Tue, 25 Mar 2025 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906409;
	bh=G68uwORXpDNBiDQGHeilvzG2VtA+ZTT4PQ7JBf3z+H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUhJD3ZeCSmrPwiV67PgGwRVijGFp3PPixpfLbtn9emGfPkM0GuqpEfuZXchBUH5J
	 wsfptvNK5FsmJAXzz1P++8PxomPj6B5bz/LTpRf78oiYFLqz1tzU0Sb3iYpN4GxFwc
	 Tg8eqeAeRJOj7syg1y472V5TjiEFM7YCkhaqvoLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 072/116] mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops
Date: Tue, 25 Mar 2025 08:22:39 -0400
Message-ID: <20250325122151.050769267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


