Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CE531AF1A;
	Sat, 25 Oct 2025 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409611; cv=none; b=VxJ2fmDVbtH2KC8L6gt6rjCesXJBo8zYRY6/IPQZCobj+YKYiR6WFhW6nAnXhxzSwgWvp9IWdl6qaDg6+III4j6LdzzK1XCpD2YNChuou9tohePfzY6rWPkW0ubp2HUcoyjMezs/h+DulFUd4LLPDwpIXTgRS2eyPPRAU3rElnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409611; c=relaxed/simple;
	bh=ojubRILSQvthy+t5x9+vZuDYUG4G6Zijk2t9SISXndw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAO2/lp4RaFESj5V/CxOqZLqvvWhgHchaFAAldvBQo6jRxyll1OCkzm8ojeDPGCqEIrlZkHs/unaDvBdCH5tpo98SrPH4QuYnAMdacsSMt/UQUu/3JlxbandzK3xIz7Lx8/d1+QHuKfF9NusUbMvL+LVAK3YAQ+e59eNAbELuHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wed7lOHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wed7lOHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFFDC4CEFB;
	Sat, 25 Oct 2025 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409611;
	bh=ojubRILSQvthy+t5x9+vZuDYUG4G6Zijk2t9SISXndw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wed7lOHCsDhAu5CB8gNQn2k420+j5Q0nfWbt7ItFftj0SbkgH5YQ9oMjnE+fNP+OF
	 vrO1uBHFTBiLbHZyqe6HrzGKW0ChS0AZHgvK4cyb7lk9kE9gOnP2NbVaEdLk0Y/f7c
	 lZTVlUxOE7QYjTX0CyNf19dR0BrbED/dOShZNirjFyRViJXbs54GKP1AYoAUAiJ21O
	 /vrpNci2Cja0N8bJuJMUBqW/FEpJhwelXPGR3SQYOWgqfRlv0iHcndCCPrSZ4aIqQr
	 UI0xThua2Wdg3G+Ygpn7nNdZuM9ujI/4VZP97tbghnj7Y7d2qSTieXlrtn3KEFgqY5
	 hok793lCHKlfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86/intel-uncore-freq: Present unique domain ID per package
Date: Sat, 25 Oct 2025 12:00:23 -0400
Message-ID: <20251025160905.3857885-392-sashal@kernel.org>
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

[ Upstream commit a191224186ec16a4cb1775b2a647ea91f5c139e1 ]

In partitioned systems, the domain ID is unique in the partition and a
package can have multiple partitions.

Some user-space tools, such as turbostat, assume the domain ID is unique
per package. These tools map CPU power domains, which are unique to a
package. However, this approach does not work in partitioned systems.

There is no architectural definition of "partition" to present to user
space.

To support these tools, set the domain_id to be unique per package. For
compute die IDs, uniqueness can be achieved using the platform info
cdie_mask, mirroring the behavior observed in non-partitioned systems.

For IO dies, which lack a direct CPU relationship, any unique logical
ID can be assigned. Here domain IDs for IO dies are configured after all
compute domain IDs. During the probe, keep the index of the next IO
domain ID after the last IO domain ID of the current partition. Since
CPU packages are symmetric, partition information is same for all
packages.

The Intel Speed Select driver has already implemented a similar change
to make the domain ID unique, with compute dies listed first, followed
by I/O dies.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20250903191154.1081159-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Fixes a user-visible inconsistency in partitioned systems where
    `domain_id` values repeat per partition instead of being unique per
    package, which breaks userspace tools that assume package-unique
    domain IDs (e.g., turbostat). Turbostat reads `domain_id` from sysfs
    and uses it to name counters per package
    (tools/power/x86/turbostat/turbostat.c:7065,
    tools/power/x86/turbostat/turbostat.c:7072), so duplicate IDs cause
    mislabeling/misaggregation.

