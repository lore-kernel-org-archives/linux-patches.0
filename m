Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5983403FC;
	Thu,  2 Jul 2026 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009593; cv=none; b=WgOI0hoA78wL8DHmEcjdrZEeakUELI1X8AnqkPbfb1MvzDYofXM3ETJHDbPFSOTURFp0ml5EBcT0kprQbFb6YORDYDgtaP1Wi57IJTrB8NkUdoMydmR8IEIfRWbIUNOkwAaxRwyJf34CtIFDP7fcg/h/ItD87DH4WJRYwZDikG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009593; c=relaxed/simple;
	bh=Bac/BAqy/ENIIHmSGttCixWk/3zhoWQflFA7nH4ITrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoENXdI2pWoC3oB6EST09K88vTn06SrcROZinb6SFt7OSV31+s6E1rjtjKacrVOwJ/tZuMINDt/QrT74nTPj+xtrrVxgOTlgdA+r4ktibN5/yykjm5QnV+9qjS17iK+7tRQOnd6CFLRDyaLDMMGoeFW5+INdzZ+ACtzj/UZkeVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rB61b9lv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rB61b9lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC131F000E9;
	Thu,  2 Jul 2026 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009592;
	bh=yv6tyF2PJFEdRuvWno2wOF6IAqJ485YArgOw2NTkERE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rB61b9lvg1UkpeR4My796VsH40GCbBQ6idibuDXEu4ISJIjfUXdedy6BFSGC9u1f5
	 gya1qFbTJVjL4Uae7empTwH+k4ijqXpz0Bsz2ek2sHTns4BdqD8MmUJwqbJ9HJ7iND
	 M/ixHh1nM/aXYi2WhdqFyrj6uiuPKF+fm8wlY+Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.15 14/95] RDMA/bnxt_re: zero shared page before exposing to userspace
Date: Thu,  2 Jul 2026 18:19:17 +0200
Message-ID: <20260702155109.506137802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3864,7 +3864,7 @@ int bnxt_re_alloc_ucontext(struct ib_uco
 
 	uctx->rdev = rdev;
 
-	uctx->shpg = (void *)__get_free_page(GFP_KERNEL);
+	uctx->shpg = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!uctx->shpg) {
 		rc = -ENOMEM;
 		goto fail;


