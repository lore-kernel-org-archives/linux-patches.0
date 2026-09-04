Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50683F4101;
	Fri,  4 Sep 2026 06:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501966; cv=none; b=MUb92HO8uM+/ipPhxORErJtTqcNyLBG0VHI/crLMHWagr8TERC3THi7LCrUWDDUYrj+DFAoa7nXfixZJ6Az0QLEraRE7ChjIqBbigOQ5cTLptGuEdj3xgc2J+u4e1bGz+dinSKoFnNo3ExIsD7WEBGW+rvdWRVl0yTO61JdaizQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501966; c=relaxed/simple;
	bh=qx3iZCFy2ch7RwDXcv2RndtikbzZhXBlLLZ29fMujU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdcjWFsqcCGy64tgxZzZoO+ORKupv1hfhErvSOlgtVg4rKHpfeTLkDB2AnR0rBahRPVtgcoDlELwlDmhJ0NU/lK4zVPY0P0BN14AQkAmWQeRxmhQdc8JO6injEtnQSJd53+e+FJ9v48IaK06pdh2Zh1ltVyJh3peXbs5A4fSCQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXIcNgpE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXIcNgpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A231F00A3D;
	Fri,  4 Sep 2026 06:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501964;
	bh=6lygDirfAEOc6YPYR1vhhzbdcSJZHOf+VUsFWTRCvRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXIcNgpEvxSwQ225n63VvLfY0tjjNI79cG5vMJ5vcur3knWtFzUD6T6ume21Y5rBD
	 MgR0bopi1rr3VgMUYSOgFjIbo2pqUeagwX3XUbWTXwKSUaFPJPsgEoEva4AnI81Kbu
	 v+XHrBEpQg6nHCtbe2BwD9saHUVw7iRNwmPmbmn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/403] perf/x86/intel/uncore: Fix die ID init and look up bugs
Date: Fri,  4 Sep 2026 06:56:49 +0200
Message-ID: <20260904045734.956152632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e7aba7349231d..96607174a0a93 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -66,6 +66,7 @@ int uncore_die_to_segment(int die)
 	return bus ? pci_domain_nr(bus) : -EINVAL;
 }
 
+/* Note: This API can only be used when NUMA information is available. */
 int uncore_device_to_die(struct pci_dev *dev)
 {
 	int node = pcibus_to_node(dev->bus);
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index c453ee7a52074..ca0193cbbe924 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1474,13 +1474,7 @@ static int snbep_pci2phy_map_init(int devid, int nodeid_loc, int idmap_loc, bool
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
 
@@ -6530,7 +6524,7 @@ static void spr_update_device_location(int type_id)
 
 	while ((dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, dev)) != NULL) {
 
-		die = uncore_device_to_die(dev);
+		die = uncore_pcibus_to_dieid(dev->bus);
 		if (die < 0)
 			continue;
 
@@ -6554,6 +6548,11 @@ static void spr_update_device_location(int type_id)
 
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



