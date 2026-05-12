Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73541368972;
	Tue, 12 May 2026 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609566; cv=none; b=pX3qH6tBq5IkOyaN7CKQeeaTDEPzFYeyIOScDqfQF5auMesY1lC/Iw1kv5wCqXMyPL6vZbxmorzv8rcKmJf5z5L00DcMe5MNPZx/QeknAI65id356AHevsJd8zAsSIPtsT6tUjW5NWl4HSKAnQIrus/bEiNG2CejUaQCI8LdpoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609566; c=relaxed/simple;
	bh=teGZlQvM1TIvSSQFwk26Mx8nnkjzOid8NjVEksjh+4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a304cgssMSijYYC5UmGmHUAstklRDrBIi/kYhaMMvOLpyg2xFqNiZ3izQRhcXH8Ww+lpY+kd3R8Y9PJfymIt1WjUEFnvQfjb06y5nf/N+MF5G7pTKt3VSYIT5HzAvYO4szlqr0DK+XyrnasSvUdsRUkK74aJmSoH1rDSH9pGV3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ6gi3Ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ6gi3Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004BAC2BCB0;
	Tue, 12 May 2026 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609566;
	bh=teGZlQvM1TIvSSQFwk26Mx8nnkjzOid8NjVEksjh+4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ6gi3Ve8RPLGHq7P1Pr9g/xq/56KgDamUmcH4QtFuR0HuONKWcef9FczdJlk1+nr
	 I549ba+v78rs2Ygge6yrcwvCzdNvA7PgWnACZdeZjvVQvc+JUBqc5eRW5VYUxrEptS
	 FTtDD5rZpA3Ik1Ot/la5d3NWefWiI9FiWdiodwFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 243/307] RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path
Date: Tue, 12 May 2026 19:40:38 +0200
Message-ID: <20260512173945.251457470@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -322,7 +322,7 @@ int pvrdma_alloc_ucontext(struct ib_ucon
 	uresp.qp_tab_size = vdev->dsr->caps.max_qp;
 	ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (ret) {
-		pvrdma_uar_free(vdev, &context->uar);
+		/* pvrdma_dealloc_ucontext() also frees the UAR */
 		pvrdma_dealloc_ucontext(&context->ibucontext);
 		return -EFAULT;
 	}


