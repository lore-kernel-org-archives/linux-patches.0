Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D641F892A;
	Tue,  3 Dec 2024 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240612; cv=none; b=YhE3n5ae3XCk6ZSVLhbmCBEYg2bn0ypoPW1oFGAmGhB4QHVHWHWoEpaAOLpnpePPo4qiom+AAcr/Qnoppd16wr1HQ6jFcdFTyw5vdQ6YTUTMxL419OtSzP4y+4gLGDk+GazNTN+Gc2bCVuoTdjf3N/T+PkHH0XeuoulYLsLr29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240612; c=relaxed/simple;
	bh=yed/L6IeOAT3JaBIK4g1APOXL8RtpQdRW9pnegpyOY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awn9Wp6mzzj41xe5ihsqvuKSpO3velm2mJ5oMjwRnw4AQqiiTsYjWNqz6ckLVDCI78VVRoRQ0J14zDejk4JL+ekkt5/JmWhcFO16bI3PfbuI9LEIjy0gvr7kRO8V88sa9orxfYWQzvc8/qpFTJSv0l18kiPRnyCyOsbsjyHAnXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jB+qJcmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jB+qJcmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD327C4CED8;
	Tue,  3 Dec 2024 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240612;
	bh=yed/L6IeOAT3JaBIK4g1APOXL8RtpQdRW9pnegpyOY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jB+qJcmBwRqMpqEcQbksnnHCnkSNI3Ihz/LhPf9S1MVYM1AL+O7lp28gDjJbOQqK9
	 0Sj6hME6rexeNNcmmSxOdC5klNtxinm4SqF7wj+l8eY0fM68ts7WQbIZMVYmrxiYbG
	 UkGd+mIMaDdp0QoueAGMrmARCFRcBLLjGUbTGrpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/826] drm/vc4: hvs: Remove incorrect limit from hvs_dlist debugfs function
Date: Tue,  3 Dec 2024 15:38:34 +0100
Message-ID: <20241203144751.035801860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit d285bb622ebdfaa84f51df3a1abccb87036157ea ]

The debugfs function to dump dlists aborted at 256 bytes,
when actually the dlist memory is generally significantly
larger but varies based on SoC.

We already have the correct limit in __vc4_hvs_alloc, so
store it for use in the debugfs dlist function.

Fixes: c6dac00340fc ("drm/vc4: hvs: Add debugfs node that dumps the current display lists")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-19-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.h | 1 +
 drivers/gpu/drm/vc4/vc4_hvs.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index 08e29fa825635..d463fabf5ecce 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -315,6 +315,7 @@ struct vc4_hvs {
 	struct platform_device *pdev;
 	void __iomem *regs;
 	u32 __iomem *dlist;
+	unsigned int dlist_mem_size;
 
 	struct clk *core_clk;
 
diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 2cd9ad9c031c1..14415943a1157 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -110,6 +110,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_printer p = drm_seq_file_printer(m);
+	unsigned int dlist_mem_size = hvs->dlist_mem_size;
 	unsigned int next_entry_start;
 	unsigned int i, j;
 	u32 dlist_word, dispstat;
@@ -126,7 +127,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 		drm_printf(&p, "HVS chan %u:\n", i);
 		next_entry_start = 0;
 
-		for (j = HVS_READ(SCALER_DISPLISTX(i)); j < 256; j++) {
+		for (j = HVS_READ(SCALER_DISPLISTX(i)); j < dlist_mem_size; j++) {
 			dlist_word = readl((u32 __iomem *)vc4->hvs->dlist + j);
 			drm_printf(&p, "dlist: %02d: 0x%08x\n", j,
 				   dlist_word);
@@ -804,9 +805,10 @@ struct vc4_hvs *__vc4_hvs_alloc(struct vc4_dev *vc4, struct platform_device *pde
 	 * our 16K), since we don't want to scramble the screen when
 	 * transitioning from the firmware's boot setup to runtime.
 	 */
+	hvs->dlist_mem_size = (SCALER_DLIST_SIZE >> 2) - HVS_BOOTLOADER_DLIST_END;
 	drm_mm_init(&hvs->dlist_mm,
 		    HVS_BOOTLOADER_DLIST_END,
-		    (SCALER_DLIST_SIZE >> 2) - HVS_BOOTLOADER_DLIST_END);
+		    hvs->dlist_mem_size);
 
 	/* Set up the HVS LBM memory manager.  We could have some more
 	 * complicated data structure that allowed reuse of LBM areas
-- 
2.43.0



