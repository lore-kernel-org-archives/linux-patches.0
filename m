Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868AA194A67;
	Tue, 27 May 2025 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364785; cv=none; b=Qhq4P6cDGiisKg4WioVzkJGja8Vjbt6jIRC/7aIekpff6P9XeckruhLhdGQJr4ghMl7/gurL9SrXf5g+2HLzIGXDgOg3TctcaczHlRXTlCs1d/uosZCAMyw+zaXKdmDeVyfUGUoVWClMmtwA2q0eIeITCrqUnVppv42m4ftDH5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364785; c=relaxed/simple;
	bh=eP34UMOP/Vx33sehqtLYHmFv3zfLV92ZaOvAPQDKy0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgmKkqxCP+OKE2MwfkxYGEPUNjbnd3B0rVcB42O0GYZ5lA2Z5m1OPjh8q7KaoOwXnlbRydwgopPTlL7D7k33gqzD8piOSXEtqpjBwzN18zI8a2H+70W0tvCFTHpqcCPtlIyCT0DSEke4LOMoX9HFkuqVnwSpneOBBbnyTTKDjVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMeH7k7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMeH7k7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FC3C4CEE9;
	Tue, 27 May 2025 16:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364785;
	bh=eP34UMOP/Vx33sehqtLYHmFv3zfLV92ZaOvAPQDKy0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMeH7k7DcetRBXcvbpdJ1nWDGrO7BqpKWiIhqnzbeDxDuo+bcgHBoLTnHFHp7YcZp
	 RJVg2sIsVsuWWgvbAMbcRrTUZcUCDJBmrta8Vv904Uhibyl02k8ntU0TwLMZEEp40h
	 YYnybLOko7XW90hiHZyvu0jJarqunWQqpDju9Ja0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/626] RDMA/uverbs: Propagate errors from rdma_lookup_get_uobject()
Date: Tue, 27 May 2025 18:20:58 +0200
Message-ID: <20250527162451.729750169@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 81f8f7454ad9e0bf95efdec6542afdc9a6ab1e24 ]

Currently, the IB uverbs API calls uobj_get_uobj_read(), which in turn
uses the rdma_lookup_get_uobject() helper to retrieve user objects.
In case of failure, uobj_get_uobj_read() returns NULL, overriding the
error code from rdma_lookup_get_uobject(). The IB uverbs API then
translates this NULL to -EINVAL, masking the actual error and
complicating debugging. For example, applications calling ibv_modify_qp
that fails with EBUSY when retrieving the QP uobject will see the
overridden error code EINVAL instead, masking the actual error.

Furthermore, based on rdma-core commit:
"2a22f1ced5f3 ("Merge pull request #1568 from jakemoroni/master")"
Kernel's IB uverbs return values are either ignored and passed on as is
to application or overridden with other errnos in a few cases.

Thus, to improve error reporting and debuggability, propagate the
original error from rdma_lookup_get_uobject() instead of replacing it
with EINVAL.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/64f9d3711b183984e939962c2f83383904f97dfb.1740577869.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 144 ++++++++++++++-------------
 include/rdma/uverbs_std_types.h      |   2 +-
 2 files changed, 77 insertions(+), 69 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index edef79daed3fa..535bb99ed9f5f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -718,8 +718,8 @@ static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
 		goto err_free;
 
 	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle, attrs);
