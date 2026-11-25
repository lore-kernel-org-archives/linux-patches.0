Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625281;
	b=2HwIMJl0bB8FsJtNcrpTpg+7fgJmQHXqM9mpkuxjdafLgjVYlKefmprcV2VS6icBjJc5
	 y/AZhvz7ZsrGARu6ZYResK18AD0Zy6ZmS9u4ELvNHc4RpysG2kQ7PsDqIqoLG08vw6rb3
	 cvT8aVZmO8pA2xFoe1FdLGSBke2lqMm1GPvk6lfjxDvtJE6hMIifj5me3lgLQpL04/Awb
	 McOdeBxfwxr8lbNoKRAaubhwUso06Eb3O/qev553EqtmCJa3K0vCWV5zhW/qWBpoLLEu1
	 VLm/Jvs8myiOjwpO7D7Tf9TmgWAXhREtXBJlEa8W/Eceune4LD4i7DseOfTerD5x10w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NI/F7PRsgCEAref+5xbDTrZEjMLGTueKJ11sYrathOM=;
	b=InSaTTuXT5fllNxkmqi1KBibsO2XaMna3l4OSyckeB7JhICK4nDttESei/am1geP2Xqr
	 MSFwv93dqaDoQhikNJdia63ZNDVUgY+86hjlvhzHWPEF7sk6Nt8+eRBzNRcYgXgGYb8eF
	 o01SN97/BqfU8TfirlOhUuOUIryBKV0GY53n5hAz+bxA+5SQF+9FSvQP1h6i/fZloH5HR
	 M+jBLpzQX7y/+IJprJWJvwwCDQa122L+DEoIUYoc26NU3jj1XgcJu7eYV3GAILG7Gv2Is
	 8210msigyUcnides5b1ZHn6Qu0PleCMmPhcXaOMGvOHTPUFmfMA8I/mXuG9bA/a1R0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FrCn/kV2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3D8606A31E;
	Wed, 25 Nov 2026 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrCn/kV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE831F000E0;
	Wed, 25 Nov 2026 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625281;
	bh=NI/F7PRsgCEAref+5xbDTrZEjMLGTueKJ11sYrathOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrCn/kV2YnCBZVRHq4NHjsmvMR9i7pggpjIVOyzOXPXeT887VLOVudDtrBZm3a424
	 xTJIi1M0YffQPK2xJSAEnqKBI4i99weM+1TsW1+nDzHtP+HeLacb2jx5TmINCFi1kB
	 AytBX0RhBfKHPFbhusB00acRp+niDTD4fzWOrGYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 420/816] bpf: Keep target extended until its last freplace link detaches
Date: Wed, 25 Nov 2026 15:32:48 +0100
Message-ID: <20261125143858.919849452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit c43c348a84460b003fa757dd43d8c89848ae220d ]

The is_extended / prog_array_member_cnt protocol introduced by commit
d6083f040d5d ("bpf: Prevent tailcall infinite loop caused by freplace")
keeps a prog extended by a freplace program out of prog_array maps, and
vice versa: once a tail call re-enters an extended subprogram, its
tail_call_cnt resets on every execution and the loop never terminates.

But is_extended is a plain boolean, while one target prog can carry
several freplace links at the same time, one on its entry and one on a
global subprogram.  __bpf_trampoline_unlink_prog() cleared is_extended
whenever *any* freplace link detached, so detaching one of two links
re-armed the unbounded loop through the remaining one.

Replace the is_extended boolean with a count of the freplace links
attached to each target prog, so the target stays extended until its
last link detaches.  Also rename bpf_freplace_check_tgt_prog() to
bpf_freplace_link_tgt_prog(), as the helper has never been a pure
check: it reserves the target prog on success.

Fixes: d6083f040d5d ("bpf: Prevent tailcall infinite loop caused by freplace")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20260924023737.1140521-2-chenyuan_fl@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
[ sashal: adjusted bpf.h context for the older struct layout and changed bpf_tramp_node usage to the older bpf_tramp_link API in the trampoline context, with the changed lines identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     | 4 ++--
 kernel/bpf/arraymap.c   | 2 +-
 kernel/bpf/trampoline.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 16fe36438173a..59661363d08f6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1513,10 +1513,9 @@ struct bpf_prog_aux {
 	bool xdp_has_frags;
 	bool exception_cb;
 	bool exception_boundary;
-	bool is_extended; /* true if extended by freplace program */
 	bool changes_pkt_data;
 	u64 prog_array_member_cnt; /* counts how many times as member of prog_array */
-	struct mutex ext_mutex; /* mutex for is_extended and prog_array_member_cnt */
+	struct mutex ext_mutex; /* mutex for freplace_link_cnt and prog_array_member_cnt */
 	struct bpf_arena *arena;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
@@ -1544,6 +1543,7 @@ struct bpf_prog_aux {
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
 	u64 (*bpf_exception_cb)(u64 cookie, u64 sp, u64 bp, u64, u64);
+	u16 freplace_link_cnt; /* counts freplace links extending this prog */
 #ifdef CONFIG_SECURITY
 	void *security;
 #endif
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index fcc0ca7ee8831..5c70ff1e7d4ac 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -957,7 +957,7 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	}
 
 	mutex_lock(&prog->aux->ext_mutex);
-	is_extended = prog->aux->is_extended;
+	is_extended = prog->aux->freplace_link_cnt > 0;
 	if (!is_extended)
 		prog->aux->prog_array_member_cnt++;
 	mutex_unlock(&prog->aux->ext_mutex);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 76fdd4ee9225a..a85e6491fbd1b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -532,7 +532,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-static int bpf_freplace_check_tgt_prog(struct bpf_prog *tgt_prog)
+static int bpf_freplace_link_tgt_prog(struct bpf_prog *tgt_prog)
 {
 	struct bpf_prog_aux *aux = tgt_prog->aux;
 
@@ -546,7 +546,7 @@ static int bpf_freplace_check_tgt_prog(struct bpf_prog *tgt_prog)
 		 */
 		return -EBUSY;
 
-	aux->is_extended = true;
+	aux->freplace_link_cnt++;
 	return 0;
 }
 
@@ -573,7 +573,7 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link,
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt)
 			return -EBUSY;
-		err = bpf_freplace_check_tgt_prog(tgt_prog);
+		err = bpf_freplace_link_tgt_prog(tgt_prog);
 		if (err)
 			return err;
 		tr->extension_prog = link->link.prog;
@@ -628,7 +628,7 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
 		guard(mutex)(&tgt_prog->aux->ext_mutex);
-		tgt_prog->aux->is_extended = false;
+		tgt_prog->aux->freplace_link_cnt--;
 		return err;
 	}
 	hlist_del_init(&link->tramp_hlist);
-- 
2.53.0



