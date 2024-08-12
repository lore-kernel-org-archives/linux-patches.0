Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A75136348;
	Mon, 12 Aug 2024 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479315; cv=none; b=gxxD1uUee8gl+hKLDDaMN92YA3gfNxtU216iJE7AhAtx56hZ+/la7FFGl1PiM23YwesInAr2Igs5gcZmq/LWRkSxq9Pt5ipMd2Exviovhtjr7pEt9U7b6J9GBgnlN+rYLR/kma8cYifnUypIMUMxJlHCpHCtIBs2b83PICJhp7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479315; c=relaxed/simple;
	bh=H3o5M2TJyl6nC8vQBDecwX8UhgsIWUzI3vXVJR353ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n95WcXxtRJjMnpVWaxwQswMfEESImBoDx3ass3T4uVr04z9vDcqEOsB0TyE4M4hUeuNDsf0p36MpIMvtYVrV9Zh+1OW9QOS0Zw3gvLgdlyaPPXqeQO5Cj7yQ0sX0a/QlAYaoPSDTRgfQBzQgf8CUfZGaX4MvyZGxwa5m/szXTQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6sKCOL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6sKCOL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9996FC32782;
	Mon, 12 Aug 2024 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479315;
	bh=H3o5M2TJyl6nC8vQBDecwX8UhgsIWUzI3vXVJR353ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6sKCOL7mNK35w8uYeaqR9tKxmm5iHonSP8eyKYhLS/QP/8RGEhuGKuf1OYuOx92a
	 c+rkW6jwFZw9Vq/jrH+3r18IAA01L710R/ySbZOf1Ci9oo1PxEKEsY/qsr9+d+igHA
	 tVNzgtm22AyAUwu4SwtZGPg/R0IX2Q7LNIQgw9TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/189] Bluetooth: btnxpuart: Shutdown timer and prevent rearming when driver unloading
Date: Mon, 12 Aug 2024 18:01:44 +0200
Message-ID: <20240812160133.994634934@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit 0d0df1e750bac0fdaa77940e711c1625cff08d33 ]

When unload the btnxpuart driver, its associated timer will be deleted.
If the timer happens to be modified at this moment, it leads to the
kernel call this timer even after the driver unloaded, resulting in
kernel panic.
Use timer_shutdown_sync() instead of del_timer_sync() to prevent rearming.

panic log:
  Internal error: Oops: 0000000086000007 [#1] PREEMPT SMP
  Modules linked in: algif_hash algif_skcipher af_alg moal(O) mlan(O) crct10dif_ce polyval_ce polyval_generic   snd_soc_imx_card snd_soc_fsl_asoc_card snd_soc_imx_audmux mxc_jpeg_encdec v4l2_jpeg snd_soc_wm8962 snd_soc_fsl_micfil   snd_soc_fsl_sai flexcan snd_soc_fsl_utils ap130x rpmsg_ctrl imx_pcm_dma can_dev rpmsg_char pwm_fan fuse [last unloaded:   btnxpuart]
  CPU: 5 PID: 723 Comm: memtester Tainted: G           O       6.6.23-lts-next-06207-g4aef2658ac28 #1
  Hardware name: NXP i.MX95 19X19 board (DT)
  pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : 0xffff80007a2cf464
  lr : call_timer_fn.isra.0+0x24/0x80
...
  Call trace:
   0xffff80007a2cf464
   __run_timers+0x234/0x280
   run_timer_softirq+0x20/0x40
   __do_softirq+0x100/0x26c
   ____do_softirq+0x10/0x1c
   call_on_irq_stack+0x24/0x4c
   do_softirq_own_stack+0x1c/0x2c
   irq_exit_rcu+0xc0/0xdc
   el0_interrupt+0x54/0xd8
   __el0_irq_handler_common+0x18/0x24
   el0t_64_irq_handler+0x10/0x1c
   el0t_64_irq+0x190/0x194
  Code: ???????? ???????? ???????? ???????? (????????)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Oops: Fatal exception in interrupt
  SMP: stopping secondary CPUs
  Kernel Offset: disabled
  CPU features: 0x0,c0000000,40028143,1000721b
  Memory Limit: none
  ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 83e8e27a5ecec..b5d40e0e05f31 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -340,7 +340,7 @@ static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
 	struct ps_data *psdata = &nxpdev->psdata;
 
 	flush_work(&psdata->work);
-	del_timer_sync(&psdata->ps_timer);
+	timer_shutdown_sync(&psdata->ps_timer);
 }
 
 static void ps_control(struct hci_dev *hdev, u8 ps_state)
-- 
2.43.0



