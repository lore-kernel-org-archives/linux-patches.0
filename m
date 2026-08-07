Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E283A3E7A;
	Fri,  7 Aug 2026 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116332; cv=none; b=iDOU7KWZIhorsUMtVk4ujF3WIPP5Af4cgw8dGYTWlVt+ckfzJfXo98h0mHqoMIhfoMDDDPzoCxoOehIVWkt119JEe6qPoHo1sHcaJYisK28L1X/gZF8PO1LQCrJ6tihzz9uaIsksPg/ceQdDW98tgmltaFWXaDTiiN/to4b2hbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116332; c=relaxed/simple;
	bh=FulGE1InOzhaxZMjONQzepJ/YutnfO9MfbNDNh2CMC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZsVra7y+U1Vk2zfVHJbvRzcQEAiAizQ8iUkwcz07zUezye7Fw9lv0EFwqiiMB3cpI2QzAVrsi1ZJRgQOsOnxbWLrNZiRHDGHRwXGrzuhMa0Di1UccEMpGcGI9ROpPbnLQ4BQu1DFkoVB/N0Kd81eCU4AloMhVpxRX73Fg82z5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM8oFeBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM8oFeBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06321F000E9;
	Fri,  7 Aug 2026 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116331;
	bh=f7eYSTa8EuvGsemt902iSQm7AyMM1v+rC/g+3HcDOFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM8oFeBCUorQQM+3F/FPhzwz1vH16VOWdWMsRyzWF0/usviYP6e7KwtDR8KnBMK8H
	 lVf9Hm6z/+KOzLdvUzIHSXKe1JFCNUk7hQDNPyjg7oz9FavyoPHTNhzfYIYgFt3iJy
	 Tww83x0CAD/zmcPKKMEWbYeJh1Ahq03XeN0UXoKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Ba <Gang.Ba@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 193/261] drm/amdkfd: Fix missing authorization check in KFD_IOC_DBG_TRAP_DISABLE
Date: Fri,  7 Aug 2026 16:39:10 +0200
Message-ID: <20260807143419.532020019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2977,10 +2977,14 @@ static int kfd_ioctl_set_debug_trap(stru
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


