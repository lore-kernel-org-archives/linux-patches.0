Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216101;
	b=qiSi8DvEizA/IOIhIP0tCN92++cqfSX3JF/REnEqAyCqOoeS1HGEoVgOkPJ84KOhz7o+
	 nd6XEocoG0eZwowttCAOeqBCQSNfJ2SNcabntmsqYUlo03vioxMO/dwmoV34Ia87CHrYd
	 u5FDNlpLNM8kfccXMwWx+cZ/9p78ysSgB5CHkLVtRUrxoDtWVWTSrGNqIj5fed7oO5gM8
	 Z/JDp9T6SWzY7I2WTe98Fh3kfAcK0MvpeQHNYHopW9vPn0rRPBfMTjKFCftF/sGtyM1JV
	 YvUNsnlRAJ6enl0BgFP3YF+xeKDwLt0HdmKdrNpJSS5ChhEyrvMcQU/bPrZB0fFJkAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srdxt2GJsREItjBJbPEGeDDMmy+9u4nt/yxUkisgPUo=;
	b=fn4tMWd0bXg7pQ7SFpTy8zCG2SLaQj8zKrfmhQdUbpEzJ5PgNapQKXVsl16OXiuBXInF
	 3cCz297jcL0smXZnjjHu2G8snw6QKW0mp/jafQ4JxZvFCr9Kzun5rB03YB09ErDRP83AD
	 tMYl0TasYXLg4YV0oWQqV+wNu/hXzOzK3Hpv5cgicdNw3FXb5bHBNc4i/r4G70hin8AH4
	 /P5CLVPhg+4iKQzZ9SQapGigmL2Qf+5LzRFLOAOu1Upm6iVy2gmrAJqucK/S4RR8s3gTm
	 /pwB5ems3SM5GUclvaX3tqF8Kfh0atJxZ7CmxtIiIJ7InNB0CHVHxLhh7Un2VmdxskQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3ZCb6ck;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB04606A31A;
	Wed, 28 Oct 2026 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3ZCb6ck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BCC1F01825;
	Wed, 28 Oct 2026 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216101;
	bh=srdxt2GJsREItjBJbPEGeDDMmy+9u4nt/yxUkisgPUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3ZCb6ckEGpbNdbVx7oyGBMXqaz8koottHA8gYzVLpjPaHoZ94dDbeKe8Ifkwkbqp
	 BmsmOmf0TUk+anZ8nEZBI60wwkGlBo+NDEZ7WJrGJQqdthMFUP851ACKigQCD/AZNH
	 oFgIRjNyz4NN2Nb4m/sW9wwSX8MaWuFhWGI0DoJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1414/1887] fbdev: ssd1307fb: defer I2C transfers from damage callbacks
Date: Wed, 28 Oct 2026 17:58:30 +0100
Message-ID: <20261028170531.634853425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 9ad709afdfa32509ed64938a6d9cd00db3cd54c2 ]

The fbdev damage callbacks may run from fbcon while printk has disabled
preemption.  They currently update the display synchronously, which enters
the sleeping I2C transfer path from atomic context.

