Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1EA3C1D57;
	Sat, 12 Sep 2026 07:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197111; cv=none; b=WZLK26l95MST3HacjsS7FFNVU/anZb2EPHnGDtJ/hW+nzzBGoR5mTGxQW4ESXV70p01ul1mWl3YKwyh/q/3Arr9QiWk+g8yYnarmGAqFD23l/jy0bFcXTbMj7rlH4VBWa7yyBT3SzVm+XbMesuhah1KV5e5rgOxR9a5BV6AFiZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197111; c=relaxed/simple;
	bh=+GiHQ5ZHK5KHmOV/64L9xNo8BuuhksYV9kVVrX7X5Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzUmGl8lBSXi7s+9sts919rYps8OIlyV6Jmwb+nzvkCq4EP0rA+FiaSsa9NCFIqQN9F2JuY78oMzIw72zhB1j/X1nX/BOUAt639xOpdNZAHphX6rhwZRuyR5h4mSUdF1oyOzIaDL92l/oqtr4dfIm/CXVxZperCaOz8TkoRocDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKAV+HFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKAV+HFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6311F000FF;
	Sat, 12 Sep 2026 07:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197110;
	bh=9w+wOf1LNEfq3vFOa3NjmpltkD8B6zQTVcBuGRJKPfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKAV+HFBBpCZuyhuJpBtB1CyRD1kE+CUp+kNoUXwBIo/PP+xzw1NfK+riAeVJlO2s
	 6MfjsUPUI8HGUb6n7Z00JTfZKCjcB69L4TQgypd7F4Ax9RaypNGM2ko5351qpd+ltP
	 FlaxbwJq4SRImMQXJH36yHeOt/y87P45i2gj2XT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0104/1815] perf/x86/intel/uncore: Fix refcnt and other cleanups
Date: Sat, 12 Sep 2026 08:30:54 +0200
Message-ID: <20260912065651.449240717@linuxfoundation.org>
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

[ Upstream commit 7d3a9ff98898b3521eb5d7a3daf703b383f7935a ]

Fix typo UNCORE_BOX_FLAG_INITIATED to UNCORE_BOX_FLAG_INITIALIZED.

Rename the 'id' parameter in uncore_box_{ref,unref}() to 'die' to
reflect its actual meaning and be consistent with other functions.

box->refcnt is incremented in the PCI PMU register path but has never
been checked or decremented. Although for PCI PMUs box->refcnt
effectively tracks only a single user, add atomic_dec_return() in the
PCI PMU unregister path to make the reference counting complete and
consistent.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-3-zide.chen@intel.com
Stable-dep-of: 174f0582e38a ("perf/x86/intel/uncore: Fix uncore_box ref/unref ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 16 +++++++++-------
 arch/x86/events/intel/uncore.h |  6 +++---
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index b2f5ff494aae1..eae335df7634e 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1255,8 +1255,10 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
-	uncore_box_exit(box);
-	kfree(box);
+	if (atomic_dec_return(&box->refcnt) == 0) {
+		uncore_box_exit(box);
+		kfree(box);
+	}
 }
 
 static void uncore_pci_remove(struct pci_dev *pdev)
@@ -1518,7 +1520,7 @@ static void uncore_change_context(struct intel_uncore_type **uncores,
 		uncore_change_type_ctx(*uncores, old_cpu, new_cpu);
 }
 
-static void uncore_box_unref(struct intel_uncore_type **types, int id)
+static void uncore_box_unref(struct intel_uncore_type **types, int die)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -1529,7 +1531,7 @@ static void uncore_box_unref(struct intel_uncore_type **types, int id)
 		type = *types;
 		pmu = type->pmus;
 		for (i = 0; i < type->num_boxes; i++, pmu++) {
-			box = pmu->boxes[id];
+			box = pmu->boxes[die];
 			if (box && box->cpu >= 0 && atomic_dec_return(&box->refcnt) == 0)
 				uncore_box_exit(box);
 		}
@@ -1604,14 +1606,14 @@ static int allocate_boxes(struct intel_uncore_type **types,
 }
 
 static int uncore_box_ref(struct intel_uncore_type **types,
-			  int id, unsigned int cpu)
+			  int die, unsigned int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
 	int i, ret;
 
-	ret = allocate_boxes(types, id, cpu);
+	ret = allocate_boxes(types, die, cpu);
 	if (ret)
 		return ret;
 
@@ -1619,7 +1621,7 @@ static int uncore_box_ref(struct intel_uncore_type **types,
 		type = *types;
 		pmu = type->pmus;
 		for (i = 0; i < type->num_boxes; i++, pmu++) {
-			box = pmu->boxes[id];
+			box = pmu->boxes[die];
 			if (box && box->cpu >= 0 && atomic_inc_return(&box->refcnt) == 1)
 				uncore_box_init(box);
 		}
diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index c2e5ccb1d72c4..bad5d8dec8e04 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -185,7 +185,7 @@ struct intel_uncore_box {
 #define CFL_UNC_CBO_7_PERFEVTSEL0		0xf70
 #define CFL_UNC_CBO_7_PER_CTR0			0xf76
 
-#define UNCORE_BOX_FLAG_INITIATED		0
+#define UNCORE_BOX_FLAG_INITIALIZED		0
 /* event config registers are 8-byte apart */
 #define UNCORE_BOX_FLAG_CTL_OFFS8		1
 /* CFL 8th CBOX has different MSR space */
@@ -559,7 +559,7 @@ static inline u64 uncore_read_counter(struct intel_uncore_box *box,
 
 static inline void uncore_box_init(struct intel_uncore_box *box)
 {
-	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags)) {
+	if (!test_and_set_bit(UNCORE_BOX_FLAG_INITIALIZED, &box->flags)) {
 		if (box->pmu->type->ops->init_box)
 			box->pmu->type->ops->init_box(box);
 	}
@@ -567,7 +567,7 @@ static inline void uncore_box_init(struct intel_uncore_box *box)
 
 static inline void uncore_box_exit(struct intel_uncore_box *box)
 {
-	if (test_and_clear_bit(UNCORE_BOX_FLAG_INITIATED, &box->flags)) {
+	if (test_and_clear_bit(UNCORE_BOX_FLAG_INITIALIZED, &box->flags)) {
 		if (box->pmu->type->ops->exit_box)
 			box->pmu->type->ops->exit_box(box);
 	}
-- 
2.53.0



