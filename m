Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C27533CCA;
	Fri, 24 Nov 2023 18:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDM8QDX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9F1C433C8;
	Fri, 24 Nov 2023 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851650;
	bh=JrQKXhM2tIwy6juNohMm5CTVxU74Jxmu+IFD+KO+Dh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDM8QDX2AQUb5s46qu9sY9nEOnZkBr8uLh9uQ/71Zr6Fg+8GulDrGpvQeYkYeJU0r
	 NIG6g2neYyQ8X+T+a46VZzgfimLHv+197xjK/qaxJaQsJc9dHGpA/Qv9BtVLu8zgfx
	 F1ePsfYGuUquGFeIWkLHgtioE0ehRa0LwGHjoDmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Airlie <airlied@redhat.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Zack Rusin <zackr@vmware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/372] drm: vmwgfx_surface.c: copy user-array safely
Date: Fri, 24 Nov 2023 17:47:08 +0000
Message-ID: <20231124172011.852083224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 06ab64a0d836ac430c5f94669710a78aa43942cb ]

Currently, there is no overflow-check with memdup_user().

Use the new function memdup_array_user() instead of memdup_user() for
duplicating the user-space array safely.

Suggested-by: David Airlie <airlied@redhat.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230920123612.16914-7-pstanner@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 591c301e6cf21..1a1a286bc749f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -774,9 +774,9 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 	       sizeof(metadata->mip_levels));
 	metadata->num_sizes = num_sizes;
 	metadata->sizes =
-		memdup_user((struct drm_vmw_size __user *)(unsigned long)
+		memdup_array_user((struct drm_vmw_size __user *)(unsigned long)
 			    req->size_addr,
-			    sizeof(*metadata->sizes) * metadata->num_sizes);
+			    metadata->num_sizes, sizeof(*metadata->sizes));
 	if (IS_ERR(metadata->sizes)) {
 		ret = PTR_ERR(metadata->sizes);
 		goto out_no_sizes;
-- 
2.42.0



