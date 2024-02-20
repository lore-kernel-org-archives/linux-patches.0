Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D571509BC;
	Tue, 20 Feb 2024 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462933; cv=none; b=eXQQSBTIMxzwqphDnUCcRKW/8HwhIjWrEapdhsSPSMnBy/RKRZU1hkr2lu1W4ak6OVgjL7dBvSVQRxVibcvk3tbnGNZ8lkznm9hu0YHzKL3VTu8c131eid4QLX4YIIoLOgfux/OEdyTwd96cn4oF+siWe/ud37YlIPIVmGPoIT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462933; c=relaxed/simple;
	bh=AxijDpuQkMFVYGPd71MPf9D7IaCi+XRVBMUuojcIS+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0ZaOtACYuVSUnk/DFZeXMUsImpGbUlVJrU8EpprBhmLWNFgvW1088kRb+qsi45a7XkemVtpui8DwnvfO0dwr5DoYsnpuDRP5AgNERPFUmFsTqWlNFXkrRCnj9zS4DYLGvcxX5FIx2n0ZIBZs/lDPsQMs711eqKT+X3PyHUqwCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKBD+4aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKBD+4aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6D6C433C7;
	Tue, 20 Feb 2024 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462933;
	bh=AxijDpuQkMFVYGPd71MPf9D7IaCi+XRVBMUuojcIS+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKBD+4aQzf/XCll+NW/mhgwQYN3miXjTrrD8Ob6Yz4MX/J7wwIbid6xFye94jHd6V
	 7W0myftWdWQ6di+SR5Ye/66N2o1niG0yALV/znvk0u6qG6LIAqkSv4HvIrMwVZPhDm
	 wRTMhDm7CI8CuTD1eQKH06DNAHNymjWOR+8AoCcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ae0a3f42c84074b7c8e@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 083/197] net: hsr: remove WARN_ONCE() in send_hsr_supervision_frame()
Date: Tue, 20 Feb 2024 21:50:42 +0100
Message-ID: <20240220204843.571601048@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 37e8c97e539015637cb920d3e6f1e404f707a06e upstream.

Syzkaller reported [1] hitting a warning after failing to allocate
resources for skb in hsr_init_skb(). Since a WARN_ONCE() call will
not help much in this case, it might be prudent to switch to
netdev_warn_once(). At the very least it will suppress syzkaller
reports such as [1].

Just in case, use netdev_warn_once() in send_prp_supervision_frame()
for similar reasons.

[1]
HSR: Could not send supervision frame
WARNING: CPU: 1 PID: 85 at net/hsr/hsr_device.c:294 send_hsr_supervision_frame+0x60a/0x810 net/hsr/hsr_device.c:294
RIP: 0010:send_hsr_supervision_frame+0x60a/0x810 net/hsr/hsr_device.c:294
...
Call Trace:
 <IRQ>
 hsr_announce+0x114/0x370 net/hsr/hsr_device.c:382
 call_timer_fn+0x193/0x590 kernel/time/timer.c:1700
 expire_timers kernel/time/timer.c:1751 [inline]
 __run_timers+0x764/0xb20 kernel/time/timer.c:2022
 run_timer_softirq+0x58/0xd0 kernel/time/timer.c:2035
 __do_softirq+0x21a/0x8de kernel/softirq.c:553
 invoke_softirq kernel/softirq.c:427 [inline]
 __irq_exit_rcu kernel/softirq.c:632 [inline]
 irq_exit_rcu+0xb7/0x120 kernel/softirq.c:644
 sysvec_apic_timer_interrupt+0x95/0xb0 arch/x86/kernel/apic/apic.c:1076
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
...

This issue is also found in older kernels (at least up to 5.10).

Cc: stable@vger.kernel.org
Reported-by: syzbot+3ae0a3f42c84074b7c8e@syzkaller.appspotmail.com
Fixes: 121c33b07b31 ("net: hsr: introduce common code for skb initialization")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -291,7 +291,7 @@ static void send_hsr_supervision_frame(s
 
 	skb = hsr_init_skb(master);
 	if (!skb) {
-		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
+		netdev_warn_once(master->dev, "HSR: Could not send supervision frame\n");
 		return;
 	}
 
@@ -338,7 +338,7 @@ static void send_prp_supervision_frame(s
 
 	skb = hsr_init_skb(master);
 	if (!skb) {
-		WARN_ONCE(1, "PRP: Could not send supervision frame\n");
+		netdev_warn_once(master->dev, "PRP: Could not send supervision frame\n");
 		return;
 	}
 


