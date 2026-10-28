Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211755;
	b=SPX83ZIP7QX4sFdX7CocCxGBMtRrw8JcA8D8DGmY/WVhIWkwgieTaOx6oIVndfxuaRq+
	 snQa5o+KEJaXSJtbP69jF5UjwclMW0tpsGI2JDK1w/ljjysK5wiq9FEE6T33qjXBMaVqD
	 +pbhddnjP348i4MfURlbEjg7hZxJx3ujQN2we1A7o4D6gviEU918vNBTsx3Ymxii/qKQ+
	 p1apGxxwwcEYftdsYCtKmZOxVMDb+FbzVieintrXtXyfs+p3eLMS2BQeelubbpZPTfv7B
	 n0CAlWrG1VRgLasRQtx44iIZGIxqNIm9i7iivzN/bNHVaZAnmFDNrrUbxM0ImgdOLHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r53YmDKbMfDFSIWx5nySnReCwOmGBIPz/owHg4B92js=;
	b=4zPpZSaAZSWd3iyVnXtDrTutQUnvm0hdfvhP/jfnniB0+dQpQdu+EIlIe8rg3AaZa/vk
	 WlfvzLXRJmBlYqXwTXQiDrSJMprPuM8I5ufdv1fNtbU/os/FKZOP5ngMAsuEHOFpSsWMi
	 0asAFwgKYQ6ZjvYSxxNNYrt6jcVzaOLZ08r0nByGW+LIHijEBlknqSH6OwW82c44RptcU
	 yWtkCThnVriW3wpscjbryChzY2SxZ1Ga2RwES92fq4aRBqWi33ekUCjunnkeb3umDj0rt
	 B89nbJCAGgY/LIT7KHvBERCGPtCdV2vcbEAM6qZF4sV6/pWA0J5kX2srUbjr3CC/ZIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIVgCyav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BA160A2623;
	Wed, 28 Oct 2026 18:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIVgCyav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC0E1F01825;
	Wed, 28 Oct 2026 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211755;
	bh=r53YmDKbMfDFSIWx5nySnReCwOmGBIPz/owHg4B92js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIVgCyavhXu+FrWnM7Bu3Ekmgzh9F8tCrRBwvWxWXC3HYUADpa7yzqJdjhEELkcgj
	 g0Tn0KOrladt6sOryBPz41WCEZzy/aKMm2r7tEcuxKolAoGJvefFqNrjf4B0oJzvCi
	 cskv8Pp2N4LrrWDiCA8LAQ7HRsLy1pgSGd3Pzi4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 489/571] exit: fix lost-update race on the child_subreaper bitfields
Date: Wed, 28 Oct 2026 18:00:36 +0100
Message-ID: <20261028170019.631754331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 28d2905d77bc2e7c20260a6bc6b4179bdf95cb06 ]

is_child_subreaper, has_child_subreaper, autoreap and, with
CONFIG_POSIX_TIMERS=y, timer_create_restore_ids are 1-bit fields that
share one memory location in struct signal_struct.  A store to any of
them is a read-modify-write of the whole word, and three of the stores
run without a common lock:

  - PR_SET_CHILD_SUBREAPER writes me->signal->is_child_subreaper with
    no lock held.

  - propagate_has_child_subreaper(), run by walk_process_tree() from
    the same prctl in an ancestor, writes p->signal->has_child_subreaper
    of every descendant p under read_lock(&tasklist_lock), which does
    not exclude the other writers.

  - PR_TIMER_CREATE_RESTORE_IDS writes
    current->signal->timer_create_restore_ids with no lock held.

When a process calls prctl(PR_SET_CHILD_SUBREAPER, 1) while an
ancestor's PR_SET_CHILD_SUBREAPER walk visits it, or while another
thread of the same process calls prctl(PR_TIMER_CREATE_RESTORE_IDS),
the read-modify-write sequences interleave and one of the bits is
silently lost:

  - If has_child_subreaper is lost, the process's orphaned descendants
    are reparented straight to init when it exits: find_new_reaper()
    tests father->signal->has_child_subreaper first and never looks for
    the ancestor subreaper.  The service manager that registered as the
    subreaper never gets SIGCHLD for them and cannot wait() on them.

  - If is_child_subreaper is lost, the prctl returned 0 but the process
    is not a subreaper: orphans of its descendants skip it and are
    reparented to the next subreaper up or to init.
    PR_GET_CHILD_SUBREAPER reads back 0.

  - If timer_create_restore_ids is lost, the prctl returned 0 but
    timer_create() does not restore the requested timer ids (or keeps
    restoring them after _OFF), and _GET reads back the old value.

Documentation/memory-barriers.txt requires all fields of one bitfield
to be protected by one lock for exactly this reason.  No lock is taken
or documented for these flags, and the prctls need no privilege, so any
process can hit the race against its own ancestors or descendants, or
between two of its own threads.

Make is_child_subreaper and has_child_subreaper separate bool members.
Each store then has its own memory location and no read-modify-write
of a neighbour.  The readers and their locking are unchanged.

autoreap stays a bit-field and so shares a memory location only with
timer_create_restore_ids.  That pair is race-free: autoreap is stored
exactly once, in copy_process() before the new signal_struct is
reachable by any other task, and timer_create_restore_ids is only
stored to the signal_struct of an already running process.

Fixes: 749860ce2427 ("prctl: propagate has_child_subreaper flag to every descendant")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261011123440.768054-1-nickolai@csail.mit.edu
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/signal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 7135324f8fb3c..324a3fd0f3c3e 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -119,8 +119,8 @@ struct signal_struct {
 	 * process will inherit a flag if they should look for a
 	 * child_subreaper process at exit.
 	 */
-	unsigned int		is_child_subreaper:1;
-	unsigned int		has_child_subreaper:1;
+	bool			is_child_subreaper;
+	bool			has_child_subreaper;
 	unsigned int		autoreap:1;
 
 #ifdef CONFIG_POSIX_TIMERS
-- 
2.53.0



