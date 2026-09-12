Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEB137EFE5;
	Sat, 12 Sep 2026 19:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243082; cv=none; b=D2/vigRi/f+WFoDGUca4aru23P/aRPt1/UoVAQjutJRJKBwHJ2zsK5njGSbNJpsxZtRQWK7hZIh5wJnD/gj0gG0WOnKj3p4Iyf2StMWf6/7n43+LA+pUTBLmQISPyyqVxmN3KGtmZyquTEn7rTi8Ce6cm2U+1IQRgAc/Nolfhuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243082; c=relaxed/simple;
	bh=aS2xf+MXsziOxveq/tWVB/2etrufCe6p6gAM6/6nFYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQGW1d2Jy4m8PTXE4XEnR64hPuhO4Fn8BJe6kz1LxpOvRNzMj3zUEU3/XOP0xsP7yTDw6JSL0xgYxCKXhhyPRBsyF+tW3CuT45sBVAp87dOWWiAAJVkq73CUEyEdN9kM+XN7ms1p7B7uJ5pH73A1oUZO48H9q06CxyaFayWqepk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpcXHUay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpcXHUay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B13A1F000FF;
	Sat, 12 Sep 2026 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243081;
	bh=JWG3PxX6EbUGY0pLqb2ZFXS4+tveKHju61L/+0tWczg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpcXHUayD+AacwiF+/DLS/Uk3QPY8k2C4T3ScZOp8cyAHnbsV0SwxxNTe80ImaWXn
	 ThP95dnmKBnHBBvb+bRCa264ib9XB9/FmDlUaBR2t+zz6FsPTN1avQ8R7Wpc1lAoZK
	 0JpC4OuHOq+hsuPBllxC/rWHvCwQadHNJcrFI2m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 630/798] RDMA/siw: Introduce siw_free_cm_id
Date: Sat, 12 Sep 2026 09:04:18 +0200
Message-ID: <20260912065531.562850857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index df5f675993c74..7b2d3c39b4fc3 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -361,6 +361,15 @@ static int siw_cm_upcall(struct siw_cep *cep, enum iw_cm_event_type reason,
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
@@ -413,8 +422,7 @@ void siw_qp_cm_drop(struct siw_qp *qp, int schedule)
 			default:
 				break;
 			}
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
+			siw_free_cm_id(cep);
 			siw_cep_put(cep);
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
@@ -1172,8 +1180,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 			cep->sock = NULL;
 		}
 		if (cep->cm_id) {
-			cep->cm_id->rem_ref(cep->cm_id);
-			cep->cm_id = NULL;
+			siw_free_cm_id(cep);
 			siw_cep_put(cep);
 		}
 	}
@@ -1698,10 +1705,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-	if (cep->cm_id) {
-		cep->cm_id->rem_ref(id);
-		cep->cm_id = NULL;
-	}
+	siw_free_cm_id(cep);
 	if (qp->cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
@@ -1870,10 +1874,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
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
@@ -1903,10 +1904,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 
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



