Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1246919E96D;
	Wed,  4 Feb 2026 15:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219300; cv=none; b=jAQjY1LyWsRHpouPSNiCeHUHF3WBCb9Q+t9DJBuQXVmlViI/ZGOIwGMoifUjGbP+/6DPH67csBxICJLxIc4pV+wM0C3jz4H52+mywmOfxyj9jbUlN6cvqNs++dwMv36jZSYBEe6njQ8NKGzBeCKyWl9OzPYd9XHOqsV1xj33wbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219300; c=relaxed/simple;
	bh=mxZm3vnoIfYHGNiz9DvVpeya+bPzMPrXV1fiP7uENz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ii+B1VJwjFJO+4AarRDpdN5GAxMTwCs1609R+hurr7ElDo/i/4tAXzD1yB3SzX/VZcS/pTc1FLiEfOdJkSswGJ/6D1b21j6NuoYhZLhzLJOeypBNrFdTYdsvZ0IgXwfZgdT9TKUbm1cJvmUe3amrK0EMQEfQffIp4bFyZ4G2Sy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhfSRH+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhfSRH+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3582AC4CEF7;
	Wed,  4 Feb 2026 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219299;
	bh=mxZm3vnoIfYHGNiz9DvVpeya+bPzMPrXV1fiP7uENz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhfSRH+U/BDbz9HW92XoFNATfxeqznTP+3hZsfyPD5pYmEuEJY6sOjFTQePrIY9uM
	 sJhZi5aB/WEfajuNlCo5Z4kmkzxw7IE9Cd3O/wRhyPe88dNMCDhg7wg2ImP/yGFFAk
	 fmF+aXQpruFVA2pbyMTh2V5OjN/H/o5hpYf+Dk24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Zhi Wang <wangzhi@stu.xidian.edu.cn>,
	David Francis <David.Francis@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.18 100/122] drm: Do not allow userspace to trigger kernel warnings in drm_gem_change_handle_ioctl()
Date: Wed,  4 Feb 2026 15:41:22 +0100
Message-ID: <20260204143855.446700182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 12f15d52d38ac53f7c70ea3d4b3d76afed04e064 upstream.

Since GEM bo handles are u32 in the uapi and the internal implementation
uses idr_alloc() which uses int ranges, passing a new handle larger than
INT_MAX trivially triggers a kernel warning:

idr_alloc():
...
	if (WARN_ON_ONCE(start < 0))
		return -EINVAL;
...

Fix it by rejecting new handles above INT_MAX and at the same time make
the end limit calculation more obvious by moving into int domain.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reported-by: Zhi Wang <wangzhi@stu.xidian.edu.cn>
Fixes: 53096728b891 ("drm: Add DRM prime interface to reassign GEM handle")
Cc: David Francis <David.Francis@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org> # v6.18+
Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260123141540.76540-1-tvrtko.ursulin@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -970,16 +970,21 @@ int drm_gem_change_handle_ioctl(struct d
 {
 	struct drm_gem_change_handle *args = data;
 	struct drm_gem_object *obj;
-	int ret;
+	int handle, ret;
 
 	if (!drm_core_check_feature(dev, DRIVER_GEM))
 		return -EOPNOTSUPP;
 
+	/* idr_alloc() limitation. */
+	if (args->new_handle > INT_MAX)
+		return -EINVAL;
+	handle = args->new_handle;
+
 	obj = drm_gem_object_lookup(file_priv, args->handle);
 	if (!obj)
 		return -ENOENT;
 
-	if (args->handle == args->new_handle) {
+	if (args->handle == handle) {
 		ret = 0;
 		goto out;
 	}
@@ -987,18 +992,19 @@ int drm_gem_change_handle_ioctl(struct d
 	mutex_lock(&file_priv->prime.lock);
 
 	spin_lock(&file_priv->table_lock);
-	ret = idr_alloc(&file_priv->object_idr, obj,
-		args->new_handle, args->new_handle + 1, GFP_NOWAIT);
+	ret = idr_alloc(&file_priv->object_idr, obj, handle, handle + 1,
+			GFP_NOWAIT);
 	spin_unlock(&file_priv->table_lock);
 
 	if (ret < 0)
 		goto out_unlock;
 
 	if (obj->dma_buf) {
-		ret = drm_prime_add_buf_handle(&file_priv->prime, obj->dma_buf, args->new_handle);
+		ret = drm_prime_add_buf_handle(&file_priv->prime, obj->dma_buf,
+					       handle);
 		if (ret < 0) {
 			spin_lock(&file_priv->table_lock);
-			idr_remove(&file_priv->object_idr, args->new_handle);
+			idr_remove(&file_priv->object_idr, handle);
 			spin_unlock(&file_priv->table_lock);
 			goto out_unlock;
 		}


