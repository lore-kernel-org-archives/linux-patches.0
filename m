Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23535101A;
	Mon, 11 Dec 2023 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGdQ6CbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C4AC433C7;
	Mon, 11 Dec 2023 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319372;
	bh=gXjR7eOIG++qSAGB8nz2XTnlTzyea1mZFWOlg3Ybdb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGdQ6CbTVHJBjafNRSH4uU4UI5R6Z+V+kw1hPhnERN6Kw2pJvWMIY+iVZiLgqIJsC
	 DW4HQIkvRhd+qcqjcRhuy2mAOCed2+wUEdXfK5pmAC+dwRca0f/BA4GdKSXNt7yBrh
	 rl3ccdugulC/IdUoLq4vIdykWsw8RUs61uJxM+Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/244] RDMA/irdma: Do not modify to SQD on error
Date: Mon, 11 Dec 2023 19:19:34 +0100
Message-ID: <20231211182049.420943757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit ba12ab66aa83a2340a51ad6e74b284269745138c ]

Remove the modify to SQD before going to ERROR state. It is not needed.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20231114170246.238-2-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 3eb7a7a3a975d..895799cbc4fdc 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1424,13 +1424,6 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		case IB_QPS_SQE:
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
-			if (iwqp->iwarp_state == IRDMA_QP_STATE_RTS) {
-				spin_unlock_irqrestore(&iwqp->lock, flags);
-				info.next_iwarp_state = IRDMA_QP_STATE_SQD;
-				irdma_hw_modify_qp(iwdev, iwqp, &info, true);
-				spin_lock_irqsave(&iwqp->lock, flags);
-			}
-
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
-- 
2.42.0



