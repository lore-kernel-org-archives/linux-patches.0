Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622703;
	b=W/weoeVCDqGVxBbZiY6KSQZ7i0vqsYOttn3Mz06lIQJz6Ir3WZFxjawr9aR00EtB9ljI
	 rnKEgPXQxMrS+lFa3EdqSRAXgS3z2+RSvtAqSCaYJUngGzLc4d8SSkwK4bfcEgOfZKYsU
	 Up46ZnKvaZy6Xzsq5udZImbj/FutkVsmqvuDq6yPLKeAe9d1TmUujjVDQJWdspt3KmuoO
	 kklBr+pjZAI27pyJwBOXa/XyEa4zxuXEGtgHlHC5jrnimpSMRuUSU7r+F9bZgGuSaVNbL
	 T2FSZpgDrAMzpA2ANtoXHicoSzIcc+2fcCPZ/vnBXwNTpbLBr72UxQ/acUZCZwb11Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KCXd8s5GMTpnnOZtR5LNDMWpz60l2S9VDc0Xe2YUiuE=;
	b=dHOxHEMG3DL4UZiC7Ll/iVpvboxaoadFurXjyzcXg2zrZPIezHRKSUsTUKVv7qws9YJ7
	 77YC5aby0ejEnz48qsImSDvyMNabrwGoN/xf/TlsXH52Y/dtjLctz1GXGrn9fZ6k8S5x7
	 0dVMhODdFLnzauNyxLNtDN9Cj1nlE+C4Jegm9j5sthHB3leMA8O0LmaN4g/GD3ovnha8z
	 bh9PecEbBZhlbadLd9ksx0TDBJhg+W9HYaZOhh2ZAinzoC4VHRL9NxPRwJbDeLyy3Sn9U
	 KjZwDt2YgtFdqeOLDKbbLFBHrUjCPj6Qs0VKZo5fJfeX8Z4wAPf11+8SNyn30LLNxkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fv0Y7kKA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE16D606A31E;
	Wed, 25 Nov 2026 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fv0Y7kKA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FAA1F000ED;
	Wed, 25 Nov 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622703;
	bh=KCXd8s5GMTpnnOZtR5LNDMWpz60l2S9VDc0Xe2YUiuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fv0Y7kKAuuGbns10Q8xWsPW/V1qV1SH10M95zaKV9yopR5DIoUAvTdCTB91NGP2IE
	 qlokH04K5azjnNRA3wsKrXE5IRCOkLAk0l7vHSiqATm5Q3Jgvjr0v1gdx78LMzawVp
	 UteYV0o4hmiq84iE8wu/3UZ08r3MrOPz6RvpSovY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 594/990] RDMA/bnxt_re: Unpublish QP table before freeing it
Date: Wed, 25 Nov 2026 15:32:41 +0100
Message-ID: <20261125143836.006258420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 978361dd2ccff357d4fe6aac6ce057d1bfae8312 ]

bnxt_re_dev_uninit() frees the QP table before the RCFW channel is
disabled, so the CREQ tasklet can still look up rcfw->qp_tbl while it
is being freed.

Clear rcfw->qp_tbl under tbl_lock before freeing it, and have the QP
error notification handler bail out if the table is gone.

Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20261013140427.256612-3-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  4 ++++
 drivers/infiniband/hw/bnxt_re/qplib_res.c  | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 4dad0cfcfa98d..a70aa6a83da3b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -638,6 +638,10 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		err_event = (struct creq_qp_error_notification *)qp_event;
 		qp_id = le32_to_cpu(err_event->xid);
 		spin_lock(&rcfw->tbl_lock);
+		if (!rcfw->qp_tbl) {
+			spin_unlock(&rcfw->tbl_lock);
+			break;
+		}
 		tbl_indx = map_qp_id_to_tbl_indx(qp_id, rcfw);
 		qp = rcfw->qp_tbl[tbl_indx].qp_handle;
 		if (!qp) {
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index ad0ba952eb48d..5948e1f11384e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -867,7 +867,15 @@ int bnxt_qplib_init_res(struct bnxt_qplib_res *res)
 
 void bnxt_qplib_free_res(struct bnxt_qplib_res *res)
 {
-	kvfree(res->rcfw->qp_tbl);
+	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
+	struct bnxt_qplib_qp_node *qp_tbl;
+
+	/* The CREQ tasklet may still be running; unpublish the table first */
+	spin_lock_bh(&rcfw->tbl_lock);
+	qp_tbl = rcfw->qp_tbl;
+	rcfw->qp_tbl = NULL;
+	spin_unlock_bh(&rcfw->tbl_lock);
+	kvfree(qp_tbl);
 	bnxt_qplib_free_sgid_tbl(res, &res->sgid_tbl);
 	bnxt_qplib_free_pd_tbl(&res->pd_tbl);
 	bnxt_qplib_free_dpi_tbl(res, &res->dpi_tbl);
-- 
2.53.0



