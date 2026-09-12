Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405D4367F36;
	Sat, 12 Sep 2026 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197552; cv=none; b=FSmK6zj9Alji+i81w7zdMYnjhU2gve6iBsKhwF1JQ40qKE+bUBA9EkyHmWnwsknhLsgUiC7HaOjEt7Ev9R+dIWxb27CRO0YtAoem7AQnWkPOWd81AsyvNfWwHvxlexzdy+Q9egchylvCKpIQCNLQ08xWz4Nt8Uvpg1Glfdnt6Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197552; c=relaxed/simple;
	bh=PRyjupGlOutYi+hCa4WmUbBvWW0Yg9ZZplfw+mSxbUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM4+iTs+cufxZtZdIbeokRgmgT2okggztseSvg7de9XTVU7QDgZiBeTBwSkXm66LOer7jVqoUyOiPxMAOO1hYXdJVpJC44CmjvV2zySyz443Q7vtodeJJTGFD7csWGtSxv60LSwrNpRmCW1HRSKawFo7JDby53h7FE5GcjUuyTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8r/OY+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8r/OY+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA011F000FF;
	Sat, 12 Sep 2026 07:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197551;
	bh=Fr0eZDHV9MBs5hi5tAKl+pLgdZozRADEHfvGX7f26Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8r/OY+fIwoHbBQpF+wvT9Sldx9L4O3hTHfTrzh6qlzC+Y9os7W5psNyABeXYEEKk
	 6Opt/E6RpADaYxjwDqlUPDzrqJxltJ2qh3xBwBnJiPYu1etyhmeNUUCB5GgRpbLfIW
	 zLAXqoAKgGUf2J7nW25EZhgwwPDIn5hPK6bUhdsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0199/1815] RDMA/irdma: Add irdma_cq fields to track pbl allocations
Date: Sat, 12 Sep 2026 08:32:29 +0200
Message-ID: <20260912065653.675659929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 971e99623ed7a0d75a719021cf4fd64e5f9e44e5 ]

These fields will be used in a subsequent commit which adds
refcounting to user CQ MRs.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260618201458.875740-4-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f67d8a08f60c ("RDMA/irdma: Add refcounting to user ring MRs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 25 +++++++++++++++----------
 drivers/infiniband/hw/irdma/verbs.h |  2 ++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b4c91349bcd87..d8e7dc9bd4920 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2128,6 +2128,11 @@ static int irdma_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 		goto error;
 
 	spin_lock_irqsave(&iwcq->lock, flags);
+	if (udata)
+		/* Only update if the resize was successful. Otherwise, HW is
+		 * still pointing to the old PBL.
+		 */
+		iwcq->iwpbl = iwpbl_buf;
 	if (cq_buf) {
 		cq_buf->kmem_buf = iwcq->kmem;
 		cq_buf->hw = dev->hw;
@@ -2498,6 +2503,8 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	INIT_LIST_HEAD(&iwcq->resize_list);
 	INIT_LIST_HEAD(&iwcq->cmpl_generated);
 	iwcq->cq_num = cq_num;
+	iwcq->iwpbl = NULL;
+	iwcq->iwpbl_shadow = NULL;
 	info.dev = dev;
 	ukinfo->cq_size = max(entries, 4);
 	ukinfo->cq_id = cq_num;
@@ -2517,8 +2524,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		struct irdma_ucontext *ucontext;
 		struct irdma_create_cq_req req = {};
 		struct irdma_cq_mr *cqmr;
-		struct irdma_pbl *iwpbl;
-		struct irdma_pbl *iwpbl_shadow;
 		struct irdma_cq_mr *cqmr_shadow;
 
 		iwcq->user_mode = true;
@@ -2532,34 +2537,34 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		}
 
 		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-		iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
-				      &ucontext->cq_reg_mem_list);
+		iwcq->iwpbl = irdma_get_pbl((unsigned long)req.user_cq_buf,
+					    &ucontext->cq_reg_mem_list);
 		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
-		if (!iwpbl) {
+		if (!iwcq->iwpbl) {
 			err_code = -EPROTO;
 			goto cq_free_rsrc;
 		}
 
-		cqmr = &iwpbl->cq_mr;
+		cqmr = &iwcq->iwpbl->cq_mr;
 
 		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
 		    IRDMA_FEATURE_CQ_RESIZE) {
 			spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-			iwpbl_shadow = irdma_get_pbl(
+			iwcq->iwpbl_shadow = irdma_get_pbl(
 					(unsigned long)req.user_shadow_area,
 					&ucontext->cq_reg_mem_list);
 			spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
 
-			if (!iwpbl_shadow) {
+			if (!iwcq->iwpbl_shadow) {
 				err_code = -EPROTO;
 				goto cq_free_rsrc;
 			}
-			cqmr_shadow = &iwpbl_shadow->cq_mr;
+			cqmr_shadow = &iwcq->iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
 		} else {
 			info.shadow_area_pa = cqmr->shadow;
 		}
-		if (iwpbl->pbl_allocated) {
+		if (iwcq->iwpbl->pbl_allocated) {
 			info.virtual_map = true;
 			info.pbl_chunk_size = 1;
 			info.first_pm_pbl_idx = cqmr->cq_pbl.idx;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index fbd487dbebfb9..a1651641eb714 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -153,6 +153,8 @@ struct irdma_cq {
 	struct list_head resize_list;
 	struct irdma_cq_poll_info cur_cqe;
 	struct list_head cmpl_generated;
+	struct irdma_pbl *iwpbl;
+	struct irdma_pbl *iwpbl_shadow;
 };
 
 struct irdma_cmpl_gen {
-- 
2.53.0



