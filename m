Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1518F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48CCC433C7;
	Sun, 16 Jul 2023 19:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537524;
	bh=IdTIutY4uHBSMNXWSLVDbZbdqRIqKBWykVjlWI9Zypc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1ShHMBwDJJZVivBBdIvGzFBfHoqu9RkodxKvs8IbyFh41rtj1y8Yl/ooKVdab9PC
	 7QDgItz4H/YRHYwgskx/IzxXo/TedhFhMxig6K5zCSaft2UZUwiTFhX575OWxjBEOT
	 MzWpiTUNK55w82t+LWHDVvHANYTfvWwOGp19I33o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <olsajiri@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 127/800] bpf: Fix memleak due to fentry attach failure
Date: Sun, 16 Jul 2023 21:39:40 +0200
Message-ID: <20230716194952.053775642@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 108598c39eefbedc9882273ac0df96127a629220 ]

If it fails to attach fentry, the allocated bpf trampoline image will be
left in the system. That can be verified by checking /proc/kallsyms.

This meamleak can be verified by a simple bpf program as follows:

  SEC("fentry/trap_init")
  int fentry_run()
  {
      return 0;
  }

It will fail to attach trap_init because this function is freed after
kernel init, and then we can find the trampoline image is left in the
system by checking /proc/kallsyms.

  $ tail /proc/kallsyms
  ffffffffc0613000 t bpf_trampoline_6442453466_1  [bpf]
  ffffffffc06c3000 t bpf_trampoline_6442453466_1  [bpf]

  $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep "FUNC 'trap_init'"
  [2522] FUNC 'trap_init' type_id=119 linkage=static

  $ echo $((6442453466 & 0x7fffffff))
  2522

Note that there are two left bpf trampoline images, that is because the
libbpf will fallback to raw tracepoint if -EINVAL is returned.

Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <song@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Link: https://lore.kernel.org/bpf/20230515130849.57502-2-laoar.shao@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 84850e66ce3d6..78acf28d48732 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -251,11 +251,8 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total, bool *ip_a
 	return tlinks;
 }
 
-static void __bpf_tramp_image_put_deferred(struct work_struct *work)
+static void bpf_tramp_image_free(struct bpf_tramp_image *im)
 {
-	struct bpf_tramp_image *im;
-
-	im = container_of(work, struct bpf_tramp_image, work);
 	bpf_image_ksym_del(&im->ksym);
 	bpf_jit_free_exec(im->image);
 	bpf_jit_uncharge_modmem(PAGE_SIZE);
@@ -263,6 +260,14 @@ static void __bpf_tramp_image_put_deferred(struct work_struct *work)
 	kfree_rcu(im, rcu);
 }
 
+static void __bpf_tramp_image_put_deferred(struct work_struct *work)
+{
+	struct bpf_tramp_image *im;
+
+	im = container_of(work, struct bpf_tramp_image, work);
+	bpf_tramp_image_free(im);
+}
+
 /* callback, fexit step 3 or fentry step 2 */
 static void __bpf_tramp_image_put_rcu(struct rcu_head *rcu)
 {
@@ -437,7 +442,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 					  &tr->func.model, tr->flags, tlinks,
 					  tr->func.addr);
 	if (err < 0)
-		goto out;
+		goto out_free;
 
 	set_memory_rox((long)im->image, 1);
 
@@ -466,7 +471,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 	}
 #endif
 	if (err)
-		goto out;
+		goto out_free;
 
 	if (tr->cur_image)
 		bpf_tramp_image_put(tr->cur_image);
@@ -477,6 +482,10 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 		tr->flags = orig_flags;
 	kfree(tlinks);
 	return err;
+
+out_free:
+	bpf_tramp_image_free(im);
+	goto out;
 }
 
 static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
-- 
2.39.2