A complete report from an RK3566 system follows:

  [  258.129004] watchdog: watchdog0: watchdog did not stop!
  [  258.129067] BUG: scheduling while atomic: systemd/1/0x00000003
  [  258.129076] Modules linked in: algif_hash algif_skcipher af_alg bnep
  binfmt_misc lz4hc lz4 zram snd_soc_hdmi_codec brcmfmac_wcc hci_uart
  fb_ssd1306(C) fbtft(C) btqca btrtl btintel btsdio snd_soc_simple_card
  motorcomm pwm_fan snd_soc_simple_card_utils ssd130x_spi nls_iso8859_1
  ssd130x btbcm drm_shmem_helper display_connector brcmfmac ssd1307fb
  brcmutil bluetooth cfg80211 rfkill snd_soc_rockchip_i2s_tdm
  snd_soc_rk817 hantro_vpu snd_soc_core snd_compress snd_pcm_dmaengine
  v4l2_vp9 snd_pcm v4l2_h264 rockchip_rga snd_timer rk_crypto2
  spi_rockchip_sfc videobuf2_dma_contig snd sm3_generic v4l2_mem2mem
  videobuf2_dma_sg dwmac_rk sm3 soundcore videobuf2_memops videobuf2_v4l2
  stmmac_platform dw_hdmi_cec videodev videobuf2_common dw_hdmi_i2s_audio
  stmmac rk817_charger pcs_xpcs mc cpufreq_dt sch_fq_codel ip_tables
  x_tables autofs4
  [  258.129215] Preemption disabled at:
  [  258.129216] [<ffff80008012f96c>] vprintk_emit+0x11c/0x340
  [  258.129234] CPU: 0 PID: 1 Comm: systemd Tainted: G         C
  6.6.0-rc5-rockchip-rk356x #4
  [  258.129239] Hardware name: Rockchip RK3566 OPi 3B (DT)
  [  258.129243] Call trace:
  [  258.129245]  dump_backtrace+0xa0/0x128
  [  258.129252]  show_stack+0x20/0x38
  [  258.129256]  dump_stack_lvl+0x60/0xb0
  [  258.129265]  dump_stack+0x18/0x28
  [  258.129269]  __schedule_bug+0xa0/0xc8
  [  258.129274]  __schedule+0x9ac/0xd30
  [  258.129279]  schedule+0x60/0x100
  [  258.129282]  schedule_timeout+0x194/0x338
  [  258.129289]  rk3x_i2c_xfer_common.isra.0+0x384/0x498
  [  258.129296]  rk3x_i2c_xfer+0x20/0x60
  [  258.129300]  __i2c_transfer+0x194/0x648
  [  258.129308]  i2c_transfer+0x9c/0x130
  [  258.129313]  i2c_transfer_buffer_flags+0x64/0x98
  [  258.129318]  ssd1307fb_update_rect+0x42c/0x560 [ssd1307fb]
  [  258.129334]  ssd1307fb_defio_imageblit+0x34/0x50 [ssd1307fb]
  [  258.129343]  soft_cursor+0x13c/0x210
  [  258.129350]  bit_cursor+0x2dc/0x550
  [  258.129354]  fbcon_cursor+0xec/0x108
  [  258.129359]  hide_cursor+0x44/0xc8
  [  258.129365]  vt_console_print+0x398/0x3b0
  [  258.129370]  console_flush_all.isra.0+0x17c/0x410
  [  258.129377]  console_unlock+0x4c/0x100
  [  258.129382]  vprintk_emit+0x1c8/0x340
  [  258.129386]  vprintk_default+0x40/0x58
  [  258.129389]  vprintk+0xb8/0xd0
  [  258.129392]  _printk+0x68/0x98
  [  258.129398]  watchdog_release+0x170/0x230
  [  258.129404]  __fput+0xbc/0x288
  [  258.129409]  __fput_sync+0x58/0x70
  [  258.129413]  __arm64_sys_close+0x40/0x90
  [  258.129419]  invoke_syscall+0x4c/0x118
  [  258.129426]  el0_svc_common.constprop.0+0x48/0xf0
  [  258.129432]  do_el0_svc+0x24/0x38
  [  258.129437]  el0_svc+0x48/0x100
  [  258.129443]  el0t_64_sync_handler+0xc0/0xc8
  [  258.129448]  el0t_64_sync+0x190/0x198
  [  258.573087] ------------[ cut here ]------------
  [  258.573098] DEBUG_LOCKS_WARN_ON(val > preempt_count())
  [  258.573111] WARNING: CPU: 0 PID: 1 at kernel/sched/core.c:5871
  preempt_count_sub+0x9c/0x148
  [  258.573130] Modules linked in: algif_hash algif_skcipher af_alg bnep
  binfmt_misc lz4hc lz4 zram snd_soc_hdmi_codec brcmfmac_wcc hci_uart
  fb_ssd1306(C) fbtft(C) btqca btrtl btintel btsdio snd_soc_simple_card
  motorcomm pwm_fan snd_soc_simple_card_utils ssd130x_spi nls_iso8859_1
  ssd130x btbcm drm_shmem_helper display_connector brcmfmac ssd1307fb
  brcmutil bluetooth cfg80211 rfkill snd_soc_rockchip_i2s_tdm
  snd_soc_rk817 hantro_vpu snd_soc_core snd_compress snd_pcm_dmaengine
  v4l2_vp9 snd_pcm v4l2_h264 rockchip_rga snd_timer rk_crypto2
  spi_rockchip_sfc videobuf2_dma_contig snd sm3_generic v4l2_mem2mem
  videobuf2_dma_sg dwmac_rk sm3 soundcore videobuf2_memops videobuf2_v4l2
  stmmac_platform dw_hdmi_cec videodev videobuf2_common dw_hdmi_i2s_audio
  stmmac rk817_charger pcs_xpcs mc cpufreq_dt sch_fq_codel ip_tables
  x_tables autofs4
  [  258.573268] CPU: 0 PID: 1 Comm: systemd Tainted: G        WC
  6.6.0-rc5-rockchip-rk356x #4
  [  258.573274] Hardware name: Rockchip RK3566 OPi 3B (DT)
  ** 37 printk messages dropped **
  [  258.574064] Preemption disabled at:
  ** 42 printk messages dropped **
  [  259.190237] Preemption disabled at:

