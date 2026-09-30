Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32393D25B2;
	Wed, 30 Sep 2026 19:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795902; cv=none; b=H41SOT/yJC7ToogM3IqHd7W/UNjIuL8U+NMny1qceS+iredDoYKEv4MYrClXr1M5b2IFsq/kCnlP8Y56UD34f5jW6CdfQN64F+z2+qXo5N85MbTdYtYe47ZxJ2IQzHvI33rCNfkFc11IlebY1LnQXI2bXsdINpSdxzsejMuH4kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795902; c=relaxed/simple;
	bh=XJnOiwAEDpShRkjmw0L0KxS8EZ6TC2F70BZXQh1Umk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgXxrS5XmMDTtZI218CrVx3tDyHx4ZEEfxFoQa0MNtUsen3D9bIe3EU09xdHLvRREvyWCTe60SvaIOF0Z1KZ9th6v18ckv+DGeuiIDXsvJ8AQ9/hKhZ9ivywXRJAVmeFcBzPbIEo8asQTbx4DVhF9A4BEF8JQ1bI+9pHBtnmunM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoWoEAyg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoWoEAyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA0C1F000FF;
	Wed, 30 Sep 2026 19:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795901;
	bh=vIYZXqJLYQoartJweaxY0oyS5vqXjg0X0hJE1POeiZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoWoEAygJyORazKd2S6867y5+3YHybuZStn2PSU0YUqmUX/28fNgz6gyxt5A/lq78
	 u3RJQ1R2y386jCU7FT6C5oFTEt/kwd5RKrDTuJbSQS99QN+X7VgiBN2kKSGXZpMzvg
	 U0rtTsbo2vqmFTPIMowhz8+kpOGOR5O34+5gXv4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0725/1193] RDMA/siw: Introduce siw_cep_set_free_and_put
Date: Wed, 30 Sep 2026 17:23:29 +0200
Message-ID: <20260930152450.359790931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index a04c1fcabfcc4..6dff4ddd896f8 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -453,6 +453,12 @@ void siw_cep_put(struct siw_cep *cep)
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
@@ -1522,9 +1528,7 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		siw_cep_set_free(cep);
-
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 
 	} else if (s) {
 		sock_release(s);
@@ -1572,16 +1576,14 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
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
@@ -1724,8 +1726,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->qp = NULL;
 	siw_qp_put(qp);
 
-	siw_cep_set_free(cep);
-	siw_cep_put(cep);
+	siw_cep_set_free_and_put(cep);
 
 	return rv;
 }
@@ -1748,8 +1749,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
 		siw_dbg_cep(cep, "out of state\n");
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep); /* put last reference */
+		siw_cep_set_free_and_put(cep); /* put last reference */
 
 		return -ECONNRESET;
 	}
@@ -1766,8 +1766,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-	siw_cep_set_free(cep);
-	siw_cep_put(cep);
+	siw_cep_set_free_and_put(cep);
 
 	return 0;
 }
@@ -1899,8 +1898,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 	}
 	sock_release(s);
 
@@ -1931,8 +1929,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
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



