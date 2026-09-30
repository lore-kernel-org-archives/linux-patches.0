Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D7509F01;
	Wed, 30 Sep 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783331; cv=none; b=Kt0LpswaWmlGx2r1m3S34OCSgqq9RQJRHbzVfA3gxJ4BxOC/HaJ1M61tGg0d5oKDzhVemUg4ttuVxuPhG2bm/L2kVf7xQQl3gRmvvd1OQUTRd3D2dn4Wj6GTFYFGQOqGsQ7E+XQanaix2i1j1jBExRQy1H6WtbRChXlsRYmhcLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783331; c=relaxed/simple;
	bh=7XVcwQcFmQfBvhggV62Lt84U5ZOKn5WOorNODXbQORs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6pDas1507QcYzAsNT2aIU/TSg3HsUwezvw2Ob5p06ve73L3XpaZy9y92yC258tdnqvieW72nwQsJEuBXD5Rr0VsSMBOk7/kQz+fMujQ+1GqFocRfXQfhcKlQRg7q/hjvQTAHsZNJxOKL+WuhOr8Kl2+7WHS7A7NBnZ0CE35TZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyHcMDKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyHcMDKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4EE1F000FF;
	Wed, 30 Sep 2026 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783324;
	bh=mhhxptita6bMD6JGBkQrwLeF4aH2yDs5MorwAHQkYJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyHcMDKytRK5AcdJyuoJBoOAnZgJKvV0LWbde+DLZSRAIqbIpLXQ2HN0xmiGXvR9V
	 +e6fKee8wrup9MPRZ/2FykCyEfgvocLrrpBDCG1Eu3NujB5kOEev8jM5xuOQCKdupf
	 5CE4wk1aCqibw+BOybvPqAZf9CZLZKSvAspJ914g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/595] RDMA/siw: Introduce siw_cep_set_free_and_put
Date: Wed, 30 Sep 2026 17:24:05 +0200
Message-ID: <20260930152355.250392470@linuxfoundation.org>
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

[ Upstream commit b5c91543204c345f1b28af573854c4b7e699cc91 ]

Add the helper which can be used in some places.

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-11-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 32cd87f54dd1 ("RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 31 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index dfe9077ee168d..de71e32258a6b 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -450,6 +450,12 @@ void siw_cep_put(struct siw_cep *cep)
 	kref_put(&cep->ref, __siw_cep_dealloc);
 }
 
+static void siw_cep_set_free_and_put(struct siw_cep *cep)
+{
+	siw_cep_set_free(cep);
+	siw_cep_put(cep);
+}
+
 void siw_cep_get(struct siw_cep *cep)
 {
 	kref_get(&cep->ref);
@@ -1511,9 +1517,7 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		siw_cep_set_free(cep);
-
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 
 	} else if (s) {
 		sock_release(s);
@@ -1561,16 +1565,14 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
 		siw_dbg_cep(cep, "out of state\n");
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 
 		return -ECONNRESET;
 	}
 	qp = siw_qp_id2obj(sdev, params->qpn);
 	if (!qp) {
 		WARN(1, "[QP %d] does not exist\n", params->qpn);
-		siw_cep_set_free(cep);
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 
 		return -EINVAL;
 	}
@@ -1713,8 +1715,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->qp = NULL;
 	siw_qp_put(qp);
 
-	siw_cep_set_free(cep);
-	siw_cep_put(cep);
+	siw_cep_set_free_and_put(cep);
 
 	return rv;
 }
@@ -1737,8 +1738,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
 		siw_dbg_cep(cep, "out of state\n");
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep); /* put last reference */
+		siw_cep_set_free_and_put(cep); /* put last reference */
 
 		return -ECONNRESET;
 	}
@@ -1755,8 +1755,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-	siw_cep_set_free(cep);
-	siw_cep_put(cep);
+	siw_cep_set_free_and_put(cep);
 
 	return 0;
 }
@@ -1879,8 +1878,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 	}
 	sock_release(s);
 
@@ -1911,8 +1909,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 			cep->sock = NULL;
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
-		siw_cep_set_free(cep);
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 	}
 }
 
-- 
2.53.0



