Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BEB3955DC;
	Tue, 12 May 2026 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608214; cv=none; b=VlmbUk0yRbjQ9aKFF9Bt/9vVKCEoTcnTB4Djkwa2wTCwN4Uj8w2SaCf5DNch6NzMg/f7YSNYjY0flQjAnjdBHedZ4nCKswouLHBrdYsoMhJe01oWI0OcGwnvVOPkE+kIn3PJmAaHvQMldtE+mweBZGJE2VI8vr06+e9gVhH3IVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608214; c=relaxed/simple;
	bh=1yBLGyuc16bV5iDTylUcH4xv5Ap0xIhNuRo4dDlZjdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5jasI249X/veRTEg8zX3mWIEY+3+Jt8vcDnroRjzMAmzGTCjOaqreMh7Kav0HwXBBw5ZzTzFvWCadsc+EuAis2VFiMJ391e7iqz0kCtxF2TdIbyCxLJVzKZDoPOQrwkEpWGxVbo0zOUnfad8wvuBZ/pPjLHFR5OfrWlI3LD3lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K84NWB0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K84NWB0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3457C2BCB0;
	Tue, 12 May 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608214;
	bh=1yBLGyuc16bV5iDTylUcH4xv5Ap0xIhNuRo4dDlZjdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K84NWB0fsseqNW75DA4GqXipmKrhjErPUCXY5KhUmwG3YM50KQkQaBU55CKz54/Cq
	 P+8tXLmiNq70Iey6MBgiqAIOxMLNx2G2TK43aEd4/TXSqwAz99sYaMls+mh9ptos0K
	 9cwpk/uy0Li9YX/a/vVL1KoqpTZEXWRDEak44lGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 156/206] RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path
Date: Tue, 12 May 2026 19:40:08 +0200
Message-ID: <20260512173936.166574607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit e38e86995df27f1f854063dab1f0c6a513db3faf upstream.

Sashiko points out that pvrdma_uar_free() is already called within
pvrdma_dealloc_ucontext(), so calling it before triggers a double free.

Cc: stable@vger.kernel.org
Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Link: https://sashiko.dev/#/patchset/0-v1-e911b76a94d1%2B65d95-rdma_udata_rep_jgg%40nvidia.com?part=4
Link: https://patch.msgid.link/r/10-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -350,7 +350,7 @@ int pvrdma_alloc_ucontext(struct ib_ucon
 	uresp.qp_tab_size = vdev->dsr->caps.max_qp;
 	ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (ret) {
-		pvrdma_uar_free(vdev, &context->uar);
+		/* pvrdma_dealloc_ucontext() also frees the UAR */
 		pvrdma_dealloc_ucontext(&context->ibucontext);
 		return -EFAULT;
 	}


