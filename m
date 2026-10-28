Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214870;
	b=xPZUiO2Dj/QtoxJiCyG1kWjAEdzs1mUjrzi65OQWRLGaXPo6XpzU3cRH7x4JgvugHxAe
	 9wAf9CroS+quSBvc4QwbqkBcZQx2pJNg7UWEPgNRyitReL2usYE/9eUiIPk8gkO1UMbTC
	 c/GGI/Y/Ko1HJOVjcge2YsHJidyHD7SXt8jzYk13oueWFyKzuy97rZnbm2RS+INTVrbJT
	 JWssNhrEML9rP5Gcf9/CxggqCoFxheHl6gva/IGT8rzGvqZfXQjY/0bYIGvZrhVKFfyBU
	 B6uqk0mCsvg1BVuLmwDXMro95YGqDMv1pqonx6ZCObmrULdSkJVx8DFoW9j4jkQl7Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pS1uotOAHSGkqYPMeUGUXW/XmBsW04PAlY3k5mVAZKQ=;
	b=PUTq3UgAKKC8fdZ5hlTWuyOfWo8eNWyeRfy+igLNhEuw4fc5M4i0lOiWyru4ieq24YTB
	 mz4GyQp1c62rmF3NRAx9EueIFAJLKPDvME1CcnW0urxNRTrPis8GwhbXNoiHrvvzVJLgY
	 xWk+bp5Op7ORfIRD+hTu/xpFOyVSsUi8uKw9So669ddP+ZRRkpKBNOib58Uv2m2X9VGcQ
	 nY1gcw+sB7DdubOEHFt85k0m4BmhrOIn9TbDfc0UOBIZfjgNEjzsyRUsjt0cuQLY9qWp1
	 nQf1/4+veQfS120f7OFd8UGwo64Qxj1REsmGElw+kbHyt2qcma9KhfAgRG00SU7h+XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W69QXB29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BFD606A32A;
	Wed, 28 Oct 2026 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W69QXB29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3581F01825;
	Wed, 28 Oct 2026 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214869;
	bh=pS1uotOAHSGkqYPMeUGUXW/XmBsW04PAlY3k5mVAZKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W69QXB29XAWZJeoLzfWPusboKDY1GLjh2faO4fG5l1ZLWR0P72DUYOPID2rY3opPs
	 yGQy18aYgo3huEvbjbC30nFPibAy0XGY/idMEslxMhTCl9H958WjwyGIUW+nckNcgj
	 16CHWqDMlGPc72N+6XMSarbYwrdcrpmiDJXrIgg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1012/1887] perf/x86/intel/uncore: Fix die ID init and look up bugs
Date: Wed, 28 Oct 2026 17:51:48 +0100
Message-ID: <20261028170522.444945913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/events/intel/uncore_snbep.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 831c4e3f371a4..8a5e476559742 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1458,11 +1458,6 @@ static int snbep_pci2phy_map_init(int devid, int nodeid_loc, int idmap_loc, bool
 				}
 			}
 			raw_spin_unlock(&pci2phy_map_lock);
-
-			if (WARN_ON_ONCE(die_id == -1)) {
-				err = -EINVAL;
-				break;
-			}
 		}
 	}
 
-- 
2.53.0



