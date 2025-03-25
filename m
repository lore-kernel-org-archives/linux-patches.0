Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9C7267B9B;
	Tue, 25 Mar 2025 12:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905861; cv=none; b=eQik3p49sxHsQVzF8Na0X0UbqknGzHWGzKDvJGR7py6my93rnoZyp5s1xHbznpgmn22szILLqnjb4L47eqSWhDMdlDRszZ2h0L+RDzGbi6Dc2W1o9Glk/KOgK38a0FCtM+Ei3KRhaAruEsStchz3oE740tgOMnGLqtm2Bm2UAS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905861; c=relaxed/simple;
	bh=RlUHZAqh7m2Gikk/ljHAKjY9DWF/1q/8E1NU00ANySw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/+Zcik8dU1FUGuUWQJzJQ8VRl/dFAgN83n8/92qm2CByM1Glg+w8gI4MIMggAJEAfoNeJ6wo3FSOH7ZZfzYevBw7NjhOasWBgf5+zgIFVUS4RKlHmzuASyob+UNCqGPhAw2HcY6UiafZsx9ttVwABWZ3b0EdF08kUILJ8xy2ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hz93LE/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hz93LE/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3199DC4CEE4;
	Tue, 25 Mar 2025 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905861;
	bh=RlUHZAqh7m2Gikk/ljHAKjY9DWF/1q/8E1NU00ANySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hz93LE/ul1GN/aT3Afp9AXfVwRkVEmb3bCVbmlnL79pU3Z/pArVTxmULpNszMG3qK
	 EGStxep5pXrRawiqT6Ph40gD7pFI3nY4I8q4f8rCWvPqCBurBAsuXXuUIYGW8qVBCR
	 BAXppaySc6TLRrX1xhsCQgTmOx/YJ9TrzIakdT4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 176/198] mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops
Date: Tue, 25 Mar 2025 08:22:18 -0400
Message-ID: <20250325122201.264983647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,8 +396,15 @@ static int sdhci_brcmstb_suspend(struct
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
 
@@ -422,6 +429,9 @@ static int sdhci_brcmstb_resume(struct d
 			ret = clk_set_rate(priv->base_clk, priv->base_freq_hz);
 	}
 
+	if (host->mmc->caps2 & MMC_CAP2_CQE)
+		ret = cqhci_resume(host->mmc);
+
 	return ret;
 }
 #endif


