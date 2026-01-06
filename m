Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70F2D8777;
	Tue,  6 Jan 2026 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721263; cv=none; b=kheBryyBDY9jmLSDObny3bneH7d9CPgUZwnXOnwwCOZtbfdwcSrHpmkomTV8PJdyB7J3LF/7v9ngWP5P4elsGjXpK3ZD4neNMs5asdh2ecAdCmpYOMjjMx9QsfajtJaMI50WTUIFj27StdS6qYZg3plNJIvxKFHznMjc90WiTWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721263; c=relaxed/simple;
	bh=R9vAIiKMD/CDRP6WMHkzELBao1XZRTXrUi6k+WgKH/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhGuEVjyM3ggYyylaojMC+XKMEJEMo+0Qhye2bC0FzVFCb8o4DhA0cq9A/MrFNqnp+HJT0yFpftLqHyB4SVwHHHxwHMTU4odsHn3ppclCcd7E51zuZ/rIschOwLgXOCyVP4kUx/LUKad7rIViSd/3lX8pJOVhp6RP0XBfwkXRRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li3zw5eW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li3zw5eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFFAC116C6;
	Tue,  6 Jan 2026 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721262;
	bh=R9vAIiKMD/CDRP6WMHkzELBao1XZRTXrUi6k+WgKH/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li3zw5eWEInZJllg67B+Qmh8xOWLB/c5gFiemn19bA93d9V00/u1Xf2+LDuQmoHm1
	 rW2byYnQiQwJCXFtlB/xT9q3nSo80hplRqTpxCMThkXOipgdWPPGvaPyVpBW8TSBAY
	 1cBeNSbfuJLc3eBjsAFl4LtTSu3GTWxKxJkh8K/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.12 484/567] drm/imagination: Disallow exporting of PM/FW protected objects
Date: Tue,  6 Jan 2026 18:04:26 +0100
Message-ID: <20260106170509.262682977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -27,6 +27,16 @@ static void pvr_gem_object_free(struct d
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
@@ -41,6 +51,7 @@ static int pvr_gem_mmap(struct drm_gem_o
 static const struct drm_gem_object_funcs pvr_gem_object_funcs = {
 	.free = pvr_gem_object_free,
 	.print_info = drm_gem_shmem_object_print_info,
+	.export = pvr_gem_export,
 	.pin = drm_gem_shmem_object_pin,
 	.unpin = drm_gem_shmem_object_unpin,
 	.get_sg_table = drm_gem_shmem_object_get_sg_table,


