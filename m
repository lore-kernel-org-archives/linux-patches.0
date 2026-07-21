Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4016E32B132;
	Tue, 21 Jul 2026 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661933; cv=none; b=KADxkWGayNIq5s8VtTifnBydw1yiG/3OcdLQnOwtBI3vMByvJr+Gbo4IXFlD2g+rE3wDp+Asa0jabRG5FV3TqJFYZ4zvQaOLloOJORwqwJ5OBEe8gndm3cZIMojBrg/DMZs+ht5g7o8liptbRiDUgsyAhOlmnG2gwguva4SU8hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661933; c=relaxed/simple;
	bh=umi9hLiuuhIfkmwxZmU6We88qDsxO5t4QtrCoLlH/Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEqmvMl8XpiywIYVCZD8S13ZPP6teyapIew5NNvO7719jq291GwpPgPcYVT3epIcHvn1g7z/J/vHZ/GChq1MNHupcH26HGUIDCpOcapLFr1wtHe5flx4oKqjKFZrSUDshIVcqCY5jCTaaTfPVGh9YWvtAGKe3YdPdV6IQ7hrX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmmJ8xbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmmJ8xbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68291F000E9;
	Tue, 21 Jul 2026 19:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661932;
	bh=Toty82aJ0PpCvREQFeXcDbcjWC3SWjJ5cFLSueNR2w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmmJ8xbA9BqSH6McQ21+7/pcVh25tj6UmGEtCZ9UHGODayCBgjyyjmN9stPwNFNYo
	 UCj2PbdCa+vlDYgmRpo/Yb97/kCSYOVaFeJwPpDPo+LkUs6YSmDpZE2fuO6wHwUNpP
	 nZss+feCh9+OWcQRblAb+WYc4OJa2fJvT9rtk6a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0253/1276] RDMA/siw: Fix endpoint/socket association handling
Date: Tue, 21 Jul 2026 17:11:36 +0200
Message-ID: <20260721152451.748610846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Metzler <bernard.metzler@linux.dev>

[ Upstream commit ea4f6f6c53577fb3f05dbd78b15e586772d49831 ]

Disassociating a socket from an endpoint via siw_socket_disassoc() may
release the last reference on that endpoint and free it. Therefore, don't
clear the endpoints socket pointer after calling that function, but
within.

This fixes a:

  BUG: KASAN: slab-use-after-free in siw_cm_work_handler (drivers/infiniband/sw/siw/siw_cm.c:1053 drivers/infiniband/sw/siw/siw_cm.c:1075)

which occurred after processing a malformed MPA request during connection
establishment, causing the new endpoint to be closed.

Fixes: 6c52fdc244b5c ("rdma/siw: connection management")
Link: https://patch.msgid.link/r/20260604160808.30948-1-bernard.metzler@linux.dev
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 708b13993fdfd3..49ff121f77fe44 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -89,6 +89,7 @@ static void siw_socket_disassoc(struct socket *s)
 		cep = sk_to_cep(sk);
 		if (cep) {
 			siw_sk_restore_upcalls(sk, cep);
+			cep->sock = NULL;
 			siw_cep_put(cep);
 		} else {
 			pr_warn("siw: cannot restore sk callbacks: no ep\n");
@@ -369,10 +370,11 @@ static void siw_free_cm_id(struct siw_cep *cep)
 
 static void siw_destroy_cep_sock(struct siw_cep *cep)
 {
-	if (cep->sock) {
-		siw_socket_disassoc(cep->sock);
-		sock_release(cep->sock);
-		cep->sock = NULL;
+	struct socket *s = cep->sock;
+
+	if (s) {
+		siw_socket_disassoc(s);
+		sock_release(s);
 	}
 }
 
@@ -1001,7 +1003,6 @@ static void siw_accept_newconn(struct siw_cep *cep)
 	if (new_s) {
 		siw_socket_disassoc(new_s);
 		sock_release(new_s);
-		new_cep->sock = NULL;
 	}
 	siw_dbg_cep(cep, "error %d\n", rv);
 }
@@ -1153,6 +1154,8 @@ static void siw_cm_work_handler(struct work_struct *w)
 		WARN(1, "Undefined CM work type: %d\n", work->type);
 	}
 	if (release_cep) {
+		struct socket *s = cep->sock;
+
 		siw_dbg_cep(cep,
 			    "release: timer=%s, QP[%u]\n",
 			    cep->mpa_timer ? "y" : "n",
@@ -1178,10 +1181,9 @@ static void siw_cm_work_handler(struct work_struct *w)
 			cep->qp = NULL;
 			siw_qp_put(qp);
 		}
-		if (cep->sock) {
-			siw_socket_disassoc(cep->sock);
-			sock_release(cep->sock);
-			cep->sock = NULL;
+		if (s) {
+			siw_socket_disassoc(s);
+			sock_release(s);
 		}
 		if (cep->cm_id) {
 			siw_free_cm_id(cep);
@@ -1511,7 +1513,6 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (cep) {
 		siw_socket_disassoc(s);
 		sock_release(s);
-		cep->sock = NULL;
 
 		cep->qp = NULL;
 
@@ -1886,7 +1887,6 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 		siw_cep_set_inuse(cep);
 
 		siw_free_cm_id(cep);
-		cep->sock = NULL;
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
 
@@ -1908,6 +1908,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 	 */
 	list_for_each_safe(p, tmp, (struct list_head *)id->provider_data) {
 		struct siw_cep *cep = list_entry(p, struct siw_cep, listenq);
+		struct socket *s = cep->sock;
 
 		list_del(p);
 
@@ -1916,10 +1917,9 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 		siw_cep_set_inuse(cep);
 
 		siw_free_cm_id(cep);
-		if (cep->sock) {
-			siw_socket_disassoc(cep->sock);
-			sock_release(cep->sock);
-			cep->sock = NULL;
+		if (s) {
+			siw_socket_disassoc(s);
+			sock_release(s);
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
 		siw_cep_set_free_and_put(cep);
-- 
2.53.0



