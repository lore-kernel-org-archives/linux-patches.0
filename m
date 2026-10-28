Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207668;
	b=2PLhf4lx1uenVkwHNJpIjG9acGDrrml8sDqWNI10h4uTdktHDuBlI7/JNQUkvpHvytwF
	 9pI/4P01JWB8jYIiOpfTCNEvp1+clOPcrPRURNppKFZZ9M6ceFlAKW7jV0+ajit83Mwr0
	 8SnXKEGszBGhI+5akJR4y/uJ0sYnxeFht/G1KDeSh4qFyO4ujv2muLrR2Opz7jOgJbHCK
	 DzsJPh1lpGZccpHL2i8BkoPI0PMqnXYkR4DvIDtZwyTfoqB3xiVqpEZTfJVMlQWz+pqhP
	 q/6reeXEVwo8A3aOl4WVla2txlobN9vJNU7Ve8nOk5xUhO/ITdG752jNv3985dYZmmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRT1Gy5wlllsIAVJwaYsxjCQLGppQ26dk433MOS8Aa0=;
	b=vRrBKQ8yvWzqtEH+AK7DN7gkBp94LIIxusvUHi7PPktDCEFDnUit+np2Sm6UI5/3YsZm
	 p8/L5oqhCanG7HSTcZBZU+lYf1co46xMv9zM7Cyqu+419886j3oEKd5APd8ju9h5QPbiV
	 o7lLfT1/+N4h2U5ae/hA0Lom54JR35pA6KB9Z/O+y+FrxuyHZSSI/pOzMdHpk7uIHSMyG
	 FclSrLcLchHLsV1Zs1o8QF1LKaWepSSTFUb/p0aJRTjyqYsCRANRyV9OCWARz17KHNrOW
	 5T/ll1FFFw1XyULZfv9xcQefgDcRnoeNTOXb1hl4Fm5W1SVUA9xlWCAIc13dT85i+CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M561wP9p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9D606A31A;
	Wed, 28 Oct 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M561wP9p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181011F01825;
	Wed, 28 Oct 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207667;
	bh=VRT1Gy5wlllsIAVJwaYsxjCQLGppQ26dk433MOS8Aa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M561wP9pY6oWcFtuTb/H7arf0oTfR+E1Er+Aqo6PDB/NLfhh1U3IN5gZXbuTlxVuF
	 3fwfUZ0d7KUWFGTywkGxfg3bq+voO1FN4TocGm3/4L93gZiFMJRtGcXV2AFaWHfdxT
	 nq9n/pZDUZc1nsTPkchCQEvmc9nhf6nGRrzKIl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Etienne Perot <eperot@google.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 098/247] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children
Date: Wed, 28 Oct 2026 17:58:21 +0100
Message-ID: <20261028165949.716114122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Etienne Perot <eperot@google.com>

commit 8e359920216689b3b79e0fe8961a77fe312a511f upstream.

Since commit b69bb476dee9 ("cgroup: fix race between fork and
cgroup.kill"), the fork path snapshots the kill_seq of the child's
future cgroup into kargs->kill_seq, and cgroup_post_fork() SIGKILLs
the child if that cgroup's kill_seq has changed in the meantime, to
catch forks racing with a cgroup.kill sweep.

For CLONE_INTO_CGROUP, however, the snapshot in cgroup_css_set_fork()
is taken before the target cgroup has been resolved: kargs->cgrp is
always NULL at this point (it is only set at the end of the function).
So the "if (kargs->cgrp)" branch is dead code and the snapshot always
records the kill_seq of the parent's cgroup. cgroup_post_fork() then
compares it with the kill_seq of the target cgroup, so the child gets
SIGKILLed whenever the two cgroups have been killed a different number
of times.

As a result, once cgroup.kill has been written to a cgroup, every
child subsequently cloned into it with clone3(CLONE_INTO_CGROUP) is
killed on the spot, for as long as the cgroup exists: kill_seq is not
exposed to userspace and never resets.

Re-snapshot kill_seq from the target cgroup once it has been resolved,
and drop the dead branch at the early snapshot site.

This does not reopen the race fixed by b69bb476dee9. For
CLONE_INTO_CGROUP, everything from the snapshot to the check in
cgroup_post_fork() runs with cgroup_mutex held, and kill_seq is
only ever incremented under cgroup_mutex.

tj: Updated the comment above kill_seq to reflect the new serialization
rules as suggested by Shakeel Butt.

Fixes: b69bb476dee9 ("cgroup: fix race between fork and cgroup.kill")
Cc: stable@vger.kernel.org
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: LLM
Signed-off-by: Etienne Perot <eperot@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    5 ++++-
 kernel/cgroup/cgroup.c      |    6 ++----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -458,7 +458,10 @@ struct cgroup {
 
 	int nr_threaded_children;	/* # of live threaded child cgroups */
 
-	/* sequence number for cgroup.kill, serialized by css_set_lock. */
+	/*
+	 * Sequence number for cgroup.kill. Incremented with both cgroup_mutex
+	 * and css_set_lock held. Readers hold either one.
+	 */
 	unsigned int kill_seq;
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6602,10 +6602,7 @@ static int cgroup_css_set_fork(struct ke
 	spin_lock_irq(&css_set_lock);
 	cset = task_css_set(current);
 	get_css_set(cset);
-	if (kargs->cgrp)
-		kargs->kill_seq = kargs->cgrp->kill_seq;
-	else
-		kargs->kill_seq = cset->dfl_cgrp->kill_seq;
+	kargs->kill_seq = cset->dfl_cgrp->kill_seq;
 	spin_unlock_irq(&css_set_lock);
 
 	if (!(kargs->flags & CLONE_INTO_CGROUP)) {
@@ -6670,6 +6667,7 @@ static int cgroup_css_set_fork(struct ke
 	put_css_set(cset);
 	fput(f);
 	kargs->cgrp = dst_cgrp;
+	kargs->kill_seq = dst_cgrp->kill_seq;
 	return ret;
 
 err:


