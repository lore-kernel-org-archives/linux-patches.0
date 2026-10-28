Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215584;
	b=1ykybWHC8lp10de7B5OKT2N2IrPBSPBvylN9JdwAZRZknu1J5w54jxqjL8oHOArWucB3
	 Tj3czp7HsWNyEpcfnY1edtTrSJu7i0tNPrR+MhgrLwp/GbXLzGTOdZPfA1Tkli8F7uhbL
	 B0P5B3YmjlVnQMLmqR5mfi1s+PmX1vx4REcj8gtvNmD6PTVc6yutEAECX/TFGvEd31Khs
	 qQWs4nUJ8J4INZFW3PdgpLuIcqVvBAj3/8fzOQywTrUlODV3BcTa6tLFGN0OlSm9JhFQo
	 7EB1Hthgp/e1HItLoW7rKemJurO/ITo946lFICaEzsEC0QdtLH7ztBg/WXZL5MijJfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=de4vgNILq7ToikStSrLKg9txR2Eb9m4rFIwbMI++CpY=;
	b=CLH0ZEJjutyTY0w5ep8yJddXOMMzt48pXAcg4AbQMHHJbylnWCH0T+u3CWeVq24l61+D
	 Xh2w032thzjclbftH8G5R/5r5uShp8+pFCFr/FjA6zBY2/CyR++6iQIxbA1SpK5F2tvEn
	 Mg/m1hya004BIkSss0TsnUqDuxmWHFWsJYlrtTqisHu5qsoc+VKf2zcl9wxncomlgCxJn
	 oUHP90wdGV1l165CyFLUMzI1Fwg+QcDeBlFXuS4x931Kr3eZQBGBEE7hvDBif8mUiORWb
	 FE7tGeXfHJDfsAMUZG/ZU3qwJsxlDivtREFKoFgACFubbPimzn1CPM81YuNt9ISbySQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dujQEe5E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E418F606A31A;
	Wed, 28 Oct 2026 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dujQEe5E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8611F01825;
	Wed, 28 Oct 2026 19:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215583;
	bh=de4vgNILq7ToikStSrLKg9txR2Eb9m4rFIwbMI++CpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dujQEe5ElVsHDxXK1uTrv1TA795Ip1FgW4IU4SO0VPZg/vllub5r8MiBS5QptJtZ7
	 5HaLw5k6SDdjmps9qpsNmINY1IyzysKoPMSml5fls/WE7iDJksa2YOI/kGoxMT7Hkl
	 WLwvMc4kiGxHmIREx3sZhlGDMMOgASiwAanQPvSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1260/1887] RDMA/siw: Fix endpoint/socket association handling
Date: Wed, 28 Oct 2026 17:55:56 +0100
Message-ID: <20261028170528.100932898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4311413c64d4..2ffac1c94df38 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -93,6 +93,7 @@ static void siw_socket_disassoc(struct socket *s)
 		cep = sk_to_cep(sk);
 		if (cep) {
 			siw_sk_restore_upcalls(sk, cep);
+			cep->sock = NULL;
 			siw_cep_put(cep);
 		} else {
 			pr_warn("siw: cannot restore sk callbacks: no ep\n");
@@ -372,10 +373,11 @@ static void siw_free_cm_id(struct siw_cep *cep)
 
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
 
@@ -1005,7 +1007,6 @@ static void siw_accept_newconn(struct siw_cep *cep)
 	if (new_s) {
 		siw_socket_disassoc(new_s);
 		sock_release(new_s);
-		new_cep->sock = NULL;
 	}
 	siw_dbg_cep(cep, "error %d\n", rv);
 }
@@ -1157,6 +1158,8 @@ static void siw_cm_work_handler(struct work_struct *w)
 		WARN(1, "Undefined CM work type: %d\n", work->type);
 	}
 	if (release_cep) {
+		struct socket *s = cep->sock;
+
 		siw_dbg_cep(cep,
 			    "release: timer=%s, QP[%u]\n",
 			    cep->mpa_timer ? "y" : "n",
@@ -1182,10 +1185,9 @@ static void siw_cm_work_handler(struct work_struct *w)
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
@@ -1513,7 +1515,6 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (cep) {
 		siw_socket_disassoc(s);
 		sock_release(s);
-		cep->sock = NULL;
 
 		cep->qp = NULL;
 
@@ -1877,7 +1878,6 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 		siw_cep_set_inuse(cep);
 
 		siw_free_cm_id(cep);
-		cep->sock = NULL;
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
 
@@ -1898,6 +1898,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 	 */
 	list_for_each_safe(p, tmp, (struct list_head *)id->provider_data) {
 		struct siw_cep *cep = list_entry(p, struct siw_cep, listenq);
+		struct socket *s = cep->sock;
 
 		list_del(p);
 
@@ -1906,10 +1907,9 @@ static void siw_drop_listeners(struct iw_cm_id *id)
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



