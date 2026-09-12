Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799ED39448F;
	Sat, 12 Sep 2026 07:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197106; cv=none; b=KH0+hDLM8SW/x9qRwd/3hZOGjb4gDTCt1ScJCfM3JEbCWFne9PaMLQ/iUAaGFd5VDu6wKGpCrCdRavcQtu5pZR6rpYs/UY6+8UG+zbinhmcp9kr5aqOuwa4YUXphKZ2lExO7AqY4KgfTdSCJajFibb2HWy0nrUYf9q9TBUZwyso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197106; c=relaxed/simple;
	bh=cqr5O0dXkvWn44jjRkEVPTyabvcxR9eAKbeHww+sTb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWH3DrL1SJee8Q4WRAE9sxlhg8zUDp+jObgDzv8OvHCkwk6cZ/rB4KiU1Nnz4GUJKxW27R+bdA11VMYWQquF9ulr4j/FdmgUmLZISW9tIxHervy3DdmP5lxvB44d/ahhOSJHuNSMr24Qp6nyUykECHMMdymYt7zKLcRWO/W8X8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AftajZoe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AftajZoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E2F1F000FF;
	Sat, 12 Sep 2026 07:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197105;
	bh=0sh+pQ5D8XRFO0r83xHy3l3GGbmo3Q25TC3Iidc49p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AftajZoek2cYHVYSe2EJ6Lbd/y1JQrtG/+QeHQIEMismBlrSFIjFuT8CO9gkcTVXf
	 lKwYrcCL+vxE52jTjM84Gpje8BoAu2V1F2m/7RYDqQLXsqE8HMgp21xJ198BJj0FKn
	 ryp+2pcwBMrbKUSrlvDLNAENb5sSDuaOzB7Dj66k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0103/1815] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Sat, 12 Sep 2026 08:30:53 +0200
Message-ID: <20260912065651.425809377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 003267cb94e21d762eb72d6977d84f44f1705bb7 ]

When uncore_pci_pmu_register() fails, pmu->boxes[die] is set to NULL
before returning.  In the uncore_pci_remove() path, this causes
uncore_pci_pmu_unregister() to be skipped entirely, leaking
pmu->activeboxes.  In the uncore_bus_notify() path,
uncore_pci_pmu_unregister() may still be called and must exit early
when pmu->boxes[die] is NULL to avoid a NULL pointer dereference, and
to ensure activeboxes is only decremented for a previously active box.

Additionally, since pci_get_drvdata() returns NULL on registration
failure, uncore_pci_remove() can no longer treat NULL drvdata as an
indicator of an auxiliary PCI device.  Remove the associated
WARN_ON_ONCE().

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://sashiko.dev/#/patchset/20260512233048.9577-1-zide.chen@intel.com?part=1
Link: https://patch.msgid.link/20260611160033.66760-2-zide.chen@intel.com
Stable-dep-of: 174f0582e38a ("perf/x86/intel/uncore: Fix uncore_box ref/unref ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index cb61f2a65d853..b2f5ff494aae1 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1183,6 +1183,7 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	/* First active box registers the pmu */
 	ret = uncore_pmu_register(pmu);
 	if (ret) {
+		atomic_dec(&pmu->activeboxes);
 		pmu->boxes[die] = NULL;
 		uncore_box_exit(box);
 		kfree(box);
@@ -1248,6 +1249,9 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 {
 	struct intel_uncore_box *box = pmu->boxes[die];
 
+	if (!box)
+		return;
+
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
@@ -1272,7 +1276,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 				break;
 			}
 		}
-		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
 		return;
 	}
 
-- 
2.53.0