- Key changes
  - Introduces package-unique domain ID assignment logic via
    `set_domain_id()`, replacing the previous direct assignment
    `domain_id = i` done during probe.
    - Adds the new helper and supporting state:
      - `MAX_PARTITIONS`, `io_die_start[]`, `io_die_index_next`,
        `domain_lock` to coordinate ID space allocation across
        partitions (drivers/platform/x86/intel/uncore-frequency/uncore-
        frequency-tpmi.c:377–386).
      - New `set_domain_id(int id, int num_resources, struct
        oobmsm_plat_info *plat_info, struct tpmi_uncore_cluster_info
        *cluster_info)` that:
        - Returns old behavior if `plat_info->partition >=
          MAX_PARTITIONS` (drivers/platform/x86/intel/uncore-
          frequency/uncore-frequency-tpmi.c:394–397).
        - For compute dies (AGENT_TYPE_CORE), sets `domain_id = cdie_id`
          to mirror non-partitioned behavior
          (drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
          tpmi.c:399–402).
        - For IO dies, allocates IDs after the compute-die range using
          `io_die_start[partition]` and advances `io_die_index_next`,
          protected by `domain_lock` to ensure uniqueness across
          partitions (drivers/platform/x86/intel/uncore-
          frequency/uncore-frequency-tpmi.c:404–445).
    - Hooks the new logic into probe by removing
      `cluster_info->uncore_data.domain_id = i` and calling
      `set_domain_id(...)` instead (drivers/platform/x86/intel/uncore-
      frequency/uncore-frequency-tpmi.c:684–689).
  - Leaves non-partitioned systems behavior unchanged (compute dies use
    `cdie_id`, IO dies follow compute dies, matching pre-existing
    expectations).

- Why it matters (userspace impact)
  - The driver exposes `domain_id` via sysfs
    (drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
    common.c:25–33, 200–208) and creates per-domain entries used by
    turbostat (e.g., `uncoreXX/domain_id`, `.../package_id`,
    `.../fabric_cluster_id`). Turbostat assumes `domain_id` is unique
    per package to generate per-domain counter names
    (tools/power/x86/turbostat/turbostat.c:7054–7099), which is violated
    in partitioned systems without this patch. This is a clear user-
    visible bug fix, not a feature.

- Scope and risk
  - Small, contained change in one driver file; pure ID assignment
    during probe. No changes to the uncore frequency control logic, MMIO
    programming, or sysfs schema. Only the values of `domain_id` change
    for partitioned platforms.
  - Concurrency is correctly handled by `domain_lock`
    (drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
    tpmi.c:385–386, 415).
  - Safe fallback: if an unexpected partition count (`>=
    MAX_PARTITIONS`) appears, it falls back to the old `domain_id = id`
    behavior (drivers/platform/x86/intel/uncore-frequency/uncore-
    frequency-tpmi.c:394–397), avoiding regressions.
  - Non-partitioned systems and compute dies keep previous semantics
    (`domain_id = cdie_id`), preserving existing userspace behavior
    (drivers/platform/x86/intel/uncore-frequency/uncore-frequency-
    tpmi.c:399–402).

- Alignment with stable criteria
  - Fixes an important userspace-visible bug (domain ID non-uniqueness
    per package in partitioned systems).
  - Change is minimal and isolated to a single driver’s probe-time
    bookkeeping.
  - No architectural changes; no cross-subsystem impact; low regression
    risk.
  - Mirrors existing precedent in a related Intel driver (commit message
    notes Intel Speed Select already made domain IDs unique in a similar
    way).

- Backport notes
  - The patch uses `guard(mutex)` (include/linux/cleanup.h); if
    backporting to older stable kernels lacking this helper, a trivial
    conversion to `mutex_lock()`/`mutex_unlock()` is sufficient.
  - Depends on `struct oobmsm_plat_info` providing `partition` and
    `cdie_mask` (include/linux/intel_vsec.h:161–172), and on the TPMI
    plumbing already present in the target stable series. Ensure these
    prior platform bits exist in that series.

