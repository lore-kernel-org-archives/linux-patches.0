Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A52309A6;
	Mon, 10 Mar 2025 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627341; cv=none; b=ea6Io21qvtfyx0NGD5nQtkwuPmA8357yZXyv3p3W3qOs82bdUmmkAO4gCy24OvmJRpmDUjfcKceWsNBP7Lqdl0PsUNny12K3mkYXu6emQUpI87G3jB9U5coBOmXZgyAtL4mhBLjs9QdPtdLYtMZ1G2AzfH58J7HOXveR7WIpGXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627341; c=relaxed/simple;
	bh=Z88eIT1DY4oFUHb7nXN/+Ozn1WYZOIf9AturofdDWkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAHhJkj8HkSXyoluLTX3kbSxTbiG4/1rFOdYHQlxnBbhRPU57HXfU4FmwuGVXPnwOi1I+JqGxFFDUWyMlGWkG2eY+EApHaJmKvFhma5sE/hcv4aI9WBoUApkjMjoLdPnoNbZgMSw8aO4VVTdF3xt7QpBro4S3M99irP4n2Pnh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q5MhGjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q5MhGjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0541FC4CEE5;
	Mon, 10 Mar 2025 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627341;
	bh=Z88eIT1DY4oFUHb7nXN/+Ozn1WYZOIf9AturofdDWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q5MhGjJldW5DWtuFGPoI40sblFTe3FD1cmhpyGrHpBHP748KSnmR9Aj6hnQLGsDO
	 tKuKmt9W/zufsC8woN0jA55yDcSgeMQMEoSZFYfJbmonpllBcQYphW/cchIwpnsh41
	 AuL2mmWiigvFkLFd4z90ooV/8Uw2B5exjZAnwuqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <Andrew.Martin@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 096/269] drm/amdkfd: Fix NULL Pointer Dereference in KFD queue
Date: Mon, 10 Mar 2025 18:04:09 +0100
Message-ID: <20250310170501.536887411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index ecccd7adbab4..24396a2c77bd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -266,8 +266,8 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
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
-- 
2.48.1



