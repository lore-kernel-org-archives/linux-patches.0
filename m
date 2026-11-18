Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019926;
	b=QtCBSFXKlAhmrTBd3enxsMMdqHZoTnN8S8Pim28XGB3W+wOc9bNTDVcdx2Zuu3eMEql7
	 xnsmDPsT/AfbWan7ObDOEoECMypKiBaKj5yG79PtQdgDOGGGub9H2rirUYaHeOAthMLYa
	 QPahB+SAfNYZrCxZrDEVWzbO6h6uyZ3b267OJfmDETmBrJX97FkFWkMHO9aZzg+MiQMjX
	 5XJs4grM7VM58J966x3ExVOcLjwpyrRDvqKfU1AderImxTnCcheTsiwF8mLxPIUgyUrF1
	 3PHa96AKtjtcrAH9ZDadp/upqhX9JpsLJQYF46DuQORJBU26oi/FqpBOvbneXB2NGGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LvrLHFfUTKXenxu+3jI/MoDrvzw2B4oORNuFgZ8vViI=;
	b=Wg3ZUtdCDuPaidnggaMPoYzc3Aj8WnsCesM+sdeGMJInu8Dot/TVxQNlss1z1JbWqbwe
	 RiPXPC/ZeZc65/u/VkfryCtkukgyGVLyVBhg2nBzRCxUfJlAEmlssXjLb02hOVuW8Msni
	 Q+TRMMRdBFcXtmbRAe1bqd0sJ9AQeABbgrg1ajYPH/mM+geTG98P2c7VDT7Z1M6zn16TA
	 OxxNCSZ9uhLfTMb0MSqQgGKkUuP4i2tu8PbW1strcfqJBUKwCs0ecvADjn8m/QXeVEkyL
	 ebEXm2rp5nGgMNt0oaHRGs9ATude/YSN0apMOCAzhrAWz+LzqJNV87QlVcAAop9JHaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Un9fJ2V9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E762E606A31C;
	Wed, 18 Nov 2026 16:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Un9fJ2V9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA9C1F000C4;
	Wed, 18 Nov 2026 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019925;
	bh=LvrLHFfUTKXenxu+3jI/MoDrvzw2B4oORNuFgZ8vViI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Un9fJ2V9nqY4fPfj0EDO7lPh2p9Dnhc6/wj+rVUOTM5dm1apopR5WJrEpOhsxxOh/
	 +l7T6Zd6kre/dX2r9qWRpaaANkv+w0l9Z/ZPdpx+t0OJygnWh1HxnXlANyFxZONib2
	 zKOO0YhNWC0LtpBQJf3mS2TDoDhbdQjzgaIZ2K44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1769/2651] RDMA/bnxt_re: Unpublish QP table before freeing it
Date: Wed, 18 Nov 2026 15:50:09 +0100
Message-ID: <20261118150351.108556023@linuxfoundation.org>
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
index 9ee0d500436cb..34d8aa12265de 100644
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
index e8a111646fc9a..cde56ff2313b2 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -910,7 +910,15 @@ int bnxt_qplib_init_res(struct bnxt_qplib_res *res)
 
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



