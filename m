Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881CE37EFFE;
	Wed, 30 Sep 2026 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791849; cv=none; b=A0TA6i6LxvG4Yx826f0EM/QD79FUhAk2XoWqhi1tfsPvukLd5qnpkb0f2dNGa9DO78TSKF3fw7hxQd35w+ldMtM8WMA14tXaaDXX2W075gexJJeb+P/ALhJ0yrplSzTzpbGNwxzaTjh+KMDB+bAaPXi348Ju1VroIoA+P+gaHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791849; c=relaxed/simple;
	bh=afgoMWkDXw5YKTHPR7URVZC5Qqn+mCY/ay5+G0EbpyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWCB82BewZ/ANdAv/jBNXsvK06zWfv6mgvDlgXZm2yZJKAJ1mXPXu2xm30AHR9djedrzPHa03A/UrG9Z2P+1V27wYgKY3qP2LTF/BvrEfSjC7xhLhLlUN6rlFXdevUN3dbKaAjlX3qSKNnsAyjKtvZRNqwoXiOtu6Cii37d5aqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFtzALJ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFtzALJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DA81F00898;
	Wed, 30 Sep 2026 18:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791848;
	bh=iSain4/tcnIsM/inS9smORwhOqhrkIga1YRZoVWLkuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFtzALJ87Y3gkiHPpyM9/azFwiWC7GxbgNGjvUJ8O4RmMJcYCCvLk95PEMFs727iV
	 KjcWePKup6wD1yfdYN0dWx63zZLDF9FZ5LVd9jS2GFiM23ADwyUvoiXsOoEc2meC//
	 dImHmXG/jzqTD99GliO3tv0mI9VBsL3prkxlb+wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/752] RDMA/siw: Cleanup siw_accept
Date: Wed, 30 Sep 2026 17:25:16 +0200
Message-ID: <20260930152407.932478440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 5810d4640742e..a15d79001bbbf 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1554,7 +1554,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	struct siw_cep *cep = (struct siw_cep *)id->provider_data;
 	struct siw_qp *qp;
 	struct siw_qp_attrs qp_attrs;
-	int rv, max_priv_data = MPA_MAX_PRIVDATA;
+	int rv = -EINVAL, max_priv_data = MPA_MAX_PRIVDATA;
 	bool wait_for_peer_rts = false;
 
 	siw_cep_set_inuse(cep);
@@ -1570,24 +1570,17 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
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
@@ -1601,9 +1594,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
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
@@ -1613,9 +1604,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
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
@@ -1624,9 +1613,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
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
@@ -1635,8 +1622,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 				params->ird = cep->ird;
 			else {
 				rv = -ENOMEM;
-				up_write(&qp->state_lock);
-				goto error;
+				goto error_unlock;
 			}
 		}
 		if (cep->mpa.v2_ctrl.ord &
@@ -1683,7 +1669,6 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
 				   SIW_QP_ATTR_MPA);
 	up_write(&qp->state_lock);
-
 	if (rv)
 		goto error;
 
@@ -1706,6 +1691,9 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	siw_cep_set_free(cep);
 
 	return 0;
+
+error_unlock:
+	up_write(&qp->state_lock);
 error:
 	siw_socket_disassoc(cep->sock);
 	sock_release(cep->sock);
@@ -1720,9 +1708,8 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
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