Track damage in the driver's private data under a spinlock and merge
multiple updates into a bounding rectangle.  Queue the existing
deferred-I/O work immediately for damage reported by fbdev drawing and
write helpers, so allocation and I2C transfers run from process context
without adding the configured mmap refresh delay.  Keep full-screen
updates for dirty mmap pages, for which no precise rectangle is available.

Tested on an RK3566 board with a 128x64 OLED by running five rounds of 250
KERN_EMERG messages in total while issuing framebuffer writes every 15 ms.
No atomic-sleep, preemption, or lockdep warning occurred.  Kprobe tracing
also confirmed that cursor-only damage remained an 8x16 partial update.

Fixes: a2ed00da5047 ("drivers/video: add support for the Solomon SSD1307 OLED Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ssd1307fb.c | 72 ++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index a7b8be508f562..61f84abb5e0c9 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/pwm.h>
+#include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/regulator/consumer.h>
 
@@ -72,6 +73,13 @@ struct ssd1307fb_par {
 	struct i2c_client *client;
 	u32 height;
 	struct fb_info *info;
+	/* Pending damage, with exclusive x2/y2, protected by damage_lock. */
+	spinlock_t damage_lock;
+	bool damage_pending;
+	u32 damage_x1;
+	u32 damage_x2;
+	u32 damage_y1;
+	u32 damage_y2;
 	u8 lookup_table[4];
 	u32 page_offset;
 	u32 col_offset;
@@ -302,19 +310,49 @@ static int ssd1307fb_blank(int blank_mode, struct fb_info *info)
 		return ssd1307fb_write_cmd(par->client, SSD1307FB_DISPLAY_ON);
 }
 
+static void ssd1307fb_schedule_damage(struct fb_info *info, u32 x, u32 y,
+				      u32 width, u32 height)
+{
+	struct ssd1307fb_par *par = info->par;
+	unsigned long flags;
+	u32 x2, y2;
+
+	if (!width || !height || x >= par->width || y >= par->height)
+		return;
+
+	x2 = x + min(width, par->width - x);
+	y2 = y + min(height, par->height - y);
+
+	spin_lock_irqsave(&par->damage_lock, flags);
+	if (par->damage_pending) {
+		par->damage_x1 = min(par->damage_x1, x);
+		par->damage_y1 = min(par->damage_y1, y);
+		par->damage_x2 = max(par->damage_x2, x2);
+		par->damage_y2 = max(par->damage_y2, y2);
+	} else {
+		par->damage_x1 = x;
+		par->damage_y1 = y;
+		par->damage_x2 = x2;
+		par->damage_y2 = y2;
+		par->damage_pending = true;
+	}
+	spin_unlock_irqrestore(&par->damage_lock, flags);
+
+	/* Advance an already-pending mmap update as well. */
+	mod_delayed_work(system_wq, &info->deferred_work, 0);
+}
+
 static void ssd1307fb_defio_damage_range(struct fb_info *info, off_t off, size_t len)
 {
 	struct ssd1307fb_par *par = info->par;
 
-	ssd1307fb_update_display(par);
+	ssd1307fb_schedule_damage(info, 0, 0, par->width, par->height);
 }
 
 static void ssd1307fb_defio_damage_area(struct fb_info *info, u32 x, u32 y,
 					u32 width, u32 height)
 {
-	struct ssd1307fb_par *par = info->par;
-
-	ssd1307fb_update_rect(par, x, y, width, height);
+	ssd1307fb_schedule_damage(info, x, y, width, height);
 }
 
 FB_GEN_DEFAULT_DEFERRED_SYS_OPS(ssd1307fb,
@@ -329,7 +367,30 @@ static const struct fb_ops ssd1307fb_ops = {
 
 static void ssd1307fb_deferred_io(struct fb_info *info, struct list_head *pagereflist)
 {
-	ssd1307fb_update_display(info->par);
+	struct ssd1307fb_par *par = info->par;
+	unsigned long flags;
+	u32 x, y, width, height;
+
+	spin_lock_irqsave(&par->damage_lock, flags);
+	if (!list_empty(pagereflist)) {
+		x = 0;
+		y = 0;
+		width = par->width;
+		height = par->height;
+		par->damage_pending = false;
+	} else if (par->damage_pending) {
+		x = par->damage_x1;
+		y = par->damage_y1;
+		width = par->damage_x2 - par->damage_x1;
+		height = par->damage_y2 - par->damage_y1;
+		par->damage_pending = false;
+	} else {
+		spin_unlock_irqrestore(&par->damage_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&par->damage_lock, flags);
+
+	ssd1307fb_update_rect(par, x, y, width, height);
 }
 
 static int ssd1307fb_init(struct ssd1307fb_par *par)
@@ -609,6 +670,7 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	par = info->par;
 	par->info = info;
 	par->client = client;
+	spin_lock_init(&par->damage_lock);
 
 	par->device_info = device_get_match_data(dev);
 
-- 
2.53.0



