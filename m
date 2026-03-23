Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A41D37B02A;
	Mon, 23 Mar 2026 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283052; cv=none; b=Y3KEbr760v7fTd+i71tEZIWJY/A9R/6EJ9SpEcuCdBS1TiNb48buG9TD+LVAJubuySgd3vtI3fmpMDpdO2TVaw728TvK+Z2jI2r//IpiO7+O5PeQZyIg9s/BSpRM1258SB3Rwe4LCTWKMKECa00vNZ67ORJiaClusrHlGv8Mlto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283052; c=relaxed/simple;
	bh=o56kMI09mB9WgjgJK7ZYMNyI+xgsBAruDWdnhmjkBcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHfqNZuw//HXf2SKcREMoDi6kVzHXhpbOrfEGHDPWzXnez2mOMhcsiU+S+CxMOyrIvHqI+GVcUxXOouN/CkaaemrQJHhzybEtzj2Ox5LDYlhOIxgVX2wst3FCJIF6+jBNaK0V+p+fepVaXnheHeBnpL/VxU4GwSElf9tBpF/n9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F62tIuWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F62tIuWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87F0C2BC9E;
	Mon, 23 Mar 2026 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283052;
	bh=o56kMI09mB9WgjgJK7ZYMNyI+xgsBAruDWdnhmjkBcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F62tIuWtc8pOXCp7JUqAzyccIZg0Po5QteUItjnFRQEUo+N5RxKlyFDDSjgHlMGbu
	 yyVNnjTYlLUnU/H3A039zLZ/wZVW19szP7Y6UZy128xgpEoi5eECUK70W4ASIpEnST
	 /QLAR2tj+j7ew/LLg+/1pvb6ramtIDEo3nBLu38I=
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
	Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 6.1 385/481] net: Handle napi_schedule() calls from non-interrupt
Date: Mon, 23 Mar 2026 14:46:07 +0100
Message-ID: <20260323134534.524496181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

commit 77e45145e3039a0fb212556ab3f8c87f54771757 upstream.

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
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4486,7 +4486,7 @@ static inline void ____napi_schedule(str
 	}
 
 	list_add_tail(&napi->poll_list, &sd->poll_list);
-	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
 
 #ifdef CONFIG_RPS


