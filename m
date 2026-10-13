Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935234EBAEC;
	Tue, 13 Oct 2026 11:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892790; cv=none; b=Z3I4KPpVdRlZqwKui6eEfxn5Ecfe/qo+Mm9/nsEx40I61mo3LsAsn8KHzYxRyv7BrE1k3Metv92MRT2gTKSKmkztER2BZXLEu35lnbVxj3g326rVmmcCI5+wQKfCz5QChQu5doquiv8EUnfWOmdRaEWovee61Ezy+vs5IdIdbnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892790; c=relaxed/simple;
	bh=FscoxWNEpAMvs7ytcivWQOk9nKVsnDH8dNs1LZ3YTZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiuKHuv7/5dhtIeuWlb/xTTjAm0Qi8ZAn17iPsyakVRwn6K8TRRbE279hr+Aq9xBl5MFvPxq+F0zBnpE7LWr9vPxdA+/HWCp28zNEdqOIiKxorJIuP6wVKyPfg4dNiyn0J9aBNBWXYnd+DoXIh7v0H/wjjg2u4KGVn9QBfQgbeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT83gybE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT83gybE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59361F000FF;
	Tue, 13 Oct 2026 11:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892789;
	bh=+HCe0HWo9bwe05/KkcqzHgt759oMNWSbFDad9hJdG40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gT83gybEuosrPZQwSqHfbqcnmmvwdDSKzou68TuvUBErXYfp4sfzN5iJ79zXZeojO
	 SbzC9o/8CFpwYQ08jrJndJMtATzOwqGhFn9HkYtWEaIiuKrAEoyWPu1PGua1gg9CLr
	 h2Db4HKPe78FACI/xHhkjb3+PFF0ukxF109k1zKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Crystal <0xiviel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/621] accel/amdxdna: Bound the sync_bo flush range to the BO size
Date: Tue, 13 Oct 2026 13:30:05 +0200
Message-ID: <20261013112921.108071670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Eva Crystal <0xiviel@gmail.com>

[ Upstream commit dbc8fd7a03cbc0704e8e558a448015f620547a02 ]

amdxdna_drm_sync_bo_ioctl() passes the caller's offset and size to
drm_clflush_virt_range() on the BO's kernel mapping without checking
either against the BO size. The ioctl has no permission flags: any
process that can open the accel node controls the offset. Any BO with a
kernel mapping reaches that call: AMDXDNA_BO_DEV_HEAP, AMDXDNA_BO_DEV
and AMDXDNA_BO_CMD. A DEV_HEAP is vmapped, so an offset equal to its
size lands the flush on the vmap guard page.

Measured on 6.18.55 on an AMD Ryzen AI 9 365 NPU, firmware 1.0.0.63,
as a non-root user with access to the accel node: unpatched, an offset
equal to the 64 MiB DEV_HEAP size oopses in drm_clflush_virt_range()
under amdxdna_drm_sync_bo_ioctl(), 2 of 2 runs; patched, the same call
returns -EINVAL, 2 of 2, and an in-bounds sync returns 0, 2 of 2.
DEV_HEAP is the type tested; DEV and CMD are by code reading.

Upstream bounds the range in amdxdna_flush_bo(), added by commit
dbc8fd7a03cb ("accel/amdxdna: Add expandable device heap support").
This applies only that check: an offset at or past the BO's end, or
an overflowing offset plus size, returns -EINVAL.

Deviations from upstream: that commit adds a feature and is too large
for stable as a whole. It calls drm_WARN() when the check rejects a BO
whose type is not AMDXDNA_BO_DEV, which userspace can trigger; this
fix does not. Upstream bounds AMDXDNA_BO_DEV by the heap chunks it
spans and flushes only the overlap, reporting no error for an offset
past the end; 6.18 has one heap per client, so this fix uses the BO's
own abo->mem.size and rejects such an offset instead. As in upstream,
a size past the BO's end is clamped, not rejected.

Built from v6.18.55 with the test system's distro-derived config,
DRM_ACCEL_AMDXDNA=m. The touched file also compiles W=1 clean.

Fixes: e252e3f3488a ("accel/amdxdna: Revise device bo creation and free")
Cc: stable@vger.kernel.org # 6.18.x
Assisted-by: LLM
Signed-off-by: Eva Crystal <0xiviel@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index ca747457cec79..95d04af2b9933 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -934,6 +934,7 @@ int amdxdna_drm_sync_bo_ioctl(struct drm_device *dev,
 	struct amdxdna_drm_sync_bo *args = data;
 	struct amdxdna_gem_obj *abo;
 	struct drm_gem_object *gobj;
+	u64 end, size;
 	int ret;
 
 	gobj = drm_gem_object_lookup(filp, args->handle);
@@ -943,6 +944,13 @@ int amdxdna_drm_sync_bo_ioctl(struct drm_device *dev,
 	}
 	abo = to_xdna_obj(gobj);
 
+	if (args->offset >= abo->mem.size ||
+	    check_add_overflow(args->offset, args->size, &end)) {
+		ret = -EINVAL;
+		goto put_obj;
+	}
+	size = min(abo->mem.size, end) - args->offset;
+
 	ret = amdxdna_gem_pin(abo);
 	if (ret) {
 		XDNA_ERR(xdna, "Pin BO %d failed, ret %d", args->handle, ret);
@@ -955,7 +963,7 @@ int amdxdna_drm_sync_bo_ioctl(struct drm_device *dev,
 	if (is_import_bo(abo))
 		drm_clflush_sg(abo->base.sgt);
 	else if (abo->mem.kva)
-		drm_clflush_virt_range(abo->mem.kva + args->offset, args->size);
+		drm_clflush_virt_range(abo->mem.kva + args->offset, size);
 	else if (abo->base.pages)
 		drm_clflush_pages(abo->base.pages, gobj->size >> PAGE_SHIFT);
 	else
-- 
2.53.0



