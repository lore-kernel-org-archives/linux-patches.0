Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14922EF652;
	Sat, 30 May 2026 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166062; cv=none; b=niM2RAGSGePQ0CNGJU23bnch9CuBPHlghLr40Kh51N0x97UArONMwTyFWf6CjuPtj8MpEFdWFILrjfY/+spgGUc0/hnBwE/WaFX4mgiI4QytZWbhjnc9yurdc/yEvsiMMr/AHyTKI7ssIwuPfOJivSNhmf+0fL75gcgsn6M7Kdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166062; c=relaxed/simple;
	bh=n80SMFPG/5y3Q4wAYjH4zUVCpVFnE/yfas4VDZ2lWzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua+JZBupYcxJeO3Dq3WlpN/ukopKUTa74/5KeMBvCaUEXkp4ZnHKj8jrCBF7MhTLJVwf7q96lW9f5MqIysJjkYBGTH9PL9UouoE5VZ9u6XfGiwDufvWwVp2yS5vkeprl3hzbGwv+wJbPGck8Oj8F/7/WYN1dRiCaoVeVzFFYfko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8WP/bwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8WP/bwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66671F00893;
	Sat, 30 May 2026 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166061;
	bh=Ihap1q5ounk3sTkg1toP4xjOvqds2pLbBALoYuPpFNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8WP/bwORyD7zkB1cBZS6w1dnlPtB2NFxOZFxAT8Hh0hphy/PH5PjeM4LOOD0hEyh
	 Rz7OjkV4SDITqEQiqoQNazo7H6tr8B1vuAlODnEJYcv7fGjbL/xbjCewN26x1YpFER
	 8ZPEeFwisCGPDmMAeevnM11fmn+pQOJlzDNvEXT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 262/589] RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path
Date: Sat, 30 May 2026 18:02:23 +0200
Message-ID: <20260530160231.849609491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