-	if (!pd) {
-		ret = -EINVAL;
+	if (IS_ERR(pd)) {
+		ret = PTR_ERR(pd);
 		goto err_free;
 	}
 
@@ -809,8 +809,8 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 	if (cmd.flags & IB_MR_REREG_PD) {
 		new_pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle,
 					   attrs);
-		if (!new_pd) {
-			ret = -EINVAL;
+		if (IS_ERR(new_pd)) {
+			ret = PTR_ERR(new_pd);
 			goto put_uobjs;
 		}
 	} else {
@@ -919,8 +919,8 @@ static int ib_uverbs_alloc_mw(struct uverbs_attr_bundle *attrs)
 		return PTR_ERR(uobj);
 
 	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle, attrs);
-	if (!pd) {
-		ret = -EINVAL;
+	if (IS_ERR(pd)) {
+		ret = PTR_ERR(pd);
 		goto err_free;
 	}
 
@@ -1127,8 +1127,8 @@ static int ib_uverbs_resize_cq(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	cq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ, cmd.cq_handle, attrs);
-	if (!cq)
-		return -EINVAL;
+	if (IS_ERR(cq))
+		return PTR_ERR(cq);
 
 	ret = cq->device->ops.resize_cq(cq, cmd.cqe, &attrs->driver_udata);
 	if (ret)
@@ -1189,8 +1189,8 @@ static int ib_uverbs_poll_cq(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	cq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ, cmd.cq_handle, attrs);
-	if (!cq)
-		return -EINVAL;
+	if (IS_ERR(cq))
+		return PTR_ERR(cq);
 
 	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
 	header_ptr = attrs->ucore.outbuf;
@@ -1238,8 +1238,8 @@ static int ib_uverbs_req_notify_cq(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	cq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ, cmd.cq_handle, attrs);
-	if (!cq)
-		return -EINVAL;
+	if (IS_ERR(cq))
+		return PTR_ERR(cq);
 
 	ib_req_notify_cq(cq, cmd.solicited_only ?
 			 IB_CQ_SOLICITED : IB_CQ_NEXT_COMP);
@@ -1321,8 +1321,8 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 		ind_tbl = uobj_get_obj_read(rwq_ind_table,
 					    UVERBS_OBJECT_RWQ_IND_TBL,
 					    cmd->rwq_ind_tbl_handle, attrs);
-		if (!ind_tbl) {
-			ret = -EINVAL;
+		if (IS_ERR(ind_tbl)) {
+			ret = PTR_ERR(ind_tbl);
 			goto err_put;
 		}
 
@@ -1360,8 +1360,10 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 			if (cmd->is_srq) {
 				srq = uobj_get_obj_read(srq, UVERBS_OBJECT_SRQ,
 							cmd->srq_handle, attrs);
-				if (!srq || srq->srq_type == IB_SRQT_XRC) {
-					ret = -EINVAL;
+				if (IS_ERR(srq) ||
+				    srq->srq_type == IB_SRQT_XRC) {
+					ret = IS_ERR(srq) ? PTR_ERR(srq) :
+								  -EINVAL;
 					goto err_put;
 				}
 			}
@@ -1371,23 +1373,29 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 					rcq = uobj_get_obj_read(
 						cq, UVERBS_OBJECT_CQ,
 						cmd->recv_cq_handle, attrs);
-					if (!rcq) {
-						ret = -EINVAL;
+					if (IS_ERR(rcq)) {
+						ret = PTR_ERR(rcq);
 						goto err_put;
 					}
 				}
 			}
 		}
 
-		if (has_sq)
+		if (has_sq) {
 			scq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ,
 						cmd->send_cq_handle, attrs);
+			if (IS_ERR(scq)) {
+				ret = PTR_ERR(scq);
+				goto err_put;
+			}
+		}
+
 		if (!ind_tbl && cmd->qp_type != IB_QPT_XRC_INI)
 			rcq = rcq ?: scq;
 		pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd->pd_handle,
 				       attrs);
-		if (!pd || (!scq && has_sq)) {
-			ret = -EINVAL;
+		if (IS_ERR(pd)) {
+			ret = PTR_ERR(pd);
 			goto err_put;
 		}
 
@@ -1482,18 +1490,18 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 err_put:
 	if (!IS_ERR(xrcd_uobj))
 		uobj_put_read(xrcd_uobj);
-	if (pd)
+	if (!IS_ERR_OR_NULL(pd))
 		uobj_put_obj_read(pd);
-	if (scq)
+	if (!IS_ERR_OR_NULL(scq))
 		rdma_lookup_put_uobject(&scq->uobject->uevent.uobject,
 					UVERBS_LOOKUP_READ);
-	if (rcq && rcq != scq)
+	if (!IS_ERR_OR_NULL(rcq) && rcq != scq)
 		rdma_lookup_put_uobject(&rcq->uobject->uevent.uobject,
 					UVERBS_LOOKUP_READ);
-	if (srq)
+	if (!IS_ERR_OR_NULL(srq))
 		rdma_lookup_put_uobject(&srq->uobject->uevent.uobject,
 					UVERBS_LOOKUP_READ);
-	if (ind_tbl)
+	if (!IS_ERR_OR_NULL(ind_tbl))
 		uobj_put_obj_read(ind_tbl);
 
 	uobj_alloc_abort(&obj->uevent.uobject, attrs);
@@ -1655,8 +1663,8 @@ static int ib_uverbs_query_qp(struct uverbs_attr_bundle *attrs)
 	}
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
-	if (!qp) {
-		ret = -EINVAL;
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
 		goto out;
 	}
 
