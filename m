Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A31F790F;
	Tue, 26 Aug 2025 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218088; cv=none; b=jgE/2xNS8THRiFGPtnDnQhZrTxJrm70lP4DhhguWduixkfsg3SJUdff7GW2AGy/5hisQ4Vk/Ec9au/lZpMfpbwuyPxCR1QHmjeDcjzbl8nT4xZ1986i8scvyholfwSWWrEDQfb1asNs8C0rxV9FtxI11nLJhHYeHYDSyJKD9Dsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218088; c=relaxed/simple;
	bh=nMMjJKE3KEWv3U5z8li/Lq4OwdeM8xhajbfDDiX+z4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jfk1t0u9WlipDtqn1ikwf36TiXS59HQJd8VMzWibbBHO41QO9CGKqdM0+Dqh2icx+hoVsOWPsOt+5i6vbopeNaxJA6xUJL7X89M9vJvOjznkblBuQ7H/N8p/GCk6gh03+/ED5XHiXZR4geq8Jj7TbLUNckjaqwonD6yL0f6GskI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IP9djklc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IP9djklc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C285C113CF;
	Tue, 26 Aug 2025 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218087;
	bh=nMMjJKE3KEWv3U5z8li/Lq4OwdeM8xhajbfDDiX+z4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IP9djklcRpP1Jgp5eV/O1tyJRSKTe8HsPZR/dIV3lOWZtRZ+7lw+tLN5fwYroduNn
	 YoSZMfkaKRzxu+2MqykE1gZc3Bh9ZsCgVqhK+WbA2/O/ph90bD7LDc4Ykj4HYOXlP2
	 iAZZbeZTKCk1XABYnKpDY4f9kIsXtPyb6t40WtzQ=
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
Subject: [PATCH 5.10 388/523] sch_hfsc: make hfsc_qlen_notify() idempotent
Date: Tue, 26 Aug 2025 13:09:58 +0200
Message-ID: <20250826110934.028346800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hfsc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -209,7 +209,10 @@ eltree_insert(struct hfsc_class *cl)
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
@@ -1230,7 +1233,8 @@ hfsc_qlen_notify(struct Qdisc *sch, unsi
 	/* vttree is now handled in update_vf() so that update_vf(cl, 0, 0)
 	 * needs to be called explicitly to remove a class from vttree.
 	 */
-	update_vf(cl, 0, 0);
+	if (cl->cl_nactive)
+		update_vf(cl, 0, 0);
 	if (cl->cl_flags & HFSC_RSC)
 		eltree_remove(cl);
 }


