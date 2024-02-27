Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E712145327;
	Tue, 27 Feb 2024 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044073; cv=none; b=DEMNDvQxlajibNfWXaa0dYZzppggWHVWIibXju74JwHCqc2i3uhAARBVe7El+Me136AQpCxMSIn3katf0sayJvA4bPzfst7W9fS40U9c/EnXj2TmhANNPLho4WTsnJtbW2KTsbFZTwm2fhEEIOXSLSWtgWyjBBNPWItTJKU0k/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044073; c=relaxed/simple;
	bh=fAgBA948DBCUAna3LK2ZqZASLQn6WE1WJs4Z7W5WwZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud6xKnO1Ldgj5ITDeNF46xQL47fr4O+EVZ7TInn8ZDdR+r5CksqZlO8tMFH3iuDy8JHzmZ/l/fYh0cjGtSxRqK8En0lCTWCQZBZNWiL7kZasF3uy8sIQVxpQmFJdE8Y378p7H0cRFGfzzDPEfzC1tKehQKYcclMYUur85YZnSyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgcAQeqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgcAQeqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9149FC433F1;
	Tue, 27 Feb 2024 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044072;
	bh=fAgBA948DBCUAna3LK2ZqZASLQn6WE1WJs4Z7W5WwZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgcAQeqoVXpi/IsHYxKhQWLId1+h+akWd1dX/e2Fe7wtAUcocMUQ3hFnMBN5NamoM
	 0HCtc8iuEOigZ6HW5sY8aM07EAXlWHJd0+wyZCB26u8fFOXSoah7QL1HNCSGLUF+ye
	 Ekn7+ENkjHynXI2fwf7ky3WfVjWJs8fHrv1CxeKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/122] powerpc/watchpoint: Workaround P10 DD1 issue with VSX-32 byte instructions
Date: Tue, 27 Feb 2024 14:26:54 +0100
Message-ID: <20240227131600.443373400@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit 3d2ffcdd2a982e8bbe65fa0f94fb21bf304c281e ]

POWER10 DD1 has an issue where it generates watchpoint exceptions when
it shouldn't. The conditions where this occur are:

 - octword op
 - ending address of DAWR range is less than starting address of op
 - those addresses need to be in the same or in two consecutive 512B
   blocks
 - 'op address + 64B' generates an address that has a carry into bit
   52 (crosses 2K boundary)

Handle such spurious exception by considering them as extraneous and
emulating/single-steeping instruction without generating an event.

[ravi: Fixed build warning reported by lkp@intel.com]
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201106045650.278987-1-ravi.bangoria@linux.ibm.com
Stable-dep-of: 27646b2e02b0 ("powerpc/watchpoints: Annotate atomic context in more places")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 67 ++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 6e5bed50c3578..49273f67c7498 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -504,6 +504,11 @@ static bool is_larx_stcx_instr(int type)
 	return type == LARX || type == STCX;
 }
 
+static bool is_octword_vsx_instr(int type, int size)
+{
+	return ((type == LOAD_VSX || type == STORE_VSX) && size == 32);
+}
+
 /*
  * We've failed in reliably handling the hw-breakpoint. Unregister
  * it and throw a warning message to let the user know about it.
@@ -554,6 +559,58 @@ static bool stepping_handler(struct pt_regs *regs, struct perf_event **bp,
 	return true;
 }
 
+static void handle_p10dd1_spurious_exception(struct arch_hw_breakpoint **info,
+					     int *hit, unsigned long ea)
+{
+	int i;
+	unsigned long hw_end_addr;
+
+	/*
+	 * Handle spurious exception only when any bp_per_reg is set.
+	 * Otherwise this might be created by xmon and not actually a
+	 * spurious exception.
+	 */
+	for (i = 0; i < nr_wp_slots(); i++) {
+		if (!info[i])
+			continue;
+
+		hw_end_addr = ALIGN(info[i]->address + info[i]->len, HW_BREAKPOINT_SIZE);
+
+		/*
+		 * Ending address of DAWR range is less than starting
+		 * address of op.
+		 */
+		if ((hw_end_addr - 1) >= ea)
+			continue;
+
+		/*
+		 * Those addresses need to be in the same or in two
+		 * consecutive 512B blocks;
+		 */
+		if (((hw_end_addr - 1) >> 10) != (ea >> 10))
+			continue;
+
+		/*
+		 * 'op address + 64B' generates an address that has a
+		 * carry into bit 52 (crosses 2K boundary).
+		 */
+		if ((ea & 0x800) == ((ea + 64) & 0x800))
+			continue;
+
+		break;
+	}
+
+	if (i == nr_wp_slots())
+		return;
+
+	for (i = 0; i < nr_wp_slots(); i++) {
+		if (info[i]) {
+			hit[i] = 1;
+			info[i]->type |= HW_BRK_TYPE_EXTRANEOUS_IRQ;
+		}
+	}
+}
+
 int hw_breakpoint_handler(struct die_args *args)
 {
 	bool err = false;
@@ -612,8 +669,14 @@ int hw_breakpoint_handler(struct die_args *args)
 		goto reset;
 
 	if (!nr_hit) {
-		rc = NOTIFY_DONE;
-		goto out;
+		/* Workaround for Power10 DD1 */
+		if (!IS_ENABLED(CONFIG_PPC_8xx) && mfspr(SPRN_PVR) == 0x800100 &&
+		    is_octword_vsx_instr(type, size)) {
+			handle_p10dd1_spurious_exception(info, hit, ea);
+		} else {
+			rc = NOTIFY_DONE;
+			goto out;
+		}
 	}
 
 	/*
-- 
2.43.0



