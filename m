Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A4F30505C;
	Sat, 25 Oct 2025 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408822; cv=none; b=nqqCTDHmD8beO0oZ7RHcvrXkJLMVxvncWNy2g+OHzAVAWxlnPGFVYPlzDg5G5KTuftBawLrkeGLsvpDsCI38Ux5A4XtBdxuSG4lV2H9juoupBhLGKm34GituYKMBJgZs0gWQ0z1ShFtOsA3vrH2dLKBsNF5gOKMQ4eDHV7vRDNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408822; c=relaxed/simple;
	bh=5OAOeHTcbADLXMuRZH9wy4isX8zkwFuM85Qa2+sanXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4ePArfx3JRtceEpLbLHPXUM5G4aRSgrj3TcFYBHZSpFJgfKwTwFupCCqbA/rMpjOpqKtAcx5b+AMsYkpoCJRuYvVUBZGMk6VsYOhWU2n4zvlpQgcclTCawiU/tmnszqnGmEZcE6sdLpUVY9rVM0dyk/oC+c6xvQECNURidfCiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVDL2e1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVDL2e1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE40DC4AF0B;
	Sat, 25 Oct 2025 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408822;
	bh=5OAOeHTcbADLXMuRZH9wy4isX8zkwFuM85Qa2+sanXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVDL2e1re0CVkjFGQI/WCCgZW0mZwUxNDHZNBWUCyV727aNW4P6YGPDbwxrslQxZD
	 WJ+T1Z6YEXn42perCT60C+NloMi4jhnBRAPXrDGkTVF4JzvSvCS1poG9LFaRAIbov5
	 f1Pv/cCBekaJ6p9g6CTo9AhmCKuS7PcdfZJ3o3dwkPMIQ0S5Etcwvu4jOsWV0r8hom
	 KA4HoHtu9uHO/CfN6AImjABMlbUUzMeS89j7e1lw57QKJBuKJuT6HEplFsi7penYOP
	 ZyrAEEQi+uN27JZK6WuoON5YmlZLWVc930CE2wXhBo1N8tjsWUNS1gN+5LkH88ACkB
	 tMu80u/MhwKDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] platform/x86/intel-uncore-freq: Fix warning in partitioned system
Date: Sat, 25 Oct 2025 11:55:16 -0400
Message-ID: <20251025160905.3857885-85-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 6d47b4f08436cb682fb2644e6265a3897fd42a77 ]

A partitioned system configured with only one package and one compute
die, warning will be generated for duplicate sysfs entry. This typically
occurs during the platform bring-up phase.

Partitioned systems expose dies, equivalent to TPMI compute domains,
through the CPUID. Each partitioned system must contains at least one
compute die per partition, resulting in a minimum of two dies per
package. Hence the function topology_max_dies_per_package() returns at
least two, and the condition "topology_max_dies_per_package() > 1"
prevents the creation of a root domain.

In this case topology_max_dies_per_package() will return 1 and root
domain will be created for partition 0 and a duplicate sysfs warning
for partition 1 as both partitions have same package ID.

To address this also check for non zero partition in addition to
topology_max_dies_per_package() > 1.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20250819211034.3776284-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents duplicate sysfs root-domain creation on partitioned systems
    that expose only one die per package via CPU topology, which leads
    to a duplicate-name error and probe failure for the second
    partition.
  - The duplicate arises because both partitions share the same
    `package_id`, so the root-domain sysfs name “package_%02d_die_%02d”
    collides.

- Precise change
  - Adds a guard to skip creating the per-package root domain if the
    device is for a non-zero partition:
    - drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
      tpmi.c:713
      - Changed from `if (topology_max_dies_per_package() > 1)` to `if
        (topology_max_dies_per_package() > 1 || plat_info->partition)`.
  - This ensures only partition 0 attempts the root-domain sysfs,
    avoiding a collision on partition 1.

- Why the issue occurs
  - Platform partition information is provided via TPMI
    (`tpmi_get_platform_data`), including `partition` and `package_id`:
    - drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
      tpmi.c:590
    - drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
      tpmi.c:597
  - The `partition` field comes from `struct oobmsm_plat_info`, where it
    denotes the per-package partition id:
    - include/linux/intel_vsec.h:164
  - Root-domain sysfs naming uses `package_id` and `die_id`:
    - drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
      common.c:274
      - `sprintf(data->name, "package_%02d_die_%02d", data->package_id,
        data->die_id);`
  - On partitioned systems where `topology_max_dies_per_package()`
    (CPUID-based) returns 1, both partition 0 and 1 attempt to create
    the same “package_%02d_die_%02d” entry, causing a duplicate.

- User-visible impact of the bug
  - The duplicate sysfs group creation fails; in the TPMI probe path
    this failure tears down all already-created cluster entries for that
    device:
    - drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
      tpmi.c:721 calls `uncore_freq_add_entry(...)`
    - drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
      tpmi.c:722–723 jumps to `remove_clusters` on error, removing
      entries
  - So this is not just a warning; it can cause probe failure for the
    second partition, removing uncore controls for that partition.

- Why the fix is safe and minimal
  - One-line condition change in a single driver; no API/ABI changes.
  - Only alters behavior when `plat_info->partition != 0`, a case where
    creating the root domain would conflict. Non-partitioned systems
    (`partition == 0`) and multi-die systems
    (`topology_max_dies_per_package() > 1`) are unaffected.
  - The logic remains consistent with existing behavior that already
    skips root-domain creation on multi-die systems.

- Stable backport criteria
  - Fixes a real bug that affects users of partitioned platforms
    (duplicate sysfs + probe failure).
  - Small, contained change with minimal regression risk.
  - No architectural changes or new features; confined to `platform/x86`
    Intel uncore-frequency TPMI path.

Given the above, this is a clear, low-risk bug fix that prevents a
probe-time failure on partitioned systems and should be backported to
stable.

 .../platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
index bfcf92aa4d69d..3e531fd1c6297 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -638,7 +638,7 @@ static int uncore_probe(struct auxiliary_device *auxdev, const struct auxiliary_
 
 	auxiliary_set_drvdata(auxdev, tpmi_uncore);
 
-	if (topology_max_dies_per_package() > 1)
+	if (topology_max_dies_per_package() > 1 || plat_info->partition)
 		return 0;
 
 	tpmi_uncore->root_cluster.root_domain = true;
-- 
2.51.0

