Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017878;
	b=lK96evxOw7HqyogVsFufpLUM4A9KL7Ba/liE7DJVm9q4gnQcwRjVf0mVjYpOUvBK/vjn
	 PgAaql6yqkl5R9cO/bbbfS7LtJuX8Fsg+N5vjUmqVmlGXCGOBnAOnmq8cShjtoMOBtpFx
	 1hbngDJO0K4h4SmdgLtSqsSGPhyr3rSRJMGOarPIrle7PwqRtsLQH9BQ9QXr7ufu4eHBH
	 W7BvjG9BzKJlZ+kbx7iYKxlbwesPH8ILzEECt1eSh/h0ml8MKHpahoUfZhGHGJcMHyPzd
	 CY07+upDwUlwXu2z6ouTeZGxkZkPCkD8mDs4p0oWLlSsCOZq1HGp5Q9if6rZV3fR0YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+naom/DrN83Amhvk7bO8voflzG1Ix4bKhhiW7GqBOk=;
	b=27bXIFvl+k3/lStTVC9hghbTr2EB8pLOzGMtKd7EbPlQzVpUH6AO+Kgzt9sIZrRCHiZ5
	 lc2LtOMpw5OVAhzZDpfpMiZnskgwSvi3+aE/PeQGzk5URGaGrO6nsd4URRSnCp6PL3NqJ
	 pyDf1eVZRvpF2j25XXAjP0EuYK2jm6PCvLTHPJnLajRQ2ACA8o4hG96nyWA/om5qOepoE
	 G13P3mmPY27OXNiXrH7WddUCEMDP9aTMAMXrGLURKadrDaS/pJer6jWZkenzlbJS7zK0Z
	 KfNTGyz10IJgGXe4KDuYjUcGO1N19p30Ta8FLbZjwQYS26peqDweDkNxRsr3zxBC43w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O4M2qWXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A54606A31C;
	Wed, 18 Nov 2026 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O4M2qWXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A3B1F000C5;
	Wed, 18 Nov 2026 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017878;
	bh=M+naom/DrN83Amhvk7bO8voflzG1Ix4bKhhiW7GqBOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4M2qWXo15UzSS4jV0amLVoIRsQBBfMbV04jOigEM5L7cQk87jLKQ2muY/KxqGDpe
	 ZNlNinc48GoVc5WVbgbfQ+PyrvYNuOISqI9gCQ0UPKk1NfbtPDKBqvJa0YiSSIVpMT
	 SKY3w64TGgOzLW3kbR2lkyDk2QnXKpPytGJ49mws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1039/2651] RDMA/ionic: Fix double removal of CMB mmap entries in create QP error path
Date: Wed, 18 Nov 2026 15:37:59 +0100
Message-ID: <20261118150325.369529625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhijit Gangurde <abhijit.gangurde@amd.com>

[ Upstream commit 485effd117d0310a7f589defb4f442fa3bb52ae2 ]

The error unwind in ionic_create_qp() removes the SQ and RQ CMB mmap
entries explicitly, and then falls through to ionic_qp_rq_destroy() and
ionic_qp_sq_destroy(), whose ionic_qp_{rq,sq}_destroy_cmb() helpers
remove the very same entries a second time.

Drop the explicit removals and leave ionic_qp_{rq,sq}_destroy_cmb() as
the single owner on the ionic_destroy_qp() path.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://patch.msgid.link/20260925093638.3032149-2-abhijit.gangurde@amd.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index a70ef59a8064e..c82e61fdadc26 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2336,7 +2336,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 						    &resp.sq_cmb_offset);
 			if (!qp->mmap_sq_cmb) {
 				rc = -ENOMEM;
-				goto err_mmap_sq;
+				goto err_qp_cmd;
 			}
 
 			resp.sq_cmb = qp->sq_cmb;
@@ -2373,7 +2373,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 						    &resp.rq_cmb_offset);
 			if (!qp->mmap_rq_cmb) {
 				rc = -ENOMEM;
-				goto err_mmap_rq;
+				goto err_qp_cmd;
 			}
 
 			resp.rq_cmb = qp->rq_cmb;
@@ -2381,7 +2381,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 		rc = ib_respond_udata(udata, resp);
 		if (rc)
-			goto err_resp;
+			goto err_qp_cmd;
 	}
 
 	ionic_pgtbl_unbuf(dev, &rq_buf);
@@ -2399,7 +2399,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		else
 			rc = xa_err(entry);
 
-		goto err_resp;
+		goto err_qp_cmd;
 	}
 
 	if (qp->has_sq) {
@@ -2430,13 +2430,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	return 0;
 
-err_resp:
-	if (udata && (qp->rq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_rq_cmb);
-err_mmap_rq:
-	if (udata && (qp->sq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_sq_cmb);
-err_mmap_sq:
+err_qp_cmd:
 	ionic_destroy_qp_cmd(dev, qp->qpid);
 err_cmd:
 	ionic_pgtbl_unbuf(dev, &rq_buf);
-- 
2.53.0



