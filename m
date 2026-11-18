Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027411;
	b=twNHFNpCO5YVZkUMIFBgZYoypzDTXde14/HofrZrk6QwxBZTptuU81YlQyiSXVUG2n4T
	 F+vKp7Yq/3cLJSp7eDrn9HWYtFqWzuKd/O4V0UEdXgaHtSDrsuJVE0/EOz+5fulyuTbY3
	 7Bz9HkDiMYN021U81tt9BppnY9CMpM6ulZ3mDgMyXTCwFiH9EO+5ZvhUSMzyZ3/Qibga3
	 X9nUW2048K3uU2hJCWS5slwQca5BjmNoelVtT2FXNYkTYdS46+BnfEs6aCSiIF+1RP6yA
	 An0Kd/o+ll2PuLYrQcBLBLb40azkYmW7oGIX6eMAQ6fq4Va+4jyqCVUj/9Bngqa+ENA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tTdKqxpmHT5/JYPQ+eh2kjGqc+xim12qnCEt5X7LPsw=;
	b=EeJ46k/r7qg/RcnKPKlqT46J4yhkqqeD+VHs2EK4aI5FFRHjQOc8zRV6WGIqkqx+ahds
	 z7G35B3fVH2j5BvUi7l05yYSV+5mpe2j+M2KY9OWd6i4GXgjbbnrUzxTA8GL/h5fTvIbo
	 ybMf20rv4JuqHY/w6PXXVBfFD1wN5o7dS98r0L3jkMc/PzURuf2xfs4MVoKEbTxvUQrmc
	 21ZgK/fwTcNDmnRNCIQydFk5hPeoXGPnrmeuwqkvWDv+z5bJYl66z4pQQeH5vlPjNtgtM
	 xMr/w0pfCi/ZBwtNBllB09yfdfxvB074WJHEUBS27CWKwNqmTypoIEDV40ngXFbs0gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vL9C7Kh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ABB60A260F;
	Wed, 18 Nov 2026 18:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vL9C7Kh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EBE1F000C4;
	Wed, 18 Nov 2026 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027411;
	bh=tTdKqxpmHT5/JYPQ+eh2kjGqc+xim12qnCEt5X7LPsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vL9C7Kh//fIIs3Z29Ra2m5KJp/nCtjG8DCsaU5ZLBlqYUTbbYIQ0sm3Z8UU+obsVs
	 VgBbIjhTJLf3zbyyxKSOVPNHlCIo4vlS/UB6nsU80b00ZJWwxvytD2RwsOgjI8pIDV
	 UH9ILuShoUmQ3jDEWVr8fUFjwjK0EJbiMvJQHFxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1738/2151] bpf: Keep the symbols of a program until it has ended
Date: Wed, 18 Nov 2026 15:57:53 +0100
Message-ID: <20261118150225.177760628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 51e303b39b949..d840ec32d95ba 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1698,6 +1698,7 @@ struct bpf_prog_aux {
 	union {
 		struct work_struct work;
 		struct rcu_head	rcu;
+		struct rcu_work rwork;
 	};
 	struct bpf_stream stream[2];
 };
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 076d84ee89a92..346588a32a854 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2944,12 +2944,40 @@ static void bpf_free_used_btfs(struct bpf_prog_aux *aux)
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
 	bpf_prog_stream_free(aux->prog);
@@ -2968,20 +2996,12 @@ static void bpf_prog_free_deferred(struct work_struct *work)
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
index fc3d530095a18..79668e8441419 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2385,6 +2385,8 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
 	btf_put(aux->btf);
+	kvfree(aux->jited_linfo);
+	kvfree(aux->linfo);
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
 	free_uid(aux->user);
@@ -2394,10 +2396,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 
 static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
-	bpf_prog_kallsyms_del_all(prog);
 	module_put(prog->aux->mod);
-	kvfree(prog->aux->jited_linfo);
-	kvfree(prog->aux->linfo);
 	kfree(prog->aux->kfunc_tab);
 	kfree(prog->aux->ctx_arg_info);
 	if (prog->aux->attach_btf)
-- 
2.53.0