@@ -1761,8 +1769,8 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd->base.qp_handle,
 			       attrs);
-	if (!qp) {
-		ret = -EINVAL;
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
 		goto out;
 	}
 
@@ -2028,8 +2036,8 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
 		return -ENOMEM;
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
-	if (!qp) {
-		ret = -EINVAL;
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
 		goto out;
 	}
 
@@ -2066,9 +2074,9 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
 
 			ud->ah = uobj_get_obj_read(ah, UVERBS_OBJECT_AH,
 						   user_wr->wr.ud.ah, attrs);
-			if (!ud->ah) {
+			if (IS_ERR(ud->ah)) {
+				ret = PTR_ERR(ud->ah);
 				kfree(ud);
-				ret = -EINVAL;
 				goto out_put;
 			}
 			ud->remote_qpn = user_wr->wr.ud.remote_qpn;
@@ -2305,8 +2313,8 @@ static int ib_uverbs_post_recv(struct uverbs_attr_bundle *attrs)
 		return PTR_ERR(wr);
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
-	if (!qp) {
-		ret = -EINVAL;
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
 		goto out;
 	}
 
@@ -2356,8 +2364,8 @@ static int ib_uverbs_post_srq_recv(struct uverbs_attr_bundle *attrs)
 		return PTR_ERR(wr);
 
 	srq = uobj_get_obj_read(srq, UVERBS_OBJECT_SRQ, cmd.srq_handle, attrs);
-	if (!srq) {
-		ret = -EINVAL;
+	if (IS_ERR(srq)) {
+		ret = PTR_ERR(srq);
 		goto out;
 	}
 
@@ -2413,8 +2421,8 @@ static int ib_uverbs_create_ah(struct uverbs_attr_bundle *attrs)
 	}
 
 	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle, attrs);
