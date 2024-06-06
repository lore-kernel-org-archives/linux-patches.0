Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F57B1A1866;
	Thu,  6 Jun 2024 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683702; cv=none; b=g6SrtlOI+Ap6e6lHvOtxcTBEIdA3bitBQgi0A5MW2glKqchncEWqyyPkaGCYK/yVt/cit4I1TBdhf4c7kdnuh49YfdsgGrGVokWnVv+5wbQ5ax8iNbZr5JJGGa8aQsGxRJ8QGepmMtEpQzsPpMW3jB4IXltDH2BtYxsHENQ7QI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683702; c=relaxed/simple;
	bh=HR+NIUSKOVxwVSR/KZ+XKbGrfjVYrurA+a/V6+qnXMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr35XEI6szfqjOlgsSk80Y9eQGWlvw4RJ7Dm7bZmz3o15Js25bqoRvVR7lzquQIHCUbA4RsZSrdWF6rGIlP0Gco18u3oqpDHTL6kYlFRydCmhxcJOiFq7paf12DjTzR9aapGUes9g54Ny7OcKWZJ6a12kDFu3RdQnHfRBTCbs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N87DcjBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N87DcjBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D0FC2BD10;
	Thu,  6 Jun 2024 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683702;
	bh=HR+NIUSKOVxwVSR/KZ+XKbGrfjVYrurA+a/V6+qnXMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N87DcjBJCTV79Dei4ojWiDk0b/NqvizsjU+/bn297l+v5WLhJDaDmTHiP3T65I3Jl
	 LuUvZCG59Drwtk0e7Pj0Hf/kF5dTSQmX5ZL/1mZKzdHCcuLH01B3pEkc7b33inFC5y
	 MF2L2qusahHs+9qEmvUY0PJod1ykiXsx4xtp7QUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 625/744] drm/nouveau: use tile_mode and pte_kind for VM_BIND bo allocations
Date: Thu,  6 Jun 2024 16:04:57 +0200
Message-ID: <20240606131752.543024025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>

[ Upstream commit aed9a1a4f7106ff99a882ad06318cebfa71016a2 ]

Allow PTE kind and tile mode on BO create with VM_BIND, and add a
GETPARAM to indicate this change. This is needed to support modifiers in
NVK and ensure correctness when dealing with the nouveau GL driver.

The userspace modifiers implementation this is for can be found here:
https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/24795

Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Signed-off-by: Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240509204352.7597-1-mohamedahmedegypt2001@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_abi16.c |  3 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c    | 44 +++++++++++--------------
 include/uapi/drm/nouveau_drm.h          |  7 ++++
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index 0fbc9c841666e..b3f0e10f83fef 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -277,6 +277,9 @@ nouveau_abi16_ioctl_getparam(ABI16_IOCTL_ARGS)
 		getparam->value = (u64)ttm_resource_manager_usage(vram_mgr) << PAGE_SHIFT;
 		break;
 	}
+	case NOUVEAU_GETPARAM_HAS_VMA_TILEMODE:
+		getparam->value = 1;
+		break;
 	default:
 		NV_PRINTK(dbg, cli, "unknown parameter %lld\n", getparam->param);
 		return -EINVAL;
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 254d6c9ef2023..3a7f4ce34aa31 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -234,28 +234,28 @@ nouveau_bo_alloc(struct nouveau_cli *cli, u64 *size, int *align, u32 domain,
 	}
 
 	nvbo->contig = !(tile_flags & NOUVEAU_GEM_TILE_NONCONTIG);
-	if (!nouveau_cli_uvmm(cli) || internal) {
-		/* for BO noVM allocs, don't assign kinds */
-		if (cli->device.info.family >= NV_DEVICE_INFO_V0_FERMI) {
-			nvbo->kind = (tile_flags & 0x0000ff00) >> 8;
-			if (!nvif_mmu_kind_valid(mmu, nvbo->kind)) {
-				kfree(nvbo);
-				return ERR_PTR(-EINVAL);
-			}
 
-			nvbo->comp = mmu->kind[nvbo->kind] != nvbo->kind;
-		} else if (cli->device.info.family >= NV_DEVICE_INFO_V0_TESLA) {
-			nvbo->kind = (tile_flags & 0x00007f00) >> 8;
-			nvbo->comp = (tile_flags & 0x00030000) >> 16;
-			if (!nvif_mmu_kind_valid(mmu, nvbo->kind)) {
-				kfree(nvbo);
-				return ERR_PTR(-EINVAL);
-			}
-		} else {
-			nvbo->zeta = (tile_flags & 0x00000007);
+	if (cli->device.info.family >= NV_DEVICE_INFO_V0_FERMI) {
+		nvbo->kind = (tile_flags & 0x0000ff00) >> 8;
+		if (!nvif_mmu_kind_valid(mmu, nvbo->kind)) {
+			kfree(nvbo);
+			return ERR_PTR(-EINVAL);
+		}
+
+		nvbo->comp = mmu->kind[nvbo->kind] != nvbo->kind;
+	} else if (cli->device.info.family >= NV_DEVICE_INFO_V0_TESLA) {
+		nvbo->kind = (tile_flags & 0x00007f00) >> 8;
+		nvbo->comp = (tile_flags & 0x00030000) >> 16;
+		if (!nvif_mmu_kind_valid(mmu, nvbo->kind)) {
+			kfree(nvbo);
+			return ERR_PTR(-EINVAL);
 		}
-		nvbo->mode = tile_mode;
+	} else {
+		nvbo->zeta = (tile_flags & 0x00000007);
+	}
+	nvbo->mode = tile_mode;
 
+	if (!nouveau_cli_uvmm(cli) || internal) {
 		/* Determine the desirable target GPU page size for the buffer. */
 		for (i = 0; i < vmm->page_nr; i++) {
 			/* Because we cannot currently allow VMM maps to fail
@@ -297,12 +297,6 @@ nouveau_bo_alloc(struct nouveau_cli *cli, u64 *size, int *align, u32 domain,
 		}
 		nvbo->page = vmm->page[pi].shift;
 	} else {
-		/* reject other tile flags when in VM mode. */
-		if (tile_mode)
-			return ERR_PTR(-EINVAL);
-		if (tile_flags & ~NOUVEAU_GEM_TILE_NONCONTIG)
-			return ERR_PTR(-EINVAL);
-
 		/* Determine the desirable target GPU page size for the buffer. */
 		for (i = 0; i < vmm->page_nr; i++) {
 			/* Because we cannot currently allow VMM maps to fail
diff --git a/include/uapi/drm/nouveau_drm.h b/include/uapi/drm/nouveau_drm.h
index 77d7ff0d5b110..c3d8dc7512971 100644
--- a/include/uapi/drm/nouveau_drm.h
+++ b/include/uapi/drm/nouveau_drm.h
@@ -68,6 +68,13 @@ extern "C" {
  */
 #define NOUVEAU_GETPARAM_VRAM_USED 19
 
+/*
+ * NOUVEAU_GETPARAM_HAS_VMA_TILEMODE
+ *
+ * Query whether tile mode and PTE kind are accepted with VM allocs or not.
+ */
+#define NOUVEAU_GETPARAM_HAS_VMA_TILEMODE 20
+
 struct drm_nouveau_getparam {
 	__u64 param;
 	__u64 value;
-- 
2.43.0



