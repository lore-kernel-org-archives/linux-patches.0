Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33DE3ACEED;
	Mon, 23 Mar 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275672; cv=none; b=NML59xFvyi8EwARn+Gze5AyA6N9jivUrG0e2YS7wwOPz7EOI8sCZxyjq6t5rvtx+JK/+GejhCTaTPouyyDY0azfk7ZEKrqDL5rdPbva+UIMSUqCOw9WsWi7eQ9n0eWTdJEtol0TgCWgLhDHgEZuo/M3OcY4Ozd7FARaPkTdn3C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275672; c=relaxed/simple;
	bh=27mXVwHPkVN2hK9C2RMWHzuo/mfiHXoCxsPymYSFL2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6sZSzkXkbPNHCwsLFfaD/j82jQtmUTfe5TawQ53uTc/GzTxMM74N5EYydP/o5rFRuPwUlcZhpnHLW6KOa4K1Jdad0Voa9wWqXcRyt5QMu+6msStNc/0zP0A6fhYRmFeqRr2M6VNPgZO1+fJy+eRX3jfBMHqCdelI7Rxh1S/C7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8chHati; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8chHati"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183ECC2BCB3;
	Mon, 23 Mar 2026 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275671;
	bh=27mXVwHPkVN2hK9C2RMWHzuo/mfiHXoCxsPymYSFL2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8chHati2Y9RBN84sQYbP6LIZuRu9o2qeBhWG+IBuvqgT/DKaA7ic5a1lFi8HJ5fI
	 FKBZQFobvhagkmwDeoGBNPM0ny5BMdNpLPsHkw+I95ToAL0JNS2eQmrVU8YYfEvv+m
	 cJyBiH6IRwSmHlIEYO8cx1IOUQ3V8SeuzVjagGvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 178/460] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Mon, 23 Mar 2026 14:42:54 +0100
Message-ID: <20260323134530.915448791@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -1403,7 +1403,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*process_info = info;
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.bo, true);
@@ -1443,6 +1446,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		dma_fence_put(&info->eviction_fence->base);
 		*process_info = NULL;


