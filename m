Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E743D3CE4;
	Tue, 21 Jul 2026 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669731; cv=none; b=MpDbtdUPpgihZiFKdsGztACSQRqL1LKuXvXbv3aXiX9/eKD43+Q5qTD2xzIoAbUkRCEDfItWZOKx4z7ljoKWmqfuamkZzn5K0LgiKoMt1JvirooHOoEYR9E1UKvHCajHzh8IlDdP9rralsnNsyoA5bZTMeUFSlz1glRds77boww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669731; c=relaxed/simple;
	bh=x0Ht9xGiwDhz+Q2a8uJwg3WwGjJMnh8OmwFz8Q3/A8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQop2KVxwiCBbLH9e+QzO9vJEuSrH7f+BNZBWbYUIeR/t5bENY7qhrCh+Yodfyf77blW0RpeDD9SDsuX7cFI6TzCUunyUYljJj3YjsoEoGIqbHT351w2DDa8/caarrxC0lf14I2FMVdxizOOr+JqzDEQmsU75/JuTDkm+e564Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFcsiTJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFcsiTJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7771F000E9;
	Tue, 21 Jul 2026 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669729;
	bh=/R66MaUkmnDQbKNIZ87ILbCpQEohhmQXF1RjnRpYzfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFcsiTJ3SjuM0NnbeIQqy6VIpunCmBI//dTYooWakhHvLIVEN7G2HW7IGWrOyTW6o
	 4QFj8e+dW/Ib0CaFjPwkCAW44+v3ujyh3/rz+6CsVYSP9ajQ+GBJCAvk+sVrZ5RgeU
	 GqZcIGFUCv2c0TjhvGchRmU2aT7v2DjdMN/rUhFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0666/1067] net/sched: act_bpf: use rcu_dereference_bh() to read the filter
Date: Tue, 21 Jul 2026 17:21:07 +0200
Message-ID: <20260721152439.496431790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index e33a6be877defd..c000a62b1bdae3 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -42,7 +42,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 	tcf_lastuse_update(&prog->tcf_tm);
 	bstats_update(this_cpu_ptr(prog->common.cpu_bstats), skb);
 
-	filter = rcu_dereference(prog->filter);
+	filter = rcu_dereference_bh(prog->filter);
 	if (at_ingress) {
 		__skb_push(skb, skb->mac_len);
 		filter_res = bpf_prog_run_data_pointers(filter, skb);
-- 
2.53.0



