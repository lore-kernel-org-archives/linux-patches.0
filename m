Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BAB23099F;
	Mon, 10 Mar 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626685; cv=none; b=teD/3o+7Q9jP+468WBzAGCtcKkFcYi5TrPh43pOCjyxqfPtXvNvwp0Hrg56Z+kYJq3Wjp9gilDqB0de5IlyqMOg8qKDL5gGO50HkqsKIE4obwZv5zYouqy/mP0DUDGMy7TXYlLwVCPfN/plZ36ali/Yx6Aj5g/+NkJXh+lG8cB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626685; c=relaxed/simple;
	bh=Q7BhjS3uAYwKNvKsj4tRrBzZX5km9knTeNXVggbhCrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMz9LV0CtA6nok5DCMBNZVQxaWfAY7CBTh33dOaoJxpYhFBrA2t8NjP7pbET0leGgh5T8TpGnVNc33Mk72cqzrrJO4/ai8YQV7pZJtDkRFkYWL1bxmG0ZGe5R1yI5r2rQmyYfHIhVG/BjN7zLze1a1ZeMMdGsMPUYYbqNuBZiFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XM7tNLte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XM7tNLte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3FFC4CEE5;
	Mon, 10 Mar 2025 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626685;
	bh=Q7BhjS3uAYwKNvKsj4tRrBzZX5km9knTeNXVggbhCrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XM7tNLten2l6QXEygXL/DocF+wrZKHPQTjLr+x4oDLkFnzDEGa1t989njBTiONqPy
	 G2rSOnfAmRXocMO6cyY+tF8TvpqhXvBQxHU6IxSusFqr2YInpBFxBxVAm+rJC1ESzJ
	 kIs78n5lsf/YQrrDRMz2Wree2+A0qCCnAGhD8/NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <Andrew.Martin@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 035/207] drm/amdkfd: Fix NULL Pointer Dereference in KFD queue
Date: Mon, 10 Mar 2025 18:03:48 +0100
Message-ID: <20250310170449.169210378@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Martin <Andrew.Martin@amd.com>

commit fd617ea3b79d2116d53f76cdb5a3601c0ba6e42f upstream.

Through KFD IOCTL Fuzzing we encountered a NULL pointer derefrence
when calling kfd_queue_acquire_buffers.

Fixes: 629568d25fea ("drm/amdkfd: Validate queue cwsr area and eop buffer size")
Signed-off-by: Andrew Martin <Andrew.Martin@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Andrew Martin <Andrew.Martin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 049e5bf3c8406f87c3d8e1958e0a16804fa1d530)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -266,8 +266,8 @@ int kfd_queue_acquire_buffers(struct kfd
 	/* EOP buffer is not required for all ASICs */
 	if (properties->eop_ring_buffer_address) {
 		if (properties->eop_ring_buffer_size != topo_dev->node_props.eop_buffer_size) {
-			pr_debug("queue eop bo size 0x%lx not equal to node eop buf size 0x%x\n",
-				properties->eop_buf_bo->tbo.base.size,
+			pr_debug("queue eop bo size 0x%x not equal to node eop buf size 0x%x\n",
+				properties->eop_ring_buffer_size,
 				topo_dev->node_props.eop_buffer_size);
 			err = -EINVAL;
 			goto out_err_unreserve;


