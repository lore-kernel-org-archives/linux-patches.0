Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2401C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD542C433D2;
	Mon, 20 Mar 2023 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326110;
	bh=F7dkdpTN4iR1V1ivf5qe5HbXs2eZ33zf6n9Nc9wlBAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=be2+na6OVZLreLk2fwFQ/GQkl899kw0w6VVTU5k4nnkRFEz3OZLt+Of8fm6wjN9sQ
	 DF4zfzhlkO8gWy6ctzwvWDYZeTPjbbzlxPKJuqUPmQa3O1oN0HdTsADhlA2kJvuKkb
	 f7xc8m7UPE/UTcGFwRz0V56r8xrclqyZ85i9AqSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Rob Clark <robdclark@gmail.com>
Subject: [PATCH 6.2 162/211] drm/shmem-helper: Remove another errant put in error path
Date: Mon, 20 Mar 2023 15:54:57 +0100
Message-Id: <20230320145520.232753889@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit ee9adb7a45516cfa536ca92253d7ae59d56db9e4 upstream.

drm_gem_shmem_mmap() doesn't own reference in error code path, resulting
in the dma-buf shmem GEM object getting prematurely freed leading to a
later use-after-free.

Fixes: f49a51bfdc8e ("drm/shme-helpers: Fix dma_buf_mmap forwarding bug")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230108211311.3950107-1-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -622,11 +622,14 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
 	int ret;
 
 	if (obj->import_attach) {
-		/* Drop the reference drm_gem_mmap_obj() acquired.*/
-		drm_gem_object_put(obj);
 		vma->vm_private_data = NULL;
+		ret = dma_buf_mmap(obj->dma_buf, vma, 0);
+
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		if (!ret)
+			drm_gem_object_put(obj);
 
-		return dma_buf_mmap(obj->dma_buf, vma, 0);
+		return ret;
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);


