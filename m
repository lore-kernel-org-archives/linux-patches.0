Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622416;
	b=GceoNbgeJguwX7SKyRJ/JcZ29phuVXJ5rb6nC/HNWUqFK/iyOtfLojUwetuXjQiyXkxk
	 v1mUG9AgAcgIOldbbx6MOvHmdmw6M4WFm2/aZNEQ6Hv5VaLjk7YIDdn2xub2onk2PZoRu
	 GXr/pNHFshYoDLVO3YkVOsY/6N7lrVqjES6M/80vhcarAWDou6VuUWC3xvYLVcccyxxy9
	 NbSUHaZO+WxHRBGl3ncBHvW1E2Nba/IkSS/zB8v4/qjKyL0hFHH0dWct/NDqXzCqsb7IE
	 PNdsw9q9qxdg9x9pl4yvepRmPanPL3B1iULZoM86SnkAm3YPnJ55XN/86zm6fWvxw+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MMGek8h6eBVe85gKdi8Q189t0FmvgotCc3EHGUoOxgY=;
	b=wBMr4Qc+aEj49vtj5/AyqnGPf14xl30Yoe1q9LfW4kSHujnsBrfcgQelhe+pNa/8fIV0
	 oG/9Prrw1RelBU4Rpe1xJP/SF296Flx+Qo6QntzfaLOPci76dheqqKpXGrDYyBDOmowNP
	 nN1eS2kVTDvezCrXLDd5rY089gDZK0Z5rf7eL0PE6IRAnkshskPBKkscNKbItq59K5tI0
	 W5yOWFe/TuXS6I5krzqpfz7YSf0tmL4AFNQfTJx1V2V8rHsaKWqP2LSYmZeHtNvhDaAYx
	 HwZG9OtTe2yebYLqn21U5o6OLs1LLjUdiaioCiEKR6jiNUr9n1DplmuPC14EhJgVrOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlCMTXDV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B17606A334;
	Wed, 25 Nov 2026 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlCMTXDV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6371F000C0;
	Wed, 25 Nov 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622415;
	bh=MMGek8h6eBVe85gKdi8Q189t0FmvgotCc3EHGUoOxgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlCMTXDVJGPSv6ISmgFYhnsTdcUpf7Ga4Qe5Rsu+c0R3GQRmk6DI+6+l2NqJT1qrV
	 H5+vdCpFUDRskTm7Ux01bzvsqYNcGxvHmUPW1pmHUBnY2d0enVTHzt3nfyfUeXCkIm
	 oDMUHKFRkGQaXaGh3AEbf6x35yKS8HUyhLVs64I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/990] bpf: Keep target extended until its last freplace link detaches
Date: Wed, 25 Nov 2026 15:31:36 +0100
Message-ID: <20261125143834.482736336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: adjusted context in include/linux/bpf.h, where neighboring struct members differ, and in the trampoline code, which still uses the older bpf_tramp_link layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     | 4 ++--
 kernel/bpf/arraymap.c   | 2 +-
 kernel/bpf/trampoline.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5af5a7f6a21..f165743cd71f3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1624,14 +1624,13 @@ struct bpf_prog_aux {
 	bool xdp_has_frags;
 	bool exception_cb;
 	bool exception_boundary;
-	bool is_extended; /* true if extended by freplace program */
 	bool jits_use_priv_stack;
 	bool priv_stack_requested;
 	bool changes_pkt_data;
 	bool might_sleep;
 	bool kprobe_write_ctx;
 	u64 prog_array_member_cnt; /* counts how many times as member of prog_array */
-	struct mutex ext_mutex; /* mutex for is_extended and prog_array_member_cnt */
+	struct mutex ext_mutex; /* mutex for freplace_link_cnt and prog_array_member_cnt */
 	struct bpf_arena *arena;
 	void (*recursion_detected)(struct bpf_prog *prog); /* callback if recursion is detected */
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
@@ -1662,6 +1661,7 @@ struct bpf_prog_aux {
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
 	u64 (*bpf_exception_cb)(u64 cookie, u64 sp, u64 bp, u64, u64);
+	u16 freplace_link_cnt; /* counts freplace links extending this prog */
 #ifdef CONFIG_SECURITY
 	void *security;
 #endif
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 248ab6854cf24..859fb807ea899 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -967,7 +967,7 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 	}
 
 	mutex_lock(&prog->aux->ext_mutex);
-	is_extended = prog->aux->is_extended;
+	is_extended = prog->aux->freplace_link_cnt > 0;
 	if (!is_extended)
 		prog->aux->prog_array_member_cnt++;
 	mutex_unlock(&prog->aux->ext_mutex);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index ccb943b7ac2c1..478ea4ec3a801 100644
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



