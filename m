Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC612512F2;
	Thu,  3 Apr 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693829; cv=none; b=sZ7eysTz/VzjvXiciXicSOhCchMoaQK8G0nZ2RqWmnJGfNfud0MfMoONJcjkTlZt86oVKCQWH/4BpD5z9Y/bECylYI8GxN3XK/8vdHhDxy34BXb2Lsk9ruaRiRuUWHgXCls1VbANbw5nS1i4fioSzKnkfmt7h/SW39uqoMuL0F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693829; c=relaxed/simple;
	bh=zwCqDl7yhcmDMVPb4kbeohG2EOv1M/DcDG/vpeJYDSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ3UvLl0iQmHmZUoYsosFqgemC+MR6aF08eOjLU3tFFg/RKZnsK3pn4cuYRkIiJMKCpqOqjNny9UBHF3BKaGF82u+8RWkIQPCbbJ8N3dbLct0ILZbwmOv6RorGVoWrpp3DeAXU5+Ll6FU1h2pAihGhHitXP/DCtjpb/zDv+z+Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkVqFUQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkVqFUQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047A8C4CEE3;
	Thu,  3 Apr 2025 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693829;
	bh=zwCqDl7yhcmDMVPb4kbeohG2EOv1M/DcDG/vpeJYDSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkVqFUQjVmZPDNBWWy7zGL1VA2GVHFOv1CXmplhIFu92kih9pkITyxt1Ewx2FG3bg
	 TwMtcneqrd+qUsCyoOYkA0x9vxDmpgV0lmiQ+0QTrE7g8iT/wftkVvf7WJx4moskWa
	 TLYRNtWPq2o/0THUxMwRh+W94fy6e8qgzZb6N7L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.14 04/21] cgroup/rstat: Fix forceidle time in cpu.stat
Date: Thu,  3 Apr 2025 16:20:08 +0100
Message-ID: <20250403151621.253194807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Wu <wuyun.abel@bytedance.com>

commit c4af66a95aa3bc1d4f607ebd4eea524fb58946e3 upstream.

The commit b824766504e4 ("cgroup/rstat: add force idle show helper")
retrieves forceidle_time outside cgroup_rstat_lock for non-root cgroups
which can be potentially inconsistent with other stats.

Rather than reverting that commit, fix it in a way that retains the
effort of cleaning up the ifdef-messes.

Fixes: b824766504e4 ("cgroup/rstat: add force idle show helper")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/rstat.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -612,36 +612,33 @@ static void cgroup_force_idle_show(struc
 void cgroup_base_stat_cputime_show(struct seq_file *seq)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	u64 usage, utime, stime, ntime;
+	struct cgroup_base_stat bstat;
 
 	if (cgroup_parent(cgrp)) {
 		cgroup_rstat_flush_hold(cgrp);
-		usage = cgrp->bstat.cputime.sum_exec_runtime;
+		bstat = cgrp->bstat;
 		cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime,
-			       &utime, &stime);
-		ntime = cgrp->bstat.ntime;
+			       &bstat.cputime.utime, &bstat.cputime.stime);
 		cgroup_rstat_flush_release(cgrp);
 	} else {
-		/* cgrp->bstat of root is not actually used, reuse it */
-		root_cgroup_cputime(&cgrp->bstat);
-		usage = cgrp->bstat.cputime.sum_exec_runtime;
-		utime = cgrp->bstat.cputime.utime;
-		stime = cgrp->bstat.cputime.stime;
-		ntime = cgrp->bstat.ntime;
+		root_cgroup_cputime(&bstat);
 	}
 
-	do_div(usage, NSEC_PER_USEC);
-	do_div(utime, NSEC_PER_USEC);
-	do_div(stime, NSEC_PER_USEC);
-	do_div(ntime, NSEC_PER_USEC);
+	do_div(bstat.cputime.sum_exec_runtime, NSEC_PER_USEC);
+	do_div(bstat.cputime.utime, NSEC_PER_USEC);
+	do_div(bstat.cputime.stime, NSEC_PER_USEC);
+	do_div(bstat.ntime, NSEC_PER_USEC);
 
 	seq_printf(seq, "usage_usec %llu\n"
 			"user_usec %llu\n"
 			"system_usec %llu\n"
 			"nice_usec %llu\n",
-			usage, utime, stime, ntime);
+			bstat.cputime.sum_exec_runtime,
+			bstat.cputime.utime,
+			bstat.cputime.stime,
+			bstat.ntime);
 
-	cgroup_force_idle_show(seq, &cgrp->bstat);
+	cgroup_force_idle_show(seq, &bstat);
 }
 
 /* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */


