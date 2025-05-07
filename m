Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43E01482F5;
	Wed,  7 May 2025 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644233; cv=none; b=aeeegB4Azci12cGT2P3H0EbywSRmJf+159cFnJxFmwSK4yRMQlRp0nqR0q70M88pYqOy+2Psi71pFN3oLbogV2tOQD2IycwEy1BEMmmrKA2puUQTNg7ve71hllNUndD3HabG1GAhG34zjuA3Dba0kUUD59Q+UWMGjVdhGkwrng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644233; c=relaxed/simple;
	bh=w58Fa7LCnqrHobBCLv2HbjojGPPf54Jkg2iTw20YJOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxHSzEfQpOWuCpxufziPXlGBRzPib3F7N1ElWIkJWKO1mwo5MlfF+1rXz7Og/lCvPgjmPkWKKqp3l0AccS5H+An5nrNw98TNXaHrq7rqpgoT05hkwxK/Hsag/N5rPxiopojrSjdYKJu5+QvQRjgs8thBfj66l9Ce1wBYtAJf9Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0PiwfaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0PiwfaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3C2C4CEE2;
	Wed,  7 May 2025 18:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644232;
	bh=w58Fa7LCnqrHobBCLv2HbjojGPPf54Jkg2iTw20YJOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0PiwfaM+GAHcDtIFWL8CHDV5IM12K9soJ/9173keMxCyKa4oOPHYgLCShQYwpSnl
	 nrFLKbM4hF4uDPcGThAOKO+DAsZFdlCQ8E8SaPbSubdWgy4NRe4rh84DmkmNe9NQtF
	 DZflLiC3ug/+PJEOGHYerMUk5HhufTD088IEZjQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.14 162/183] sch_drr: make drr_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:40:07 +0200
Message-ID: <20250507183831.430560950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit df008598b3a00be02a8051fde89ca0fbc416bd55 upstream.

drr_qlen_notify() always deletes the DRR class from its active list
with list_del(), therefore, it is not idempotent and not friendly
to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life. Also change other list_del()'s to list_del_init() just to be
extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-3-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_drr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -110,6 +110,7 @@ static int drr_change_class(struct Qdisc
 		return -ENOBUFS;
 
 	gnet_stats_basic_sync_init(&cl->bstats);
+	INIT_LIST_HEAD(&cl->alist);
 	cl->common.classid = classid;
 	cl->quantum	   = quantum;
 	cl->qdisc	   = qdisc_create_dflt(sch->dev_queue,
@@ -234,7 +235,7 @@ static void drr_qlen_notify(struct Qdisc
 {
 	struct drr_class *cl = (struct drr_class *)arg;
 
-	list_del(&cl->alist);
+	list_del_init(&cl->alist);
 }
 
 static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
@@ -393,7 +394,7 @@ static struct sk_buff *drr_dequeue(struc
 			if (unlikely(skb == NULL))
 				goto out;
 			if (cl->qdisc->q.qlen == 0)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 
 			bstats_update(&cl->bstats, skb);
 			qdisc_bstats_update(sch, skb);
@@ -434,7 +435,7 @@ static void drr_reset_qdisc(struct Qdisc
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->qdisc->q.qlen)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 			qdisc_reset(cl->qdisc);
 		}
 	}


