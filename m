Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6674236C0D9;
	Wed,  3 Dec 2025 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779510; cv=none; b=SOxzpBOy/BG3AFGSZCs8QkByrufA0FT1TXOHCoR/k+XhILwC9i6mCl9OfH3yTBjpyb37i/r5wvI9+rxVwj+gw1fHV+78CoHwNbMcoFUvEXGlJbp25R+CqQf/BYm+GJsslTFHqKb+UCw4I0r2mY/SrB51kwsmc5oVRHyq0DFHB5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779510; c=relaxed/simple;
	bh=uIR+ZsvJMG9ues0ptz+GKpP8YE38YAseydcxnFZFs2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cobkSf1c7UgUNuFQgGLKMq4zhd9qgBDYcHflexwHr9teZ3RSqeN5TwD+KqZ+FHySwBsbDtAs0rIVOqBfM2FhWiCDOrvc1wvfDo++MDQvRSZRKS844vZSEReRp56QRuW7cbSrHDld3jE1tPwblEE/1ywdN1JNQdnzLBq/9VL2En4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4HQdtxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4HQdtxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D8CC4CEF5;
	Wed,  3 Dec 2025 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779510;
	bh=uIR+ZsvJMG9ues0ptz+GKpP8YE38YAseydcxnFZFs2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4HQdtxLQXGC953X/mhgGFeJJyG30fbt0SjWhxSvRfrTExX0v4p7OQpnv25FuPciB
	 AbWgOK60ZuRDBH10UD1oOIzoOgyvbUH5ItUoC+UBVbnwcuYxRdkdoODIsRMRaMOTCV
	 YT+SjYLYM/MfSRny4FEHwR6OqTEXyzMWJ7e6Sfy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 277/568] RDMA/irdma: Set irdma_cq cq_num field during CQ create
Date: Wed,  3 Dec 2025 16:24:39 +0100
Message-ID: <20251203152450.854959373@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 5575b7646b94c0afb0f4c0d86e00e13cf3397a62 ]

The driver maintains a CQ table that is used to ensure that a CQ is
still valid when processing CQ related AEs. When a CQ is destroyed,
the table entry is cleared, using irdma_cq.cq_num as the index. This
field was never being set, so it was just always clearing out entry
0.

Additionally, the cq_num field size was increased to accommodate HW
supporting more than 64K CQs.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20250923142439.943930-1-jmoroni@google.com
Acked-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 drivers/infiniband/hw/irdma/verbs.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index fb02017a1aa63..6fc622e3eb07a 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2050,6 +2050,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	spin_lock_init(&iwcq->lock);
 	INIT_LIST_HEAD(&iwcq->resize_list);
 	INIT_LIST_HEAD(&iwcq->cmpl_generated);
+	iwcq->cq_num = cq_num;
 	info.dev = dev;
 	ukinfo->cq_size = max(entries, 4);
 	ukinfo->cq_id = cq_num;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index b55d30df96261..8809465020e13 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -113,7 +113,7 @@ struct irdma_mr {
 struct irdma_cq {
 	struct ib_cq ibcq;
 	struct irdma_sc_cq sc_cq;
-	u16 cq_num;
+	u32 cq_num;
 	bool user_mode;
 	atomic_t armed;
 	enum irdma_cmpl_notify last_notify;
-- 
2.51.0



