Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCA0444709;
	Tue, 21 Jul 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672120; cv=none; b=H1j0fC1nyCrySeya6faddtePUCODXHNDd3jg3XdGJZlcOLsqOgzVDqtEJzQPy7Rjx5nSXqkT4NGRjo4GBsfh8yBl/YeFogldOxffd7pPgsG9LwbbOFDqm8iKx3sI/ZJn5kZusm5Alr9VA51wECPkQXe8utqceR2QAfuWNIaa2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672120; c=relaxed/simple;
	bh=pPXrnPHkKJpFuRoXYmjZzs3Uv9Gyvvy/EiweGyEHalc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlyFiDn7bZv38a9JdbzAYyM4myIVq9NAppODmYYI3LG8RNaq1JqKhBdybPZmfr0m3MNlb94wBRnfqUzgZ7I0McAqkmfiObcob6MMBteFXol23EuakcbRg5BagWN/AFuVGiTB3BFINR9t6EL/bkefkRGKO0OiusXdz/a/Uj/YRMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SKSl3iP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SKSl3iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DADF1F000E9;
	Tue, 21 Jul 2026 22:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672118;
	bh=us52ehSVSr8U6SBky08vT0PS2wCUlqrzXVcKe0BbcFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SKSl3iPQbzjUXUeS9kL9fZDa75BW+YxmKb79mygv9ktHyv2rnFUXxnbqj6yakwP0
	 7ogejb7nScQbJH0URdKgoeyyVNgUlFLtoBqoiMymIJKurHPWTkAD7inQNqnlaPM4kX
	 m6pdF02R3K5Ip5OcSaTmkJ+EC6owmgIldEWM4P6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/843] net/sched: act_bpf: use rcu_dereference_bh() to read the filter
Date: Tue, 21 Jul 2026 17:22:20 +0200
Message-ID: <20260721152417.391244514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e1b6e88feaf513..e3fa5b17ea7fc5 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -42,7 +42,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 	tcf_lastuse_update(&prog->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(prog->common.cpu_bstats), skb);
 
-	filter = rcu_dereference(prog->filter);
+	filter = rcu_dereference_bh(prog->filter);
 	if (at_ingress) {
 		__skb_push(skb, skb->mac_len);
 		filter_res = bpf_prog_run_data_pointers(filter, skb);
-- 
2.53.0



