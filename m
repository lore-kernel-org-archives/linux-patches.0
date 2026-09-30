Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E3D51B174;
	Wed, 30 Sep 2026 17:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790837; cv=none; b=dRh86hk8r8o/MgfO0flLE/39L3BjAMkZAailU3ADkCbgecmHoh3fdnTaL1JGnl+zZsRZwKwdJiNJkQLL5uc8ZXj4DQ2+75jn6vibglP749GJ4NVkTCfSWE+nz5fIlH4OPjTjMgBeRdlG0lkOb91XGOdBO5icKSgmorAeW8K3oEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790837; c=relaxed/simple;
	bh=2zNGZfwIG3kvbP1VYq1earCTK/p5r/ljaMZwkJO8L1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sorUWPv4lNWW5thxLvPu2Bu+Ab311Rt/2XwSrSJw8AKev3E2McRUsj2DbO8LTDG5R8DzDqggmWMCVq2rXTr2YsjkTwaqefDdyeXB/K2Z88YLXdgk2D7hA+CJaxlTChPSPoz5k7wrt2IvzGUL3xMT8fRU8LTDl8il6y9Dd6V3pD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6aYk5H9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6aYk5H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BA81F000FF;
	Wed, 30 Sep 2026 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790835;
	bh=om3ViBOsl+//8D6SwKUNhbl7MYg/hEQ3UiF5AirXu80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6aYk5H9Jd3VElaankB2zcNWKfDB55CCEj2R2HJ4F38CMS7jhdLLvblzOSKFD3/Z/
	 7wbBxIxnkVCPFcwO25V9yBVY5Cn92VrteY4lVjatla5p47nWEvAAPLS0I+kHkBgV9n
	 XQ171IvclaCfCz8dmz1SXOoq5MRGkKSL84xQ/it4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/752] ASoC: Intel: catpt: Complete coredump handling
Date: Wed, 30 Sep 2026 17:19:22 +0200
Message-ID: <20260930152400.159717213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 7e5d59f407bc39d43b350cc45f7880647429eb5d ]

An exception may occur during the firmware booting procedure.  In such
case the firmware sends COREDUMP_REQUESTS and expects the driver to dump
relevant information and finish with the COREDUMP_RELEASE write.

To distinguish such situation from generic timeout, always signal
fw_ready completion when a coredump request is received and translate
it to -EREMOTEIO in catpt_boot_firmware().

The "FW READY" print makes the success clearly visible even when
the event-traces are not enabled.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260528083444.1439233-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/ipc.c       |  8 ++++++++
 sound/soc/intel/catpt/loader.c    |  3 +++
 sound/soc/intel/catpt/registers.h | 12 ++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/sound/soc/intel/catpt/ipc.c b/sound/soc/intel/catpt/ipc.c
index 5b718a846fda5..3341a3a190e62 100644
--- a/sound/soc/intel/catpt/ipc.c
+++ b/sound/soc/intel/catpt/ipc.c
@@ -205,6 +205,7 @@ static void catpt_dsp_process_response(struct catpt_dev *cdev, u32 header)
 		memcpy_fromio(&config, cdev->lpe_ba + off, sizeof(config));
 		trace_catpt_ipc_payload((u8 *)&config, sizeof(config));
 
+		dev_dbg(cdev->dev, "FW READY 0x%08x\n", header);
 		catpt_ipc_arm(ipc, &config);
 		complete(&cdev->fw_ready);
 		return;
@@ -215,6 +216,13 @@ static void catpt_dsp_process_response(struct catpt_dev *cdev, u32 header)
 		dev_err(cdev->dev, "ADSP device coredump received\n");
 		ipc->ready = false;
 		catpt_coredump(cdev);
+
+		if (catpt_readl_dram(cdev, COREDUMP) == CATPT_COREDUMP_REQUEST) {
+			dev_dbg(cdev->dev, "releasing firmware from the coredump state\n");
+			catpt_writel_dram(cdev, COREDUMP, CATPT_COREDUMP_RELEASE);
+		}
+
+		complete(&cdev->fw_ready);
 		/* TODO: attempt recovery */
 		break;
 
diff --git a/sound/soc/intel/catpt/loader.c b/sound/soc/intel/catpt/loader.c
index ff7b8f0d34ac7..6602587787cb4 100644
--- a/sound/soc/intel/catpt/loader.c
+++ b/sound/soc/intel/catpt/loader.c
@@ -626,6 +626,9 @@ int catpt_boot_firmware(struct catpt_dev *cdev, bool restore)
 	if (!ret) {
 		dev_err(cdev->dev, "firmware ready timeout\n");
 		return -ETIMEDOUT;
+	/* Wake up does not mean FW is ready, an exception could occur. */
+	} else if (!cdev->ipc.ready) {
+		return -EREMOTEIO;
 	}
 
 	/* update sram pg & clock once done booting */
diff --git a/sound/soc/intel/catpt/registers.h b/sound/soc/intel/catpt/registers.h
index 47280d82842eb..a6da59dff76ef 100644
--- a/sound/soc/intel/catpt/registers.h
+++ b/sound/soc/intel/catpt/registers.h
@@ -124,6 +124,11 @@
 #define CATPT_SSCR2_DEFAULT		0x0
 #define CATPT_SSPSP2_DEFAULT		0x0
 
+/* Coredump register and its states */
+#define CATPT_DRAM_COREDUMP		0x1F4
+#define CATPT_COREDUMP_REQUEST		UINT_MAX
+#define CATPT_COREDUMP_RELEASE		0
+
 /* Physically the same block, access address differs between host and dsp */
 #define CATPT_DSP_DRAM_OFFSET		0x400000
 #define catpt_to_host_offset(offset)	((offset) & ~(CATPT_DSP_DRAM_OFFSET))
@@ -137,6 +142,8 @@
 
 /* registry I/O helpers */
 
+#define catpt_dram_addr(cdev) \
+	((cdev)->lpe_ba + (cdev)->spec->host_dram_offset)
 #define catpt_shim_addr(cdev) \
 	((cdev)->lpe_ba + (cdev)->spec->host_shim_offset)
 #define catpt_dma_addr(cdev, dma) \
@@ -151,6 +158,11 @@
 #define catpt_writel_ssp(cdev, ssp, reg, val) \
 	writel(val, catpt_ssp_addr(cdev, ssp) + (reg))
 
+#define catpt_readl_dram(cdev, reg) \
+	readl(catpt_dram_addr(cdev) + CATPT_DRAM_##reg)
+#define catpt_writel_dram(cdev, reg, val) \
+	writel(val, catpt_dram_addr(cdev) + CATPT_DRAM_##reg)
+
 #define catpt_readl_shim(cdev, reg) \
 	readl(catpt_shim_addr(cdev) + CATPT_SHIM_##reg)
 #define catpt_writel_shim(cdev, reg, val) \
-- 
2.53.0



