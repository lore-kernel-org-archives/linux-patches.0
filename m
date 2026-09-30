Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF86B511E9D;
	Wed, 30 Sep 2026 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783360; cv=none; b=OhuOwLlNwDRVU4JJQpZGdTn2ZJGzfio2tAvaBESVU8u+IWlclTIx0w5tkJbforQub4zy1fmFIiPPE8zQTF+zY3wQt2lrbWN/5zHpqnHm+zzAmUBRbybw5lPhau81+bYF5k2M3rhcljbvO+NQ7IfKSBxJLuQmia88hS8BtILcK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783360; c=relaxed/simple;
	bh=AR2eO9ojudo8f9Hd29T9JBxg/woNj1swocXJ/znAAz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSqN2H/LWPr44lz0OXudcENOZRe2ItYxege3hp6tXZpHQcNkUkRWox3b+dhOXrbtv4n2Brb3LVeT1T6GC22qhF+m5lNE/N0NeZruBwHfTxMfTclu7xHMFrx6yFB0eBvFiJjy9p97TkM5vQoLbix0vwffrT78/3EISF6tNa0IePM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBlz6X/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBlz6X/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE70B1F000FF;
	Wed, 30 Sep 2026 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783356;
	bh=k94zlvC+0X+vdU9Ss8z0VHZL50l21rI5i/ckUkd7rIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBlz6X/FcyEDkVrdCxgq/Xv94GTLJ+Yvt2wgx73gYN+XtDgMEYVnY7fq2/RMkxcKB
	 qdVUIjZ6/WKO+4igxK6cCLB+uOc1e//uxFw8ALCuVGT3aEAPJHbTsIQ2IqNPs8GB+L
	 gr6JsbTs7GFy38mAKPe8dKaEGb2twTN3/yJCUlLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/595] RDMA/siw: Cleanup siw_accept
Date: Wed, 30 Sep 2026 17:24:06 +0200
Message-ID: <20260930152355.271597119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 77b59bd932a026b64303d313d966decb0e9225fa ]

With the initialization of rv and the two added label, we can
simplifiy code a bit.

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-13-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 32cd87f54dd1 ("RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 41 ++++++++++--------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index de71e32258a6b..f17dbb9237df7 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1548,7 +1548,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	struct siw_cep *cep = (struct siw_cep *)id->provider_data;
 	struct siw_qp *qp;
 	struct siw_qp_attrs qp_attrs;
-	int rv, max_priv_data = MPA_MAX_PRIVDATA;
+	int rv = -EINVAL, max_priv_data = MPA_MAX_PRIVDATA;
 	bool wait_for_peer_rts = false;
 
 	siw_cep_set_inuse(cep);
@@ -1564,24 +1564,17 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
 		siw_dbg_cep(cep, "out of state\n");
-
-		siw_cep_set_free_and_put(cep);
-
-		return -ECONNRESET;
+		rv = -ECONNRESET;
+		goto free_cep;
 	}
 	qp = siw_qp_id2obj(sdev, params->qpn);
 	if (!qp) {
 		WARN(1, "[QP %d] does not exist\n", params->qpn);
-		siw_cep_set_free_and_put(cep);
-
-		return -EINVAL;
+		goto free_cep;
 	}
 	down_write(&qp->state_lock);
-	if (qp->attrs.state > SIW_QP_STATE_RTR) {
-		rv = -EINVAL;
-		up_write(&qp->state_lock);
-		goto error;
-	}
+	if (qp->attrs.state > SIW_QP_STATE_RTR)
+		goto error_unlock;
 	siw_dbg_cep(cep, "[QP %d]\n", params->qpn);
 
 	if (try_gso && cep->mpa.hdr.params.bits & MPA_RR_FLAG_GSO_EXP) {
@@ -1595,9 +1588,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 			"[QP %u]: ord %d (max %d), ird %d (max %d)\n",
 			qp_id(qp), params->ord, sdev->attrs.max_ord,
 			params->ird, sdev->attrs.max_ird);
-		rv = -EINVAL;
-		up_write(&qp->state_lock);
-		goto error;
+		goto error_unlock;
 	}
 	if (cep->enhanced_rdma_conn_est)
 		max_priv_data -= sizeof(struct mpa_v2_data);
@@ -1607,9 +1598,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 			cep,
 			"[QP %u]: private data length: %d (max %d)\n",
 			qp_id(qp), params->private_data_len, max_priv_data);
-		rv = -EINVAL;
-		up_write(&qp->state_lock);
-		goto error;
+		goto error_unlock;
 	}
 	if (cep->enhanced_rdma_conn_est) {
 		if (params->ord > cep->ord) {
@@ -1618,9 +1607,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 			} else {
 				cep->ird = params->ird;
 				cep->ord = params->ord;
-				rv = -EINVAL;
-				up_write(&qp->state_lock);
-				goto error;
+				goto error_unlock;
 			}
 		}
 		if (params->ird < cep->ird) {
@@ -1629,8 +1616,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 				params->ird = cep->ird;
 			else {
 				rv = -ENOMEM;
-				up_write(&qp->state_lock);
-				goto error;
+				goto error_unlock;
 			}
 		}
 		if (cep->mpa.v2_ctrl.ord &
@@ -1677,7 +1663,6 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
 				   SIW_QP_ATTR_MPA);
 	up_write(&qp->state_lock);
-
 	if (rv)
 		goto error;
 
@@ -1700,6 +1685,9 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	siw_cep_set_free(cep);
 
 	return 0;
+
+error_unlock:
+	up_write(&qp->state_lock);
 error:
 	siw_socket_disassoc(cep->sock);
 	sock_release(cep->sock);
@@ -1714,9 +1702,8 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	}
 	cep->qp = NULL;
 	siw_qp_put(qp);
-
+free_cep:
 	siw_cep_set_free_and_put(cep);
-
 	return rv;
 }
 
-- 
2.53.0



