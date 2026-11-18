Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020842;
	b=d8eFCRD6fwpyrhaXkrXs9HgC2IP++JdAi/KQhKdMXxxvxiceUuWt/P8fKOZekt16tZnq
	 F64dVwK1L2bswhCNVPS+ONu/IJxuskEhdkkmI6vsbvCCnlJpkczeM4wup1s6BVu8MxL5y
	 EQ3YlD6czaQ0dBBdj9k7+rPh/B/5YNhs/56qhPYfBy2VnwWioe+wBGx6XI9kiaE9t/1O1
	 /3+TgP/c5yYblTbKV8X0j13+ffUlQyE7QJCIT97Xk4qzk9cq7wn8nyuPjpnfAqPEBJEV4
	 VFzESLXv2YrSX7SPFvaCguvuB6Y4Ik3+VgEhj5xi6A7vqHr4gDFGq4EAwhKSJ2ciRrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a6tbzX5/TqRlB8NhcvC8GeViWAPUFkVZVEOorF43II8=;
	b=w1YDnY+AfxVjdQexaRusxbhDhvvIqauCj1YcFbB2mWBjeXo2PhwE5dP3TL7qxoHd6evl
	 xLakj9JSiC78nwE8/36tltJatFf6jCyEYgZJErcMeRw49d1mev8346wOtheVUzZp/8QMG
	 RAl93rR9j6OKeW/7HZYxbdB137RAg/KPG5//eXzIYVrGJ7f0OeC3s6o6DmR9KjPRCvuqL
	 VabTvwzms+LTqu2QJNO9NzqneI8GXrbqHIt6NCe1GZ1X204WWPYuEOiRjgmXitqSSp3LC
	 KdayfClh+jj8o7atCM6xEFbxkMkJ42OBunhhKl6lx+V6vgOdvMyQXTYwZ6KWAuoUHqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OuOKF56t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D692606A335;
	Wed, 18 Nov 2026 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OuOKF56t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A521F000C4;
	Wed, 18 Nov 2026 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020842;
	bh=a6tbzX5/TqRlB8NhcvC8GeViWAPUFkVZVEOorF43II8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuOKF56tlFYxOyFbD1mCOp3A2fpCGY70+knaYX2lEZqiZ8Jqf6i4Lmm0jGAj+HHQS
	 +mKg8e1rgOZZOID3OuFVOQTMarPNHsbs8rlUvXzp2ZfQgtEaPKG9mh4ur7mgwvjpCb
	 mxjAU3fBFTuJoi0rLLJ6DnnyWQce2ZOPm5lgej+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2093/2651] bpf: Reject sleepable programs for task_vma iterator
Date: Wed, 18 Nov 2026 15:55:33 +0100
Message-ID: <20261118150401.369205164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit dfcd1765911223df60845e288ad392d5237f47a3 ]

A sleepable "iter.s/task_vma" program can be attached, but its ->show()
callback runs with the mmap_lock of the iterated mm held for read. As soon
as the program runs, bpf_iter_run_prog() calls might_fault(), and any
bpf_copy_from_user() or bpf_copy_from_user_task() it does may really fault
or take mmap_lock again. With lockdep this is reported as recursive
locking of mmap_lock. Without lockdep, a fault on the reader's own mm, or
access_process_vm() on the iterated mm, has to take mmap_lock for read
again. If a writer queued up in the meantime that blocks behind the
writer, which in turn waits for the read lock the iterator already holds,
and the read() hangs:

    reader (iter.s/task_vma)        other thread of the same mm
    task_vma_seq_get_next()
      mmap_read_lock(mm)
                                    mmap_write_lock(mm)  <- waits
    bpf prog: copy_from_user()
      page fault
        mmap_read_lock(mm)          <- queued behind the writer

The reader waits killable, so the hang lasts until it gets a fatal signal.

bpf_iter_link_attach() allows sleepable programs for the targets that set
BPF_ITER_RESCHED, and task_vma sets it because cond_resched() between VMAs
is fine with mmap_lock held. Rescheduling between objects and running a
sleepable program inside ->show() are different properties, though, and
task_vma only has the first one. The open-coded task_vma iterator does not
have this problem since it hands out a snapshot of the VMA and holds no
lock when it returns to the program.

The vma handed to the program is only stable under mmap_lock, so the lock
can't be dropped around ->show(). Add a feature flag BPF_ITER_NOSLEEP for
targets which can't run sleepable programs although they can reschedule,
and set it for task_vma.

