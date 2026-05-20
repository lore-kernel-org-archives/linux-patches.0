Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546222628D;
	Wed, 20 May 2026 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298237; cv=none; b=dtAI7v+UfIyy5GLcn+3Vie2e/jvxTAxBDrB/e4dJazBmwncd/+p+ya+wP60V6flHqeq5yMhYgy1tQ0ug1cIMuqJQbxGa7vZ3Yiog0c1JyYYO343SF9ps7ylx3txZznL2Shm9f8XDTmk/v4rulnRNl0V4E12vkpJHP+Pkb36Vl4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298237; c=relaxed/simple;
	bh=dUjDRf1QNhCAwjImsQJkEqRPjtZuFPdiZpj0GU4hbFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OuYdK3ZJxS/v5r91/KRa9eBm5piUtoKEjTNVXjlmaM+DlGF02kr+k8qzmspbTpJN7MkzsnfDMVGJhazQ4LqOR8qudk10n3Txx1NHzr2Tdf//Msy6ndxH779wtZqB/6j0Fng8cPKMJMtDEYrHfSIKl9IeXrA0PtFrXyW9MGnhiLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LPhCOVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LPhCOVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA671F000E9;
	Wed, 20 May 2026 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298236;
	bh=GaDXCjATXjAXPUdo2VdaZ5rFoFrkqBGUOm2ocPRmabo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2LPhCOVSvPSMM+wHp4WQGFvWlkBNXEmmDwhwrdRiomRg80rodF6jLFtEHhXEgQnzM
	 2dy2W7CpbmXVa7BfzS10Gb8D2CGy+Zik8xBUj7qghSHkPRygU4dm9Dqkm20O4WszjC
	 KHbs2eVq+D09vzmHjr3bYfMOO0DcCpT1gwRpCjXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/957] ALSA: sc6000: Keep the programmed board state in card-private data
Date: Wed, 20 May 2026 18:13:37 +0200
Message-ID: <20260520162141.774389822@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit fb79bf127ac2577b4876132da6dba768018aad4c ]

The driver may auto-select IRQ and DMA resources at probe time, but
sc6000_init_board() still derives the SC-6000 soft configuration from
the module parameter arrays.  When irq=auto or dma=auto is used, the
codec is created with the selected resources while the board is
programmed with the unresolved values.

Store the mapped ports and generated SC-6000 board configuration in
card-private data, build that configuration from the live probe
results instead of the raw module parameters, and keep the probe-time
board programming in a shared helper.

This fixes the resource-programming mismatch and leaves the driver
with a stable board-state block that can be reused by suspend/resume.

Fixes: c282866101bf ("ALSA: sc6000: add support for SC-6600 and SC-7000")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260410-alsa-sc6000-pm-v1-1-4d9e95493d26@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sc6000.c | 152 +++++++++++++++++++++++++++------------------
 1 file changed, 92 insertions(+), 60 deletions(-)

diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 6d618cc2ba457..9949e06403f61 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -100,6 +100,15 @@ MODULE_PARM_DESC(joystick, "Enable gameport.");
 #define PFX "sc6000: "
 #define DRV_NAME "SC-6000"
 
