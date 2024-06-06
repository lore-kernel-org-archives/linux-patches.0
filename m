Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995A7199229;
	Thu,  6 Jun 2024 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683701; cv=none; b=gimph8fq7gxamNY4q8oZC4gmacutBgkmmf1kK/BuT2kfK7iKmOowo1/U207V+4IA+3GFobowR6XJdtQg2pbGvX4kR/5KMbjnBG0PALEZ7EucpJj0aNcuFBc/YOLXdeE3mfl67VIaKpKnr0W8Z1zvjCfrevhaQil1ZNuOBQTo9fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683701; c=relaxed/simple;
	bh=2xPfXcKSNZKsmx3LbuyQLV3V8vuwqe7FNGz9fngatZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4dXS0DzJcf9NqPbHPWlJhq5+qg6Sf58ver3pUJmrdolrexa93u6BoMQ8n1M2HnTHWdq+Nk4LD+MppdNaj1kyuXQewur546qBl48bVEfyD9qnnSPI4q21hQsVTveMkjvDpq8+GHzd1ZVHHfgmUxecQpTwVR7SbAHvatDaKNNNlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQXM8Ids; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQXM8Ids"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79262C2BD10;
	Thu,  6 Jun 2024 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683701;
	bh=2xPfXcKSNZKsmx3LbuyQLV3V8vuwqe7FNGz9fngatZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQXM8IdsjVUld1a/SZcBJQhtUW7B3t3b8/2e+a2zzm2S5SddPIgTzme91N0PSCGaG
	 KOIbYI0cZ1+FSsv5S9io7I0yAftMUvtvwnGRHy8qZAuEHivzVPjnxRdBuv5jCDSEOT
	 1WqMoanwf1aXZLoNHb1bEtSAtapztY1H0PwTepU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 624/744] nouveau: add an ioctl to report vram usage
Date: Thu,  6 Jun 2024 16:04:56 +0200
Message-ID: <20240606131752.511479498@linuxfoundation.org>
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

[ Upstream commit 72fa02fdf83306c52bc1eede28359e3fa32a151a ]

This reports the currently used vram allocations.

userspace using this has been proposed for nvk, but
it's a rather trivial uapi addition.

Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Stable-dep-of: aed9a1a4f710 ("drm/nouveau: use tile_mode and pte_kind for VM_BIND bo allocations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_abi16.c | 5 +++++
 include/uapi/drm/nouveau_drm.h          | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index d05bd0ecea2b5..0fbc9c841666e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -272,6 +272,11 @@ nouveau_abi16_ioctl_getparam(ABI16_IOCTL_ARGS)
 	case NOUVEAU_GETPARAM_VRAM_BAR_SIZE:
 		getparam->value = nvkm_device->func->resource_size(nvkm_device, 1);
 		break;
+	case NOUVEAU_GETPARAM_VRAM_USED: {
+		struct ttm_resource_manager *vram_mgr = ttm_manager_type(&drm->ttm.bdev, TTM_PL_VRAM);
+		getparam->value = (u64)ttm_resource_manager_usage(vram_mgr) << PAGE_SHIFT;
+		break;
+	}
 	default:
 		NV_PRINTK(dbg, cli, "unknown parameter %lld\n", getparam->param);
 		return -EINVAL;
diff --git a/include/uapi/drm/nouveau_drm.h b/include/uapi/drm/nouveau_drm.h
index 10a917639d8d3..77d7ff0d5b110 100644
--- a/include/uapi/drm/nouveau_drm.h
+++ b/include/uapi/drm/nouveau_drm.h
@@ -61,6 +61,13 @@ extern "C" {
  */
 #define NOUVEAU_GETPARAM_VRAM_BAR_SIZE 18
 
+/*
+ * NOUVEAU_GETPARAM_VRAM_USED
+ *
+ * Get remaining VRAM size.
+ */
+#define NOUVEAU_GETPARAM_VRAM_USED 19
+
 struct drm_nouveau_getparam {
 	__u64 param;
 	__u64 value;
-- 
2.43.0



