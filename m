Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8C3279DCC;
	Fri,  7 Aug 2026 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114414; cv=none; b=PWKMoqml16H6mX4ERMiRL+0gFfuLIIbUrctc0UBNK04C+mZ6pGjvcVd/JhlAurcl8LWGod4eg2fomF+NTifbO57ytoh1hifIjKlPds9Locb7WNIr/LmtlcBb8qkQHLNeDwUt7GcR2LhRyJdNfOKl/1pQ5Pqv75j/2BS5ROaLIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114414; c=relaxed/simple;
	bh=rzebSplhS8NQI5ZMG8XMcj1Sv3y8glAnN5ZFH2nSDHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgaqtDaNwHcdoEIA5f50XTqCtdYjFyUPhKqAwn4i0Jk6JraOSJKtoFcUejPv08W7G/N36L5rf6ZDSlFKJYxJLdFMscFlVr+M/FXu0nSpKhZYji2TjmsUjFgs/MKyhly3NT7a3DfL0tJ73Yn3cH5+po5oNsb4vGX3aEnAb39HwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5yxCRXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5yxCRXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272241F000E9;
	Fri,  7 Aug 2026 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114413;
	bh=fdNggmXwRzJpjiutEthnJlPIK1Pp2oCSUpM39e82Mo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5yxCRXRmNbLidlviK2d/ZcDBM8P2gUcnsKLp9CnTbI5O7NA+LvtSXgm9dH0hHO2t
	 cy+WeyANkx+EFBs/TMxJVfLzmauc59mHM2IU3nuXFChBiYsZfgZFMeqv/sZch464Xj
	 OkxId/cUMLIl5762XLjeyv8NOuYUVAlVRVFizTpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Ba <Gang.Ba@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 254/337] drm/amdkfd: Fix missing authorization check in KFD_IOC_DBG_TRAP_DISABLE
Date: Fri,  7 Aug 2026 16:37:37 +0200
Message-ID: <20260807143424.053375016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Gang Ba <Gang.Ba@amd.com>

commit 99b2fe4f19e3be0a8d0a0b5ea98d855970889653 upstream.

Prevent unauthorized termination of active GPU debug sessions.
Previously, users with /dev/kfd access could terminate another process's
debug session without proper ownership or ptrace authorization.

Signed-off-by: Gang Ba <Gang.Ba@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4db4c5ffd5585b72622ecf6ffedf2da258ee23f5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2978,10 +2978,14 @@ static int kfd_ioctl_set_debug_trap(stru
 		goto out;
 	}
 
-	/* Check if target is still PTRACED. */
+	/*
+	 * Verify debugger has permission to debug target process.
+	 * For cross-process debugging, require active ptrace relationship.
+	 * This applies to ALL operations to prevent unauthorized interference.
+	 */
 	rcu_read_lock();
-	if (target != p && args->op != KFD_IOC_DBG_TRAP_DISABLE
-				&& ptrace_parent(target->lead_thread) != current) {
+	if (target != p && ptrace_parent(target->lead_thread) != current
+			&& target->debugger_process != p) {
 		pr_err("PID %i is not PTRACED and cannot be debugged\n", args->pid);
 		r = -EPERM;
 	}


