Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF9F25F797;
	Tue, 11 Nov 2025 01:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823304; cv=none; b=V600RP68FTal5km/KIU4+ZS5GCc2SfzGHAUGhbtgmW3ezhYG3g3cbvKIyrD/dMpNp9dfytjyZh2DhzvnLZ7N97/zsAXO6F5rpRmbRnpj/J9usPdpNmNfYv2fHjdz2mnjH4yOPCdsXUhyn2w1H24eE6cj1sZuX/AM36tJ++ePixQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823304; c=relaxed/simple;
	bh=Fu4oz8YMpa1E6Hb8h70+BcDOvwXTv7mjjVMZrMYXBAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIGoCS5CVJFpWATGblo5RTUyvJplme+xP/4MEYeWuRAEAP5k8Is0xSJuEw91YUlsqtTk13BShWpG6wF4eefAf+CrtJ2gZHfa7QqbGGHnIjfEFTg6BqGuPbyZytB62c7/EGm3HPPVVnFdvXO4ZZpXXRxXx8WMoKZ56Ioq0IHao2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWyUkXbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWyUkXbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C7EC4CEF5;
	Tue, 11 Nov 2025 01:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823304;
	bh=Fu4oz8YMpa1E6Hb8h70+BcDOvwXTv7mjjVMZrMYXBAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWyUkXbMIMUGpd7JtrE1aEjOd1NZ7T4TJNAeARByqYuo+nsHRAxCNpt3bO1s3vs5k
	 DCz0LsKAfXEryh4KyKnew8wx9MdJrTqfsFcTvfp0U1dKn50Sup0G+Ho2Af1sv0up4X
	 FBRxvW4gw32s19x52hgAlPHVerdTY15C5V3dlMCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 272/849] drm/nouveau: always set RMDevidCheckIgnore for GSP-RM
Date: Tue, 11 Nov 2025 09:37:22 +0900
Message-ID: <20251111004543.004238843@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 27738c3003bf3b124527c9ed75e1e0d0c013c101 ]

Always set the RMDevidCheckIgnore registry key for GSP-RM so that it
will continue support newer variants of already supported GPUs.

GSP-RM maintains an internal list of PCI IDs of GPUs that it supports,
and checks if the current GPU is on this list.  While the actual GPU
architecture (as specified in the BOOT_0/BOOT_42 registers) determines
how to enable the GPU, the PCI ID is used for the product name, e.g.
"NVIDIA GeForce RTX 5090".

Unfortunately, if there is no match, GSP-RM will refuse to initialize,
even if the device is fully supported.  Nouveau will get an error
return code, but by then it's too late.  This behavior may be corrected
in a future version of GSP-RM, but that does not help Nouveau today.

Fortunately, GSP-RM supports an undocumented registry key that tells it
to ignore the mismatch.  In such cases, the product name returned will
be a blank string, but otherwise GSP-RM will continue.

Unlike Nvidia's proprietary driver, Nouveau cannot update to newer
firmware versions to keep up with every new hardware release.  Instead,
we can permanently set this registry key, and GSP-RM will continue
to function the same with known hardware.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://lore.kernel.org/r/20250808191340.1701983-1-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
index 588cb4ab85cb4..32e6a065d6d7a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -582,10 +582,13 @@ struct nv_gsp_registry_entries {
  * RMSecBusResetEnable - enables PCI secondary bus reset
  * RMForcePcieConfigSave - forces GSP-RM to preserve PCI configuration
  *   registers on any PCI reset.
+ * RMDevidCheckIgnore - allows GSP-RM to boot even if the PCI dev ID
+ *   is not found in the internal product name database.
  */
 static const struct nv_gsp_registry_entries r535_registry_entries[] = {
 	{ "RMSecBusResetEnable", 1 },
 	{ "RMForcePcieConfigSave", 1 },
+	{ "RMDevidCheckIgnore", 1 },
 };
 #define NV_GSP_REG_NUM_ENTRIES ARRAY_SIZE(r535_registry_entries)
 
-- 
2.51.0



