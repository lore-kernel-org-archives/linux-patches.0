Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F023330B01;
	Thu,  2 Jul 2026 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009892; cv=none; b=TWG8cuGanKCq2fU4LBeAIo2naPppHPF23Lbh3QZzQtFO8rVX9vGY/IdnS9ANShbLQVoVS+mtQpzBXRPsPWRDrXDNdqEc3AAmgoy3nj3V2yD2A+3Hh9fAz0N2pxkgmdpUabzM1uZWj/hi82vOktS5PpYDnLGN54PtKu05o25UrSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009892; c=relaxed/simple;
	bh=lMSWWe4soLu1VynmrmJ6fERuTTVYTo+UnNTdLK5TCo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUAj0HSctnud4DskGDIzfqB6UkXj5z4pW6HmyzUUNwTw9RyV9r9mqpnXdQjFQ5nCs08B9+WfLQJBcreu6h7OrZqu4ZBt7lLmTSJ3SaoQIj8H1QVE3XYcIK6VSc9my5Y9O5kiEfQdR6VhpFzU+yGUHAnKDa9QXD94HMiaJKJk30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxqErbLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxqErbLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EC81F000E9;
	Thu,  2 Jul 2026 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009891;
	bh=yc61fK6OcFcOYQHTmUzSfemp7M4kJ7BjnDUkYQ57KFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxqErbLM+sgr4HFvoEyaJfNSGV9EzVPXf9WpKdLKO4ueh55m6vgvcsTIOmVEevwVh
	 h6c77MnUFNI5ynet0gsh4tfAxC4OylTqYDUfI6poOQrSXUV5CCX8LYeEK+C8IySK1q
	 pecBrZYVCpazY4rCoAuz71D6eFulr7qzo32mOjjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 031/129] RDMA/bnxt_re: zero shared page before exposing to userspace
Date: Thu,  2 Jul 2026 18:19:10 +0200
Message-ID: <20260702155112.800808283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>

commit f6b079629becfa977f9c51fe53ad2e6dcc55ef44 upstream.

bnxt_re_alloc_ucontext() allocates uctx->shpg via
__get_free_page(GFP_KERNEL). The buddy allocator does not zero pages
without __GFP_ZERO, so the page contains stale kernel data from
whatever object most recently freed it.

The page is then mapped into userspace via vm_insert_page() under
BNXT_RE_MMAP_SH_PAGE in bnxt_re_mmap(). The driver only ever writes
4 bytes (a u32 AVID) at offset BNXT_RE_AVID_OFFT (0x10) inside
bnxt_re_create_ah(); the remaining 4092 bytes of the page are exposed
to userspace unsanitised, leaking kernel memory contents.

Any user with access to /dev/infiniband/uverbsX on a host with a
bnxt_re device (typically rdma group membership) can read this data
via a single mmap() at pgoff 0 after IB_USER_VERBS_CMD_GET_CONTEXT.

Other shared pages in the same file already use get_zeroed_page()
correctly:

  drivers/infiniband/hw/bnxt_re/ib_verbs.c
      srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
      cq->uctx_cq_page  = (void *)get_zeroed_page(GFP_KERNEL);

uctx->shpg is the only outlier. Bring it in line with the existing
convention by switching to get_zeroed_page().

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>
Link: https://patch.msgid.link/20260509084011.11971-1-pomzm67@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3870,7 +3870,7 @@ int bnxt_re_alloc_ucontext(struct ib_uco
 
 	uctx->rdev = rdev;
 
-	uctx->shpg = (void *)__get_free_page(GFP_KERNEL);
+	uctx->shpg = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!uctx->shpg) {
 		rc = -ENOMEM;
 		goto fail;


