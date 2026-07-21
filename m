Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072CD46AA83;
	Tue, 21 Jul 2026 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649138; cv=none; b=k7xwwVIbiI5lJgXNfIy8IUUzVZ3Jsi1T1pgabdyTzHgKdI1ssWthAFIqjZ3Iu1Dj8famHXInuUJjsDfYyVJk2nfsjyF7RNAUdgX6cCYmi0blc52TuRy7tFljlJj99x+TX0HLaP71FlS24THOFSksEGOKCfvyhHlA/WLApXrKMIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649138; c=relaxed/simple;
	bh=l/p1iTNgU8Z80VgcSmjRAXAh2N2zTZzHfAqILNm2jqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olCaoNjp9gQd29QNSZVlNDScLZc3dpSjKaLz7ke5PP+p4yl7aNuefR1LIZf1TObkLzuAmrTpN+5Z3X42Q6rzjONj/hf99VKIuUnykTcASy3FECeUjehG5rHRVScE7ToTeR1DHHx62fbu4VrcjiRpNwUzj9QQVKy1OUAc5j3IX04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkfH+dPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkfH+dPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6801F00A3D;
	Tue, 21 Jul 2026 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649136;
	bh=XYpy3Bm2sbHeqPGl6KrKkEweMfQ2FkmLjOdWcu+ImPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkfH+dPs2A4H6162UhByT+QS9dkY/Hf/AeptnXmuzi2JeZ2+u/qi8VZrvIXqfqL3x
	 JdVV/RKqNrOfdGAkuqSeqUCqsl2WrwfNNAErr+SlfHqHrJQObs8GqWEz8mUVCz0ZAZ
	 lk6/brV6yXgF0VIvI3Pg9wAVKVeqMC9zR8mCxlW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0465/2077] perf/x86/intel/uncore: Fix PCI device refcount leak in UPI discovery
Date: Tue, 21 Jul 2026 17:02:18 +0200
Message-ID: <20260721152603.761880743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 81ec618f59415bdcf3e8989e2691c1f240be27fb ]

pci_get_domain_bus_and_slot() increments the reference count of the
returned PCI device and therefore requires a matching pci_dev_put().

In skx_upi_topology_cb() and discover_upi_topology(), the lookup is
performed inside a loop, but pci_dev_put() is only called once after
the loop. As a result, references from all previous iterations are
leaked.

Move pci_dev_put(dev) into the if (dev) block immediately after
upi_fill_topology() returns.

Opportunistically, fix uninitialized variable in skx_upi_topology_cb().

Fixes: 4cfce57fa42d ("perf/x86/intel/uncore: Enable UPI topology discovery for Skylake Server")
Fixes: f680b6e6062e ("perf/x86/intel/uncore: Enable UPI topology discovery for Icelake Server")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260602144908.263680-4-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 215d33e260ede7..c9ce206fcbb6e7 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4261,7 +4261,7 @@ static int upi_fill_topology(struct pci_dev *dev, struct intel_uncore_topology *
 static int skx_upi_topology_cb(struct intel_uncore_type *type, int segment,
 				int die, u64 cpu_bus_msr)
 {
-	int idx, ret;
+	int idx, ret = 0;
 	struct intel_uncore_topology *upi;
 	unsigned int devfn;
 	struct pci_dev *dev = NULL;
@@ -4274,12 +4274,12 @@ static int skx_upi_topology_cb(struct intel_uncore_type *type, int segment,
 		dev = pci_get_domain_bus_and_slot(segment, bus, devfn);
 		if (dev) {
 			ret = upi_fill_topology(dev, upi, idx);
+			pci_dev_put(dev);
 			if (ret)
 				break;
 		}
 	}
 
-	pci_dev_put(dev);
 	return ret;
 }
 
@@ -5499,6 +5499,7 @@ static int discover_upi_topology(struct intel_uncore_type *type, int ubox_did, i
 							  devfn);
 			if (dev) {
 				ret = upi_fill_topology(dev, upi, idx);
+				pci_dev_put(dev);
 				if (ret)
 					goto err;
 			}
@@ -5506,7 +5507,6 @@ static int discover_upi_topology(struct intel_uncore_type *type, int ubox_did, i
 	}
 err:
 	pci_dev_put(ubox);
-	pci_dev_put(dev);
 	return ret;
 }
 
-- 
2.53.0



