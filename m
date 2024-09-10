Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79938143880;
	Tue, 10 Sep 2024 10:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964853; cv=none; b=YqYYIlWzsdwO8sY3IDTLkXa0tgVqgSaaotOWPYGGvn5fglrj2JGLq96NfxQ/smhN3T2H1B5uKm2nxEL4LexrfxwfC2yHLxzdv3sgXW14kePwOU2v8quI2iPBLU7Jm2RPjGVcfH+MD32QxkMQRIDyE/Fd5Hg5TiYygBvSV0BxOoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964853; c=relaxed/simple;
	bh=03DkKXnuDbWDEBJ9RPRr8qIScedb/x85o9MmbZXOug4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlJs+3hdCGZP4YZv08WTtYmINBgPIXIirmhI4VUU8FbEiUrorebNOTvzntwuSI0Awt58Zj5AvUhH1zT4t2DVu4XujkJORN5rdZwEoAcQ4un9OV2fQoI61pZttEKIkf/d/hXDTjIOVa7EJH3L0FlW5lSQR65rUgXUxn2RzTZePdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSog3xpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSog3xpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007AFC4CEC3;
	Tue, 10 Sep 2024 10:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964853;
	bh=03DkKXnuDbWDEBJ9RPRr8qIScedb/x85o9MmbZXOug4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSog3xpQexUmZDpTp0GDDqZ/SujPFYdVdQdeFEkH6jGcKujaiib6oQqPRqg5zznqT
	 LDu9/hxSoeKzPmCSmADl3m+VoQsRMzG3kMoxDyOTnj0NUWZZJnyx8KvdLjQdLELseW
	 AAWYLJhcYPfQ6pC2vrycLMwBE5I4mhZaKDSDakB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com,
	syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Connor OBrien <connor.obrien@crowdstrike.com>
Subject: [PATCH 5.10 053/186] bpf, cgroup: Assign cgroup in cgroup_sk_alloc when called from interrupt
Date: Tue, 10 Sep 2024 11:32:28 +0200
Message-ID: <20240910092556.682986100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Connor O'Brien <connor.obrien@crowdstrike.com>

From: Daniel Borkmann <daniel@iogearbox.net>

commit 78cc316e9583067884eb8bd154301dc1e9ee945c upstream.

If cgroup_sk_alloc() is called from interrupt context, then just assign the
root cgroup to skcd->cgroup. Prior to commit 8520e224f547 ("bpf, cgroups:
Fix cgroup v2 fallback on v1/v2 mixed mode") we would just return, and later
on in sock_cgroup_ptr(), we were NULL-testing the cgroup in fast-path, and
iff indeed NULL returning the root cgroup (v ?: &cgrp_dfl_root.cgrp). Rather
than re-adding the NULL-test to the fast-path we can just assign it once from
cgroup_sk_alloc() given v1/v2 handling has been simplified. The migration from
NULL test with returning &cgrp_dfl_root.cgrp to assigning &cgrp_dfl_root.cgrp
directly does /not/ change behavior for callers of sock_cgroup_ptr().

syzkaller was able to trigger a splat in the legacy netrom code base, where
the RX handler in nr_rx_frame() calls nr_make_new() which calls sk_alloc()
and therefore cgroup_sk_alloc() with in_interrupt() condition. Thus the NULL
skcd->cgroup, where it trips over on cgroup_sk_free() side given it expects
a non-NULL object. There are a few other candidates aside from netrom which
have similar pattern where in their accept-like implementation, they just call
to sk_alloc() and thus cgroup_sk_alloc() instead of sk_clone_lock() with the
corresponding cgroup_sk_clone() which then inherits the cgroup from the parent
socket. None of them are related to core protocols where BPF cgroup programs
are running from. However, in future, they should follow to implement a similar
inheritance mechanism.

Additionally, with a !CONFIG_CGROUP_NET_PRIO and !CONFIG_CGROUP_NET_CLASSID
configuration, the same issue was exposed also prior to 8520e224f547 due to
commit e876ecc67db8 ("cgroup: memcg: net: do not associate sock with unrelated
cgroup") which added the early in_interrupt() return back then.

Fixes: 8520e224f547 ("bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode")
Fixes: e876ecc67db8 ("cgroup: memcg: net: do not associate sock with unrelated cgroup")
Reported-by: syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com
Reported-by: syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com
Tested-by: syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/bpf/20210927123921.21535-1-daniel@iogearbox.net
Signed-off-by: Connor O'Brien <connor.obrien@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6559,22 +6559,29 @@ int cgroup_parse_float(const char *input
 
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 {
-	/* Don't associate the sock with unrelated interrupted task's cgroup. */
-	if (in_interrupt())
-		return;
+	struct cgroup *cgroup;
 
 	rcu_read_lock();
+	/* Don't associate the sock with unrelated interrupted task's cgroup. */
+	if (in_interrupt()) {
+		cgroup = &cgrp_dfl_root.cgrp;
+		cgroup_get(cgroup);
+		goto out;
+	}
+
 	while (true) {
 		struct css_set *cset;
 
 		cset = task_css_set(current);
 		if (likely(cgroup_tryget(cset->dfl_cgrp))) {
-			skcd->cgroup = cset->dfl_cgrp;
-			cgroup_bpf_get(cset->dfl_cgrp);
+			cgroup = cset->dfl_cgrp;
 			break;
 		}
 		cpu_relax();
 	}
+out:
+	skcd->cgroup = cgroup;
+	cgroup_bpf_get(cgroup);
 	rcu_read_unlock();
 }
 


