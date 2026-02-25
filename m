Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E123530F526;
	Wed, 25 Feb 2026 06:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002793; cv=none; b=PtSyyaKFhdAF0RqisRJsHz/xbOdtclutPmnWK6kbZbuZNIO+1oxkhqx4zi7W9ZDdCWaeB2UviXh04ep9BHt2TIPFerBuGQh/eNCAMaHoMKNLz6sqh3r9N4kPg8Rfc+08Z/MpWrdpJIsiKU58qXHQ4fCv5U69UMejwYMf2g3ZVQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002793; c=relaxed/simple;
	bh=wflWR4ZUMU7z1iRzp1QX147YKJOUpSprFZiOCHql3ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4vtaJjiy3QJfdpIGa3bQVoL4q2XljIkeFIGcayTCO7QaIaAK8bEV/qoNcqBAKlJ45dNdVK6DiKD/TtHNBXWKIIScQfMwgVMLk1S5D5YbetrjomY0SLrIIBj68i98SO5hGH64qFHWtAkHYUvswhep1FuXhf0eFLgvvN2s+Lxz78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMMc2fLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMMc2fLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D94C116D0;
	Wed, 25 Feb 2026 06:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002792;
	bh=wflWR4ZUMU7z1iRzp1QX147YKJOUpSprFZiOCHql3ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMMc2fLwsLXTyNCwpm/mDp050PiK7RhJANAwiX4hnUPQDywSHyq8XXetL1/byF9V4
	 4+TbPme5EW634P7GRC2geXxLyvYY5H5954DT0eKKrTqce8uywlLOs2f7HcDihzgOVN
	 TMWVSfTUFqiytrv86mIRS7QFroeXFgpTq9qlbuM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6.18 636/641] drm/exynos: vidi: fix to avoid directly dereferencing user pointer
Date: Tue, 24 Feb 2026 17:26:02 -0800
Message-ID: <20260225012403.916226316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit d4c98c077c7fb2dfdece7d605e694b5ea2665085 upstream.

In vidi_connection_ioctl(), vidi->edid(user pointer) is directly
dereferenced in the kernel.

This allows arbitrary kernel memory access from the user space, so instead
of directly accessing the user pointer in the kernel, we should modify it
to copy edid to kernel memory using copy_from_user() and use it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -262,13 +262,27 @@ int vidi_connection_ioctl(struct drm_dev
 
 	if (vidi->connection) {
 		const struct drm_edid *drm_edid;
-		const struct edid *raw_edid;
+		const void __user *edid_userptr = u64_to_user_ptr(vidi->edid);
+		void *edid_buf;
+		struct edid hdr;
 		size_t size;
 
-		raw_edid = (const struct edid *)(unsigned long)vidi->edid;
-		size = (raw_edid->extensions + 1) * EDID_LENGTH;
+		if (copy_from_user(&hdr, edid_userptr, sizeof(hdr)))
+			return -EFAULT;
 
-		drm_edid = drm_edid_alloc(raw_edid, size);
+		size = (hdr.extensions + 1) * EDID_LENGTH;
+
+		edid_buf = kmalloc(size, GFP_KERNEL);
+		if (!edid_buf)
+			return -ENOMEM;
+
+		if (copy_from_user(edid_buf, edid_userptr, size)) {
+			kfree(edid_buf);
+			return -EFAULT;
+		}
+
+		drm_edid = drm_edid_alloc(edid_buf, size);
+		kfree(edid_buf);
 		if (!drm_edid)
 			return -ENOMEM;
 


