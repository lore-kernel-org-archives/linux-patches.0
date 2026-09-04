Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB36412294;
	Fri,  4 Sep 2026 05:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500302; cv=none; b=SJHS8PA0Mgw27aq/Y6t1cGVT6sS/lZbB8tQwQxHzlbWvl58tVbSlXoJ07pzS4fPHGaq14voxVqCdzJ+FERmQrxEwch2c4OQWRY7Z7uv49Xz/yBDUfyyEc1Q+3ijxbfwwB1tmy+Z+K0oJ/3DHEbjkYaLYnPge7xQOS77+3O0X8lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500302; c=relaxed/simple;
	bh=Kk21t4K8v0wVuQUSblmH/VKGfPot8TsF3Z4HAFJ1SC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjNYL7zLAfASDdEa9LipmXot7nVKEh4i7AysFPFWweEd+8T1dWlT1MXRABhopHf/QyG1Hct4j5wRnFVjBu1NHRU6xiAKKpfKR5mLu1F7AGBxpsuSBjl0K5gDmIxB9LOryoAI+s05LiFCgnMz1f9jhhT5BINXET82Kf6IiPX3kJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGnp4bZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGnp4bZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EC81F00A3D;
	Fri,  4 Sep 2026 05:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500301;
	bh=J7lS5KQ5EowycYq4VnYB0t2sFuRiFWeYSVYgpUwvYVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGnp4bZGd+34bdG+rEJZsE9in5bn5ejJrpTWxzmkH/U5f778Nil3nyoHksZZBmx7j
	 tayuSdarxKKIGOD4CvOwZQGgTofyFDEydsUHKDWt+5UNX9YePLiGpUo5Cr3G7uomeo
	 6epmtqYa0Hecv1GPkWGjNccsbOR6o7wsuGuJOIb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/552] perf/x86/intel/uncore: Fix die ID init and look up bugs
Date: Fri,  4 Sep 2026 06:52:38 +0200
Message-ID: <20260904045747.854369727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit a16d1ec4dd0cdcf689f324adde6067083bce9099 ]

In snbep_pci2phy_map_init(), in the nr_node_ids > 8 path,
uncore_device_to_die() may return -1 when all CPUs associated
with the UBOX device are offline.

Remove the WARN_ON_ONCE(die_id == -1) check for two reasons:

- The current code breaks out of the loop. This is incorrect because
  pci_get_device() does not guarantee iteration in domain or bus order,
  so additional UBOX devices may be skipped during the scan.

- Returning -EINVAL is incorrect, since marking offline buses with
  die_id == -1 is expected and should not be treated as an error.

Separately, when NUMA is disabled on a NUMA-capable platform,
pcibus_to_node() returns NUMA_NO_NODE, causing uncore_device_to_die()
to return -1 for all PCI devices.  As a result,
spr_update_device_location(), used on Intel SPR and EMR, ignores the
corresponding PMON units and does not add them to the RB tree.

Fix this by using uncore_pcibus_to_dieid(), which retrieves topology
from the UBOX GIDNIDMAP register and works regardless of whether NUMA
is enabled in Linux.  This requires snbep_pci2phy_map_init() to be
added in spr_uncore_pci_init().

Keep uncore_device_to_die() only for the nr_node_ids > 8 case, where
NUMA is expected to be enabled.

Fixes: 9a7832ce3d92 ("perf/x86/intel/uncore: With > 8 nodes, get pci bus die id from NUMA info")
Fixes: 65248a9a9ee1 ("perf/x86/uncore: Add a quirk for UPI on SPR")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Steve Wahl <steve.wahl@hpe.com>
Link: https://patch.msgid.link/20260313174050.171704-4-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c       |  1 +
 arch/x86/events/intel/uncore_snbep.c | 13 ++++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index e228e564b15ea..8301a589d9a61 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -67,6 +67,7 @@ int uncore_die_to_segment(int die)
 	return bus ? pci_domain_nr(bus) : -EINVAL;
 }
 
+/* Note: This API can only be used when NUMA information is available. */
 int uncore_device_to_die(struct pci_dev *dev)
 {
 	int node = pcibus_to_node(dev->bus);
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index a338ee01bb242..0182785cad1fe 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1475,13 +1475,7 @@ static int snbep_pci2phy_map_init(int devid, int nodeid_loc, int idmap_loc, bool
 			}
 
 			map->pbus_to_dieid[bus] = die_id = uncore_device_to_die(ubox_dev);
-
 			raw_spin_unlock(&pci2phy_map_lock);
-
-			if (WARN_ON_ONCE(die_id == -1)) {
-				err = -EINVAL;
-				break;
-			}
 		}
 	}
 
@@ -6533,7 +6527,7 @@ static void spr_update_device_location(int type_id)
 
 	while ((dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, dev)) != NULL) {
 
-		die = uncore_device_to_die(dev);
+		die = uncore_pcibus_to_dieid(dev->bus);
 		if (die < 0)
 			continue;
 
@@ -6557,6 +6551,11 @@ static void spr_update_device_location(int type_id)
 
 int spr_uncore_pci_init(void)
 {
+	int ret = snbep_pci2phy_map_init(0x3250, SKX_CPUNODEID, SKX_GIDNIDMAP, true);
+
+	if (ret)
+		return ret;
+
 	/*
 	 * The discovery table of UPI on some SPR variant is broken,
 	 * which impacts the detection of both UPI and M3UPI uncore PMON.
-- 
2.53.0



