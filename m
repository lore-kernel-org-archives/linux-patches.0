Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD4531B0B;
	Wed, 23 Sep 2026 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172718; cv=none; b=cHeHa1Z+udsNBQRtWr+om3G3W1qrcw4iCj10PlShBmC1p17Z5tgacJhf6xVOqqNegJOK7+9lS3qR936VlOqkAjRlgMThLYESyUDAQvRXHRb/b/NFDMndRzp53Zima9GNSuuHeVL36poMcIQ8+WSGlB0vph+behLSdnUMDwsBbrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172718; c=relaxed/simple;
	bh=ipZf5+iJRBdJWU8UVPEytN51qjeYq2P6OyHqvTqTDAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Whs/idRDnIlRxyehcCqagFtvGa2hVq9pj7rxCrryMKlXcZtZGTmOcFUFhGUls6DvHTMEdYtxSu3olwEeo3gEH5r4tmkE9ho2WsYvggeYIsNRMD4qhogk0heDD9bDZw2Q/sRbZvt1k+leV9DpzoxKy7bI4BfB/RBsRg/TmpzcpsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goyDR8eN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goyDR8eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5851F000FF;
	Wed, 23 Sep 2026 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172716;
	bh=/CicZV9KKYyTSIE+y90hRKDLq+4tONDF/MJdximShRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goyDR8eNxOwZlD/iU8zyDwFgquFYDdFq6aDPbvOJSjzqmhr++lM7d75pkEl38KWNS
	 SQFaLUNvH52OB32F1iVDiKKj6BbMw9ague+C8UoQQkueGCUZa1yK3h5itZUq89d9hS
	 cdzxEqI+Vk0uNJ34v4gOqfPSnK1WMzgDDR5Lwq+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 039/438] RDMA/bnxt_re: Avoid exposing umdbr to userspace
Date: Wed, 23 Sep 2026 16:01:00 +0200
Message-ID: <20260923140645.798775863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

[ Upstream commit 23d7e03a52ece66b992620aa9b8fa5f164077c0f ]

The umdbr field in struct bnxt_re_db_region returns the raw
unmapped PCI BAR address of the doorbell region. Avoid sharing
this field to the userspace. Change this to a reserved field
and stop populating it, keeping the ABI layout and size
unchanged for existing binaries.

Fixes: 1234a9d8aebb ("RDMA/bnxt_re: Support doorbell extensions")
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Link: https://patch.msgid.link/20260824172443.33943-1-sriharsha.basavapatna@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/uapi.c | 6 ++----
 include/uapi/rdma/bnxt_re-abi.h      | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 263238a6e4cdd..f278c4f70ff7b 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -409,7 +409,6 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_DBR_ALLOC)(struct uverbs_attr_bundle *a
 	uobj->object = obj;
 	uverbs_finalize_uobj_create(attrs, BNXT_RE_ALLOC_DBR_HANDLE);
 
-	dbr.umdbr = dpi->umdbr;
 	dbr.dpi = dpi->dpi;
 	ret = uverbs_copy_to_struct_or_zero(attrs, BNXT_RE_ALLOC_DBR_ATTR,
 					    &dbr, sizeof(dbr));
@@ -472,7 +471,6 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_DEFAULT_DBR)(struct uverbs_attr_bun
 		return PTR_ERR(ib_uctx);
 
 	uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
-	dpi.umdbr = uctx->dpi.umdbr;
 	dpi.dpi = uctx->dpi.dpi;
 
 	ret = uverbs_copy_to_struct_or_zero(attrs, BNXT_RE_DEFAULT_DBR_ATTR,
@@ -490,7 +488,7 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_DBR_ALLOC,
 					    UA_MANDATORY),
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_ALLOC_DBR_ATTR,
 						UVERBS_ATTR_STRUCT(struct bnxt_re_db_region,
-								   umdbr),
+								   reserved2),
 								   UA_MANDATORY),
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_ALLOC_DBR_OFFSET,
 						UVERBS_ATTR_TYPE(u64),
@@ -510,7 +508,7 @@ DECLARE_UVERBS_NAMED_OBJECT(BNXT_RE_OBJECT_DBR,
 DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_DEFAULT_DBR,
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_DEFAULT_DBR_ATTR,
 						UVERBS_ATTR_STRUCT(struct bnxt_re_db_region,
-								   umdbr),
+								   reserved2),
 						UA_MANDATORY));
 
 DECLARE_UVERBS_GLOBAL_METHODS(BNXT_RE_OBJECT_DEFAULT_DBR,
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index a4599d7b736aa..0a125c2a8cc4e 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -247,7 +247,7 @@ struct bnxt_re_query_device_ex_resp {
 struct bnxt_re_db_region {
 	__u32 dpi;
 	__u32 reserved;
-	__aligned_u64 umdbr;
+	__aligned_u64 reserved2;
 };
 
 enum bnxt_re_obj_dbr_alloc_attrs {
-- 
2.53.0