Given the userspace breakage it resolves and the low-risk, self-
contained nature of the change, this is a good candidate for stable
backport.

 .../uncore-frequency/uncore-frequency-tpmi.c  | 74 ++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
index 3e531fd1c6297..1237d95708865 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -374,6 +374,77 @@ static void uncore_set_agent_type(struct tpmi_uncore_cluster_info *cluster_info)
 	cluster_info->uncore_data.agent_type_mask = FIELD_GET(UNCORE_AGENT_TYPES, status);
 }
 
+#define MAX_PARTITIONS	2
+
+/* IO domain ID start index for a partition */
+static u8 io_die_start[MAX_PARTITIONS];
+
+/* Next IO domain ID index after the current partition IO die IDs */
+static u8 io_die_index_next;
+
+/* Lock to protect io_die_start, io_die_index_next */
+static DEFINE_MUTEX(domain_lock);
+
+static void set_domain_id(int id,  int num_resources,
+			  struct oobmsm_plat_info *plat_info,
+			  struct tpmi_uncore_cluster_info *cluster_info)
+{
+	u8 part_io_index, cdie_range, pkg_io_index, max_dies;
+
+	if (plat_info->partition >= MAX_PARTITIONS) {
+		cluster_info->uncore_data.domain_id = id;
+		return;
+	}
+
+	if (cluster_info->uncore_data.agent_type_mask & AGENT_TYPE_CORE) {
+		cluster_info->uncore_data.domain_id = cluster_info->cdie_id;
+		return;
+	}
+
+	/* Unlikely but cdie_mask may have holes, so take range */
+	cdie_range = fls(plat_info->cdie_mask) - ffs(plat_info->cdie_mask) + 1;
+	max_dies = topology_max_dies_per_package();
+
+	/*
+	 * If the CPU doesn't enumerate dies, then use current cdie range
+	 * as the max.
+	 */
+	if (cdie_range > max_dies)
+		max_dies = cdie_range;
+
+	guard(mutex)(&domain_lock);
+
+	if (!io_die_index_next)
+		io_die_index_next = max_dies;
+
+	if (!io_die_start[plat_info->partition]) {
+		io_die_start[plat_info->partition] = io_die_index_next;
+		/*
+		 * number of IO dies = num_resources - cdie_range. Hence
+		 * next partition io_die_index_next is set after IO dies
+		 * in the current partition.
+		 */
+		io_die_index_next += (num_resources - cdie_range);
+	}
+
+	/*
+	 * Index from IO die start within the partition:
+	 * This is the first valid domain after the cdies.
+	 * For example the current resource index 5 and cdies end at
+	 * index 3 (cdie_cnt = 4). Then the IO only index 5 - 4 = 1.
+	 */
+	part_io_index = id - cdie_range;
+
+	/*
+	 * Add to the IO die start index for this partition in this package
+	 * to make unique in the package.
+	 */
+	pkg_io_index = io_die_start[plat_info->partition] + part_io_index;
+
+	/* Assign this to domain ID */
+	cluster_info->uncore_data.domain_id = pkg_io_index;
+}
+
 /* Callback for sysfs read for TPMI uncore values. Called under mutex locks. */
 static int uncore_read(struct uncore_data *data, unsigned int *value, enum uncore_index index)
 {
@@ -610,11 +681,12 @@ static int uncore_probe(struct auxiliary_device *auxdev, const struct auxiliary_
 			cluster_info->uncore_data.package_id = pkg;
 			/* There are no dies like Cascade Lake */
 			cluster_info->uncore_data.die_id = 0;
-			cluster_info->uncore_data.domain_id = i;
 			cluster_info->uncore_data.cluster_id = j;
 
 			set_cdie_id(i, cluster_info, plat_info);
 
+			set_domain_id(i, num_resources, plat_info, cluster_info);
+
 			cluster_info->uncore_root = tpmi_uncore;
 
 			if (TPMI_MINOR_VERSION(pd_info->ufs_header_ver) >= UNCORE_ELC_SUPPORTED_VERSION)
-- 
2.51.0

