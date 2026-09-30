Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE863D9526;
	Wed, 30 Sep 2026 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794229; cv=none; b=l6qDYKQRbYX5jDv4cJpKHqhsznsGr1t82HXDaNVPqRfnSp+cR8GtaATrjDLOQGPWRJB8LCr+Lz5fizQR1PF5nuBS2c1iGmQQz6iIWF3Jq1rnzyMayyurJdRC7OmCELbcTA6D0nQU6AvCzreNfhLk01JW60KMa9wbwey28/tg8UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794229; c=relaxed/simple;
	bh=Ud2xHNQ2GlfzMsUTNgIux2TMcp8qm7fUrI5s/Ytm8oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK56SsL7poUsjEP7qTwKNvsXh0pwKOV+UWoSuPWrlwUPPGv3w4zlpPtzrFxOMvwGl6q0WeqgGw8FFsNAwpSxEcyYnTSGQk/ebsi3Ynygsj4frjJNCpCq8Gxv2Aq46SIzEn1wrw0AEb5QfEOd5oi/UXEvTnGuFZ89EMDHpnILdLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBZ9ljKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBZ9ljKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40E21F000FF;
	Wed, 30 Sep 2026 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794228;
	bh=t9XwBF8kUa3F/lLmTgS+K6eqLDsVoUjCOaa4wd/c3nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBZ9ljKlu8ChDsSjsjV6pQC3GyR3NbbVRiktSK1sMaULDnM96O8AT6zyFd97i4f3p
	 9C31JRPKpNriALCyfPDlK8uvTGrSRW5K580MYA8KPbvM4JyxGteG/M5ERORLN+70Va
	 H8spYcfRX2wiEzWojPIWvq67jZrHzZJGCVJ4vVH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0136/1193] ASoC: Intel: catpt: Complete coredump handling
Date: Wed, 30 Sep 2026 17:13:40 +0200
Message-ID: <20260930152437.233816316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



