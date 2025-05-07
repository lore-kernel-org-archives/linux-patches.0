Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C706E28BA9F;
	Wed,  7 May 2025 19:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644915; cv=none; b=Kxzimt5g3Rh0yOigMJNJi4YSMiOayGAoD83k1k2m8r8Dktt1FgIEdedzcC0A6ZwHLOv1Z5WAhIfFMrCKtezAwFvjQa/yOJ1WV41rzGJyUOih90ljUhP/2678R38gS1QDcYVk5d1vMeliBt0Pv8+WwoAJxdLWqLjcSFn4v5fNPm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644915; c=relaxed/simple;
	bh=n6pCJKxegKGSpZR5yA5gbOA1jRZ67Q+SmR3ViptnOEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTYrZU6CFKnzlD80ex8fFLJibNI7QHIPnOuwcmr9n+SYZrFIChS4R8n6JfVZ1kiszVbmQ9trxvTXGiETVe4ruePMzQPW28wwtNkTtU7qTBlG4a2ofHlgQHc+JJTwDQWvA/JrSOiMUTRwr/Lv3ZET1UhugC9Rk+EOAC4KwnQrBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocTjrkZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocTjrkZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B3FC4CEE2;
	Wed,  7 May 2025 19:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644914;
	bh=n6pCJKxegKGSpZR5yA5gbOA1jRZ67Q+SmR3ViptnOEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocTjrkZx4u30wsYdQmUGtuoEn57IelTpeHCxK04vd03cQyXx+iQqmGisnuNF97XXG
	 d6TlZoWhJBJqC8w/9pU98IquWIdg9HHVPF6PWMqcpGUQ5qLsSaTb7tWJFCEAjn3cUD
	 H6SDLf9wlscwUCqWzKUWZdFTzrohs3m5m2dDpqLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 034/129] bpf: refactor bpf_helper_changes_pkt_data to use helper number
Date: Wed,  7 May 2025 20:39:30 +0200
Message-ID: <20250507183814.907269021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit b238e187b4a2d3b54d80aec05a9cab6466b79dde upstream.

Use BPF helper number instead of function pointer in
bpf_helper_changes_pkt_data(). This would simplify usage of this
function in verifier.c:check_cfg() (in a follow-up patch),
where only helper number is easily available and there is no real need
to lookup helper proto.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-3-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/filter.h |    2 -
 kernel/bpf/core.c      |    2 -
 kernel/bpf/verifier.c  |    2 -
 net/core/filter.c      |   61 +++++++++++++++++++++----------------------------
 4 files changed, 30 insertions(+), 37 deletions(-)

--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -915,7 +915,7 @@ bool bpf_jit_needs_zext(void);
 bool bpf_jit_supports_subprog_tailcalls(void);
 bool bpf_jit_supports_kfunc_call(void);
 bool bpf_jit_supports_far_kfunc_call(void);
-bool bpf_helper_changes_pkt_data(void *func);
+bool bpf_helper_changes_pkt_data(enum bpf_func_id func_id);
 
 static inline bool bpf_dump_raw_ok(const struct cred *cred)
 {
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2893,7 +2893,7 @@ void __weak bpf_jit_compile(struct bpf_p
 {
 }
 
-bool __weak bpf_helper_changes_pkt_data(void *func)
+bool __weak bpf_helper_changes_pkt_data(enum bpf_func_id func_id)
 {
 	return false;
 }
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10007,7 +10007,7 @@ static int check_helper_call(struct bpf_
 	}
 
 	/* With LD_ABS/IND some JITs save/restore skb from r1. */
-	changes_data = bpf_helper_changes_pkt_data(fn->func);
+	changes_data = bpf_helper_changes_pkt_data(func_id);
 	if (changes_data && fn->arg1_type != ARG_PTR_TO_CTX) {
 		verbose(env, "kernel subsystem misconfigured func %s#%d: r1 != ctx\n",
 			func_id_name(func_id), func_id);
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7868,42 +7868,35 @@ static const struct bpf_func_proto bpf_t
 
 #endif /* CONFIG_INET */
 
-bool bpf_helper_changes_pkt_data(void *func)
+bool bpf_helper_changes_pkt_data(enum bpf_func_id func_id)
 {
-	if (func == bpf_skb_vlan_push ||
-	    func == bpf_skb_vlan_pop ||
-	    func == bpf_skb_store_bytes ||
-	    func == bpf_skb_change_proto ||
-	    func == bpf_skb_change_head ||
-	    func == sk_skb_change_head ||
-	    func == bpf_skb_change_tail ||
-	    func == sk_skb_change_tail ||
-	    func == bpf_skb_adjust_room ||
-	    func == sk_skb_adjust_room ||
-	    func == bpf_skb_pull_data ||
-	    func == sk_skb_pull_data ||
-	    func == bpf_clone_redirect ||
-	    func == bpf_l3_csum_replace ||
-	    func == bpf_l4_csum_replace ||
-	    func == bpf_xdp_adjust_head ||
-	    func == bpf_xdp_adjust_meta ||
-	    func == bpf_msg_pull_data ||
-	    func == bpf_msg_push_data ||
-	    func == bpf_msg_pop_data ||
-	    func == bpf_xdp_adjust_tail ||
-#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
-	    func == bpf_lwt_seg6_store_bytes ||
-	    func == bpf_lwt_seg6_adjust_srh ||
-	    func == bpf_lwt_seg6_action ||
-#endif
-#ifdef CONFIG_INET
-	    func == bpf_sock_ops_store_hdr_opt ||
-#endif
-	    func == bpf_lwt_in_push_encap ||
-	    func == bpf_lwt_xmit_push_encap)
+	switch (func_id) {
+	case BPF_FUNC_clone_redirect:
+	case BPF_FUNC_l3_csum_replace:
+	case BPF_FUNC_l4_csum_replace:
+	case BPF_FUNC_lwt_push_encap:
+	case BPF_FUNC_lwt_seg6_action:
+	case BPF_FUNC_lwt_seg6_adjust_srh:
+	case BPF_FUNC_lwt_seg6_store_bytes:
+	case BPF_FUNC_msg_pop_data:
+	case BPF_FUNC_msg_pull_data:
+	case BPF_FUNC_msg_push_data:
+	case BPF_FUNC_skb_adjust_room:
+	case BPF_FUNC_skb_change_head:
+	case BPF_FUNC_skb_change_proto:
+	case BPF_FUNC_skb_change_tail:
+	case BPF_FUNC_skb_pull_data:
+	case BPF_FUNC_skb_store_bytes:
+	case BPF_FUNC_skb_vlan_pop:
+	case BPF_FUNC_skb_vlan_push:
+	case BPF_FUNC_store_hdr_opt:
+	case BPF_FUNC_xdp_adjust_head:
+	case BPF_FUNC_xdp_adjust_meta:
+	case BPF_FUNC_xdp_adjust_tail:
 		return true;
-
-	return false;
+	default:
+		return false;
+	}
 }
 
 const struct bpf_func_proto bpf_event_output_data_proto __weak;


