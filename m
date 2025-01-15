Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB931248BC6;
	Wed, 15 Jan 2025 10:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937564; cv=none; b=QPap5wEofPzWqnwksC8cuuesyHe7Y4JkBSLH4rFdPqy6mTfcF/nbTZwFWEOz09tuCwliqsfiU5GSv2IGxwVTk3u7iiVYIm403KkCpKFSITiN49DZxS9m02gIhVb9TyZN8L/gV7Qzyik/j+l87FtZmoXLUywAuHEAue6ifjuck9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937564; c=relaxed/simple;
	bh=me6wfbadHQRcjAS7lKAISPdwksbHyZQ+6ljRH7DeG+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLA/VE8p7//JhlPR+sAWQGpNjiHFw2/qxE2Wso+CdROh/W3nefOqCLVSmgDpS3pnd5YmIv4Mx5nXPXsAZ5NbU9NltQHBwqCsVjU8jL6+doiJFAtEvvwlqGStKFcw9U7d0SPV+BFXkwT2mvxdB33HaDTQwpVKPVQxsW/li+R+04o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxrxdhzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxrxdhzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F9DC4CEE3;
	Wed, 15 Jan 2025 10:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937562;
	bh=me6wfbadHQRcjAS7lKAISPdwksbHyZQ+6ljRH7DeG+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxrxdhzXTzoLFBOi5sj/FfuKu71jX2ITK9N96nogsePF2VlYCTPWQMTxQZrscGYM9
	 a+q4ceZykITk0Hhenw6k1Hna1dwzdMp4WVLbeKcRiYLyvpgZsQ88zYWTbCTv6lZS+B
	 3WRdptjdlFfNBNcvSWn2MGJRnFeDYBVd/Hecxrqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbb57d994e54aaa04d2@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/92] net_sched: cls_flow: validate TCA_FLOW_RSHIFT attribute
Date: Wed, 15 Jan 2025 11:36:35 +0100
Message-ID: <20250115103548.225922774@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a039e54397c6a75b713b9ce7894a62e06956aa92 ]

syzbot found that TCA_FLOW_RSHIFT attribute was not validated.
Right shitfing a 32bit integer is undefined for large shift values.

UBSAN: shift-out-of-bounds in net/sched/cls_flow.c:329:23
shift exponent 9445 is too large for 32-bit type 'u32' (aka 'unsigned int')
CPU: 1 UID: 0 PID: 54 Comm: kworker/u8:3 Not tainted 6.13.0-rc3-syzkaller-00180-g4f619d518db9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
  ubsan_epilogue lib/ubsan.c:231 [inline]
  __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
  flow_classify+0x24d5/0x25b0 net/sched/cls_flow.c:329
  tc_classify include/net/tc_wrapper.h:197 [inline]
  __tcf_classify net/sched/cls_api.c:1771 [inline]
  tcf_classify+0x420/0x1160 net/sched/cls_api.c:1867
  sfb_classify net/sched/sch_sfb.c:260 [inline]
  sfb_enqueue+0x3ad/0x18b0 net/sched/sch_sfb.c:318
  dev_qdisc_enqueue+0x4b/0x290 net/core/dev.c:3793
  __dev_xmit_skb net/core/dev.c:3889 [inline]
  __dev_queue_xmit+0xf0e/0x3f50 net/core/dev.c:4400
  dev_queue_xmit include/linux/netdevice.h:3168 [inline]
  neigh_hh_output include/net/neighbour.h:523 [inline]
  neigh_output include/net/neighbour.h:537 [inline]
  ip_finish_output2+0xd41/0x1390 net/ipv4/ip_output.c:236
  iptunnel_xmit+0x55d/0x9b0 net/ipv4/ip_tunnel_core.c:82
  udp_tunnel_xmit_skb+0x262/0x3b0 net/ipv4/udp_tunnel_core.c:173
  geneve_xmit_skb drivers/net/geneve.c:916 [inline]
  geneve_xmit+0x21dc/0x2d00 drivers/net/geneve.c:1039
  __netdev_start_xmit include/linux/netdevice.h:5002 [inline]
  netdev_start_xmit include/linux/netdevice.h:5011 [inline]
  xmit_one net/core/dev.c:3590 [inline]
  dev_hard_start_xmit+0x27a/0x7d0 net/core/dev.c:3606
  __dev_queue_xmit+0x1b73/0x3f50 net/core/dev.c:4434

Fixes: e5dfb815181f ("[NET_SCHED]: Add flow classifier")
Reported-by: syzbot+1dbb57d994e54aaa04d2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6777bf49.050a0220.178762.0040.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250103104546.3714168-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 014cd3de7b5d..7657d86ad142 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -354,7 +354,8 @@ static const struct nla_policy flow_policy[TCA_FLOW_MAX + 1] = {
 	[TCA_FLOW_KEYS]		= { .type = NLA_U32 },
 	[TCA_FLOW_MODE]		= { .type = NLA_U32 },
 	[TCA_FLOW_BASECLASS]	= { .type = NLA_U32 },
-	[TCA_FLOW_RSHIFT]	= { .type = NLA_U32 },
+	[TCA_FLOW_RSHIFT]	= NLA_POLICY_MAX(NLA_U32,
+						 31 /* BITS_PER_U32 - 1 */),
 	[TCA_FLOW_ADDEND]	= { .type = NLA_U32 },
 	[TCA_FLOW_MASK]		= { .type = NLA_U32 },
 	[TCA_FLOW_XOR]		= { .type = NLA_U32 },
-- 
2.39.5



