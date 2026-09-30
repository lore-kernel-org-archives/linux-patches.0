Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03A6503BDA;
	Wed, 30 Sep 2026 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785092; cv=none; b=EQhmJSRO6IWwDL+dBGI8z32jND9YNwU627KgCXUV7JQhNNB4nbAzhqSCJWiepcvm4VQ26fSHVhTVMRltAf4G3NO7XhN6jNJ6D4nTz+w4RSwexmar0D6byt5HAydjWai4OpZCTG07ZWM3YRMve4LI5Tt5HVR1wWpROyce1WWq+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785092; c=relaxed/simple;
	bh=Vg4zP6WrqkDieRVjiSJHn2thxA7JngsOYKRo8i5xd5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYg5fCkH7BCLVAs8dFD9L0saP3veHi5OeCuHwLc+HdizOPlq2c2/I+AR9BBr60vH/g+b9dSkPrPHvgLr3mozM3oHnzKDGF9nbsE6IB5/P0dQZfbKQo4KnvhLl7lm2ujYJuqMRT4RG6qnrQeEwWU1S2/uNjTlR1vh0OY2MFtjrj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlHFJTkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlHFJTkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F8D1F000FF;
	Wed, 30 Sep 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785084;
	bh=XAg/GhLdATqBouujboLq+hkg073FWG1y/5inuAnYdmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlHFJTkFahdjBm7Hge4O1LuPb70zF0RJQd3hfKMbE8iSsEGeSCh3Uzo8i41k4VYqL
	 VORRSgZBiawQutBhMpV7oCd8MFOBW7n1LlrwTD4EupZyaoK1cuDv0rVEqeG1bCD0nJ
	 QJOcJdjv6onoZFqvb213rU7ytBGdC5fLvBSV5kYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 383/982] ASoC: ux500: Program the MSP FIFO watermarks
Date: Wed, 30 Sep 2026 17:18:39 +0200
Message-ID: <20260930152425.035664721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 43dc9b3aa4ef5..683b485fb5708 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -507,6 +507,8 @@ int ux500_msp_i2s_open(struct ux500_msp *msp,
 		old_reg &= ~mask;
 		new_reg |= old_reg;
 		writel(new_reg, msp->registers + MSP_GCR);
+		writel(MSP_WMRK_TX_4_ELEMENTS | MSP_WMRK_RX_4_ELEMENTS,
+		       msp->registers + MSP_WMRK);
 	}
 
 	res = enable_msp(msp, config, first);
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 17b5c37a7e5d5..2bf2699bdc49f 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -62,6 +62,7 @@ enum msp_direction {
 #define MSP_SRG		0x10
 #define MSP_FLR		0x14
 #define MSP_DMACR	0x18
+#define MSP_WMRK	0x1c
 
 #define MSP_IMSC	0x20
 #define MSP_RIS		0x24
@@ -228,6 +229,10 @@ enum msp_direction {
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



