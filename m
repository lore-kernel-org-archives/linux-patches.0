Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A75305066;
	Sat, 25 Oct 2025 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408939; cv=none; b=oSAbu+tS7vPNtJCakXBa0QCy2n1luvCZg7daUQDiEQ0BOb8144YP8NyAn3ONBPr2Ks4yBJc+/F+6+fa6F5R31olYgoTG5JkuQYfxd59dZsRaOG6T6nzMoEN0zfpeSW/YxMBD6Amz/AzS62MrKUUTW+YmJwSXj4l5ri6Jvh+EbW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408939; c=relaxed/simple;
	bh=S+sgQN+hicYkwFtKdfxBYx+U05oSh+5MKZu/RunLJv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VqeBirmjlwKVKOVW4AuzVE8e4z4+ayk5Dho4v67eKW7z2XE26Hah9Tdc5hY2Wynx38Zf5PG67YnEjCQv9kyjqd2UbSzcYxuGuoiQ7FZNJokNjDXuqFThA7MocqAgMHTWVm/DucSj1DLjzr+B2FXjD3hSC8Awne7pvRZkFSNUEE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMSVMdgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMSVMdgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A13C4CEFB;
	Sat, 25 Oct 2025 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408939;
	bh=S+sgQN+hicYkwFtKdfxBYx+U05oSh+5MKZu/RunLJv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMSVMdgFd9kofY22GnwnXBmA0gXl4VT4lEB70Hq2fGUUgKR9zyhzfvYIf4oI65wSP
	 nN8xReUugl3sJN914nyltD3KPZhGFiX6xuJzyKj2ICHASCyecGb7iFnuq8F9Bg/YVr
	 bUTJYSJB7UDjqieUhK8drRLget8PmeMlEvPAbpDVJ3XDzzAuJS1b5dfslvVLUi8Haf
	 CnFB2Nszt/AIC14Cizy2TiCOU959XgdGIIB6iN88mj85dc0RzLaVikur7zlRqHbfWN
	 GWVJvtOIw9FOFeVtOZMVZbLEakGeTmrgfh4P9TgI43ZIxoAo7KnNGKaxxVzpGbt5il
	 42btcxHK6Kvkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	airlied@redhat.com,
	bskeggs@nvidia.com,
	zhiw@nvidia.com
Subject: [PATCH AUTOSEL 6.17] drm/nouveau: always set RMDevidCheckIgnore for GSP-RM
Date: Sat, 25 Oct 2025 11:56:12 -0400
Message-ID: <20251025160905.3857885-141-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds `"RMDevidCheckIgnore" = 1` to the always-applied GSP-RM
    registry entries array `r535_registry_entries` so the key is sent
    unconditionally to the GSP-RM firmware during bring-up:
    drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c:586
  - These entries are appended into the registry payload by the loop in
    `r535_gsp_rpc_set_registry()`:
    drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c:639
  - The registry is pushed early in device initialization from
    `r535_gsp_oneinit()`:
    drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c:2185

- Why it matters
  - GSP-RM internally gates initialization on a PCI ID → product-name
    table, refusing to initialize if there’s no match, even when the GPU
    architecture is fully supported. This causes a hard failure on newly
    released PCI ID variants of already supported architectures.
  - The undocumented `RMDevidCheckIgnore` flag tells GSP-RM to ignore
    the PCI ID table mismatch: initialization proceeds, but the product
    name is blank. The driver does not rely on the RM-provided product
    string for functionality.
  - Nouveau cannot “chase” new PCI IDs via frequent firmware updates in
    stable kernels; always setting this flag ensures supported
    architectures remain usable as new board IDs are released.

- Scope and containment
  - The change is a single, small addition to a constant array of
    required registry entries; no logic changes, no interface changes,
    no data structure changes:
    drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c:586
  - It only affects the r535 GSP-RM path, and only the firmware’s
    registry configuration step.

- Side effects and risk
  - For already-known PCI IDs, the flag is inert; there is no change in
    behavior.
  - For unknown PCI IDs of supported architectures, initialization
    proceeds (previously failed); the only visible difference is a blank
    product name reported by RM. A code search finds no driver
    dependence on the RM-provided product string in nouveau; device
    naming in DRM/userspace flows from PCI data instead.
  - If a truly unsupported architecture is encountered, architectural
    checks elsewhere (e.g., BOOT_0/BOOT_42-based flows) will still
    prevent successful bring-up; this flag does not bypass architectural
    enablement logic.
  - The module parameter `NVreg_RegistryDwords` still allows overrides;
    adding this fixed entry does not create compatibility issues
    (duplicate keys are benign on the RM side).

- Stable backport criteria
  - Fixes a real, user-visible failure (GPU initialization refusal on
    new PCI IDs of supported GPUs).
  - Minimal and low-risk change; no architectural rework; confined to
    nouveau’s GSP-RM r535 path.
  - No ABI changes; no new features; behavior matches the proprietary
    driver’s ability to keep working as IDs update, but implemented via
    a static registry setting since nouveau can’t update firmware
    frequently on stable trees.
  - Does not touch critical kernel subsystems beyond DRM/nouveau; is
    self-contained and compile-time safe.

Given the small, surgical change, the clear user impact (fixes hard
initialization failures), and low regression risk, this is a strong
candidate for stable backport.

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

