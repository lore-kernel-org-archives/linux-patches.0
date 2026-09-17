Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0BC5172CC;
	Thu, 17 Sep 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664313; cv=none; b=iN9dJ46EfKFKOF0lfTudktZi2dPj1o9oH7j4t/Ep8RCWENsQF23NAHu5SH/F/59VPmITt/qeXAEa4a1NvjpokJBNFrzwTiRS0FobmoqGj2wg1RYKk37kwJo7h8j9PtHJu09Liw8gMWzU1aP0nijp1P0o/1kEAvGBNF+54Lx9C6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664313; c=relaxed/simple;
	bh=HgJJ/tKDn7dzEGza14BcxQbgNkuUbW9Q5fWblHEOLwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIAOfTNUcJ3fhWjqxKXjjMdIiPQwbi64GL7IY5IUGPl/kJbZAal4JXxTVXOrSN1ND8X/mro3TNf4gMxlAaeSQEykHo1kfNV/l677MkvNMBE1SgFx6KniciX+/lcZcoBLAMapU6l/QNk1Eic5vPYXItGOLJS/3Vjl5yNn20pSer4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUFoRKDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUFoRKDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EF11F00893;
	Thu, 17 Sep 2026 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664312;
	bh=RvJHPzosKZCE3/+XMgfMr7VVjTmieLKE+yWZpTTGKWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUFoRKDkacckPPTCeqZwT9s6niSOzchaX6bUIe0ssUacznqrNKTukyJdJqftx7FqS
	 239Uif1KYF/9oBrFzyUJC+rcwRgaRCoKB27VOCf7Q/7NbVpbKaLF7CUizgt468O3wj
	 5rLVpHvtbsnCj3gijH7DBsaJ5gUoxChM+GSyM8+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0329/1250] perf/x86/intel/uncore: Guard against invalid box control address
Date: Thu, 17 Sep 2026 16:02:04 +0100
Message-ID: <20260917151601.010102213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 3c19ea24f02658c4b8ad364458fae4d77fdb3fae ]

Theoretically, intel_uncore_find_discovery_unit() could return NULL,
e.g., when a CPU die is offline during uncore enumeration and its PMU
units are not added to the discovery RB-tree.

Guard against a NULL return value and the resulting invalid box control
address (0) before accessing hardware.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260602144908.263680-3-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_discovery.c | 33 +++++++++++++++++-------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/uncore_discovery.c b/arch/x86/events/intel/uncore_discovery.c
index 7dd3910d8de3a..8595e14199ed4 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -489,17 +489,28 @@ static u64 intel_generic_uncore_box_ctl(struct intel_uncore_box *box)
 
 void intel_generic_uncore_msr_init_box(struct intel_uncore_box *box)
 {
-	wrmsrq(intel_generic_uncore_box_ctl(box), GENERIC_PMON_BOX_CTL_INT);
+	u64 box_ctl = intel_generic_uncore_box_ctl(box);
+
+	if (!box_ctl)
+		return;
+
+	wrmsrq(box_ctl, GENERIC_PMON_BOX_CTL_INT);
 }
 
 void intel_generic_uncore_msr_disable_box(struct intel_uncore_box *box)
 {
-	wrmsrq(intel_generic_uncore_box_ctl(box), GENERIC_PMON_BOX_CTL_FRZ);
+	u64 box_ctl = intel_generic_uncore_box_ctl(box);
+
+	if (box_ctl)
+		wrmsrq(box_ctl, GENERIC_PMON_BOX_CTL_FRZ);
 }
 
 void intel_generic_uncore_msr_enable_box(struct intel_uncore_box *box)
 {
-	wrmsrq(intel_generic_uncore_box_ctl(box), 0);
+	u64 box_ctl = intel_generic_uncore_box_ctl(box);
+
+	if (box_ctl)
+		wrmsrq(box_ctl, 0);
 }
 
 static void intel_generic_uncore_msr_enable_event(struct intel_uncore_box *box,
@@ -548,6 +559,7 @@ bool intel_generic_uncore_assign_hw_event(struct perf_event *event,
 
 	if (box->pci_dev) {
 		box_ctl = UNCORE_DISCOVERY_PCI_BOX_CTRL(box_ctl);
+
 		hwc->config_base = box_ctl + uncore_pci_event_ctl(box, hwc->idx);
 		hwc->event_base  = box_ctl + uncore_pci_perf_ctr(box, hwc->idx);
 		return true;
@@ -566,27 +578,30 @@ static inline int intel_pci_uncore_box_ctl(struct intel_uncore_box *box)
 
 void intel_generic_uncore_pci_init_box(struct intel_uncore_box *box)
 {
-	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = intel_pci_uncore_box_ctl(box);
 
+	if (!box_ctl)
+		return;
+
 	__set_bit(UNCORE_BOX_FLAG_CTL_OFFS8, &box->flags);
-	pci_write_config_dword(pdev, box_ctl, GENERIC_PMON_BOX_CTL_INT);
+	pci_write_config_dword(box->pci_dev, box_ctl, GENERIC_PMON_BOX_CTL_INT);
 }
 
 void intel_generic_uncore_pci_disable_box(struct intel_uncore_box *box)
 {
-	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = intel_pci_uncore_box_ctl(box);
 
-	pci_write_config_dword(pdev, box_ctl, GENERIC_PMON_BOX_CTL_FRZ);
+	if (box_ctl)
+		pci_write_config_dword(box->pci_dev, box_ctl,
+				       GENERIC_PMON_BOX_CTL_FRZ);
 }
 
 void intel_generic_uncore_pci_enable_box(struct intel_uncore_box *box)
 {
-	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = intel_pci_uncore_box_ctl(box);
 
-	pci_write_config_dword(pdev, box_ctl, 0);
+	if (box_ctl)
+		pci_write_config_dword(box->pci_dev, box_ctl, 0);
 }
 
 static void intel_generic_uncore_pci_enable_event(struct intel_uncore_box *box,
-- 
2.53.0