+struct snd_sc6000 {
+	char __iomem *vport;
+	char __iomem *vmss_port;
+	u8 mss_config;
+	u8 config;
+	u8 hw_cfg[2];
+	bool old_dsp;
+};
+
 /* hardware dependent functions */
 
 /*
@@ -267,7 +276,7 @@ static int sc6000_dsp_reset(char __iomem *vport)
 
 /* detection and initialization */
 static int sc6000_hw_cfg_write(struct device *devptr,
-			       char __iomem *vport, const int *cfg)
+			       char __iomem *vport, const u8 *cfg)
 {
 	if (sc6000_write(devptr, vport, COMMAND_6C) < 0) {
 		dev_warn(devptr, "CMD 0x%x: failed!\n", COMMAND_6C);
@@ -353,8 +362,7 @@ static int sc6000_init_mss(struct device *devptr,
 	return 0;
 }
 
-static void sc6000_hw_cfg_encode(struct device *devptr,
-				 char __iomem *vport, int *cfg,
+static void sc6000_hw_cfg_encode(struct device *devptr, u8 *cfg,
 				 long xport, long xmpu,
 				 long xmss_port, int joystick)
 {
@@ -376,27 +384,83 @@ static void sc6000_hw_cfg_encode(struct device *devptr,
 	dev_dbg(devptr, "hw cfg %x, %x\n", cfg[0], cfg[1]);
 }
 
-static int sc6000_init_board(struct device *devptr,
-			     char __iomem *vport,
-			     char __iomem *vmss_port, int dev)
+static void sc6000_prepare_board(struct device *devptr,
+				 struct snd_sc6000 *sc6000,
+				 unsigned int dev, int xirq, int xdma)
+{
+	sc6000->mss_config = sc6000_irq_to_softcfg(xirq) |
+			     sc6000_dma_to_softcfg(xdma);
+	sc6000->config = sc6000->mss_config |
+			 sc6000_mpu_irq_to_softcfg(mpu_irq[dev]);
+	sc6000_hw_cfg_encode(devptr, sc6000->hw_cfg, port[dev], mpu_port[dev],
+			     mss_port[dev], joystick[dev]);
+}
+
+static void sc6000_detect_old_dsp(struct device *devptr,
+				  struct snd_sc6000 *sc6000)
+{
+	sc6000_write(devptr, sc6000->vport, COMMAND_5C);
+	sc6000->old_dsp = sc6000_read(sc6000->vport) < 0;
+}
+
+static int sc6000_program_board(struct device *devptr,
+				struct snd_sc6000 *sc6000)
+{
+	int err;
+
+	if (!sc6000->old_dsp) {
+		if (sc6000_hw_cfg_write(devptr, sc6000->vport,
+					sc6000->hw_cfg) < 0) {
+			dev_err(devptr, "sc6000_hw_cfg_write: failed!\n");
+			return -EIO;
+		}
+	}
+
+	err = sc6000_setup_board(devptr, sc6000->vport, sc6000->config);
+	if (err < 0) {
+		dev_err(devptr, "sc6000_setup_board: failed!\n");
+		return -ENODEV;
+	}
+
+	sc6000_dsp_reset(sc6000->vport);
+
+	if (!sc6000->old_dsp) {
+		sc6000_write(devptr, sc6000->vport, COMMAND_60);
+		sc6000_write(devptr, sc6000->vport, 0x02);
+		sc6000_dsp_reset(sc6000->vport);
+	}
+
+	err = sc6000_setup_board(devptr, sc6000->vport, sc6000->config);
+	if (err < 0) {
+		dev_err(devptr, "sc6000_setup_board: failed!\n");
+		return -ENODEV;
+	}
+
+	err = sc6000_init_mss(devptr, sc6000->vport, sc6000->config,
+			      sc6000->vmss_port, sc6000->mss_config);
+	if (err < 0) {
+		dev_err(devptr, "Cannot initialize Microsoft Sound System mode.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int sc6000_init_board(struct device *devptr, struct snd_sc6000 *sc6000)
 {
 	char answer[15];
 	char version[2];
-	int mss_config = sc6000_irq_to_softcfg(irq[dev]) |
-			 sc6000_dma_to_softcfg(dma[dev]);
-	int config = mss_config |
-		     sc6000_mpu_irq_to_softcfg(mpu_irq[dev]);
 	int err;
-	int old = 0;
 
-	err = sc6000_dsp_reset(vport);
+	err = sc6000_dsp_reset(sc6000->vport);
 	if (err < 0) {
 		dev_err(devptr, "sc6000_dsp_reset: failed!\n");
 		return err;
 	}
 
 	memset(answer, 0, sizeof(answer));
-	err = sc6000_dsp_get_answer(devptr, vport, GET_DSP_COPYRIGHT, answer, 15);
+	err = sc6000_dsp_get_answer(devptr, sc6000->vport, GET_DSP_COPYRIGHT,
+				    answer, 15);
 	if (err <= 0) {
 		dev_err(devptr, "sc6000_dsp_copyright: failed!\n");
 		return -ENODEV;
@@ -408,54 +472,17 @@ static int sc6000_init_board(struct device *devptr,
 	if (strncmp("SC-6000", answer, 7))
 		dev_warn(devptr, "Warning: non SC-6000 audio card!\n");
 
-	if (sc6000_dsp_get_answer(devptr, vport, GET_DSP_VERSION, version, 2) < 2) {
+	if (sc6000_dsp_get_answer(devptr, sc6000->vport,
+				  GET_DSP_VERSION, version, 2) < 2) {
 		dev_err(devptr, "sc6000_dsp_version: failed!\n");
 		return -ENODEV;
 	}
 	dev_info(devptr, "Detected model: %s, DSP version %d.%d\n",
 		answer, version[0], version[1]);
 
-	/* set configuration */
-	sc6000_write(devptr, vport, COMMAND_5C);
-	if (sc6000_read(vport) < 0)
-		old = 1;
-
-	if (!old) {
-		int cfg[2];
-		sc6000_hw_cfg_encode(devptr,
-				     vport, &cfg[0], port[dev], mpu_port[dev],
-				     mss_port[dev], joystick[dev]);
-		if (sc6000_hw_cfg_write(devptr, vport, cfg) < 0) {
-			dev_err(devptr, "sc6000_hw_cfg_write: failed!\n");
-			return -EIO;
-		}
-	}
-	err = sc6000_setup_board(devptr, vport, config);
-	if (err < 0) {
-		dev_err(devptr, "sc6000_setup_board: failed!\n");
-		return -ENODEV;
-	}
-
-	sc6000_dsp_reset(vport);
-
-	if (!old) {
-		sc6000_write(devptr, vport, COMMAND_60);
-		sc6000_write(devptr, vport, 0x02);
-		sc6000_dsp_reset(vport);
-	}
+	sc6000_detect_old_dsp(devptr, sc6000);
 
-	err = sc6000_setup_board(devptr, vport, config);
-	if (err < 0) {
-		dev_err(devptr, "sc6000_setup_board: failed!\n");
-		return -ENODEV;
-	}
-	err = sc6000_init_mss(devptr, vport, config, vmss_port, mss_config);
-	if (err < 0) {
-		dev_err(devptr, "Cannot initialize Microsoft Sound System mode.\n");
-		return -ENODEV;
-	}
-
-	return 0;
+	return sc6000_program_board(devptr, sc6000);
 }
 
 static int snd_sc6000_mixer(struct snd_wss *chip)
@@ -538,10 +565,10 @@ static int snd_sc6000_match(struct device *devptr, unsigned int dev)
 
 static void snd_sc6000_free(struct snd_card *card)
 {
-	char __iomem *vport = (char __force __iomem *)card->private_data;
+	struct snd_sc6000 *sc6000 = card->private_data;
 
-	if (vport)
-		sc6000_setup_board(card->dev, vport, 0);
+	if (sc6000->vport)
+		sc6000_setup_board(card->dev, sc6000->vport, 0);
 }
 
 static int __snd_sc6000_probe(struct device *devptr, unsigned int dev)
@@ -552,15 +579,17 @@ static int __snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	int xirq = irq[dev];
 	int xdma = dma[dev];
 	struct snd_card *card;
+	struct snd_sc6000 *sc6000;
 	struct snd_wss *chip;
 	struct snd_opl3 *opl3;
 	char __iomem *vport;
 	char __iomem *vmss_port;
 
 	err = snd_devm_card_new(devptr, index[dev], id[dev], THIS_MODULE,
-				0, &card);
+				sizeof(*sc6000), &card);
 	if (err < 0)
 		return err;
+	sc6000 = card->private_data;
 
 	if (xirq == SNDRV_AUTO_IRQ) {
 		xirq = snd_legacy_find_free_irq(possible_irqs);
@@ -587,7 +616,7 @@ static int __snd_sc6000_probe(struct device *devptr, unsigned int dev)
 		dev_err(devptr, "I/O port cannot be iomapped.\n");
 		return -EBUSY;
 	}
-	card->private_data = (void __force *)vport;
+	sc6000->vport = vport;
 
 	/* to make it marked as used */
 	if (!devm_request_region(devptr, mss_port[dev], 4, DRV_NAME)) {
@@ -600,12 +629,15 @@ static int __snd_sc6000_probe(struct device *devptr, unsigned int dev)
 		dev_err(devptr, "MSS port I/O cannot be iomapped.\n");
 		return -EBUSY;
 	}
+	sc6000->vmss_port = vmss_port;
 
 	dev_dbg(devptr, "Initializing BASE[0x%lx] IRQ[%d] DMA[%d] MIRQ[%d]\n",
 		port[dev], xirq, xdma,
 		mpu_irq[dev] == SNDRV_AUTO_IRQ ? 0 : mpu_irq[dev]);
 
-	err = sc6000_init_board(devptr, vport, vmss_port, dev);
+	sc6000_prepare_board(devptr, sc6000, dev, xirq, xdma);
+
+	err = sc6000_init_board(devptr, sc6000);
 	if (err < 0)
 		return err;
 	card->private_free = snd_sc6000_free;
-- 
2.53.0



