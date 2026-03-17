Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A4232548B;
	Tue, 17 Mar 2026 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767893; cv=none; b=SGYYoF653YPxt49DCr9eUIIpS69fHZVbPNxeCRvB58cPmNDyrrTcfHJZ9MTJ3UWxPzPW5GaM3tQGmT7Azw+1/6Qo3nupyJ0b+jkNVp50i7oPE9ojsRLURxG/TfhF5blprgAuEAgNTz9P4hMrlZ7uX3PQAjwnqcVCW63wJpHgTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767893; c=relaxed/simple;
	bh=XLm0M0ox9WV+Lk2psGKYS3PH07zPFXt9D2fXEy6qmxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrarggDszHmuMpZIC2V9YLivjokKtb0t+CcVCxv9YhXhE09/umIwP8YKFlGgJuVJSHgbyRF8NycBYPlXWsJeivpanE70YgcUXQHYThIBPiof+x+ogwQ+tRVJ72bIvSuu+TcWVIuYhQ3GhlkYlPZU6ybSbSKKFX946CCYj5ylTrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEGklCj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEGklCj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CE5C4CEF7;
	Tue, 17 Mar 2026 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767893;
	bh=XLm0M0ox9WV+Lk2psGKYS3PH07zPFXt9D2fXEy6qmxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEGklCj5kZxiM7UZBzM5bdX02itHhEEGJd62P4x2KN/4k4CfgsiOjc5qayM9mWftS
	 FtMPiSpbY7SiFXxMc+uMaPHc7GUm8fzwC71G6sA4MkcbgSMjFn1xyeLliyVhs9YBMr
	 PDTdR++pwjNwkGKU3BNip0RVYr9T77nDP24Pq8G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 183/333] drm/amdgpu: add upper bound check on user inputs in signal ioctl
Date: Tue, 17 Mar 2026 17:33:32 +0100
Message-ID: <20260317163006.142052606@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -475,6 +477,11 @@ int amdgpu_userq_signal_ioctl(struct drm
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


