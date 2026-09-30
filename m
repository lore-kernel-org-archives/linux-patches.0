Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860144BFE77;
	Wed, 30 Sep 2026 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782935; cv=none; b=SWNZEzw/ue8P+nbgyC32iH7+fCIxCsl1tarJqYSyzyy2ZcF1ya9FhdK9ON/BTHg1PO5DbxoRVbGMvhlO4EiD23k9hUjKEws8Ym2/3FGRkuNJiEotwZeENF2sNLhFM+/7Kt52fdr6sYB2UzzrpjS2+A4G/E6sopX7hvWsP4ZtKNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782935; c=relaxed/simple;
	bh=TQRX6CX9sMeOq3TEo9xohdD9TpsnurFeiGb29gfImeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWp2JJdIy2xxdZ/rzdBhVhSDDISY3YZWop1HiIssAbfU269J95QEjg+veBBY+ZzudzopwXV6tKM5W4sA0CfYxWdnschADWf98zUTSoJlLlIVOsx5Oom7CXJN/uUcYdGS+PJjhFtzRcK1TpZylGn62XEPIpP7z5Rl79PM5ypthYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KORNHX+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KORNHX+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5126D1F00898;
	Wed, 30 Sep 2026 15:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782930;
	bh=pauEoEMxWjFCO+wYRBccpC4ZytlglVFK6rp8l8e67xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KORNHX+oGCYyHuMceDtlX55zj/rhF8h7Z8XZemjILbqYjohwCtqOG1g18rFXLqvFu
	 txyTlGUttZ5riQiKbzvdZlbyCcximLWmFgOn5jli5mdp2+2Q4YB55LvmbrcHpoK7bz
	 dq4uzxbNujG/2ht4py8/T1k1qNOz0I/cRVVxnkYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/595] ASoC: ux500: Program the MSP FIFO watermarks
Date: Wed, 30 Sep 2026 17:21:54 +0200
Message-ID: <20260930152352.483394916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2519439b4b5f6ee95879b1a44fc373127291b1e4 ]

The DMA engine is configured for four-element bursts, but the MSP
driver never programs the FIFO watermark register and instead depends
on its previous or reset value. The DB8500 DMA request protocol requires
the peripheral watermark to match the DMA packet size.

Program four-element receive and transmit watermarks when configuring
the first direction, before enabling MSP DMA requests.

Fixes: 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-9-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 2 ++
 sound/soc/ux500/ux500_msp_i2s.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 11a697d7074e6..86193f1583931 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -509,6 +509,8 @@ int ux500_msp_i2s_open(struct ux500_msp *msp,
 		old_reg &= ~mask;
 		new_reg |= old_reg;
 		writel(new_reg, msp->registers + MSP_GCR);
+		writel(MSP_WMRK_TX_4_ELEMENTS | MSP_WMRK_RX_4_ELEMENTS,
+		       msp->registers + MSP_WMRK);
 	}
 
 	res = enable_msp(msp, config, first);
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 983bc84fbf7e2..28a90207a4cb5 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -64,6 +64,7 @@ enum msp_direction {
 #define MSP_SRG		0x10
 #define MSP_FLR		0x14
 #define MSP_DMACR	0x18
+#define MSP_WMRK	0x1c
 
 #define MSP_IMSC	0x20
 #define MSP_RIS		0x24
@@ -230,6 +231,10 @@ enum msp_direction {
 #define RDMAE_SHIFT		0
 #define TDMAE_SHIFT		1
 
+/* FIFO watermark register */
+#define MSP_WMRK_RX_4_ELEMENTS	BIT(0)
+#define MSP_WMRK_TX_4_ELEMENTS	BIT(3)
+
 /* Interrupt Register */
 #define RX_SERVICE_INT		BIT(0)
 #define RX_OVERRUN_ERROR_INT	BIT(1)
-- 
2.53.0



