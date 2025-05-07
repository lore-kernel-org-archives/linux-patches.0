Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD1628DF5A;
	Wed,  7 May 2025 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645122; cv=none; b=Z41MEaRDX7jqK1aATudB2BfZQSh7aK9setaJbsPxX/jRAis3SgR6CBCp45ZNvVH3VfrKoh0uDV3XY+rS/HBSdboJfD0EuskG7Vk99plJ5f33DXr7BaERAqZwCcPpEk+2bDYLlMdZgCcBuu5Bdv772w/dxeMoe4XAOmmPaGUjUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645122; c=relaxed/simple;
	bh=cpqg12718Yq06usUY1pBa2EwFb/DDfpdmaVA7hE3bLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkTewgXc5V/W0WBBw+veGeWAdm4elDfvFMuUAryX9N6EdqWCSk0oCphUo2d2ice+1iR1NuzqyMjCg8d97yKAGwSUOqiV7J+9ZVO7doA3SpngI15wkrqVC/Mld2osteTgWeXtb0VGwiPH9WqoMMI8dQA22IzYFKroDD5d6duH67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kO4LmDZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO4LmDZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81443C4CEE2;
	Wed,  7 May 2025 19:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645122;
	bh=cpqg12718Yq06usUY1pBa2EwFb/DDfpdmaVA7hE3bLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO4LmDZRGK005V2DgpxMZExNyLj4DSHdIkMA7/WpQTp2J/dmN8EYXvK3IaffehA0Z
	 mQTmpK73ITsrgW0ZT1aDV+NBp9/8ZxULJ9oUnacVNHgNQPa1ygz4bunOQ3koNBmoz1
	 92n9ZHZwtIHTPOyt44Oq9fvfusvE0fOk+pBC9S/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 101/129] sch_hfsc: make hfsc_qlen_notify() idempotent
Date: Wed,  7 May 2025 20:40:37 +0200
Message-ID: <20250507183817.592205133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb upstream.

hfsc_qlen_notify() is not idempotent either and not friendly
to its callers, like fq_codel_dequeue(). Let's make it idempotent
to ease qdisc_tree_reduce_backlog() callers' life:

1. update_vf() decreases cl->cl_nactive, so we can check whether it is
non-zero before calling it.

2. eltree_remove() always removes RB node cl->el_node, but we can use
   RB_EMPTY_NODE() + RB_CLEAR_NODE() to make it safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-4-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hfsc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -203,7 +203,10 @@ eltree_insert(struct hfsc_class *cl)
 static inline void
 eltree_remove(struct hfsc_class *cl)
 {
-	rb_erase(&cl->el_node, &cl->sched->eligible);
+	if (!RB_EMPTY_NODE(&cl->el_node)) {
+		rb_erase(&cl->el_node, &cl->sched->eligible);
+		RB_CLEAR_NODE(&cl->el_node);
+	}
 }
 
 static inline void
@@ -1224,7 +1227,8 @@ hfsc_qlen_notify(struct Qdisc *sch, unsi
 	/* vttree is now handled in update_vf() so that update_vf(cl, 0, 0)
 	 * needs to be called explicitly to remove a class from vttree.
 	 */
-	update_vf(cl, 0, 0);
+	if (cl->cl_nactive)
+		update_vf(cl, 0, 0);
 	if (cl->cl_flags & HFSC_RSC)
 		eltree_remove(cl);
 }


