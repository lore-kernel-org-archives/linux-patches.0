Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032342;
	b=WJLxGMgUPMikBkT6ATKlEFG5Ux68wg9eXQYb1xM7VW1Bc7W4N7rOOhsa6hFg7RfeqSvh
	 FdaKIe0FOO4KKvX3wpH89ua9KTD8GbMXQSlANTSjgYEnquYHIqMEun5/+Zcq67/32in9F
	 PQUkQ7+JLXCAIrHaQD2LtA3w6n2L0zDmY1CCYJY7BaNkXIdD6p+9jgTbfUGD21jytowaa
	 lMIrfPJ3XaOfJncSkKvFacj/2ZUx+mCOZaoH4QsBfcMyBH5iz1Xec8ARnrVFBcgPDgcby
	 7iQKSeJmbabt5XysUUg76ociECeDM1KzDBj4lo6azcC3HwgAprCoOl4FkFqhRg87xmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZRjUeqJsM+Cax5b/mIweiYHlRlV0RokJAAhzBXPfiXQ=;
	b=uNqMqjtG/P0MIMCnhD2/js9HY7R3Zc3TXfxw1qKnZTWeZBsNYNaQw/dkYFMFdtGFPZsh
	 5K9lt79hWuF+l+EytyqP8Jp8E/TPiM10O36wnarX1I9y6QyMw9eICPI1woY+6Fekqk4+R
	 cKEozXL1mW9/HD/knEteg4ZXqDUbjYO4d3kDTZH0v5eLd1reG9IWtTalLCubrZ+EWC90w
	 2JXPwk7fe7XK2nCj542zqIdhSvNwuwbRQ9102jW7vY3P2C1Vrwe4kLZ48a5ImW+vTJoh4
	 GEyPYHM9huHKaI8A5Oz8MUIhLuFUZekl1oyjsuCMlr6xM2c6jDofLdV/sgdFfVgAO6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVb7gTYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6265A606A32F;
	Wed, 18 Nov 2026 20:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVb7gTYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D161F000C8;
	Wed, 18 Nov 2026 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032342;
	bh=ZRjUeqJsM+Cax5b/mIweiYHlRlV0RokJAAhzBXPfiXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVb7gTYxV/2peX946+uerdQLoirPBq6AtQA9A7FGfleRM3RRWu283s11jw3uX8Ni9
	 cUPxhL+rYW2UYX2lU6mIbJtbacSQBD+tBqgfJOii7IPfo3X9plt4MTPFkRFhnFUYx/
	 LVAu89Cw/nGdR6TkSdm+PsKGXeBP6fkXxblrGXh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1379/1756] bpf: Keep the symbols of a program until it has ended
Date: Wed, 18 Nov 2026 15:58:26 +0100
Message-ID: <20261118150104.094176415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4eaf4d71b91a983489227336adcab33d8eae58a5 ]

When the last reference to a program goes, __bpf_prog_put_noref() takes
its symbols out of the kallsyms tree and frees its line info at once, and
waits for the grace periods only with the rest.  But the program may still
be running: the link or the array it was called from is gone, the call is
not over.

search_bpf_extables() finds the exception table of a program by its
symbol.  A load that faults, and that the table is there to fix up, is
fatal from then on:

  Oops: general protection fault, probably for non-canonical address
  0xdead0000000006f8: 0000 [#1] SMP NOPTI
  RIP: 0010:0xffffffffc06008f6

It takes a program that is detached and closed on one CPU while it runs on
another.  Unwinders and bpf_prog_find_from_stack() do not know the program
any more either, and the stack dump of a BPF stream reads the freed line
info.

Free the line info behind the grace periods the program needs, as it is
done with the BTF that its text comes from.  Remove the symbols in
bpf_prog_free_deferred(), which runs behind them as well.  The symbols are
looked up under rcu_read_lock(), so the images and the program itself are
freed one more grace period later.  All that the program refers to is
released when it was before.

Fixes: 3dec541b2e63 ("bpf: Add support for BTF pointers to x86 JIT")
Fixes: d7c431cafcb4 ("bpf: Add dump_stack() analogue to print to BPF stderr")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-6-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  |  1 +
 kernel/bpf/core.c    | 50 +++++++++++++++++++++++++++++++-------------
 kernel/bpf/syscall.c |  5 ++---
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e456fe475e017..16fe36438173a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1580,6 +1580,7 @@ struct bpf_prog_aux {
 	union {
 		struct work_struct work;
 		struct rcu_head	rcu;
+		struct rcu_work rwork;
 	};
 };
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3387709aca48e..643ccb230ddda 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2909,12 +2909,40 @@ static void bpf_free_used_btfs(struct bpf_prog_aux *aux)
 	kfree(aux->used_btfs);
 }
 
