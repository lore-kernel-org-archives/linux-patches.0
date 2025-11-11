Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A12343D86;
	Tue, 11 Nov 2025 01:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824113; cv=none; b=HJIMDpPHgVsBP32cORc115nehbD4kGxY7/Yrd9O3yy0LO19WjZHRlXwIjHpKF0NCEE4nxOG0gbTbQY0cMbWW38O39mZaujtxLpU2ekFM7L6BDx67V9OhkTYfG45/PjEsHc1JTH9/+MC5WVJWI0mNPvA6UOQ7cuPk4RbR389eKm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824113; c=relaxed/simple;
	bh=trVAscobxmPU6ggE3jlUszyWHBCHyWSRdJHezX+CGyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jNbuy0uLfrrxi+2aoe+4EBuFGqHdTkgg4KmUiSWg42UnqsGsNq9hIrIu/afxyZ3EY9GqNFNh6uOcMjbbOYRsDuKHWQ4nF/pSeATGL3I8RumICcdIlMWng/Iy2uoEP2K6s+FfrgFxUXovPg/NAvAf7/b3zCJWgPAbvRWabvKWlMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c14OQ/rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c14OQ/rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7608CC116D0;
	Tue, 11 Nov 2025 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824113;
	bh=trVAscobxmPU6ggE3jlUszyWHBCHyWSRdJHezX+CGyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c14OQ/rtrS0zZQ2+ijoGceO03SulPRFwNtDmL6t0NwSQIu/xMKqZObpFiTs6GmV08
	 pWVzyoL19MUkhsbovnFIh2tauun+x3WPkBu9jPug7W0/hwALMxywSCVDR7r4A5MZxL
	 J56K1RHXbCprDX7TZoMnwbc9YHuohK/E8kIAqv5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 439/849] platform/x86/intel-uncore-freq: Present unique domain ID per package
Date: Tue, 11 Nov 2025 09:40:09 +0900
Message-ID: <20251111004547.045818492@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



