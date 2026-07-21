Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF3E44AB61;
	Tue, 21 Jul 2026 21:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669122; cv=none; b=kHDQkp8yLWS03iOo9sIhY6aIQUkG5RKs7CVp0h6D5p5yoGnDfJCHH5402qohzElUs+ROSMQmPSPw+EsHx0zbG+46zfvf2PZ9tjza+KFHj7x7z3FHC8sPqoYQ3zbXzcEEoqYqOKW58Ciw3C1TrOHkLQLCo92EzXOT7wLMEK1GXgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669122; c=relaxed/simple;
	bh=rTXcka0EB8xXXcGkBDtDhJgLxMdAuylnjaOKEysiV9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGRyS1QPKJZJenqUYvPYaz+JFldCe5ilurabofmaMWNg8fA5v91qNlc3gArnUl+k/zP7X+jQt/dnaYAsf2k8yHVtDWa/FW5DheRs6ky3MN9vSrhs8avWs6fAVtvFUjoU/9LE8eFe4x2AMkc2NwS/VRibJARNjXShZQqbmyuUTXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2K47vnVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2K47vnVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F2F1F000E9;
	Tue, 21 Jul 2026 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669121;
	bh=PKer9scXP1VXZMGfu0YkFEAs2ckEuqeTalCL6WF42VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2K47vnVs66s3YdqPqxOIk8p7+NY7JZl5R7oZ6kPnOlqvETuLr5T7uzbnZ9KzV7VBD
	 POBywOsmx6KG1vH6FqnGXrC4XyM17cIkHx8xdIMsOTRFb/uVS7xBtEY4Bs65FVg7LY
	 q3efoLin1BA1HFQs8A51toaX/3KvE3vu5O5kVaVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Gupta <anirudhrudr@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0436/1067] net/sched: sch_hfsc: Dont make class passive twice
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152434.368934465@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 90b662ea25f5e83bb3b8ccec5b93ced810b92fb8 ]

update_vf() is called from two places for the same class during a single
dequeue when the class's child qdisc (e.g. codel/fq_codel) drops its last
packets while dequeuing:

1. The child calls qdisc_tree_reduce_backlog(), which, now that the child
   is empty, invokes hfsc_qlen_notify() -> update_vf(cl, 0, 0) and turns
   the class passive (cl_nactive is decremented up the hierarchy).

2. hfsc_dequeue() then calls update_vf(cl, qdisc_pkt_len(skb), cur_time)
   to charge the dequeued bytes.

On the second call the class is already passive, but its child qdisc is
still empty, so update_vf() arms go_passive again:

      if (cl->qdisc->q.qlen == 0 && cl->cl_flags & HFSC_FSC)
              go_passive = 1;

The leaf is then skipped by the cl_nactive == 0 check inside the loop,
which does not clear go_passive, so the stale go_passive propagates to the
parent and decrements its cl_nactive a second time. A parent that still
has other active children is driven to cl_nactive == 0 and removed from
the vttree, even though those siblings are still backlogged. They are
never dequeued again and the qdisc stalls.

Fix this by only arming go_passive when the class is actually active, so an
already-passive class no longer triggers a second passive transition. The
byte accounting (cl->cl_total += len) still runs for every ancestor, so
dequeued bytes continue to be counted exactly once.

Fixes: 51eb3b65544c ("sch_hfsc: make hfsc_qlen_notify() idempotent")
Reported-by: Anirudh Gupta <anirudhrudr@gmail.com>
Closes: https://lore.kernel.org/netdev/CAN2cbVe79oj0O9==m4+4x3v+O+qzRagA=2=wkrp9i9=CqYvyZA@mail.gmail.com/
Tested-by: Anirudh Gupta <anirudhrudr@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260610132824.3027549-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 80acdec16d2f67..2d6baf7d7b0366 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -754,7 +754,7 @@ update_vf(struct hfsc_class *cl, unsigned int len, u64 cur_time)
 	u64 f; /* , myf_bound, delta; */
 	int go_passive = 0;
 
-	if (cl->qdisc->q.qlen == 0 && cl->cl_flags & HFSC_FSC)
+	if (cl->qdisc->q.qlen == 0 && cl->cl_flags & HFSC_FSC && cl->cl_nactive)
 		go_passive = 1;
 
 	for (; cl->cl_parent != NULL; cl = cl->cl_parent) {
-- 
2.53.0