-	if (!pd) {
-		ret = -EINVAL;
+	if (IS_ERR(pd)) {
+		ret = PTR_ERR(pd);
 		goto err;
 	}
 
@@ -2483,8 +2491,8 @@ static int ib_uverbs_attach_mcast(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
-	if (!qp)
-		return -EINVAL;
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
 
 	obj = qp->uobject;
 
@@ -2533,8 +2541,8 @@ static int ib_uverbs_detach_mcast(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
-	if (!qp)
-		return -EINVAL;
+	if (IS_ERR(qp))
+		return PTR_ERR(qp);
 
 	obj = qp->uobject;
 	mutex_lock(&obj->mcast_lock);
@@ -2668,8 +2676,8 @@ static int kern_spec_to_ib_spec_action(struct uverbs_attr_bundle *attrs,
 							UVERBS_OBJECT_FLOW_ACTION,
 							kern_spec->action.handle,
 							attrs);
-		if (!ib_spec->action.act)
-			return -EINVAL;
+		if (IS_ERR(ib_spec->action.act))
+			return PTR_ERR(ib_spec->action.act);
 		ib_spec->action.size =
 			sizeof(struct ib_flow_spec_action_handle);
 		flow_resources_add(uflow_res,
@@ -2686,8 +2694,8 @@ static int kern_spec_to_ib_spec_action(struct uverbs_attr_bundle *attrs,
 					  UVERBS_OBJECT_COUNTERS,
 					  kern_spec->flow_count.handle,
 					  attrs);
-		if (!ib_spec->flow_count.counters)
-			return -EINVAL;
+		if (IS_ERR(ib_spec->flow_count.counters))
+			return PTR_ERR(ib_spec->flow_count.counters);
 		ib_spec->flow_count.size =
 				sizeof(struct ib_flow_spec_action_count);
 		flow_resources_add(uflow_res,
@@ -2905,14 +2913,14 @@ static int ib_uverbs_ex_create_wq(struct uverbs_attr_bundle *attrs)
 		return PTR_ERR(obj);
 
 	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle, attrs);
-	if (!pd) {
-		err = -EINVAL;
+	if (IS_ERR(pd)) {
+		err = PTR_ERR(pd);
 		goto err_uobj;
 	}
 
 	cq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ, cmd.cq_handle, attrs);
-	if (!cq) {
-		err = -EINVAL;
+	if (IS_ERR(cq)) {
+		err = PTR_ERR(cq);
 		goto err_put_pd;
 	}
 
@@ -3013,8 +3021,8 @@ static int ib_uverbs_ex_modify_wq(struct uverbs_attr_bundle *attrs)
 		return -EINVAL;
 
 	wq = uobj_get_obj_read(wq, UVERBS_OBJECT_WQ, cmd.wq_handle, attrs);
-	if (!wq)
-		return -EINVAL;
+	if (IS_ERR(wq))
+		return PTR_ERR(wq);
 
 	if (cmd.attr_mask & IB_WQ_FLAGS) {
 		wq_attr.flags = cmd.flags;
@@ -3097,8 +3105,8 @@ static int ib_uverbs_ex_create_rwq_ind_table(struct uverbs_attr_bundle *attrs)
 			num_read_wqs++) {
 		wq = uobj_get_obj_read(wq, UVERBS_OBJECT_WQ,
 				       wqs_handles[num_read_wqs], attrs);
-		if (!wq) {
-			err = -EINVAL;
+		if (IS_ERR(wq)) {
+			err = PTR_ERR(wq);
 			goto put_wqs;
 		}
 
@@ -3253,8 +3261,8 @@ static int ib_uverbs_ex_create_flow(struct uverbs_attr_bundle *attrs)
 	}
 
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
-	if (!qp) {
-		err = -EINVAL;
+	if (IS_ERR(qp)) {
+		err = PTR_ERR(qp);
 		goto err_uobj;
 	}
 
@@ -3400,15 +3408,15 @@ static int __uverbs_create_xsrq(struct uverbs_attr_bundle *attrs,
 	if (ib_srq_has_cq(cmd->srq_type)) {
 		attr.ext.cq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ,
 						cmd->cq_handle, attrs);
-		if (!attr.ext.cq) {
-			ret = -EINVAL;
+		if (IS_ERR(attr.ext.cq)) {
+			ret = PTR_ERR(attr.ext.cq);
 			goto err_put_xrcd;
 		}
 	}
 
 	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd->pd_handle, attrs);
-	if (!pd) {
-		ret = -EINVAL;
+	if (IS_ERR(pd)) {
+		ret = PTR_ERR(pd);
 		goto err_put_cq;
 	}
 
@@ -3515,8 +3523,8 @@ static int ib_uverbs_modify_srq(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	srq = uobj_get_obj_read(srq, UVERBS_OBJECT_SRQ, cmd.srq_handle, attrs);
-	if (!srq)
-		return -EINVAL;
+	if (IS_ERR(srq))
+		return PTR_ERR(srq);
 
 	attr.max_wr    = cmd.max_wr;
 	attr.srq_limit = cmd.srq_limit;
@@ -3543,8 +3551,8 @@ static int ib_uverbs_query_srq(struct uverbs_attr_bundle *attrs)
 		return ret;
 
 	srq = uobj_get_obj_read(srq, UVERBS_OBJECT_SRQ, cmd.srq_handle, attrs);
-	if (!srq)
-		return -EINVAL;
+	if (IS_ERR(srq))
+		return PTR_ERR(srq);
 
 	ret = ib_query_srq(srq, &attr);
 
@@ -3669,8 +3677,8 @@ static int ib_uverbs_ex_modify_cq(struct uverbs_attr_bundle *attrs)
 		return -EOPNOTSUPP;
 
 	cq = uobj_get_obj_read(cq, UVERBS_OBJECT_CQ, cmd.cq_handle, attrs);
-	if (!cq)
-		return -EINVAL;
+	if (IS_ERR(cq))
+		return PTR_ERR(cq);
 
 	ret = rdma_set_cq_moderation(cq, cmd.attr.cq_count, cmd.attr.cq_period);
 
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index fe05121169589..555ea3d142a46 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -34,7 +34,7 @@
 static inline void *_uobj_get_obj_read(struct ib_uobject *uobj)
 {
 	if (IS_ERR(uobj))
-		return NULL;
+		return ERR_CAST(uobj);
 	return uobj->object;
 }
 #define uobj_get_obj_read(_object, _type, _id, _attrs)                         \
-- 
2.39.5



