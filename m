Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5EF3F54D3;
	Tue, 17 Mar 2026 16:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766316; cv=none; b=NxfYbbAWT+rFq+LNSLr5+Rcg8NOGPUj0XEKpnd+RJNoQby01VDXZPk5UzJuQT3hZtuGPYQSE0zi6vTy9maHh73X4hjmDTTeN0I8o9wUETFKul5TZZ4w0CYgOjooaT9nYg+pSK54blpAi4Nl7BBPIhPgc/xZLbB1fAktHrsCw91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766316; c=relaxed/simple;
	bh=E7YXiycfcXGJ2RvcT4utxSwp4JRqv3bUsHrqdpEZTB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDEKCK36XMoEDs3kKwOMCv24gomh5K5qKR+V7CJpQNnSCunR973u9q8ZVHIWm4Y4kXAJOjzusPj2vJkYV13SigKlw1CnpFv2jpBACc30a3X5+8wzLlsQacJHMh5b9lM8+YtUKVYCT5CjeONEIhqydaX6r1zcAmj/PaE4t1lm48w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8K8dGIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8K8dGIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7459C2BC86;
	Tue, 17 Mar 2026 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766316;
	bh=E7YXiycfcXGJ2RvcT4utxSwp4JRqv3bUsHrqdpEZTB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8K8dGIJTHobIS2Ckq7xKsO7+6S/ne0wYXqlVxGrnpF2cSvuLMBbFX9AzQxA/1U1d
	 KcTP9prWbJ9tYHOlUAzsdnTPTpCwcZmtr8A7wAxr3rYRUpvt01JoY+32DqrQ90Prpv
	 zHi72VQqDYOG6nKzxNoLGUOXNsl70GYNkgiepjw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 217/378] drm/amdgpu: add upper bound check on user inputs in signal ioctl
Date: Tue, 17 Mar 2026 17:32:54 +0100
Message-ID: <20260317163014.994864704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit ea78f8c68f4f6211c557df49174c54d167821962 upstream.

Huge input values in amdgpu_userq_signal_ioctl can lead to a OOM and
could be exploited.

So check these input value against AMDGPU_USERQ_MAX_HANDLES
which is big enough value for genuine use cases and could
potentially avoid OOM.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit be267e15f99bc97cbe202cd556717797cdcf79a5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -35,6 +35,8 @@
 static const struct dma_fence_ops amdgpu_userq_fence_ops;
 static struct kmem_cache *amdgpu_userq_fence_slab;
 
+#define AMDGPU_USERQ_MAX_HANDLES	(1U << 16)
+
 int amdgpu_userq_fence_slab_init(void)
 {
 	amdgpu_userq_fence_slab = kmem_cache_create("amdgpu_userq_fence",
@@ -476,6 +478,11 @@ int amdgpu_userq_signal_ioctl(struct drm
 	if (!amdgpu_userq_enabled(dev))
 		return -ENOTSUPP;
 
+	if (args->num_syncobj_handles > AMDGPU_USERQ_MAX_HANDLES ||
+	    args->num_bo_write_handles > AMDGPU_USERQ_MAX_HANDLES ||
+	    args->num_bo_read_handles > AMDGPU_USERQ_MAX_HANDLES)
+		return -EINVAL;
+
 	num_syncobj_handles = args->num_syncobj_handles;
 	syncobj_handles = memdup_user(u64_to_user_ptr(args->syncobj_handles),
 				      size_mul(sizeof(u32), num_syncobj_handles));


