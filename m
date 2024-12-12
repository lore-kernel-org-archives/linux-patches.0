Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849D12EAE5;
	Thu, 12 Dec 2024 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015756; cv=none; b=S5AxR5048XkdmjV5cl2e8A4KAPFMGH5MtLgRqONFd6rER7io6U80Fi0peQOHVR7ZAHEMWdnXnRUg3CfQbCHWhzPjQVOthLVt3t1FsgMZJC8akyA/R3IFloNWFryNEgdD2ZQif+q5hEH5rfeS1rMBr4IPKsjFV4CoYzbTw6a4+UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015756; c=relaxed/simple;
	bh=4dkncBzhCdMcde5NM5idd689imf/ucMbiqnEGXNeSz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdtqkkAOadgmiwqatP7jv6IwXPoY32aMQvRhflrv+52s4kQ+BHkgF+mZYEklc6eAwn2pcH8l4qIQck+TkfSNiwBGuAagwEYSiNGoBrRgCySKCTuHCoGRjpR5D2T7QW8UVoJFLZULOufe3g5gQadvkB2telit9JZKKxJbVotJ520=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXE1RkvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXE1RkvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D10C4CED0;
	Thu, 12 Dec 2024 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015756;
	bh=4dkncBzhCdMcde5NM5idd689imf/ucMbiqnEGXNeSz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXE1RkvKr2g/WwLVw+IijXvqZIC+onwYwJkiB/f1QK4r19XWImOsbWOM/z8FEBwpF
	 u+eBXyvBqMmXyLH3QlDnOOc/A9+4yA6YuBPteIUKFoThvKAA8Xqn3gXKSFMVN0fCrK
	 Kc2mF0vKAoMZmJKUXv0+5EydRL57UA/lSH48MSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f4643b267cc680bfa1c@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Lukasz Majewski <lukma@denx.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/466] net: hsr: must allocate more bytes for RedBox support
Date: Thu, 12 Dec 2024 15:53:25 +0100
Message-ID: <20241212144308.112067451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit af8edaeddbc52e53207d859c912b017fd9a77629 ]

Blamed commit forgot to change hsr_init_skb() to allocate
larger skb for RedBox case.

Indeed, send_hsr_supervision_frame() will add
two additional components (struct hsr_sup_tlv
and struct hsr_sup_payload)

syzbot reported the following crash:
skbuff: skb_over_panic: text:ffffffff8afd4b0a len:34 put:6 head:ffff88802ad29e00 data:ffff88802ad29f22 tail:0x144 end:0x140 dev:gretap0
------------[ cut here ]------------
 kernel BUG at net/core/skbuff.c:206 !
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 2 UID: 0 PID: 7611 Comm: syz-executor Not tainted 6.12.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
 RIP: 0010:skb_panic+0x157/0x1d0 net/core/skbuff.c:206
Code: b6 04 01 84 c0 74 04 3c 03 7e 21 8b 4b 70 41 56 45 89 e8 48 c7 c7 a0 7d 9b 8c 41 57 56 48 89 ee 52 4c 89 e2 e8 9a 76 79 f8 90 <0f> 0b 4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 94 76 fb f8 4c
RSP: 0018:ffffc90000858ab8 EFLAGS: 00010282
RAX: 0000000000000087 RBX: ffff8880598c08c0 RCX: ffffffff816d3e69
RDX: 0000000000000000 RSI: ffffffff816de786 RDI: 0000000000000005
RBP: ffffffff8c9b91c0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000302 R11: ffffffff961cc1d0 R12: ffffffff8afd4b0a
R13: 0000000000000006 R14: ffff88804b938130 R15: 0000000000000140
FS:  000055558a3d6500(0000) GS:ffff88806a800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1295974ff8 CR3: 000000002ab6e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
  skb_over_panic net/core/skbuff.c:211 [inline]
  skb_put+0x174/0x1b0 net/core/skbuff.c:2617
  send_hsr_supervision_frame+0x6fa/0x9e0 net/hsr/hsr_device.c:342
  hsr_proxy_announce+0x1a3/0x4a0 net/hsr/hsr_device.c:436
  call_timer_fn+0x1a0/0x610 kernel/time/timer.c:1794
  expire_timers kernel/time/timer.c:1845 [inline]
  __run_timers+0x6e8/0x930 kernel/time/timer.c:2419
  __run_timer_base kernel/time/timer.c:2430 [inline]
  __run_timer_base kernel/time/timer.c:2423 [inline]
  run_timer_base+0x111/0x190 kernel/time/timer.c:2439
  run_timer_softirq+0x1a/0x40 kernel/time/timer.c:2449
  handle_softirqs+0x213/0x8f0 kernel/softirq.c:554
  __do_softirq kernel/softirq.c:588 [inline]
  invoke_softirq kernel/softirq.c:428 [inline]
  __irq_exit_rcu kernel/softirq.c:637 [inline]
  irq_exit_rcu+0xbb/0x120 kernel/softirq.c:649
  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
  sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>

Fixes: 5055cccfc2d1 ("net: hsr: Provide RedBox support (HSR-SAN)")
Reported-by: syzbot+7f4643b267cc680bfa1c@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lukasz Majewski <lukma@denx.de>
Link: https://patch.msgid.link/20241202100558.507765-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index f630d6645636d..44048d7538ddc 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -246,20 +246,22 @@ static const struct header_ops hsr_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
-static struct sk_buff *hsr_init_skb(struct hsr_port *master)
+static struct sk_buff *hsr_init_skb(struct hsr_port *master, int extra)
 {
 	struct hsr_priv *hsr = master->hsr;
 	struct sk_buff *skb;
 	int hlen, tlen;
+	int len;
 
 	hlen = LL_RESERVED_SPACE(master->dev);
 	tlen = master->dev->needed_tailroom;
+	len = sizeof(struct hsr_sup_tag) + sizeof(struct hsr_sup_payload);
 	/* skb size is same for PRP/HSR frames, only difference
 	 * being, for PRP it is a trailer and for HSR it is a
-	 * header
+	 * header.
+	 * RedBox might use @extra more bytes.
 	 */
-	skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
-			    sizeof(struct hsr_sup_payload) + hlen + tlen);
+	skb = dev_alloc_skb(len + extra + hlen + tlen);
 
 	if (!skb)
 		return skb;
@@ -295,6 +297,7 @@ static void send_hsr_supervision_frame(struct hsr_port *port,
 	struct hsr_sup_tlv *hsr_stlv;
 	struct hsr_sup_tag *hsr_stag;
 	struct sk_buff *skb;
+	int extra = 0;
 
 	*interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
 	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
@@ -303,7 +306,11 @@ static void send_hsr_supervision_frame(struct hsr_port *port,
 		hsr->announce_count++;
 	}
 
-	skb = hsr_init_skb(port);
+	if (hsr->redbox)
+		extra = sizeof(struct hsr_sup_tlv) +
+			sizeof(struct hsr_sup_payload);
+
+	skb = hsr_init_skb(port, extra);
 	if (!skb) {
 		netdev_warn_once(port->dev, "HSR: Could not send supervision frame\n");
 		return;
@@ -362,7 +369,7 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	struct hsr_sup_tag *hsr_stag;
 	struct sk_buff *skb;
 
-	skb = hsr_init_skb(master);
+	skb = hsr_init_skb(master, 0);
 	if (!skb) {
 		netdev_warn_once(master->dev, "PRP: Could not send supervision frame\n");
 		return;
-- 
2.43.0



