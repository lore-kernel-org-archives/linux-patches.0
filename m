Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A934336CDFD;
	Fri, 15 May 2026 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862131; cv=none; b=H9v0Jqd83ko8XGBEjaLiDcit1N2wV/kWlfMH/Ct4t4K0Dw+IbOi7e3et/QUmqVqssTkwmDo52CVIAB4VMDlCUGgQMepRbLVnop7mTvuYsOGDJQ9V4x1wm48miElghJmnYEuLHqETY+cYsg2nCB5GSl2LtMF4PHyic9J8aJ+tuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862131; c=relaxed/simple;
	bh=sAv8A67sGUXhuVjorm+m0j7b4usgzAd0lkP9v1QcjG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rppq15lZQEje21Kytu9/smgxRJvckAmrjiNrpL2Jt1hq9AxiSPvC11yJKH9gRETv2iP6jNlEeYilQX6GDe8soNPNbpF8WFrQlk+9S5XqLSQIZ/vJypFKWf9t0HVK069wvYw6/EXqvrNUSvVIwprwaJVUB/x2u278scas/beAb5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkMwutn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkMwutn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCE0C2BCB0;
	Fri, 15 May 2026 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862131;
	bh=sAv8A67sGUXhuVjorm+m0j7b4usgzAd0lkP9v1QcjG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkMwutn/0/MQphItrg9Bfk1ms9wVO43knBW5nNgwRhyj1PeOuPdO3gResnHGFSlpn
	 WnqiCcyB2nfzyUYd+lNIzqn3Kr2TYZp9ETRzGKKbq3nI0kOltkPYFTW3+UvImGRB6p
	 ubnSLCIePqrTE0t9v2UMKD2fmsGXVb2MPKGXqeDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Puttimet Thammasaeng <pwn8official@gmail.com>,
	Vitaly Prosyak <Vitaly.Prosyak@amd.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christian Koenig <Christian.Koenig@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Dave Airlie <airlied@gmail.com>
Subject: [PATCH 6.18 121/188] drm: Set old handle to NULL before prime swap in change_handle
Date: Fri, 15 May 2026 17:48:58 +0200
Message-ID: <20260515154659.955129627@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Francis, David <David.Francis@amd.com>

commit 5e28b7b94408897e41c63477aabc9e1db439bc8c upstream.

There was a potential race condition in change_handle. The ioctl
briefly had a single object with two idr entries; a concurrent
gem_close could delete the object and remove one of the handles
while leaving the other one dangling, which could subsequently
be dereferenced for a use-after-free.

To fix this, do the same dance that gem_close itself does.
(f6cd7daecff5 drm: Release driver references to handle before making it available again)
First idr_replace the old handle to NULL. Later, if the prime
operations are successful, actually close it.

create_tail required a similar dance to avoid a similar problem.
(bd46cece51a3 drm/gem: Fix race in drm_gem_handle_create_tail())
It idr_allocs the new handle with NULL, then swaps in the correct
object later to avoid races. We don't need to do that here, since
the only operations that could race are drm_prime, and
change_handle holds the prime lock for the entire duration.

v2: cleanups of error paths

Signed-off-by: David Francis <David.Francis@amd.com>
Co-authored-by: Dave Airlie <airlied@gmail.com>
Reported-by: Puttimet Thammasaeng <pwn8official@gmail.com>
Tested-by: Vitaly Prosyak <Vitaly.Prosyak@amd.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: stable@vger.kernel.org
Cc: Christian Koenig <Christian.Koenig@amd.com>
Fixes: 53096728b8910 ("drm: Add DRM prime interface to reassign GEM handle")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -969,7 +969,7 @@ int drm_gem_change_handle_ioctl(struct d
 				struct drm_file *file_priv)
 {
 	struct drm_gem_change_handle *args = data;
-	struct drm_gem_object *obj;
+	struct drm_gem_object *obj, *idrobj;
 	int handle, ret;
 
 	if (!drm_core_check_feature(dev, DRIVER_GEM))
@@ -992,8 +992,29 @@ int drm_gem_change_handle_ioctl(struct d
 	mutex_lock(&file_priv->prime.lock);
 
 	spin_lock(&file_priv->table_lock);
+
+       /* When create_tail allocs an obj idr, it needs to first alloc as NULL,
+	* then later replace with the correct object. This is not necessary
+	* here, because the only operations that could race are drm_prime
+	* bookkeeping, and we hold the prime lock.
+	*/
 	ret = idr_alloc(&file_priv->object_idr, obj, handle, handle + 1,
 			GFP_NOWAIT);
+
+       if (ret < 0) {
+	       spin_unlock(&file_priv->table_lock);
+	       goto out_unlock;
+       }
+
+       idrobj = idr_replace(&file_priv->object_idr, NULL, handle);
+       if (idrobj != obj) {
+	       idr_replace(&file_priv->object_idr, idrobj, handle);
+	       idr_remove(&file_priv->object_idr, args->new_handle);
+	       spin_unlock(&file_priv->table_lock);
+	       ret = -ENOENT;
+	       goto out_unlock;
+       }
+
 	spin_unlock(&file_priv->table_lock);
 
 	if (ret < 0)
@@ -1005,6 +1026,8 @@ int drm_gem_change_handle_ioctl(struct d
 		if (ret < 0) {
 			spin_lock(&file_priv->table_lock);
 			idr_remove(&file_priv->object_idr, handle);
+			idrobj = idr_replace(&file_priv->object_idr, obj, handle);
+			WARN_ON(idrobj != NULL);
 			spin_unlock(&file_priv->table_lock);
 			goto out_unlock;
 		}


