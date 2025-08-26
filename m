Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475BC34DCD2;
	Tue, 26 Aug 2025 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216792; cv=none; b=CmvrzsJBSt78sad4yy2+C9YFBo8XnH88FtOKoAJD13If449seSCJm1+iOcTMyfUr9E9rGQnef6F6+pqXsgSG98+KLsY5XsqokvI201i0VymBqqtDr1fbb25ZSN7NVsMsXjAwBatIjeUBMGReopOJG5AGuSYELp1NDDJkI/Djx3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216792; c=relaxed/simple;
	bh=sJ6Jk2AQ1ZTUk3WSs4kElVlcJIy3tttq+NJHiWBGEQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knDkLncAhDFvKXShy9kZwo4diCGBb11Qtk8MdImGuWg7XzELqtLuq2qix1zS3S7Ybly5rwVbYelrFS94PvZKw9vYyXo6UZcvRlPOMSwrYXFTS5RaWCuPKDlJcxPpdBUxiRuxySSd04xKHWia4UeHdn7MvCVrHuwJq5A9HQgZOUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJB5eg2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJB5eg2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE00C4CEF1;
	Tue, 26 Aug 2025 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216791;
	bh=sJ6Jk2AQ1ZTUk3WSs4kElVlcJIy3tttq+NJHiWBGEQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJB5eg2oCqVPQ7fbtFYoVlpjVe5NDFMZRb574xIGwUArQ3BQR1bo6cDM0E1g3MlUc
	 6WJjPzFhWt5i5X1c98IxAjKiSPQB1Q0Cfxg6Jz5BTH73iYVf0U+Zwjhjgzw3bfxqXC
	 OkL9FHEpXOVTOOhsOTNPAjS9XHDRS+yzCP1RhDeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.15 546/644] sch_drr: make drr_qlen_notify() idempotent
Date: Tue, 26 Aug 2025 13:10:37 +0200
Message-ID: <20250826111000.057559587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_drr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -111,6 +111,7 @@ static int drr_change_class(struct Qdisc
 	if (cl == NULL)
 		return -ENOBUFS;
 
+	INIT_LIST_HEAD(&cl->alist);
 	cl->common.classid = classid;
 	cl->quantum	   = quantum;
 	cl->qdisc	   = qdisc_create_dflt(sch->dev_queue,
@@ -235,7 +236,7 @@ static void drr_qlen_notify(struct Qdisc
 {
 	struct drr_class *cl = (struct drr_class *)arg;
 
-	list_del(&cl->alist);
+	list_del_init(&cl->alist);
 }
 
 static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
@@ -402,7 +403,7 @@ static struct sk_buff *drr_dequeue(struc
 			if (unlikely(skb == NULL))
 				goto out;
 			if (cl->qdisc->q.qlen == 0)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 
 			bstats_update(&cl->bstats, skb);
 			qdisc_bstats_update(sch, skb);
@@ -443,7 +444,7 @@ static void drr_reset_qdisc(struct Qdisc
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->qdisc->q.qlen)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 			qdisc_reset(cl->qdisc);
 		}
 	}


