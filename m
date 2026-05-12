Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3A364959;
	Tue, 12 May 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609618; cv=none; b=a377ecyhnRJsgSnBI7zae5PF6S1gjI3wVDHmKQk1njzQxuyAkJfBbI2hC7ujR6o7DzPwofUUl3TysN1yb1Z61SEXy1l/qrK4NfZa57yoTpXk2JfGCFadsAstubkvLSb/ehZWKi4xnJm/6gbuzG/2NYHkjBEgkiarRJTXlUidouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609618; c=relaxed/simple;
	bh=TEh8kxenU2OWLIglqZHAErCa133EZhFh48f4n+j0IwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9H4YJjL6NV6h3CeLLwHnc75URf03g3WsMToOsFcJ3Mj37yqOSN3wyE3Jx2mxpilR59Mk8T5AKRDagGE3w82L8cLEEO04Wi7sf6M35mBqOaSEL8M0CdXT5/Hws1dRAEjToKROAftO4l0NPGwnw5AKoAb2MpiV9+deTd8Z+Lq3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyE9CB8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyE9CB8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E60C2BCB0;
	Tue, 12 May 2026 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609617;
	bh=TEh8kxenU2OWLIglqZHAErCa133EZhFh48f4n+j0IwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyE9CB8E+haKSCf5xhVWlKVk8UGcEj5wbCAs/x02Pn+yxvVMAZ/3RmfLPfPCZZVrp
	 W5RaoBJMF/h0ZoAmMZfl/uzxGwNuO33yMeIfBhqxqDHO2WolskSCwSGHHZScq33trO
	 WDtA9XI7R12X60oBXEZ5NQZu1gambiIK7B4J1MnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Ryan Newton <newton@meta.com>
Subject: [PATCH 7.0 248/307] sched_ext: Use dsq->first_task instead of list_empty() in dispatch_enqueue() FIFO-tail
Date: Tue, 12 May 2026 19:40:43 +0200
Message-ID: <20260512173945.360002090@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2f2ea77092660b53bfcbc4acc590b57ce9ab5dce upstream.

dispatch_enqueue()'s FIFO-tail path used list_empty(&dsq->list) to decide
whether to set dsq->first_task on enqueue. dsq->list can contain parked BPF
iterator cursors (SCX_DSQ_LNODE_ITER_CURSOR), so list_empty() is not a
reliable "no real task" check. If the last real task is unlinked while a
cursor is parked, first_task becomes NULL; the next FIFO-tail enqueue then
sees list_empty() == false and skips the first_task update, leaving
scx_bpf_dsq_peek() returning NULL for a non-empty DSQ.

Test dsq->first_task directly, which already tracks only real tasks and is
maintained under dsq->lock.

Fixes: 44f5c8ec5b9a ("sched_ext: Add lockless peek operation for DSQs")
Cc: stable@vger.kernel.org # v6.19+
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Cc: Ryan Newton <newton@meta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1093,11 +1093,13 @@ static void dispatch_enqueue(struct scx_
 			if (!(dsq->id & SCX_DSQ_FLAG_BUILTIN))
 				rcu_assign_pointer(dsq->first_task, p);
 		} else {
-			bool was_empty;
-
-			was_empty = list_empty(&dsq->list);
+			/*
+			 * dsq->list can contain parked BPF iterator cursors, so
+			 * list_empty() here isn't a reliable proxy for "no real
+			 * task in the DSQ". Test dsq->first_task directly.
+			 */
 			list_add_tail(&p->scx.dsq_list.node, &dsq->list);
-			if (was_empty && !(dsq->id & SCX_DSQ_FLAG_BUILTIN))
+			if (!dsq->first_task && !(dsq->id & SCX_DSQ_FLAG_BUILTIN))
 				rcu_assign_pointer(dsq->first_task, p);
 		}
 	}


