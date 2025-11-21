Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849F212F98;
	Fri, 21 Nov 2025 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733369; cv=none; b=rCc244xkfaZIGddFPHeKKtziXpOZqTUZpq+AorJug/S5+KeDhIQmu+TJztz4hI5vpp6KUbshB99YkRA3gcrRogTCUE+Qmf5siT/Xf2GJAsiVtaqjSMjjVtWKJeSX6iutDnsHQv9FjeKaohCIrcsPvXsPqUeKAGsIsfEq/ytaUiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733369; c=relaxed/simple;
	bh=S5ArCdLzm1vLEixwrUGuMH1jq1R/FHRWqzdM8pxfU2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGxkFePyv9RdqrOAechiQbSDOt18TVkY0w94CiTA9C00CmhuWtqwWUnAGHMRR6jpdW8dYAlwz6WmXq/JBMyJPC6ze7e2gPtCpU3k1ecCRXyzMMPH0kfYeCmNWZ1AWO5TpbkuEbJniMY1eZKxu0TrzkaP9+mKVDJgaOz0LZwvdCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1wiwuQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1wiwuQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B3EC4CEF1;
	Fri, 21 Nov 2025 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733369;
	bh=S5ArCdLzm1vLEixwrUGuMH1jq1R/FHRWqzdM8pxfU2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1wiwuQN7pPuWSPbX4O+isnZa7c5zuVcoCFwnsMjvCYjY29dKQhJ9ZarilKB5wkHw
	 vxm84oK+RymfBR+fp4tlC8H3Y8MNrhdt0SVuxFNQBQYZ+ybbhGTRRLMG8+rapFOJjP
	 TzsqP3n4UK89EUb5w9sE4RyYZBGErQalTf9YOykY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 445/529] acpi/hmat: Fix lockdep warning for hmem_register_resource()
Date: Fri, 21 Nov 2025 14:12:24 +0100
Message-ID: <20251121130246.845735565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 214291cbaaceeb28debd773336642b1fca393ae0 ]

The following lockdep splat was observed while kernel auto-online a CXL
memory region:

======================================================
WARNING: possible circular locking dependency detected
6.17.0djtest+ #53 Tainted: G        W
------------------------------------------------------
systemd-udevd/3334 is trying to acquire lock:
ffffffff90346188 (hmem_resource_lock){+.+.}-{4:4}, at: hmem_register_resource+0x31/0x50

but task is already holding lock:
ffffffff90338890 ((node_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x2e/0x70

which lock already depends on the new lock.
[..]
Chain exists of:
  hmem_resource_lock --> mem_hotplug_lock --> (node_chain).rwsem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock((node_chain).rwsem);
                               lock(mem_hotplug_lock);
                               lock((node_chain).rwsem);
  lock(hmem_resource_lock);

The lock ordering can cause potential deadlock. There are instances
where hmem_resource_lock is taken after (node_chain).rwsem, and vice
versa.

Split out the target update section of hmat_register_target() so that
hmat_callback() only envokes that section instead of attempt to register
hmem devices that it does not need to.

[ dj: Fix up comment to be closer to 80cols. (Jonathan) ]

Fixes: cf8741ac57ed ("ACPI: NUMA: HMAT: Register "soft reserved" memory as an "hmem" device")
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20251105235115.85062-3-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 46 ++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 570be52c8d90a..ea620ebd0c7c1 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -780,10 +780,32 @@ static void hmat_register_target_devices(struct memory_target *target)
 	}
 }
 
-static void hmat_register_target(struct memory_target *target)
+static void hmat_hotplug_target(struct memory_target *target)
 {
 	int nid = pxm_to_node(target->memory_pxm);
 
+	/*
+	 * Skip offline nodes. This can happen when memory marked EFI_MEMORY_SP,
+	 * "specific purpose", is applied to all the memory in a proximity
+	 * domain leading to * the node being marked offline / unplugged, or if
+	 * memory-only "hotplug" node is offline.
+	 */
+	if (nid == NUMA_NO_NODE || !node_online(nid))
+		return;
+
+	guard(mutex)(&target_lock);
+	if (target->registered)
+		return;
+
+	hmat_register_target_initiators(target);
+	hmat_register_target_cache(target);
+	hmat_register_target_perf(target, ACCESS_COORDINATE_LOCAL);
+	hmat_register_target_perf(target, ACCESS_COORDINATE_CPU);
+	target->registered = true;
+}
+
+static void hmat_register_target(struct memory_target *target)
+{
 	/*
 	 * Devices may belong to either an offline or online
 	 * node, so unconditionally add them.
@@ -801,25 +823,7 @@ static void hmat_register_target(struct memory_target *target)
 	}
 	mutex_unlock(&target_lock);
 
-	/*
-	 * Skip offline nodes. This can happen when memory
-	 * marked EFI_MEMORY_SP, "specific purpose", is applied
-	 * to all the memory in a proximity domain leading to
-	 * the node being marked offline / unplugged, or if
-	 * memory-only "hotplug" node is offline.
-	 */
-	if (nid == NUMA_NO_NODE || !node_online(nid))
-		return;
-
-	mutex_lock(&target_lock);
-	if (!target->registered) {
-		hmat_register_target_initiators(target);
-		hmat_register_target_cache(target);
-		hmat_register_target_perf(target, ACCESS_COORDINATE_LOCAL);
-		hmat_register_target_perf(target, ACCESS_COORDINATE_CPU);
-		target->registered = true;
-	}
-	mutex_unlock(&target_lock);
+	hmat_hotplug_target(target);
 }
 
 static void hmat_register_targets(void)
@@ -845,7 +849,7 @@ static int hmat_callback(struct notifier_block *self,
 	if (!target)
 		return NOTIFY_OK;
 
-	hmat_register_target(target);
+	hmat_hotplug_target(target);
 	return NOTIFY_OK;
 }
 
-- 
2.51.0