-static void bpf_prog_free_deferred(struct work_struct *work)
+static void bpf_prog_free_images(struct work_struct *work)
 {
 	struct bpf_prog_aux *aux;
 	int i;
 
+	aux = container_of(to_rcu_work(work), struct bpf_prog_aux, rwork);
+	for (i = 0; i < aux->real_func_cnt; i++) {
+		/* We can just unlink the subprog poke descriptor table as
+		 * it was originally linked to the main program and is also
+		 * released along with it.
+		 */
+		aux->func[i]->aux->poke_tab = NULL;
+		bpf_jit_free(aux->func[i]);
+	}
+	if (aux->real_func_cnt) {
+		kfree(aux->func);
+		bpf_prog_unlock_free(aux->prog);
+	} else {
+		bpf_jit_free(aux->prog);
+	}
+}
+
+static void bpf_prog_free_deferred(struct work_struct *work)
+{
+	struct bpf_prog_aux *aux;
+	bool ksyms;
+
 	aux = container_of(work, struct bpf_prog_aux, work);
+	/*
+	 * A prog that still runs when its last reference goes needs its symbols,
+	 * by which its exception table is found.  It has ended by now.
+	 */
+	ksyms = aux->real_func_cnt || !list_empty(&aux->ksym.lnode);
+	bpf_prog_kallsyms_del_all(aux->prog);
 #ifdef CONFIG_BPF_SYSCALL
 	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
 #endif
@@ -2932,20 +2960,12 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 #endif
 	if (aux->dst_trampoline)
 		bpf_trampoline_put(aux->dst_trampoline);
-	for (i = 0; i < aux->real_func_cnt; i++) {
-		/* We can just unlink the subprog poke descriptor table as
-		 * it was originally linked to the main program and is also
-		 * released along with it.
-		 */
-		aux->func[i]->aux->poke_tab = NULL;
-		bpf_jit_free(aux->func[i]);
-	}
-	if (aux->real_func_cnt) {
-		kfree(aux->func);
-		bpf_prog_unlock_free(aux->prog);
-	} else {
-		bpf_jit_free(aux->prog);
-	}
+	/* The symbols are looked up under rcu_read_lock() */
+	INIT_RCU_WORK(&aux->rwork, bpf_prog_free_images);
+	if (ksyms)
+		queue_rcu_work(system_percpu_wq, &aux->rwork);
+	else
+		bpf_prog_free_images(&aux->rwork.work);
 }
 
 void bpf_prog_free(struct bpf_prog *fp)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b4fde8698c636..3a18b5dc80290 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2195,6 +2195,8 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
 	btf_put(aux->btf);
+	kvfree(aux->jited_linfo);
+	kvfree(aux->linfo);
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
 	free_uid(aux->user);
@@ -2204,10 +2206,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 
 static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
-	bpf_prog_kallsyms_del_all(prog);
 	module_put(prog->aux->mod);
-	kvfree(prog->aux->jited_linfo);
-	kvfree(prog->aux->linfo);
 	kfree(prog->aux->kfunc_tab);
 	if (prog->aux->attach_btf)
 		btf_put(prog->aux->attach_btf);
-- 
2.53.0



