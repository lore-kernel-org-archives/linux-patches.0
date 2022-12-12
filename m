Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EDC258F
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8211BC433D2;
	Mon, 12 Dec 2022 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851295;
	bh=Ftk3/WpxJNvCzWHViDu/KeNbdM63f5WgR0ZOIKIQnCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w34zgpFve539x8yFPRMMuXv+miGYdDGLf6O+qdXH1/dTAg91dibXORqvgxuB91a81
	 CqDkfUbxxzaHzfGE6ZebSoGaOOGr6NdftAmDfHW3zm8G7EUJL61xHVIjyE4vNri+Fh
	 98sFYidGAsyED6ivHhxUBjTBx/ChFNHAi7iHyrsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 5.4 28/67] drm/shmem-helper: Remove errant put in error path
Date: Mon, 12 Dec 2022 14:17:03 +0100
Message-Id: <20221212130918.977738072@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

commit 24013314be6ee4ee456114a671e9fa3461323de8 upstream.

drm_gem_shmem_mmap() doesn't own this reference, resulting in the GEM
object getting prematurely freed leading to a later use-after-free.

Link: https://syzkaller.appspot.com/bug?extid=c8ae65286134dd1b800d
Reported-by: syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com
Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130185748.357410-2-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -554,10 +554,8 @@ int drm_gem_shmem_mmap(struct file *filp
 	shmem = to_drm_gem_shmem_obj(vma->vm_private_data);
 
 	ret = drm_gem_shmem_get_pages(shmem);
-	if (ret) {
-		drm_gem_vm_close(vma);
+	if (ret)
 		return ret;
-	}
 
 	/* VM_PFNMAP was set by drm_gem_mmap() */
 	vma->vm_flags &= ~VM_PFNMAP;