The check at attach time is not enough. BPF_LINK_UPDATE replaces the
program of a link, and bpf_iter_link_replace() only compares the type, the
attach type and the BTF id of the two programs, which are the same for a
sleepable and a non-sleepable one. Do the check there as well. That also
closes this way around the existing rule: so far a sleepable program could
be put on a link of a target that doesn't set BPF_ITER_RESCHED, like the
hash map element iterator, which runs it under rcu_read_lock().

BPF_LINK_CREATE of a sleepable program for the task_vma target, and
BPF_LINK_UPDATE to one, now fail with -EINVAL, also for programs that
don't touch user memory and have been working since sleepable iterator
programs exist. The programs can still be loaded. They have to be
loaded as non-sleepable programs, or use the open-coded iterator.

Fixes: b77fb25dcb34 ("bpf: Add support for bpf iterator programs to use sleepable helpers")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-6-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h    |  3 ++-
 kernel/bpf/bpf_iter.c  | 17 ++++++++++++++---
 kernel/bpf/task_iter.c |  6 +++++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 86f7b70bbd9a1..5f39502e4a57b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3019,7 +3019,8 @@ typedef const struct bpf_func_proto *
 			     const struct bpf_prog *prog);
 
 enum bpf_iter_feature {
-	BPF_ITER_RESCHED	= BIT(0),
+	BPF_ITER_RESCHED	= BIT(0),	/* may cond_resched() between objects */
+	BPF_ITER_NOSLEEP	= BIT(1),	/* ->show() can't run sleepable progs */
 };
 
 #define BPF_ITER_CTX_ARG_MAX 2
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index b40eb404adab9..fc3a75684ef7f 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -72,6 +72,15 @@ static inline bool bpf_iter_target_support_resched(const struct bpf_iter_target_
 	return tinfo->reg_info->feature & BPF_ITER_RESCHED;
 }
 
+/* Only allow sleepable program for resched-able iterator that can run one */
+static bool bpf_iter_target_support_prog(const struct bpf_iter_target_info *tinfo,
+					 const struct bpf_prog *prog)
+{
+	return !prog->sleepable ||
+	       (bpf_iter_target_support_resched(tinfo) &&
+		!(tinfo->reg_info->feature & BPF_ITER_NOSLEEP));
+}
+
 static bool bpf_iter_support_resched(struct seq_file *seq)
 {
 	struct bpf_iter_priv_data *iter_priv;
@@ -409,6 +418,8 @@ static int bpf_iter_link_replace(struct bpf_link *link,
 				 struct bpf_prog *new_prog,
 				 struct bpf_prog *old_prog)
 {
+	struct bpf_iter_link *iter_link =
+		container_of(link, struct bpf_iter_link, link);
 	int ret = 0;
 
 	mutex_lock(&link_mutex);
@@ -419,7 +430,8 @@ static int bpf_iter_link_replace(struct bpf_link *link,
 
 	if (link->prog->type != new_prog->type ||
 	    link->prog->expected_attach_type != new_prog->expected_attach_type ||
-	    link->prog->aux->attach_btf_id != new_prog->aux->attach_btf_id) {
+	    link->prog->aux->attach_btf_id != new_prog->aux->attach_btf_id ||
+	    !bpf_iter_target_support_prog(iter_link->tinfo, new_prog)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -544,8 +556,7 @@ int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	if (!tinfo)
 		return -ENOENT;
 
-	/* Only allow sleepable program for resched-able iterator */
-	if (prog->sleepable && !bpf_iter_target_support_resched(tinfo))
+	if (!bpf_iter_target_support_prog(tinfo, prog))
 		return -EINVAL;
 
 	link = kzalloc_obj(*link, GFP_USER | __GFP_NOWARN);
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 13e1aabe6f886..cf2bf388e1817 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -737,7 +737,11 @@ static const struct bpf_iter_seq_info task_vma_seq_info = {
 static struct bpf_iter_reg task_vma_reg_info = {
 	.target			= "task_vma",
 	.attach_target		= bpf_iter_attach_task,
-	.feature		= BPF_ITER_RESCHED,
+	/*
+	 * ->show() runs with the mmap_lock of the iterated mm held, which a
+	 * sleepable program takes again when it faults on user memory.
+	 */
+	.feature		= BPF_ITER_RESCHED | BPF_ITER_NOSLEEP,
 	.ctx_arg_info_size	= 2,
 	.ctx_arg_info		= {
 		{ offsetof(struct bpf_iter__task_vma, task),
-- 
2.53.0



