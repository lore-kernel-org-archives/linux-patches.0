Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F005F342509;
	Wed,  3 Dec 2025 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777443; cv=none; b=Xq4nfw+5Gtgx6S5sQXf8WfnBYYIitiyTa5ImLVgzF51R52lXuwyokWRmxhv3Rm5iQRDOf7VDa4l/6FqSOplLUD6kLEFDA/RgjL2XXz0JkcYlXWgjJ4u70DZGtDLKEu6jKl1jpRaFD2WCv7UJkoWC/k4u8CNKliuXdRKrdycOyLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777443; c=relaxed/simple;
	bh=7Y6M0sqSDJUJeniC1obg5g8MHXaU7M+yOJqm51cBIQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSXCyLpsvkgo1p7JYM4hnAXsaCQuKDIMjNMZ+AIo0WEcHYACn2TdyzTPE8EFkZ0526Lrhy50ZG5FmqTGADIXf36IF0RrAGzA+bR4FuRA8I6dhtgUT20ftWRdA7f1ekdcXw/+rDW1kpPNmauE/r1MsqwDeCzoZtO6DB7YtPftuUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVJvjWjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVJvjWjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7497AC116C6;
	Wed,  3 Dec 2025 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777442;
	bh=7Y6M0sqSDJUJeniC1obg5g8MHXaU7M+yOJqm51cBIQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVJvjWjOJ/6p4HtCZ99gpfW8jZzJ0M/Yc5mbVyIcpUqYmJ0U4oh8fnXBd0dVTjIde
	 2OgQArtZBvImv6toW7r76TpA04JWvSs7qKwmicZ+5HwTTRj6rvMgN0tmtYGGkSGW5f
	 nWSgo/Cc57pOoumT0fRzyhu1j8CF4h+EKqlDrEPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.15 039/392] x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID
Date: Wed,  3 Dec 2025 16:23:09 +0100
Message-ID: <20251203152415.547047587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babu Moger <babu.moger@amd.com>

[ Upstream commit 15292f1b4c55a3a7c940dbcb6cb8793871ed3d92 ]

Users can create as many monitoring groups as the number of RMIDs supported
by the hardware. However, on AMD systems, only a limited number of RMIDs
are guaranteed to be actively tracked by the hardware. RMIDs that exceed
this limit are placed in an "Unavailable" state.

When a bandwidth counter is read for such an RMID, the hardware sets
MSR_IA32_QM_CTR.Unavailable (bit 62). When such an RMID starts being tracked
again the hardware counter is reset to zero. MSR_IA32_QM_CTR.Unavailable
remains set on first read after tracking re-starts and is clear on all
subsequent reads as long as the RMID is tracked.

resctrl miscounts the bandwidth events after an RMID transitions from the
"Unavailable" state back to being tracked. This happens because when the
hardware starts counting again after resetting the counter to zero, resctrl
in turn compares the new count against the counter value stored from the
previous time the RMID was tracked.

This results in resctrl computing an event value that is either undercounting
(when new counter is more than stored counter) or a mistaken overflow (when
new counter is less than stored counter).

Reset the stored value (arch_mbm_state::prev_msr) of MSR_IA32_QM_CTR to
zero whenever the RMID is in the "Unavailable" state to ensure accurate
counting after the RMID resets to zero when it starts to be tracked again.

Example scenario that results in mistaken overflow
==================================================
1. The resctrl filesystem is mounted, and a task is assigned to a
   monitoring group.

   $mount -t resctrl resctrl /sys/fs/resctrl
   $mkdir /sys/fs/resctrl/mon_groups/test1/
   $echo 1234 > /sys/fs/resctrl/mon_groups/test1/tasks

   $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
   21323            <- Total bytes on domain 0
   "Unavailable"    <- Total bytes on domain 1

   Task is running on domain 0. Counter on domain 1 is "Unavailable".

2. The task runs on domain 0 for a while and then moves to domain 1. The
   counter starts incrementing on domain 1.

   $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
   7345357          <- Total bytes on domain 0
   4545             <- Total bytes on domain 1

3. At some point, the RMID in domain 0 transitions to the "Unavailable"
   state because the task is no longer executing in that domain.

   $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
   "Unavailable"    <- Total bytes on domain 0
   434341           <- Total bytes on domain 1

4.  Since the task continues to migrate between domains, it may eventually
    return to domain 0.

    $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
    17592178699059  <- Overflow on domain 0
    3232332         <- Total bytes on domain 1

In this case, the RMID on domain 0 transitions from "Unavailable" state to
active state. The hardware sets MSR_IA32_QM_CTR.Unavailable (bit 62) when
the counter is read and begins tracking the RMID counting from 0.

Subsequent reads succeed but return a value smaller than the previously
saved MSR value (7345357). Consequently, the resctrl's overflow logic is
triggered, it compares the previous value (7345357) with the new, smaller
value and incorrectly interprets this as a counter overflow, adding a large
delta.

In reality, this is a false positive: the counter did not overflow but was
simply reset when the RMID transitioned from "Unavailable" back to active
state.

Here is the text from APM [1] available from [2].

"In PQOS Version 2.0 or higher, the MBM hardware will set the U bit on the
first QM_CTR read when it begins tracking an RMID that it was not
previously tracking. The U bit will be zero for all subsequent reads from
that RMID while it is still tracked by the hardware. Therefore, a QM_CTR
read with the U bit set when that RMID is in use by a processor can be
considered 0 when calculating the difference with a subsequent read."

[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
    Publication # 24593 Revision 3.41 section 19.3.3 Monitoring L3 Memory
    Bandwidth (MBM).

  [ bp: Split commit message into smaller paragraph chunks for better
    consumption. ]

Fixes: 4d05bf71f157d ("x86/resctrl: Introduce AMD QOS feature")
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org # needs adjustments for <= v6.17
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
(cherry picked from commit 15292f1b4c55a3a7c940dbcb6cb8793871ed3d92)
[babu.moger@amd.com: Fix conflict in monitor.c for v5.15 stable]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/monitor.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -288,11 +288,19 @@ static u64 mbm_overflow_count(u64 prev_m
 static u64 __mon_event_count(u32 rmid, struct rmid_read *rr)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(rr->r);
-	struct mbm_state *m;
+	struct mbm_state *m = NULL;
 	u64 chunks, tval;
 
 	tval = __rmid_read(rmid, rr->evtid);
 	if (tval & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL)) {
+		if (tval & RMID_VAL_UNAVAIL) {
+			if (rr->evtid == QOS_L3_MBM_TOTAL_EVENT_ID)
+				m = &rr->d->mbm_total[rmid];
+			else if (rr->evtid == QOS_L3_MBM_LOCAL_EVENT_ID)
+				m = &rr->d->mbm_local[rmid];
+			if (m)
+				m->prev_msr = 0;
+		}
 		return tval;
 	}
 	switch (rr->evtid) {


