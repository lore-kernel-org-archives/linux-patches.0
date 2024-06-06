Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75B1A1861;
	Thu,  6 Jun 2024 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683701; cv=none; b=txWHvUarptSk2bf7IPJjLkqZyNsxDCSmwcmg9NqQHrTAk0BD3QpUmTfQfQdd65yrfc8920cZg9IvvV6vN/TrHnrNrfGG/bXVZ0XJzGDSI3wVypYi0Hc4oOysGGAgemA1yhsVhtLCK0Aw0MuOTaX7v1YfNKRLhI3BASpfXo0fAZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683701; c=relaxed/simple;
	bh=fAI4Ab9LL7OW3A/S8pOV9XMo+ysgjaVvOryfHmyyMeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu5M+oVGux8aJxDltb4ABgYuPtscPemUKrkf1CZ/mOza3EkY0oTjeG5FPXB0s2jZBnfBHfGnj5OYziSn/bgjZTACO7Svyq5BWN5nycocU0OsdDiXov6DXbvI4fdXaTGLqAVA9mDjVzWUM6wgqjFBTwmw1wzs9dGzNryvtbyWUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osCtzln7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osCtzln7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00DBC32781;
	Thu,  6 Jun 2024 14:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683701;
	bh=fAI4Ab9LL7OW3A/S8pOV9XMo+ysgjaVvOryfHmyyMeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osCtzln7NiabNVn/7dxZ2Q4pvlvhus6Plz88gQP4OossvxDhWbbIhVUhBL1bDOAc+
	 kMOPvX9aYE8L6jt3AoqW8tKczFq9wb4Wj07HYbb3vcpii8br+pdw2F03tWByyxuLwf
	 whUCaqsfrJZlvyXP9HKcA5wXJU/oEvfgOuB6fVQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 623/744] nouveau: add an ioctl to return vram bar size.
Date: Thu,  6 Jun 2024 16:04:55 +0200
Message-ID: <20240606131752.478517629@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 3f4d8aac6e768c2215ce68275256971c2f54f0c8 ]

This returns the BAR resources size so userspace can make
decisions based on rebar support.

userspace using this has been proposed for nvk, but
it's a rather trivial uapi addition.

Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Stable-dep-of: aed9a1a4f710 ("drm/nouveau: use tile_mode and pte_kind for VM_BIND bo allocations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_abi16.c | 4 ++++
 include/uapi/drm/nouveau_drm.h          | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index 2edd7bb13faea..d05bd0ecea2b5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -204,6 +204,7 @@ nouveau_abi16_ioctl_getparam(ABI16_IOCTL_ARGS)
 	struct nouveau_cli *cli = nouveau_cli(file_priv);
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nvif_device *device = &drm->client.device;
+	struct nvkm_device *nvkm_device = nvxx_device(&drm->client.device);
 	struct nvkm_gr *gr = nvxx_gr(device);
 	struct drm_nouveau_getparam *getparam = data;
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
@@ -268,6 +269,9 @@ nouveau_abi16_ioctl_getparam(ABI16_IOCTL_ARGS)
 		getparam->value = nouveau_exec_push_max_from_ib_max(ib_max);
 		break;
 	}
+	case NOUVEAU_GETPARAM_VRAM_BAR_SIZE:
+		getparam->value = nvkm_device->func->resource_size(nvkm_device, 1);
+		break;
 	default:
 		NV_PRINTK(dbg, cli, "unknown parameter %lld\n", getparam->param);
 		return -EINVAL;
diff --git a/include/uapi/drm/nouveau_drm.h b/include/uapi/drm/nouveau_drm.h
index 0bade1592f34f..10a917639d8d3 100644
--- a/include/uapi/drm/nouveau_drm.h
+++ b/include/uapi/drm/nouveau_drm.h
@@ -54,6 +54,13 @@ extern "C" {
  */
 #define NOUVEAU_GETPARAM_EXEC_PUSH_MAX   17
 
+/*
+ * NOUVEAU_GETPARAM_VRAM_BAR_SIZE - query bar size
+ *
+ * Query the VRAM BAR size.
+ */
+#define NOUVEAU_GETPARAM_VRAM_BAR_SIZE 18
+
 struct drm_nouveau_getparam {
 	__u64 param;
 	__u64 value;
-- 
2.43.0



