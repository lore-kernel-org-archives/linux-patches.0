Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE944FC355;
	Tue, 13 Oct 2026 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895908; cv=none; b=PMkAA7y14SnCv+ms+vH0uw3GAWK9e/EeWq5CqzZiHDrdXS9Z2DUcTUYLklm4iZTv6NBEO1NyRc+BkegLY1My2SI9YtWoMIPIbYLk9ZgCNiyDPHv2mGTEbgIyJ1UAsMudsHvhrecI/B8Y9izyjtMWG6VZF7lrlO5GXGRfzahObvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895908; c=relaxed/simple;
	bh=qMEorB8uWRI9M73iHlG2alt5KYiB4P+/nGitnl5h+5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4PkYqW1SxuNoFzvqbJk/J1YKRxoPhx0P+uiy3eBj61cddSAkUNvlU67V4op/clSH/hdMZVrD3OfbwpCFP3A25vhzLjBrP/WXwz06ppBWds3hnlVqlicqaAM/36/bn2vuWnOtLHP1eerF9R6DrhSAs6byhh2Z4t6O3SJYoP11Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8ToT9O+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8ToT9O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8AB1F000FF;
	Tue, 13 Oct 2026 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895907;
	bh=MLvOmzc+WSd+RhSO0cLVax3qDaL0GP8RtB3jaQAskgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8ToT9O+1xGsqW4U/ykIhISgeznwmBBCy4FXzgnTfNwWV5pqAMMZd4rKmLR7/l4/p
	 u2pSHIwWptnZWyMbU56dhTCXR1wJmFT0994zUt5bKGG/N82KPhu2Z4iRcZqs530r/w
	 eRQxVbzZvIoMlCUol9H/O2viebjdpsIAC0uwH3rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 433/497] drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info
Date: Tue, 13 Oct 2026 13:40:00 +0200
Message-ID: <20261013112918.164160889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -540,14 +540,18 @@ int amdgpu_amdkfd_get_dmabuf_info(struct
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


