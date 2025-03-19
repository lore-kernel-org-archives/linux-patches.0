Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAB1B87D5;
	Wed, 19 Mar 2025 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394933; cv=none; b=fbUM/s8bCRF5Uzp7+yVMbFvJFMwD9V4tKrAhft/LtyfvZw9xOftols78l4RU8vmLZPejWs7tZeAHY/W+SqPzz5ai7AiX13pSxxnL3wPqHaa30+rDdmUnNqzt3UvF6GtM75foPkdDg+Evyb/LceWqJ7C/znFtkpCjdCTSjTp8Twc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394933; c=relaxed/simple;
	bh=J01GgFknn6mcwOQoIWlKAqy2VyV5miIV1U0PTWe81/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCxgbASKV2gtvUSQWMJrIEfWNtR52e5QAt4m+z+OL93/Od1S7Vx7sdC74M2y4teLi5uvMLklptnsaiHQCUy1QSC47xcyMTGhtK+p/z7UJARdl/MSCI7BcL6Y4v3wexbUsJIpV2SAE558N+2+sdKXct0VjQTbECLXp4o64HFJ6XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsXUh4X6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsXUh4X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067CEC4CEE8;
	Wed, 19 Mar 2025 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394933;
	bh=J01GgFknn6mcwOQoIWlKAqy2VyV5miIV1U0PTWe81/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsXUh4X6w0t/UZZcLrpfZXc1aeFq7dmbaP2A180GZ5RiqwVYiOiA+565GylVvbLM1
	 buofCBFiSNx8mvz+RHB4nXlkmXSt+l+P5kGAW/Sf2N4Vdn5aMr18Kycy9jakuXYMXk
	 xoDn26tsjYK6H4i50gP4MsUlHz5gx3pdTIAt7z48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Breno Leitao <leitao@debian.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 147/241] net: Handle napi_schedule() calls from non-interrupt
Date: Wed, 19 Mar 2025 07:30:17 -0700
Message-ID: <20250319143031.354621826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 77e45145e3039a0fb212556ab3f8c87f54771757 ]

napi_schedule() is expected to be called either:

* From an interrupt, where raised softirqs are handled on IRQ exit

* From a softirq disabled section, where raised softirqs are handled on
  the next call to local_bh_enable().

* From a softirq handler, where raised softirqs are handled on the next
  round in do_softirq(), or further deferred to a dedicated kthread.

Other bare tasks context may end up ignoring the raised NET_RX vector
until the next random softirq handling opportunity, which may not
happen before a while if the CPU goes idle afterwards with the tick
stopped.

Such "misuses" have been detected on several places thanks to messages
of the kind:

	"NOHZ tick-stop error: local softirq work is pending, handler #08!!!"

For example:

       __raise_softirq_irqoff
        __napi_schedule
        rtl8152_runtime_resume.isra.0
        rtl8152_resume
        usb_resume_interface.isra.0
        usb_resume_both
        __rpm_callback
        rpm_callback
        rpm_resume
        __pm_runtime_resume
        usb_autoresume_device
        usb_remote_wakeup
        hub_event
        process_one_work
        worker_thread
        kthread
        ret_from_fork
        ret_from_fork_asm

And also:

* drivers/net/usb/r8152.c::rtl_work_func_t
* drivers/net/netdevsim/netdev.c::nsim_start_xmit

There is a long history of issues of this kind:

	019edd01d174 ("ath10k: sdio: Add missing BH locking around napi_schdule()")
	330068589389 ("idpf: disable local BH when scheduling napi for marker packets")
	e3d5d70cb483 ("net: lan78xx: fix "softirq work is pending" error")
	e55c27ed9ccf ("mt76: mt7615: add missing bh-disable around rx napi schedule")
	c0182aa98570 ("mt76: mt7915: add missing bh-disable around tx napi enable/schedule")
	970be1dff26d ("mt76: disable BH around napi_schedule() calls")
	019edd01d174 ("ath10k: sdio: Add missing BH locking around napi_schdule()")
	30bfec4fec59 ("can: rx-offload: can_rx_offload_threaded_irq_finish(): add new  function to be called from threaded interrupt")
	e63052a5dd3c ("mlx5e: add add missing BH locking around napi_schdule()")
	83a0c6e58901 ("i40e: Invoke softirqs after napi_reschedule")
	bd4ce941c8d5 ("mlx4: Invoke softirqs after napi_reschedule")
	8cf699ec849f ("mlx4: do not call napi_schedule() without care")
	ec13ee80145c ("virtio_net: invoke softirqs after __napi_schedule")

This shows that relying on the caller to arrange a proper context for
the softirqs to be handled while calling napi_schedule() is very fragile
and error prone. Also fixing them can also prove challenging if the
caller may be called from different kinds of contexts.

Therefore fix this from napi_schedule() itself with waking up ksoftirqd
when softirqs are raised from task contexts.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: Francois Romieu <romieu@fr.zoreil.com>
Closes: https://lore.kernel.org/lkml/354a2690-9bbf-4ccb-8769-fa94707a9340@molgen.mpg.de/
Cc: Breno Leitao <leitao@debian.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250223221708.27130-1-frederic@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2b09714761c62..7f755270ff1ce 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4610,7 +4610,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 	 * we have to raise NET_RX_SOFTIRQ.
 	 */
 	if (!sd->in_net_rx_action)
-		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+		raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
 
 #ifdef CONFIG_RPS
-- 
2.39.5



