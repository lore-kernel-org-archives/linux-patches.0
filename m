Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A279D2690D5;
	Sat, 30 May 2026 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160585; cv=none; b=ajhxZL1XetzpBxr52rEbnzIOzap0bTd1ff0ewc2YSm/7FhkqQ8vn7KBDgqwQpmvE/veRxsII8MYUFjK0ch10E0Rft1TYdL2TNWOjZUKrY0TQwbwclEoQUYBG3HnS6+HuWLOeov3Ndm373r5PdKDWN6aObbCuoSuFfqAo5UCEnhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160585; c=relaxed/simple;
	bh=x4SSc8D3tJFb8TTdi+EEfHAm1+te7nywrloEZg0w104=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAC5SC10xnOJf+OR81r2f1gO6fzajAFwm1Jt/+jNSKtk6U4CPRcw2EsaZa9rEhn77QuZTZA+X9fQKOqqrO/djikhpxAwBSBqrVrcGNtOVy76xHYx4jRdYBBynGhQrtdKx0XX62KMYRDE3tkihcgq1Kx/ypZPs88SyuOFhgZdz9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWIqvV/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWIqvV/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6291F00893;
	Sat, 30 May 2026 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160584;
	bh=P1TtSUlUvIHoUmrzNJThHhCQ/7/YH1uargkLFvIDuGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWIqvV/Du8lFksKM+ShJo39Rzc7jcyOESUVb8Vg6A53GX9OKNco9W6zxT12eNDBwX
	 jFeqeOGQnNrjoBca45FXdYH+wLMa0SVbj4Xy655gDWyTQl0Qy2+CwaCAIjRpgKNqRe
	 EPEAIxFt0wa7Pv0xlHqHsIZ6dM36zV0hR0FHDoYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 370/969] RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path
Date: Sat, 30 May 2026 17:58:14 +0200
Message-ID: <20260530160310.536104655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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


