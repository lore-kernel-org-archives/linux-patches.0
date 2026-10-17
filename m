Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A834A3CB91E;
	Sat, 17 Oct 2026 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257451; cv=none; b=r6YQtCssw3CqsRxZNjjUFCejylHpKt/MKMeRNpgM5bLDAqW1ah98ZJ98Jyp6x9TjCQpiGCTka/pOyNFA7Nmfbvop7gs4WM1JjZNlAu2pc7otGIyWaL9/4PItXAUq64Fu7W2uzfJm90J3SsqHhlfHCOaKloq+L8uVuiTpIFA6UBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257451; c=relaxed/simple;
	bh=5BDM7YUy+loZdOVrMP+Kb+CEigZikrw3nJI6C6lcMSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfwxWggrQ2Ox1eWhLb8RvwAfRUT9MQz0eW4s560JiN8aRWumy+KxMjSweYHdOyyH9yu7enQkvsmTsMTDdeqWAMsldCuOYVoE++pytSlY4qYUenNBK7j61FxXGTpxXVqOJf3hDfT6GGbJI67zKi2GuGOykbaSD57LTNsN7x11Xtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAG2Pl+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAG2Pl+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B0B1F000C5;
	Sat, 17 Oct 2026 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257450;
	bh=zj7eH8GfsfecUDJW0dj9qlUliO7iy4Da/HH47TW46hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAG2Pl+USAndTB7V++ylEOB2upvYd0MmQPze6L74Lx3WJMkYsKEB1BbCLSKZYLva9
	 COmqtBRSvmMnhQ2UjkvtIRbxMSiibbQChIpTgEynrzExThlc3vDIIfhhUKmgpjBuEr
	 c6Sll1FYILgtdknywjIEnPA3Ezz8E3cZv3WHr43Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0526/1674] drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info
Date: Sat, 17 Oct 2026 17:46:38 +0200
Message-ID: <20261017160444.610138777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -508,14 +508,18 @@ int amdgpu_amdkfd_get_dmabuf_info(struct
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


