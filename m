Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08283502A3;
	Fri,  7 Aug 2026 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117752; cv=none; b=mw4J9vodqy35S7vrWPpaah5jYKMaT2c/3BRioT6tkh2YhVBGk/YVtOiMjRyIQI/ff4AbknPYWOcyu+aExQfI6q8Zbvn5cjQztoLhd21bcjrSDEV9a8/E+RlIW3O1xOYEYFULp6zqJUd8dNL4Wi7dpl85l64QG+8AWmixH5pGAHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117752; c=relaxed/simple;
	bh=lL9HdtqOque2eMGjrQnjqTdP/K65hoi8/YE3EZZfv3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ3T2FDP2dzMQ5Rh97Z04umdTJsOjKms30n6qaVtixVOWE0P9CLk79rqhzdCNwi6GumWjgqzjQwFGpy+0VeWZt2EPq0gheeW8KoKMhE8Cm6xraH3kHl8m7kX7mmDaAmx0eDnwf3b/+16RXog+MaGxGLQZdYib1fEP22rmtChXsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tfduy4Nc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tfduy4Nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3934E1F000E9;
	Fri,  7 Aug 2026 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117751;
	bh=q21gvSo9s+YOQTZNJO2BebvKyzDgKqnLX42bzk123QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tfduy4NcTodmD8zWG+ZeEJHYLSp+WI+VeD6SisA4+BLYad+g6QAitlvAl0Xl4iHkZ
	 T9qzv+JXJ1ahZYQ8QRQCSN3kbzrJLuj1n4skM9lnqJ4qlXY4y82w7Sn/VPDMFyXwbt
	 WYfE3Pt8RU1f4vOO0V0eoirZWUmK+yUmA9z2WANY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Ba <Gang.Ba@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 402/438] drm/amdkfd: Fix missing authorization check in KFD_IOC_DBG_TRAP_DISABLE
Date: Fri,  7 Aug 2026 16:39:58 +0200
Message-ID: <20260807143436.532966305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
@@ -3038,10 +3038,14 @@ static int kfd_ioctl_set_debug_trap(stru
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


