Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A1046A603;
	Tue, 21 Jul 2026 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654870; cv=none; b=vCuFiXywG/UjbfLhNAgSZpJC6eQTb0ryulGu+w+7flVqq5jMXVT7REhP+HRKaxmTDWPxDCkvNGJ7BfnmrnqE5KKMzKjC/600RxLUywmTiBB57L5nVasiEn7Y6EebZSFIv/wP3KZUoujHJwLpXEEneqBkets/3FykS4CkxIagzL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654870; c=relaxed/simple;
	bh=foPbdxKT44Ks2oMRZ/dBVmwUnnJY4yZB4upPKV8a9qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ho3iyGQL/kg0iAQsYZcngXSzIavYDn6rJcBZ64uzsee4l3SaABUl/6OFGbdOMtgTHOSIl38O2zSx4i4eN4iB9o2B3s52aOzKjJWhjXToe9cnGjI0ZKUwMph4jbu4h8lD03BXoGQbxPRxJWJh8PqFu2Z+gDVB9ZgOULE6aNfjedU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+FjvkTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+FjvkTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DB71F00A3A;
	Tue, 21 Jul 2026 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654868;
	bh=l90Js79NjQgo9ft0+JelRSvpz/rhbSU/uLDTThO3Vf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+FjvkTzMBPyvZwz2g24KdZ2mm+eRW3a3fQhVIR5sxu3QikGGy3XLQzdxr9NxJEH6
	 C0gvgoyLQ9IzyxusD/36hYvItLL/OBF22jilXyF+3tDpjezzkXQ+UVs4rbCoeydDMh
	 Y+RmLnTpMu0yvIJLcoxsEKmvLfn0/gwCXRAup5aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.1 1868/2077] accel/amdxdna: Use caller client for debug BO sync
Date: Tue, 21 Jul 2026 17:25:41 +0200
Message-ID: <20260721152636.791211647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit 7caf2a2351d4053075670ff3e26a6815da0a9e1e upstream.

amdxdna_drm_sync_bo_ioctl() looks up args->handle in the ioctl caller's
drm_file. For SYNC_DIRECT_FROM_DEVICE, it then calls
amdxdna_hwctx_sync_debug_bo(), but passes abo->client.

amdxdna_hwctx_sync_debug_bo() uses the passed client both as the handle
namespace for debug_bo_hdl and as the owner of the hardware context xarray.
Those must match the file that supplied args->handle. The BO's stored
client pointer is object state, not the ioctl context.

Pass filp->driver_priv instead, matching the original handle lookup.

Fixes: 7ea046838021 ("accel/amdxdna: Support firmware debug buffer")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/178155468039.81818.12173237984867749651@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -1039,6 +1039,7 @@ int amdxdna_drm_get_bo_info_ioctl(struct
 int amdxdna_drm_sync_bo_ioctl(struct drm_device *dev,
 			      void *data, struct drm_file *filp)
 {
+	struct amdxdna_client *client = filp->driver_priv;
 	struct amdxdna_dev *xdna = to_xdna_dev(dev);
 	struct amdxdna_drm_sync_bo *args = data;
 	struct amdxdna_gem_obj *abo;
@@ -1073,7 +1074,7 @@ int amdxdna_drm_sync_bo_ioctl(struct drm
 		 args->handle, args->offset, args->size);
 
 	if (args->direction == SYNC_DIRECT_FROM_DEVICE)
-		ret = amdxdna_hwctx_sync_debug_bo(abo->client, args->handle);
+		ret = amdxdna_hwctx_sync_debug_bo(client, args->handle);
 
 put_obj:
 	drm_gem_object_put(gobj);


