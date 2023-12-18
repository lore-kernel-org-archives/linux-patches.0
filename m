Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93383D566;
	Mon, 18 Dec 2023 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4TZy6+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDD9C433C8;
	Mon, 18 Dec 2023 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908719;
	bh=mvOQP9c7sc0nCXYw0heHu1RLcfpU0/Ow9ErhVZRIN5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4TZy6+xUi13dLCGiZBSTTmLTL/tMISDBStakUVmrUJsHz1YpAHZISLE0biPBzXkA
	 78jwFmgoD4QwNVOqayCjw/mW0Prm2NZDV86rP525AN1+aWf6J6j4mPQDl+4AXNxYyj
	 ne7/IS9E9GKvhIJjFElYWc7HcGmwlXFWbp5vebnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Michael Petlan <mpetlan@redhat.com>,
	Mahmoud Adam <mngyadam@amazon.com>
Subject: [PATCH 5.15 01/83] perf/x86/uncore: Dont WARN_ON_ONCE() for a broken discovery table
Date: Mon, 18 Dec 2023 14:51:22 +0100
Message-ID: <20231218135049.813574262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 5d515ee40cb57ea5331998f27df7946a69f14dc3 upstream.

The kernel warning message is triggered, when SPR MCC is used.

[   17.945331] ------------[ cut here ]------------
[   17.946305] WARNING: CPU: 65 PID: 1 at
arch/x86/events/intel/uncore_discovery.c:184
intel_uncore_has_discovery_tables+0x4c0/0x65c
[   17.946305] Modules linked in:
[   17.946305] CPU: 65 PID: 1 Comm: swapper/0 Not tainted
5.4.17-2136.313.1-X10-2c+ #4

It's caused by the broken discovery table of UPI.

The discovery tables are from hardware. Except for dropping the broken
information, there is nothing Linux can do. Using WARN_ON_ONCE() is
overkilled.

Use the pr_info() to replace WARN_ON_ONCE(), and specify what uncore unit
is dropped and the reason.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Michael Petlan <mpetlan@redhat.com>
Link: https://lore.kernel.org/r/20230112200105.733466-6-kan.liang@linux.intel.com
Cc: Mahmoud Adam <mngyadam@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_discovery.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -140,13 +140,21 @@ uncore_insert_box_info(struct uncore_uni
 	unsigned int *box_offset, *ids;
 	int i;
 
-	if (WARN_ON_ONCE(!unit->ctl || !unit->ctl_offset || !unit->ctr_offset))
+	if (!unit->ctl || !unit->ctl_offset || !unit->ctr_offset) {
+		pr_info("Invalid address is detected for uncore type %d box %d, "
+			"Disable the uncore unit.\n",
+			unit->box_type, unit->box_id);
 		return;
+	}
 
 	if (parsed) {
 		type = search_uncore_discovery_type(unit->box_type);
-		if (WARN_ON_ONCE(!type))
+		if (!type) {
+			pr_info("A spurious uncore type %d is detected, "
+				"Disable the uncore type.\n",
+				unit->box_type);
 			return;
+		}
 		/* Store the first box of each die */
 		if (!type->box_ctrl_die[die])
 			type->box_ctrl_die[die] = unit->ctl;
@@ -181,8 +189,12 @@ uncore_insert_box_info(struct uncore_uni
 		ids[i] = type->ids[i];
 		box_offset[i] = type->box_offset[i];
 
-		if (WARN_ON_ONCE(unit->box_id == ids[i]))
+		if (unit->box_id == ids[i]) {
+			pr_info("Duplicate uncore type %d box ID %d is detected, "
+				"Drop the duplicate uncore unit.\n",
+				unit->box_type, unit->box_id);
 			goto free_ids;
+		}
 	}
 	ids[i] = unit->box_id;
 	box_offset[i] = unit->ctl - type->box_ctrl;


