Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B5728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E53C433D2;
	Mon, 12 Dec 2022 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850987;
	bh=HectFpQ8xBc7RfTKgvAc8T8UmPelmg8aiFD//zm2JtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReLv5+D1CXuo85MMjrMfeyGp/U6jrHfOBHi2b6kePxK6DGvUfNrrx9ogOeCH+BB+H
	 nCjtrQLnBSWA5oIeAmYhtvLoyKZnGDcnmAfItLGoslaqzhJssaTmP3Hc+UzZ/2npBc
	 HBiMgAOrAqBxDHU8SqRHvIfbjuiDYsptZ+iluDJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 5.10 055/106] drm/shmem-helper: Avoid vm_open error paths
Date: Mon, 12 Dec 2022 14:09:58 +0100
Message-Id: <20221212130927.271184688@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

commit 09bf649a74573cb596e211418a4f8008f265c5a9 upstream.

vm_open() is not allowed to fail.  Fortunately we are guaranteed that
the pages are already pinned, thanks to the initial mmap which is now
being cloned into a forked process, and only need to increment the
refcnt.  So just increment it directly.  Previously if a signal was
delivered at the wrong time to the forking process, the
mutex_lock_interruptible() could fail resulting in the pages_use_count
not being incremented.

Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130185748.357410-3-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -563,12 +563,20 @@ static void drm_gem_shmem_vm_open(struct
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	int ret;
 
 	WARN_ON(shmem->base.import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
-	WARN_ON_ONCE(ret != 0);
+	mutex_lock(&shmem->pages_lock);
+
+	/*
+	 * We should have already pinned the pages when the buffer was first
+	 * mmap'd, vm_open() just grabs an additional reference for the new
+	 * mm the vma is getting copied into (ie. on fork()).
+	 */
+	if (!WARN_ON_ONCE(!shmem->pages_use_count))
+		shmem->pages_use_count++;
+
+	mutex_unlock(&shmem->pages_lock);
 
 	drm_gem_vm_open(vma);
 }


