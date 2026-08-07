Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5C37F334;
	Fri,  7 Aug 2026 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115583; cv=none; b=fEF3wQ1Mf73CP68ftnZzf4p78ugTjXNUsng15wwGM2uKifaJ4uWw8OPMbuT+qyYcPCAAUB8f8iVg3nt41eMBQOH+cbknmlI8IH6n/shYDrWigUFuQLQ+dFY1vDHy5K6HQYpBtDpUAAZmwmDmpzqzfM1tVQ4bSjuWDbRz9J6sAbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115583; c=relaxed/simple;
	bh=HEkn1DL1zXQYhprYPWqMRzSvleCzZCWdRmaBffPQOrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRdRx1swiojKoI0YdT+hu3pEaFudWvQEsNPw+/iarsQvvVB+fN0IaJHisRaTtodeQUJSRv93x5BhZ3+++Q6tafqNv7BrIoPM77GoJ6hrgjYvwP+ii9YNmgqtBAceVHQTn1lheRKPH8WF6oFg4bLlUH2nF1LJanJ7e9fxSSuxsQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4BJ2HnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4BJ2HnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CC81F000E9;
	Fri,  7 Aug 2026 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115582;
	bh=pnD7IbcKHie69qPK6YHEnjk9Swy3SaaQb+O10OVW8Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4BJ2HnQ2GT1qbhjkzr9kaefDDDRNIiF3kq4heEkympsHMLaG9mNRHDWtl9EE+CRG
	 nUbpReKaXxbuRdfLNzUwMNYyHmtbivvZ94+EFmRc7EUGOPuaQVS61eDHz+YyvKzSEi
	 mg96JKYWMyiCou/dSK8J3dJ+ZBhRGwrdUEg/B2FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Ba <Gang.Ba@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 325/396] drm/amdkfd: Fix missing authorization check in KFD_IOC_DBG_TRAP_DISABLE
Date: Fri,  7 Aug 2026 16:38:05 +0200
Message-ID: <20260807143431.303544826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -2971,10 +2971,14 @@ static int kfd_ioctl_set_debug_trap(stru
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


