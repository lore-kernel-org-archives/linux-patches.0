Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966C350C287;
	Wed, 30 Sep 2026 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785808; cv=none; b=JmhIKKW5+QKpUwtUGumR3/DVV/fY4WFeM6lepEcgqKAsUjiUlToc1t+WZj3IFy2SZ1CZ0jy0k/tM6M7fxxiRGsG2DP7BpRCVBF18ucCFtAkoFotiQfv+LHWlaBsvpxKmJ4XrqP21jsSwFqKfNpBW2nfK1ZcGqSnS5P5rAv124aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785808; c=relaxed/simple;
	bh=r8dvwAAP7kMPT5qevPMThH/XVr78Q+/5ZtvpbV1c6og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9ypg+GpTpNwLtwwADeMob2O7EDWi2A7TXQ/GW2KiBUxtw131aenOcTw2IsLglKzCX8oBCrX7JD9lXgVOKcWpLBeLr/0dObwMccoYDr2V9Pp2FSNLxskoHLIzKoy2PPQC9UI+AKUEw8IhDQOxVW+QOrwzOMpRvnTJELwAB+MPpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBBtvKJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBBtvKJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF351F000FF;
	Wed, 30 Sep 2026 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785807;
	bh=sOSP5LJPy3fmuLYok4rmY6Iz2uhPwXxTVlov+zDLhEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBBtvKJ1MqiDR2H7EWNYtmez1E3haKgkBygU57NqbJe7SPM1wjWj8NzDyHCPvEwT8
	 oiw97jOqGKuSSU4PQYcC1sZZZtI1pAhTUbr2nTrcUce2IWtPi5JMRkY1y+EhF0IhPh
	 knH/RqSDtHAzcxxfdqbLSv4CUzTP2pLZsvWuGryg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 594/982] RDMA/siw: Introduce siw_cep_set_free_and_put
Date: Wed, 30 Sep 2026 17:22:10 +0200
Message-ID: <20260930152429.543280921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32cefc30d6cd6..bc2ad13f9c6b6 100644
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
@@ -1517,9 +1523,7 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		siw_cep_set_free(cep);
-
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 
 	} else if (s) {
 		sock_release(s);
@@ -1567,16 +1571,14 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
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
@@ -1719,8 +1721,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->qp = NULL;
 	siw_qp_put(qp);
 
-	siw_cep_set_free(cep);
-	siw_cep_put(cep);
+	siw_cep_set_free_and_put(cep);
 
 	return rv;
 }
@@ -1743,8 +1744,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
 		siw_dbg_cep(cep, "out of state\n");
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep); /* put last reference */
+		siw_cep_set_free_and_put(cep); /* put last reference */
 
 		return -ECONNRESET;
 	}
@@ -1761,8 +1761,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-	siw_cep_set_free(cep);
-	siw_cep_put(cep);
+	siw_cep_set_free_and_put(cep);
 
 	return 0;
 }
@@ -1894,8 +1893,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		siw_cep_set_free(cep);
-		siw_cep_put(cep);
+		siw_cep_set_free_and_put(cep);
 	}
 	sock_release(s);
 
@@ -1926,8 +1924,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
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



