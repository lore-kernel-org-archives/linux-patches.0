Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8863D2F659C;
	Tue,  6 Jan 2026 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722601; cv=none; b=g2lVLfn1I83MrOUQjaGZ1KqRzN5Qk9LkKNmwFj4EauqaGfxge81SYdiHYItSa6nGlR3YtRh9l41eGGpZAOzHOHSrD2B0ua2EPmYJCXzpang55epsPrfDNzgV+iR3ViSWuQCah1tp7c4Ml4twcKeukwBldCZkcDEvG6IAvna4278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722601; c=relaxed/simple;
	bh=LwW8eMgB9kSJdDDuLL/kBOUWMVdCjWA3yZvm+Q2DRaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV+vbymmjhAEN6nl9IS/LG0IWVPi2VtRob/3PqRLY4A6vsoaTuZdNL/lbI8iur40G6k0/keqkAaBx+t1Pk8kdV1sSEG4WEAx+kjjWUC8ZOHI0dgQTR16u0DX11MDqnU6E3BSeFjsKgeS6mN84djE9n6VD80MdKOgFBcrJDbxxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCIIFgKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCIIFgKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA98AC116C6;
	Tue,  6 Jan 2026 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722601;
	bh=LwW8eMgB9kSJdDDuLL/kBOUWMVdCjWA3yZvm+Q2DRaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCIIFgKP4YKexjQaoEXYx3nLulFMc5GI9piKFg9PrAB7285duo82e7yjx2h3UxPrs
	 UKRWzUd/9k9NURUYaJ5MY78nA5wJxt5n3ompUPKBdzUhBA5JL7vxPt2tU9Rz5FdApx
	 q3KnVJjN0gyhhW72IejZL/pPkZESjlLcX/rgJlaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.18 304/312] drm/imagination: Disallow exporting of PM/FW protected objects
Date: Tue,  6 Jan 2026 18:06:18 +0100
Message-ID: <20260106170558.858754949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Alessio Belle <alessio.belle@imgtec.com>

commit 6b991ad8dc3abfe5720fc2e9ee96be63ae43e362 upstream.

These objects are meant to be used by the GPU firmware or by the PM unit
within the GPU, in which case they may contain physical addresses.

This adds a layer of protection against exposing potentially exploitable
information outside of the driver.

Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251208-no-export-pm-fw-obj-v1-1-83ab12c61693@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_gem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/imagination/pvr_gem.c
+++ b/drivers/gpu/drm/imagination/pvr_gem.c
@@ -28,6 +28,16 @@ static void pvr_gem_object_free(struct d
 	drm_gem_shmem_object_free(obj);
 }
 
+static struct dma_buf *pvr_gem_export(struct drm_gem_object *obj, int flags)
+{
+	struct pvr_gem_object *pvr_obj = gem_to_pvr_gem(obj);
+
+	if (pvr_obj->flags & DRM_PVR_BO_PM_FW_PROTECT)
+		return ERR_PTR(-EPERM);
+
+	return drm_gem_prime_export(obj, flags);
+}
+
 static int pvr_gem_mmap(struct drm_gem_object *gem_obj, struct vm_area_struct *vma)
 {
 	struct pvr_gem_object *pvr_obj = gem_to_pvr_gem(gem_obj);
@@ -42,6 +52,7 @@ static int pvr_gem_mmap(struct drm_gem_o
 static const struct drm_gem_object_funcs pvr_gem_object_funcs = {
 	.free = pvr_gem_object_free,
 	.print_info = drm_gem_shmem_object_print_info,
+	.export = pvr_gem_export,
 	.pin = drm_gem_shmem_object_pin,
 	.unpin = drm_gem_shmem_object_unpin,
 	.get_sg_table = drm_gem_shmem_object_get_sg_table,


