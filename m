Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA288348C75;
	Sat, 12 Sep 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224878; cv=none; b=O/J5HPeO8WOJKzHzPrvG1hQD2D0C4SP2Etjxqnb9+OVQar0JlKSU8vWTlGejVP3fgVKsV0rxwkgpbrf25wvczdOzr5M+QmK2irXropl1TlrvC2qFoXy1ELt9xdCXZoOE2JLV8D98tVZsNo/7vBF1kAKu/eSS44RK93vJtQDu+OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224878; c=relaxed/simple;
	bh=2dTrhfeillSnNTqPLqt/zCwsHiey9eFMhuVVPpZ/WW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLTzPz5kXt0SeK1RFnwUC8YuNcnV06j+1KFM1AJU1O8cCSpTlZELSGwrnioj+pSyzdzMGJ+BHBmDNYYW7aWCh9/4vpmRxa/bYEAMID0YoVx+neS8gKcvukaDwyBcP+SNnYDez6vjWgcefwaZ/E7n4sj8N4JgWPnMR4jFvG/kO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4MB3pq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4MB3pq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858161F000FF;
	Sat, 12 Sep 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224876;
	bh=gVWQY+uXTVfc3/zTLIvIwrX16NwKCbN2nGosdzQzrlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4MB3pq5VFWRO8ZPAr94+9bvotMet49jxPsvH1cEPzyBf93AayIzDCp9UMznymDWJ
	 fLgfnEuFLp0jtWipcuSujYmHBkaw/rl37SMIcJLu2SzgaZ0wzbC01KktbqWttl3qZb
	 saqJ43/pmLo7aWqueW93GiS2haBlQF2Ht8k1by2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1082/1424] RDMA/siw: Introduce siw_free_cm_id
Date: Sat, 12 Sep 2026 08:58:34 +0200
Message-ID: <20260912065631.536758722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 08456d4db73bbb3fcaa0d63252ea2399c65297a4 ]

Factor out a helper to simplify code.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310091656.JlrmcNXB-lkp@intel.com/
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-12-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a93949718259 ("RDMA/siw: Fix use-after-free in siw_accept()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 43e776073f49f..6ce8150278dd4 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -364,6 +364,15 @@ static int siw_cm_upcall(struct siw_cep *cep, enum iw_cm_event_type reason,
 	return id->event_handler(id, &event);
 }
 
+static void siw_free_cm_id(struct siw_cep *cep)
+{
+	if (!cep->cm_id)
+		return;
+
+	cep->cm_id->rem_ref(cep->cm_id);
+	cep->cm_id = NULL;
+}
+
 /*
  * siw_qp_cm_drop()
  *
@@ -416,8 +425,7 @@ void siw_qp_cm_drop(struct siw_qp *qp, int schedule)
 			default:
 				break;
 			}
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
+			siw_free_cm_id(cep);
 			siw_cep_put(cep);
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
@@ -1175,8 +1183,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 			cep->sock = NULL;
 		}
 		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
+			siw_free_cm_id(cep);
 			siw_cep_put(cep);
 		}
 	}
@@ -1709,10 +1716,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-	if (cep->cm_id) {
-		cep->cm_id->rem_ref(id);
-		cep->cm_id = NULL;
-	}
+	siw_free_cm_id(cep);
 	if (qp->cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
@@ -1890,10 +1894,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 	if (cep) {
 		siw_cep_set_inuse(cep);
 
-		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
-		}
+		siw_free_cm_id(cep);
 		cep->sock = NULL;
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
@@ -1923,10 +1924,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 
 		siw_cep_set_inuse(cep);
 
-		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
-		}
+		siw_free_cm_id(cep);
 		if (cep->sock) {
 			siw_socket_disassoc(cep->sock);
 			sock_release(cep->sock);
-- 
2.53.0



