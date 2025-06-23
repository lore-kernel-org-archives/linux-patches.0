Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0F04C74;
	Mon, 23 Jun 2025 22:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716122; cv=none; b=biuAaA3Jzr855GTg+aXUf3lLGiatJvXAFAzSorTu7OSfL5xijzkraQG/ZpjHWthvsD1st2DtnEyEN9DPH2NhjFSg5DNzGVpbgDIbJl229gr4BeysRJnI2jV/qTcFMX1i5RSqlL50gjn+76++EM9IdMMd2kCIP4wUkp+0C667pqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716122; c=relaxed/simple;
	bh=1VUyzRSMHT2naEj9gahSn+9X+3IBY7iyqKHTVvczwlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HxD6yAt++u3W5xk9hL8Cb7c1n/6wyV94C7XTEQYTyWcXkOYTIoYsaU3MpMM604xKdBSXmKceIn9wY2kr1JFRH3PmgfHuq2eyNEBEZqCV3KLD7ZpRBrvh7vC2V3OcZcUgxO6nGoN6K4YS/x4sWNvo+CmPJaKMh+PR9TbO4qEQlWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/Ran0h6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/Ran0h6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431D1C4CEEA;
	Mon, 23 Jun 2025 22:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716122;
	bh=1VUyzRSMHT2naEj9gahSn+9X+3IBY7iyqKHTVvczwlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/Ran0h6f4wn9sifBdBeWI7kpuuUTDs1vrD+ebYRcclsB8ZO4qte55to1PHB8s3Kk
	 YCZo+NU10jlSzpCB18X4mO6DsCzbJENkKSfgm83qft/vSAfUQYvZN2IS19xvxZODAZ
	 xAP42Qwqn4zZr3boTxOaTQiZb2M4aGucNOp8/Chk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.15 503/592] drm/v3d: Avoid NULL pointer dereference in `v3d_job_update_stats()`
Date: Mon, 23 Jun 2025 15:07:41 +0200
Message-ID: <20250623130712.398134773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit e1bc3a13bd775791cca0bb144d977b00f3598042 upstream.

The following kernel Oops was recently reported by Mesa CI:

[  800.139824] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000588
[  800.148619] Mem abort info:
[  800.151402]   ESR = 0x0000000096000005
[  800.155141]   EC = 0x25: DABT (current EL), IL = 32 bits
[  800.160444]   SET = 0, FnV = 0
[  800.163488]   EA = 0, S1PTW = 0
[  800.166619]   FSC = 0x05: level 1 translation fault
[  800.171487] Data abort info:
[  800.174357]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
[  800.179832]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  800.184873]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  800.190176] user pgtable: 4k pages, 39-bit VAs, pgdp=00000001014c2000
[  800.196607] [0000000000000588] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
[  800.205305] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
[  800.211564] Modules linked in: vc4 snd_soc_hdmi_codec drm_display_helper v3d cec gpu_sched drm_dma_helper drm_shmem_helper drm_kms_helper drm drm_panel_orientation_quirks snd_soc_core snd_compress snd_pcm_dmaengine snd_pcm i2c_brcmstb snd_timer snd backlight
[  800.234448] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.25+rpt-rpi-v8 #1  Debian 1:6.12.25-1+rpt1
[  800.244182] Hardware name: Raspberry Pi 4 Model B Rev 1.4 (DT)
[  800.250005] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  800.256959] pc : v3d_job_update_stats+0x60/0x130 [v3d]
[  800.262112] lr : v3d_job_update_stats+0x48/0x130 [v3d]
[  800.267251] sp : ffffffc080003e60
[  800.270555] x29: ffffffc080003e60 x28: ffffffd842784980 x27: 0224012000000000
[  800.277687] x26: ffffffd84277f630 x25: ffffff81012fd800 x24: 0000000000000020
[  800.284818] x23: ffffff8040238b08 x22: 0000000000000570 x21: 0000000000000158
[  800.291948] x20: 0000000000000000 x19: ffffff8040238000 x18: 0000000000000000
[  800.299078] x17: ffffffa8c1bd2000 x16: ffffffc080000000 x15: 0000000000000000
[  800.306208] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  800.313338] x11: 0000000000000040 x10: 0000000000001a40 x9 : ffffffd83b39757c
[  800.320468] x8 : ffffffd842786420 x7 : 7fffffffffffffff x6 : 0000000000ef32b0
[  800.327598] x5 : 00ffffffffffffff x4 : 0000000000000015 x3 : ffffffd842784980
[  800.334728] x2 : 0000000000000004 x1 : 0000000000010002 x0 : 000000ba4c0ca382
[  800.341859] Call trace:
[  800.344294]  v3d_job_update_stats+0x60/0x130 [v3d]
[  800.349086]  v3d_irq+0x124/0x2e0 [v3d]
[  800.352835]  __handle_irq_event_percpu+0x58/0x218
[  800.357539]  handle_irq_event+0x54/0xb8
[  800.361369]  handle_fasteoi_irq+0xac/0x240
[  800.365458]  handle_irq_desc+0x48/0x68
[  800.369200]  generic_handle_domain_irq+0x24/0x38
[  800.373810]  gic_handle_irq+0x48/0xd8
[  800.377464]  call_on_irq_stack+0x24/0x58
[  800.381379]  do_interrupt_handler+0x88/0x98
[  800.385554]  el1_interrupt+0x34/0x68
[  800.389123]  el1h_64_irq_handler+0x18/0x28
[  800.393211]  el1h_64_irq+0x64/0x68
[  800.396603]  default_idle_call+0x3c/0x168
[  800.400606]  do_idle+0x1fc/0x230
[  800.403827]  cpu_startup_entry+0x40/0x50
[  800.407742]  rest_init+0xe4/0xf0
[  800.410962]  start_kernel+0x5e8/0x790
[  800.414616]  __primary_switched+0x80/0x90
[  800.418622] Code: 8b170277 8b160296 11000421 b9000861 (b9401ac1)
[  800.424707] ---[ end trace 0000000000000000 ]---
[  800.457313] ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

This issue happens when the file descriptor is closed before the jobs
submitted by it are completed. When the job completes, we update the
global GPU stats and the per-fd GPU stats, which are exposed through
fdinfo. If the file descriptor was closed, then the struct `v3d_file_priv`
and its stats were already freed and we can't update the per-fd stats.

Therefore, if the file descriptor was already closed, don't update the
per-fd GPU stats, only update the global ones.

Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Link: https://lore.kernel.org/r/20250602151451.10161-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -199,7 +199,6 @@ v3d_job_update_stats(struct v3d_job *job
 	struct v3d_dev *v3d = job->v3d;
 	struct v3d_file_priv *file = job->file->driver_priv;
 	struct v3d_stats *global_stats = &v3d->queue[queue].stats;
-	struct v3d_stats *local_stats = &file->stats[queue];
 	u64 now = local_clock();
 	unsigned long flags;
 
@@ -209,7 +208,12 @@ v3d_job_update_stats(struct v3d_job *job
 	else
 		preempt_disable();
 
-	v3d_stats_update(local_stats, now);
+	/* Don't update the local stats if the file context has already closed */
+	if (file)
+		v3d_stats_update(&file->stats[queue], now);
+	else
+		drm_dbg(&v3d->drm, "The file descriptor was closed before job completion\n");
+
 	v3d_stats_update(global_stats, now);
 
 	if (IS_ENABLED(CONFIG_LOCKDEP))


