Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D486D745D6;
	Mon,  8 Apr 2024 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583922; cv=none; b=VUqL8yVebVuVn29nZmPpTY2s//M9jUf8yJBPKQd0WAA9d/+ZYLcZ3x/L6skGouQdnmFOSM0oh0LW4ZYra3rn2NmRgUzoTc6HVct4UxRA7PnnHlfg9DrfckmkiHcFd8dRHJx6WGuu/EbrkjCS+H+40R8zzvG3NkVr2ioV7zJ3AIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583922; c=relaxed/simple;
	bh=8BA+CxJ7twa7wDmzc+yzrcAMpNPiiucsGEJ80hO7y1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STtWUMia/WfrIU5IHHJ6MyYMcFJZZ5dQQVx/36MMVVzqKsq0r/3wyksjMAOSncnFUqxVM1/E9llFcIJT5cEZrkex0lKkrqUIUGAFZo0WsvBDfdIicHz0Z/uKdZkc7JHIhq6mH9YVNV4YS4+I27rIps9Bz05lfaXM8B3x+Lc0yL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QF81C0xa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF81C0xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B436C433C7;
	Mon,  8 Apr 2024 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583922;
	bh=8BA+CxJ7twa7wDmzc+yzrcAMpNPiiucsGEJ80hO7y1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QF81C0xaVhoB4YaOtU2HiLTIu8bX2MckVJAbuWwuPJ9jO+ROVHivMFvDfMXB76h6F
	 UoGxtpCxyjl8D8s/JbKdyYRlZbxC+FIAHhsUvXrs8WOpauFZnZRUAm8odwXQFLmiFt
	 2vYsZgNm1dEF24emuPkkHzeg+/QZGuOfKGMbVDEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Eranian <eranian@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.8 234/273] perf/x86/intel/ds: Dont clear ->pebs_data_cfg for the last PEBS event
Date: Mon,  8 Apr 2024 14:58:29 +0200
Message-ID: <20240408125316.698571560@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 312be9fc2234c8acfb8148a9f4c358b70d358dee upstream.

The MSR_PEBS_DATA_CFG MSR register is used to configure which data groups
should be generated into a PEBS record, and it's shared among all counters.

If there are different configurations among counters, perf combines all the
configurations.

The first perf command as below requires a complete PEBS record
(including memory info, GPRs, XMMs, and LBRs). The second perf command
only requires a basic group. However, after the second perf command is
running, the MSR_PEBS_DATA_CFG register is cleared. Only a basic group is
generated in a PEBS record, which is wrong. The required information
for the first perf command is missed.

 $ perf record --intr-regs=AX,SP,XMM0 -a -C 8 -b -W -d -c 100000003 -o /dev/null -e cpu/event=0xd0,umask=0x81/upp &
 $ sleep 5
 $ perf record  --per-thread  -c 1  -e cycles:pp --no-timestamp --no-tid taskset -c 8 ./noploop 1000

The first PEBS event is a system-wide PEBS event. The second PEBS event
is a per-thread event. When the thread is scheduled out, the
intel_pmu_pebs_del() function is invoked to update the PEBS state.
Since the system-wide event is still available, the cpuc->n_pebs is 1.
The cpuc->pebs_data_cfg is cleared. The data configuration for the
system-wide PEBS event is lost.

The (cpuc->n_pebs == 1) check was introduced in commit:

  b6a32f023fcc ("perf/x86: Fix PEBS threshold initialization")

At that time, it indeed didn't hurt whether the state was updated
during the removal, because only the threshold is updated.

The calculation of the threshold takes the last PEBS event into
account.

However, since commit:

  b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing PEBS_DATA_CFG")

we delay the threshold update, and clear the PEBS data config, which triggers
the bug.

The PEBS data config update scope should not be shrunk during removal.

[ mingo: Improved the changelog & comments. ]

Fixes: b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing PEBS_DATA_CFG")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240401133320.703971-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1236,11 +1236,11 @@ pebs_update_state(bool needed_cb, struct
 	struct pmu *pmu = event->pmu;
 
 	/*
-	 * Make sure we get updated with the first PEBS
-	 * event. It will trigger also during removal, but
-	 * that does not hurt:
+	 * Make sure we get updated with the first PEBS event.
+	 * During removal, ->pebs_data_cfg is still valid for
+	 * the last PEBS event. Don't clear it.
 	 */
-	if (cpuc->n_pebs == 1)
+	if ((cpuc->n_pebs == 1) && add)
 		cpuc->pebs_data_cfg = PEBS_UPDATE_DS_SW;
 
 	if (needed_cb != pebs_needs_sched_cb(cpuc)) {


