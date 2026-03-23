Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11513BE65E;
	Mon, 23 Mar 2026 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282685; cv=none; b=RXyz713ekluIeLla2zjj/0yyyfuKagYHEHKvLvjG2EgGiQvgvmNki0uLynY26P5wgHb01cLM7md52rwqFD1lWbhTeSON42NfhlvK+LtqU2Zs/za2qlOpsX2G1QtM0NGtBqLur+m6M7hnSbCyj2853jE5ZwXLvJ3jAfkDWMFQ79s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282685; c=relaxed/simple;
	bh=9WtS/YPyZcIDa5n3PJ7FnUsOP0SAh5aqaFwBz6bxXyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZjkeSaLEYjR8Y0pZOw/fuJe0IAMKsuFsH0QYpy6pQId7jU/uoG5Dvp95vLFGTtXYjvEEqmRz/rn6PsvNXCRq8ZvmZYeufyYsNC0VtjnhupeRMsI8nZHo4AwvUs777aA5Nlp2ZEksrCeHbmtIy5F4Og+saxjNs93MnBxUSGsT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPJQYrQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPJQYrQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26865C2BC9E;
	Mon, 23 Mar 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282685;
	bh=9WtS/YPyZcIDa5n3PJ7FnUsOP0SAh5aqaFwBz6bxXyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPJQYrQDXCk22F4J2F07Ijq2+e6XkyOJQqkJL0kDMYWVgc/HgOIoWGhPccC5FyHHf
	 y7wyys8ySck8WfGBdtScBYa6TJ3QnukFfOAcZzuS+i4iljmGKTpcQ6o1rHqU12a7co
	 zPpUm5MPJsjnRBhewFT+3X9aNlCENrsnt7W9Rl0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 249/481] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Mon, 23 Mar 2026 14:43:51 +0100
Message-ID: <20260323134531.221278752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Alysa Liu <Alysa.Liu@amd.com>

commit 2c1030f2e84885cc58bffef6af67d5b9d2e7098f upstream.

Replace non-atomic vm->process_info assignment with cmpxchg()
to prevent race when parent/child processes sharing a drm_file
both try to acquire the same VM after fork().

Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c7c573275ec20db05be769288a3e3bb2250ec618)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1371,7 +1371,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*ef = dma_fence_get(&info->eviction_fence->base);
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.bo, true);
@@ -1409,6 +1412,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		/* Two fence references: one in info and one in *ef */
 		dma_fence_put(&info->eviction_fence->base);


