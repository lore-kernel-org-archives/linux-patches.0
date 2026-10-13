Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CFC3E639D;
	Tue, 13 Oct 2026 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893122; cv=none; b=UzCu/DMIcDnz3fjZbgAQ+z7RQYottdM6zodjmxQTUAmug0OOFp3xjGKn70mZUbvJm9rtC7joKtBnc6kqJCFCUyprUVZKM0jihhlaJKO8adh2NiOg/70wn3rD6055xhDn2MqDcPtHYvUFZ2OXp8+RrghRVlI/4Xhy+IcD2UTAb4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893122; c=relaxed/simple;
	bh=slzNTEkiWyplH5EtrskIIP7DW+U6qpWTZyQ7vGCOiOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As6Mv/jwUeqqEjnVPwKtvsEqk/6KVQnJQ2dpbiaOE17iVXL71Y7prCIcsRXI1AgfJ1Lgm8T6cJaNMMY20Sz/s82cgxIB09yTDzfiMzPRXCgaRHUNXC/Wjb70E7m17jBEPkv/WDh6Wdl7yoJHAJ8uYYIuJLsCpKkNDWoWTLQl1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AK+DtA0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AK+DtA0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A7E1F000FF;
	Tue, 13 Oct 2026 12:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893121;
	bh=DYmfqrsfT7JNtmFfqq3oq1q8ZQzvb0jqBXFQkAqnz9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AK+DtA0SsKtdSwV791tDFyUEwsaaEPyxdv3N6o7iDcLMxpLXNsZ6Nxesgx8i0g1NI
	 5BBXxCj5qB7T1T/RzWv8LRo39UvjZwB6sO+1L0jlfQWDHd5af72/9wOEAbaFe5DoVP
	 7nwCjFLpkgMkHqu9ZqoUi3l9lIN0flazWfsg2hm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 121/621] drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info
Date: Tue, 13 Oct 2026 13:31:56 +0200
Message-ID: <20261013112923.730723864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojie Li <lihaojie@kylinos.cn>

commit e6895021a328594368a2a19406a53ffca1ce51c7 upstream.

When kzalloc fails for metadata_buffer in
amdgpu_amdkfd_get_dmabuf_info(), the function returns -ENOMEM directly
without calling dma_buf_put(), leaking the dma_buf reference obtained
earlier via dma_buf_get().

Fix both issues by:
- Adding an error check after the first amdgpu_bo_get_metadata() call
- Replacing the direct return with r = -ENOMEM and goto out_put to
  ensure dma_buf_put() is called on all error paths

Fixes: f54ce9e8cbd3 ("drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl")
Signed-off-by: Haojie Li <lihaojie@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ffa699553332f8caf8688d312279ddcea9e3c141)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -567,14 +567,18 @@ int amdgpu_amdkfd_get_dmabuf_info(struct
 		/* first get metadata_size by buffer = NULL */
 		r = amdgpu_bo_get_metadata(bo, NULL, 0,
 					   metadata_size, NULL);
+		if (r)
+			goto out_put;
 
 		/* user buf_size is bigger than bo metadata_size
 		 * allocate a buf at kernel space and copy */
 		if (*metadata_size <= buffer_size) {
 			*metadata_buffer = kzalloc(*metadata_size, GFP_KERNEL);
 
-			if (!*metadata_buffer)
-				return -ENOMEM;
+			if (!*metadata_buffer) {
+				r = -ENOMEM;
+				goto out_put;
+			}
 
 			r = amdgpu_bo_get_metadata(bo, *metadata_buffer, *metadata_size,
 						   NULL, &metadata_flags);


