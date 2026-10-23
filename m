Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774095;
	b=XVPvcp94s5Ys+1TPs7PaO63fI/wOHDEETX8HnNE1IQ3ol6PxEzsYlNrlbaEKIP4Xl5f4
	 qTaA9PZeo7CLidP27PAz3BypaKn24ovTn0w7IxUn/0QNBPJOnZ9NdyTZtRy6uX7xUFCqm
	 Z/anfJpvc5qCPYmQdnIZuR+NCDGGXJuJKiy0gs7rswr4NMgQg8Im8BRYrxaQ7PNKJK7Om
	 C5AMAO5hGpVOg4Dx2UqsIpP2fQxAFUsujCKXRd9diL679DffqjuT0MAHwj2kDOoSkY/pL
	 0/8tiUxQDVKuUXkQdmyUCwGahAxtQgpRnQo0fYr26e7XDBlvcPrv5jWYb7a3MXn+Dzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sMv8RpGO3yFrDchL1pUjkgvFM2HbNayVsPO33zKoHrI=;
	b=bLrzzCvdWDIZ+wZwZR9nVFBEV6AQ7khrSt8YK6VGFvyhq9uQZFkx8nC/oVrHnQauTYmn
	 DGANjeJj6HaNOIURfTm4OgluzUv/xufjeyRyIEv1YyNzfv4voz2BOAjsbMmk2gcFBk2/s
	 riYsMQPnbi8O762dY81MJjHNNEaWoItafDXvflTRxS2dDXtS6bAEI3dJzmAuFwpo4eC2x
	 YsUv3zAXVqI9oESmruQvhrFuYP2e84MCd6zFv2Fugg7+3Wmn2PaJp40quEYAw36TV4uji
	 dArIIidHxfjod8/QODAdHgU1E9RZR9zR81wQC74wo9O+PCV/2RpQhYB+9Oh58ZDOU3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGQ2yjyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1C2606A31B;
	Fri, 23 Oct 2026 16:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGQ2yjyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0381F01825;
	Fri, 23 Oct 2026 16:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774094;
	bh=sMv8RpGO3yFrDchL1pUjkgvFM2HbNayVsPO33zKoHrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGQ2yjyEtS47LG83ZbWpq7RLAgspfidt/TM7+qrN2fLn37iW3rqfw3aJDA9XLkrD2
	 h9nGGK3/8H6wdnsloMDYdiiDFMDmDSJPeFbzqzwVvGiyNFD93YeMI9GPCjmVDYciw/
	 IDfLlM8VGxgSfm7xIUWTeroPjWL9QKP3kl49rDWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Etienne Perot <eperot@google.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 119/193] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children
Date: Fri, 23 Oct 2026 18:36:36 +0200
Message-ID: <20261023163717.017223926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -518,7 +518,10 @@ struct cgroup {
 
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
@@ -6734,10 +6734,7 @@ static int cgroup_css_set_fork(struct ke
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
@@ -6801,6 +6798,7 @@ static int cgroup_css_set_fork(struct ke
 
 	put_css_set(cset);
 	kargs->cgrp = dst_cgrp;
+	kargs->kill_seq = dst_cgrp->kill_seq;
 	return ret;
 
 err:


