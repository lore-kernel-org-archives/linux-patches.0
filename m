Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7F6314D26;
	Mon, 13 Apr 2026 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098871; cv=none; b=qe1La3Oo1u3YyskvhszLqPgRotFfclYIx2Dstc8Q9MqspSBbvyEtLaAoNbO4VSUG32iX1j+6llGIvCwBO/UGrA287jknBtYFrYNHX2z+TbgMXOat9fCd0v5JxwEusR2LjPfgsapMQNR1us9LqDhmfIeqYh9RMpdeQj04588Q9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098871; c=relaxed/simple;
	bh=9xdBdicqwp5ZB5uZ2KkzHAkhjf87jrsFISIX6V8UCVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0rfBo9t/aKvb3eDvS8+mLKwjLY38ISM787DUb0Dw0bWOCkDLskrYisCq5JZSaPwyvQrWljjOgfycm29XelodXLIT1stIAZiyRHTyd9m2oxZZhx4tUX+FhaxxaJGAKHepC1GKVrU/nrZKM+U64+/ZaSwnkwalVNEsQxTa0VOvgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk7HcX5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk7HcX5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AF8C2BCAF;
	Mon, 13 Apr 2026 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098871;
	bh=9xdBdicqwp5ZB5uZ2KkzHAkhjf87jrsFISIX6V8UCVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tk7HcX5pFTl12y3cxXM0U1NXBg+cBo554haSdku5LfCGkexgxJwPfek1Kuvy1vKP9
	 VNye/PqsRd+FyLrM03ILfT1UNWljaZ59W6N7KRTYZpIigiUp1Qy0dZcXctGkyfacXg
	 HHjvbAqe1uY/OSRxefnG9ROW1PjssELUYaiMpsMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 122/491] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Mon, 13 Apr 2026 17:56:07 +0200
Message-ID: <20260413155823.608892695@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -932,7 +932,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*ef = dma_fence_get(&info->eviction_fence->base);
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.base.bo, true);
@@ -969,6 +972,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.base.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		/* Two fence references: one in info and one in *ef */
 		dma_fence_put(&info->eviction_fence->base);


