Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062538;
	b=mjXo/u8IUTFZGiP2lHfEpCPU4Wdo3xH8Oay01Dv2AJcLPXF8hcskjmiVfLOiuLh1OXEy
	 HYLHl57+CijvHQy2IrURxZWKwlPIG0LrXAwSs36oz9A/XtyBe2BrlS/4Ox4g48ik/8D2i
	 JfbkszoZDJmd2x2khI9/EovldmbbkwKkN7dZBGvS8iByb2f1ZZ/jhtOWdVG/DCHAVxxuN
	 6+yDMV1GfOfQqh9l7r9SeZ8QDS5b/Q2fnl/anbjerL61seUrQk3Bkzo+xBAoTJuEJDJn4
	 VO0o2gcKHC6c0owmC7IKn8ejRKVue4KtsjahFBl6f7BElNgm/q1GlIaL2nYTldV7o9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/bWoaMTlaPuw/zU2UcN3Z9S8Ht49TU9TdHqO9xNWfao=;
	b=sMYODm99IlOIpiE41ANcpDmSMMBuQ940wrCONmTsAfGZmWbJodg2mn4wLiSSYbaiPJ+l
	 K12KbjgHV52lJXfMwIDI6FNQAhYoPfZrcEiBmW7/3cqBOooqCKB1hcyERPsQ6XaCwL4dI
	 PWH0ALovI/2EByRnqTNra6f/psqZ4r+e2GHs8fg5ymQFFYa0BF2CQISYb/mlwrc595TpZ
	 608DNOWDp3J6RCPNTHQ0zthyjGU7gB+s8vbpBq83YubAvr5+et0fz4p4PJpe/b0Yyi75n
	 IdKYSpfFDIM7optZbcTLcSVtV/izC+HoOmr+fuqi5di9J4HP9evTpxIIUg5m+2gzFuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtEYtuoE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF6A606D80A;
	Sat,  7 Nov 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtEYtuoE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C96D1F0089F;
	Sat,  7 Nov 2026 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062537;
	bh=/bWoaMTlaPuw/zU2UcN3Z9S8Ht49TU9TdHqO9xNWfao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtEYtuoE2KG5euUfCufGL4knXCUkvG2cLwMiqTVkXIZFdp3C+IFfqwIkwbXj6rBlm
	 9f+NP94d6tPPA8CZdsQx5KnaqV057/P9EQqSGf3WBfd9gml0wqzC9rB6UF7EMc3QDG
	 PQ0zsF1Z+7PNrTFoCdM0iAlgUs2lD7DHCqQeCfsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 1428/1536] cgroup: dont kill migrated processes through their exiting threads
Date: Sat,  7 Nov 2026 08:57:24 -0500
Message-ID: <20261107135037.942492518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 5f4a3f743acc96987ae5c2e966947942c34ba56c ]

Since commit da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader"), __cgroup_kill() visits every thread in the cgroup and
sends SIGKILL with PIDTYPE_TGID, so each visited thread takes down its
whole thread group.

A thread that has started exiting can stay in a cgroup after its process
has been moved out of it. cgroup_migrate_add_task() skips PF_EXITING
tasks, and the thread is only unlinked by cgroup_task_dead() after its
final context switch. mm_release() clears the thread's clear_child_tid
word and wakes the joiner well before that, so pthread_join() can return
while the thread is still in the old cgroup.

If cgroup.kill is written in that window, __cgroup_kill() finds the
exiting thread and complete_signal() passes the group-wide SIGKILL on to
a live thread, killing a process that already left the cgroup. The cgroup
selftest test_stress.sh runs into this: test_cgcore_proc_migration()
joins its threads, moves itself back to the root cgroup, and cg_destroy()
falls back to cgroup.kill on the old cgroup when rmdir() fails with
EBUSY, so test_core kills itself. KernelCI has been reporting
"with_stress.sh: line 94: ... Killed" on several arm64 boards since the
commit reached linux-next.

Keep visiting every thread, but go back to sending SIGKILL to the thread
that was found. A SIGKILL sent to a live thread still kills its whole
thread group, so both cases fixed by that commit stay fixed, and
task_can_queue_signal() drops one sent to a thread that is already
exiting.

Fixes: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread group leader")
Cc: stable@vger.kernel.org # v5.14+
Link: https://lore.kernel.org/all/179272264722.329188.4773475583351189022@6e52bff8000c/
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 766351c0e34e6..98e0e7584257d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4113,7 +4113,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
+		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



