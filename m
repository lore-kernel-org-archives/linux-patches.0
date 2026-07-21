Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978D42DF3EA;
	Tue, 21 Jul 2026 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659991; cv=none; b=mLgltHQnEizOLoutyT1Apz1z014wl7Lqz2aR1NK2GVyAELG9jF4AK24ryDue2clkrvBX/WL1iuDmRlngI9syFurYebqMuimsKVZrpQX7RtlBkwENzuO3fSEO8cn+uR3hfL5sYuXhkVUrar6APtlpZYGrVTGD2VL1+qfBDNl14MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659991; c=relaxed/simple;
	bh=YqCNTl/6yYgceykWGTuauHZLUZrplr2gRrLyV6z/kQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqQTtkK7ZwQfJMiJt2QE/y4NG9/4FYpMYh0KqoLMeCaZ6TZrMbIdSm0BcE3eq/yi+haCZyUu9CnlGoHuXziJFQoJ9Qxr/67QD2x69eMGE+GdgaWQ3qTB4pM0MJGnRMQTVbnTU7cJrRrytAIevAUAc7PYL2Bve8hCIunJP1ZuZmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uh/Yh9Mn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uh/Yh9Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090751F000E9;
	Tue, 21 Jul 2026 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659990;
	bh=Ix8qP1cIYOnteun4sQABHPfszU0tcjJQHab9Nj42YsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uh/Yh9MnbRcByx3u4avhL0NOJTjKy0ZjSQ4SL9lwD5jj/iP0LdBWYwKcjzkRu2HGM
	 TZm8zkZT+fQ8ExLtovZ57l8WTBeyd6auCa3M1rKS6Iyo8VKvhCBfok1MGve6X2eWdL
	 rp9hcars6Yna27a2Fs8p4Y029JTnQhjrMEHmEO9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0809/2077] RDMA/bnxt_re: Enhance dbr usecnt logic in doorbell uapis
Date: Tue, 21 Jul 2026 17:08:02 +0200
Message-ID: <20260721152611.875265403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

[ Upstream commit 73607410f4f1b0d5c3d0af2d70a79c265482a0e3 ]

The current logic in the doorbell cleanup function is not
sufficient for a change in a subsequent patch, that fails
doorbell remove operation in some conditions. The cleanup
should facilitate freeing of the dbr object when the caller
may not retry the teardown operation (implicit teardown:
process-exit/driver-removal).

Extend this counter to use kref mechanism so that the dbr
object gets freed (via kref callback) when there are no more
references to it, rather than directly freeing it in the
cleanup uapi.

Link: https://patch.msgid.link/r/20260519150041.7251-7-sriharsha.basavapatna@broadcom.com
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: dc95931b7e13 ("RDMA/bnxt_re: Add a max slot check for SQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  3 ++-
 drivers/infiniband/hw/bnxt_re/uapi.c     | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 08f71a94d55d7b..13dac48ed453e8 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -167,7 +167,7 @@ struct bnxt_re_dbr_obj {
 	struct bnxt_re_dev *rdev;
 	struct bnxt_qplib_dpi dpi;
 	struct bnxt_re_user_mmap_entry *entry;
-	atomic_t usecnt; /* QPs using this dbr */
+	struct kref usecnt; /* 1 (uobject) + n (QPs using this dbr) */
 };
 
 struct bnxt_re_flow {
@@ -308,4 +308,5 @@ void bnxt_re_unlock_cqs(struct bnxt_re_qp *qp, unsigned long flags);
 struct bnxt_re_user_mmap_entry*
 bnxt_re_mmap_entry_insert(struct bnxt_re_ucontext *uctx, u64 mem_offset,
 			  enum bnxt_re_mmap_flag mmap_flag, u64 *offset);
+void bnxt_re_dbr_kref_release(struct kref *ref);
 #endif /* __BNXT_RE_IB_VERBS_H__ */
diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 61ddfa94c1aa1a..058f76f9b679b1 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -369,6 +369,7 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_DBR_ALLOC)(struct uverbs_attr_bundle *a
 	}
 
 	obj->rdev = rdev;
+	kref_init(&obj->usecnt);
 	uobj->object = obj;
 	uverbs_finalize_uobj_create(attrs, BNXT_RE_ALLOC_DBR_HANDLE);
 
@@ -391,15 +392,24 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_DBR_ALLOC)(struct uverbs_attr_bundle *a
 	return ret;
 }
 
+void bnxt_re_dbr_kref_release(struct kref *ref)
+{
+	struct bnxt_re_dbr_obj *obj =
+		container_of(ref, struct bnxt_re_dbr_obj, usecnt);
+	struct bnxt_re_dev *rdev = obj->rdev;
+
+	rdma_user_mmap_entry_remove(&obj->entry->rdma_entry);
+	bnxt_qplib_free_uc_dpi(&rdev->qplib_res, &obj->dpi);
+	kfree(obj);
+}
+
 static int bnxt_re_dbr_cleanup(struct ib_uobject *uobject,
 			       enum rdma_remove_reason why,
 			       struct uverbs_attr_bundle *attrs)
 {
 	struct bnxt_re_dbr_obj *obj = uobject->object;
-	struct bnxt_re_dev *rdev = obj->rdev;
 
-	rdma_user_mmap_entry_remove(&obj->entry->rdma_entry);
-	bnxt_qplib_free_uc_dpi(&rdev->qplib_res, &obj->dpi);
+	kref_put(&obj->usecnt, bnxt_re_dbr_kref_release);
 	return 0;
 }
 
-- 
2.53.0



