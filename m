Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B88C36A378;
	Tue, 12 May 2026 18:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609700; cv=none; b=UaRM7aVNGHQabVeGzcrF4hNs8Q2u4mgi4dBzu4Vy/EVmS+FcX2PG63gynM9xdURS4/8jdoBtaBY7FVh7RO9j1YFQ+rA+2IXaP2VVrEZ3pOZmd56XgZKatbxzHEGeWI6t1rZF2vvTid/wEBoSG1NqvUL8YPMOI7BFOu5fgrPlcO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609700; c=relaxed/simple;
	bh=WuJh379SYp25U28FDRfe7/Lop0KzRFt45zESNgYxhXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QduMDAV/W0EseT8akyo63PuaekekLc0w8ylFXHftb5mzrf2nO0NGB1PUSiW/MGDbHY2Y/zRb/BRI1YepnRGovgm0GOPH7zfFIFgmKTlipreZ2GKlidcoE4d1A3X5X5D2vW6nEGqSBjOOxQ7ixXIgkKzcPlhW8MBVg6Y0frDlYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUcL0i+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUcL0i+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B639BC2BCB0;
	Tue, 12 May 2026 18:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609700;
	bh=WuJh379SYp25U28FDRfe7/Lop0KzRFt45zESNgYxhXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUcL0i+nYkhvs4NdwPK7jUDxJe/hQfU69k43EJUvEDdtOpaGhV7rf3kAgQNu8gmUA
	 889u2QelaSjzJPQ7DezYjNJkKAJj9GXaC9tt7HjeXE7HD36cypDq/mYtjaFE/penps
	 IVnaj607O9HRn0dK4xumtDkCjA27r6Xz2kjaKtiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Claude <noreply@anthropic.com>
Subject: [PATCH 7.0 246/307] sched_ext: idle: Recheck prev_cpu after narrowing allowed mask
Date: Tue, 12 May 2026 19:40:41 +0200
Message-ID: <20260512173945.316733075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit b34c82777a2c0648ee053595f4b290fd5249b093 upstream.

scx_select_cpu_dfl() narrows @allowed to @cpus_allowed & @p->cpus_ptr
when the BPF caller supplies a @cpus_allowed that differs from
@p->cpus_ptr and @p doesn't have full affinity. However,
@is_prev_allowed was computed against the original (wider)
@cpus_allowed, so the prev_cpu fast paths could pick a @prev_cpu that
is in @cpus_allowed but not in @p->cpus_ptr, violating the intended
invariant that the returned CPU is always usable by @p. The kernel
masks this via the SCX_EV_SELECT_CPU_FALLBACK fallback, but the
behavior contradicts the documented contract.

Move the @is_prev_allowed evaluation past the narrowing block so it
tests against the final @allowed mask.

Fixes: ee9a4e92799d ("sched_ext: idle: Properly handle invalid prev_cpu during idle selection")
Cc: stable@vger.kernel.org # v6.16+
Assisted-by: Claude <noreply@anthropic.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext_idle.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -460,12 +460,6 @@ s32 scx_select_cpu_dfl(struct task_struc
 	preempt_disable();
 
 	/*
-	 * Check whether @prev_cpu is still within the allowed set. If not,
-	 * we can still try selecting a nearby CPU.
-	 */
-	is_prev_allowed = cpumask_test_cpu(prev_cpu, allowed);
-
-	/*
 	 * Determine the subset of CPUs usable by @p within @cpus_allowed.
 	 */
 	if (allowed != p->cpus_ptr) {
@@ -482,6 +476,12 @@ s32 scx_select_cpu_dfl(struct task_struc
 	}
 
 	/*
+	 * Check whether @prev_cpu is still within the allowed set. If not,
+	 * we can still try selecting a nearby CPU.
+	 */
+	is_prev_allowed = cpumask_test_cpu(prev_cpu, allowed);
+
+	/*
 	 * This is necessary to protect llc_cpus.
 	 */
 	rcu_read_lock();


