Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449811A4F1B;
	Wed, 20 Nov 2024 12:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107504; cv=none; b=aLzKZBwCX1ZgyrYSzsq6JOpy8p+9bGaNNM7xn7+su9YEyZFgzSpy7VKgBLtwf5zJpqn9pd7dvz2L1oYQygTBWRyC5+ELF2+fDjLsZH9Q0px1OFp0QsIuBfK5ctw2n5RGoB4hWuOyyeubJG+8eQLtGJrhrrLbarPf26GAKoQiHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107504; c=relaxed/simple;
	bh=7jbB/vRt/R3ZC28WjjdhEEpUkI8FOuzehrY5CJf9Yuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQgW9HNaoLDhM67jiLQUdpALBCbk7P10+86dnoRbLdKptQ4M9WR8LbQbpSSHG3YxfI+Vpmq341/VNEExqUk/sDjLmm1hHofxoK/ZAzE9RtGFIjUdBVHHhuEg8oYpy4iLWXJ4ucwatrRDPKnCFhurVxPBUcnXcZUaoFFbSBe1gvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+gb+HBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+gb+HBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C982BC4CED1;
	Wed, 20 Nov 2024 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107503;
	bh=7jbB/vRt/R3ZC28WjjdhEEpUkI8FOuzehrY5CJf9Yuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+gb+HBhjaldbCRPpTegsMXoJ5wxg4bSVZVYt8zhtkeqYf6bjDSuK8GqK50pXO5nl
	 EiInVN4eXUVM6qsMqu2kkByujK91yvpPe1p3NZ+eGKcHhI3JINIjJkMi6uJIRVe7wX
	 GbSHdtz76mSpk7viMLOSWR0LpmbcxaWs6ZDI/HzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 029/107] drm/vmwgfx: avoid null_ptr_deref in vmw_framebuffer_surface_create_handle
Date: Wed, 20 Nov 2024 13:56:04 +0100
Message-ID: <20241120125630.337289370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 93d1f41a82de382845af460bf03bcb17dcbf08c5 ]

The 'vmw_user_object_buffer' function may return NULL with incorrect
inputs. To avoid possible null pointer dereference, add a check whether
the 'bo' is NULL in the vmw_framebuffer_surface_create_handle.

Fixes: d6667f0ddf46 ("drm/vmwgfx: Fix handling of dumb buffers")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029083429.1185479-1-chenridong@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 63b8d7591253c..10d596cb4b402 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1265,6 +1265,8 @@ static int vmw_framebuffer_surface_create_handle(struct drm_framebuffer *fb,
 	struct vmw_framebuffer_surface *vfbs = vmw_framebuffer_to_vfbs(fb);
 	struct vmw_bo *bo = vmw_user_object_buffer(&vfbs->uo);
 
+	if (WARN_ON(!bo))
+		return -EINVAL;
 	return drm_gem_handle_create(file_priv, &bo->tbo.base, handle);
 }
 
-- 
2.43.0



