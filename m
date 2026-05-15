Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6B43C9896;
	Fri, 15 May 2026 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861319; cv=none; b=oICrd7UZewTcH5b6KdvEw926OqL4S+CkvMgIIucyb/gTb1/AIURFgMF7SJNwT3i9wBy27TTnRSlsAjZgqwbZUMRtRq7H4qtYfKF6EU8t4IqKH1RoYawnt9GEXXxu6RN5o4secTbhzMX6FVq7EOC5Zh0tWmIYQPumNxuZsoqHbWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861319; c=relaxed/simple;
	bh=ZvMHYKeO7kUlq7Vk9D9JrDQ6uGj1LeQ2RWGFYtNd3QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfUW4zKBvMt7lEqpAXxK1PGI9wDmneVXD3FDDT5/GBHfKATAkDBoBA9XA0VjaDYTERlAWFKc+90hhVrh891B9dohIO1E6KvYWo3ETtLnloFiuWTvlArfdmQigHxYl6kCzULL4AChP3ArD8+PCUtNgR+mm+oZXP7ri7i1myb0CXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a06Xr9si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a06Xr9si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B41C2BCB0;
	Fri, 15 May 2026 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861319;
	bh=ZvMHYKeO7kUlq7Vk9D9JrDQ6uGj1LeQ2RWGFYtNd3QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a06Xr9silUAZo0ZaQS2HN0wfZF3MC+DcEXjk/BJ4gvXLf9RneTV9TYDHAHGbKI4Xz
	 gz/nnq2t2lu3IRlkjPJGG78ePBv3llN/+wrNPcDToA9voZ/dLo9XOvlIkUmM6Qt76/
	 5MMyG6ZJ+MxV25nuHnZzP6eOK6gYs/oiwDdXTz5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 282/474] RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path
Date: Fri, 15 May 2026 17:46:31 +0200
Message-ID: <20260515154721.103316150@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


