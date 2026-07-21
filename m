Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4C322DB7;
	Tue, 21 Jul 2026 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653529; cv=none; b=GZUKTvgQ5JVLkj2r1wNaMKdLaNKcRXuUJzykrlV5VQ6fRv4hU9HFM2lpvllTkTfg9Ekxb7jCsy7lGZF9CfdQ9q/L+yfp16Qp/j2V8xUoTNjjDraRy6HW//KdK9OQ0wk2N8xsWE+z0nbaEmBYkE1xCcezceEUehN3enMgYVK3+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653529; c=relaxed/simple;
	bh=m0R0Kbz+acYpT3sPhqJ5tGRIBX+30NqT8hVYqTAP1rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWLPD4Mz04FJRGVr4+TtLpaOix3EKDtwspUlyPK+o8pNvwOFD7dvzB3oFbWyjg35koF23WMQWo7+V4rmT4X76AgW7DYLuKEY+8Y1CyfXvTCBzL37ynJpeSywtZYQSPU3XC84+Cd82lrDtXyclGTRk2FzRR+CJn7jLg4s2rzEsGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbqMXlac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbqMXlac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EDB1F000E9;
	Tue, 21 Jul 2026 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653528;
	bh=WQNeourNOGaB4QZWxzQIpr9CHVuoYNGBGyHl1dxfmZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbqMXlac/RbwYR3jfpownxiyRX2PXfLwiyO3mjyoerDq5+9Vic/uSPUcdA/Rwqlmm
	 V7+xQVu2hPdgzThofLwB3EoTTxLIG+8KVS0Q/tauWs96HFtWMqNocBKH6zb4zqVZiV
	 3VfgVbL0J+oNhVe9zsNoZgWp+sy/sUlmlvGoyh8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1361/2077] net/sched: act_bpf: use rcu_dereference_bh() to read the filter
Date: Tue, 21 Jul 2026 17:17:14 +0200
Message-ID: <20260721152624.919967283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit adc49c7ba690c9b33b8392ec27397456b65d0893 ]

tcf_bpf_act() can run from the tc egress path, which holds only
rcu_read_lock_bh(), but reads prog->filter with rcu_dereference() and
trips lockdep:

  WARNING: suspicious RCU usage
  net/sched/act_bpf.c:47 suspicious rcu_dereference_check() usage!
  1 lock held by syz.2.1588/12756:
   #0: (rcu_read_lock_bh){....}-{1:3}, at: __dev_queue_xmit net/core/dev.c:4792
   tcf_bpf_act+0x6ae/0x940 net/sched/act_bpf.c:47
   tcf_classify+0x6e4/0x1080 net/sched/cls_api.c:1860
   sch_handle_egress net/core/dev.c:4545 [inline]
   __dev_queue_xmit+0x2185/0x2c00 net/core/dev.c:4808
   packet_sendmsg+0x3dfa/0x5120 net/packet/af_packet.c:3114

The other tc actions and cls_bpf already use rcu_dereference_bh() here.
Do the same.

Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Link: https://patch.msgid.link/20260629154112.1164986-1-rhkrqnwk98@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index c2b5bc19e09118..284800b7d3c554 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -44,7 +44,7 @@ TC_INDIRECT_SCOPE int tcf_bpf_act(struct sk_buff *skb,
 	tcf_lastuse_update(&prog->tcf_tm);
 	bstats_update(this_cpu_ptr(prog->common.cpu_bstats), skb);
 
-	filter = rcu_dereference(prog->filter);
+	filter = rcu_dereference_bh(prog->filter);
 	if (at_ingress) {
 		__skb_push(skb, skb->mac_len);
 		filter_res = bpf_prog_run_data_pointers(filter, skb);
-- 
2.53.0



