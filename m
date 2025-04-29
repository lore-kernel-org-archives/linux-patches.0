Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2A938FB0;
	Tue, 29 Apr 2025 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949513; cv=none; b=uZK3GZVfJPGt8dfuSWlybYfgKyMFJ4EhGpjN6QHUhESTnKOy9OnkbOdt+3iFaY6Jv8G8MelSy/QdBXxOnX2qZJsIR76spLqZIUkhwM5YLJ6Su3yYSdlNK3EMs9LMaBuXnZg7DIv87PqB8+UDSGubgJfY/c20Kt8D1GZHLo7Wszo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949513; c=relaxed/simple;
	bh=9IKS9le3tDWV1h3w88mSJAD9oMVSdgCA6arRyEHiFW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IluIVyg9Wgpl2+CctUNty1iBn0seV07Yn5u4Snc49rKdsIi6I4hriDQ3Q4PC9gs9x1S/0EELbtxwB/TirlI7WOx/VpOzy8W9juRgA3hmy0LgMv0d1eR9sdx/bOovVR7ePj4SJ041+wvkCuSez+rneWiY90adLJcVXpsApzS3p2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQC3RQ31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQC3RQ31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707A1C4CEE3;
	Tue, 29 Apr 2025 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949512;
	bh=9IKS9le3tDWV1h3w88mSJAD9oMVSdgCA6arRyEHiFW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQC3RQ31TRgUiSWLaH8+R3EkUj0sXQ6ifd5Un3P0M3CsksXW78zCa8Ci7I4cdLXhJ
	 qBT4Q2wD2RCOkNaNUEF6wANYF4OPLz4mSKh6SUhSwVqokTgb1bVMk73Zy0hOVE19+X
	 DoeIwY9RHcuJFfccvGDgqurIqQxKWHk9IltyxL9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/373] udmabuf: fix a buf size overflow issue during udmabuf creation
Date: Tue, 29 Apr 2025 18:43:38 +0200
Message-ID: <20250429161137.167448901@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 021ba7f1babd029e714d13a6bf2571b08af96d0f ]

by casting size_limit_mb to u64  when calculate pglimit.

Signed-off-by: Xiaogang Chen<Xiaogang.Chen@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250321164126.329638-1-xiaogang.chen@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index a8094d57d2d06..84f7611c765b9 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -186,7 +186,7 @@ static long udmabuf_create(struct miscdevice *device,
 	if (!ubuf)
 		return -ENOMEM;
 
-	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
+	pglimit = ((u64)size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
 			goto err;
-- 
2.39.5



