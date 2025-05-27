Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C536728002F;
	Tue, 27 May 2025 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367539; cv=none; b=ft0fnDwLL6li+4Ifaxhb+nYn9KszfwIi4aZeqhLs7fCzkKIExhEtdfXOG3W9Hgl303JKV5EAixFRmx02p0zIvV2H9Sy5aFwABaRT9Kb2UYcK4rFCH5ziD0pKTuFa0na4lIG34wydUuWwwlh8G0D9JIMCMu1+v8U/qXT4CvoRZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367539; c=relaxed/simple;
	bh=JmloS6YiLpURbywUJdoGQSyn82e/kMMj3RBJAXiAlzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXQNjS46WW+/eXPAzVqIFcL2xQ7h+c9cGybw3W+1rHDlvvI9InlLOQs+NDCOkOTNcUtU2tyQtQBtV/OmZ1f/udNKcvv2ncMLRZdwwHUmnp9M+5sNNeMglfAuXCDCgWSxHLRNL0ILEIatHwl+OnOX5ReILB4eur6to0oxJbI522E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flSW+XmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flSW+XmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBC1C4CEF4;
	Tue, 27 May 2025 17:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367539;
	bh=JmloS6YiLpURbywUJdoGQSyn82e/kMMj3RBJAXiAlzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flSW+XmGMmcLUVsjoICsabo1GW7F8lJqOUqx64U4zR02gmQtUoHWDrKf1GBG0fZV5
	 p6DWV/tfeL21mrKN8Pzg/3S0/z07yc9WpWNogddgkNhhIKAD1oGJJHC+u+UKo0FYpc
	 0v3VNoy0a2V4FImXfYaV/k2bqDgFFAiv/ifEtofA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 421/783] bpf: copy_verifier_state() should copy loop_entry field
Date: Tue, 27 May 2025 18:23:38 +0200
Message-ID: <20250527162530.259597008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit bbbc02b7445ebfda13e4847f4f1413c6480a85a9 ]

The bpf_verifier_state.loop_entry state should be copied by
copy_verifier_state(). Otherwise, .loop_entry values from unrelated
states would poison env->cur_state.

Additionally, env->stack should not contain any states with
.loop_entry != NULL. The states in env->stack are yet to be verified,
while .loop_entry is set for states that reached an equivalent state.
This means that env->cur_state->loop_entry should always be NULL after
pop_stack().

See the selftest in the next commit for an example of the program that
is not safe yet is accepted by verifier w/o this fix.

This change has some verification performance impact for selftests:

File                                Program                       Insns (A)  Insns (B)  Insns   (DIFF)  States (A)  States (B)  States (DIFF)
----------------------------------  ----------------------------  ---------  ---------  --------------  ----------  ----------  -------------
arena_htab.bpf.o                    arena_htab_llvm                     717        426  -291 (-40.59%)          57          37  -20 (-35.09%)
arena_htab_asm.bpf.o                arena_htab_asm                      597        445  -152 (-25.46%)          47          37  -10 (-21.28%)
arena_list.bpf.o                    arena_list_del                      309        279    -30 (-9.71%)          23          14   -9 (-39.13%)
iters.bpf.o                         iter_subprog_check_stacksafe        155        141    -14 (-9.03%)          15          14    -1 (-6.67%)
iters.bpf.o                         iter_subprog_iters                 1094       1003    -91 (-8.32%)          88          83    -5 (-5.68%)
iters.bpf.o                         loop_state_deps2                    479        725  +246 (+51.36%)          46          63  +17 (+36.96%)
kmem_cache_iter.bpf.o               open_coded_iter                      63         59     -4 (-6.35%)           7           6   -1 (-14.29%)
verifier_bits_iter.bpf.o            max_words                            92         84     -8 (-8.70%)           8           7   -1 (-12.50%)
verifier_iterating_callbacks.bpf.o  cond_break2                         113        107     -6 (-5.31%)          12          12    +0 (+0.00%)

And significant negative impact for sched_ext:

File               Program                 Insns (A)  Insns (B)  Insns         (DIFF)  States (A)  States (B)  States      (DIFF)
-----------------  ----------------------  ---------  ---------  --------------------  ----------  ----------  ------------------
bpf.bpf.o          lavd_init                    7039      14723      +7684 (+109.16%)         490        1139     +649 (+132.45%)
bpf.bpf.o          layered_dispatch            11485      10548         -937 (-8.16%)         848         762       -86 (-10.14%)
bpf.bpf.o          layered_dump                 7422    1000001  +992579 (+13373.47%)         681       31178  +30497 (+4478.27%)
bpf.bpf.o          layered_enqueue             16854      71127     +54273 (+322.02%)        1611        6450    +4839 (+300.37%)
bpf.bpf.o          p2dq_dispatch                 665        791        +126 (+18.95%)          68          78       +10 (+14.71%)
bpf.bpf.o          p2dq_init                    2343       2980        +637 (+27.19%)         201         237       +36 (+17.91%)
bpf.bpf.o          refresh_layer_cpumasks      16487     674760   +658273 (+3992.68%)        1770       65370  +63600 (+3593.22%)
bpf.bpf.o          rusty_select_cpu             1937      40872    +38935 (+2010.07%)         177        3210   +3033 (+1713.56%)
scx_central.bpf.o  central_dispatch              636       2687      +2051 (+322.48%)          63         227     +164 (+260.32%)
scx_nest.bpf.o     nest_init                     636        815        +179 (+28.14%)          60          73       +13 (+21.67%)
scx_qmap.bpf.o     qmap_dispatch                2393       3580       +1187 (+49.60%)         196         253       +57 (+29.08%)
scx_qmap.bpf.o     qmap_dump                     233        318         +85 (+36.48%)          22          30        +8 (+36.36%)
scx_qmap.bpf.o     qmap_init                   16367      17436        +1069 (+6.53%)         603         669       +66 (+10.95%)

Note 'layered_dump' program, which now hits 1M instructions limit.
This impact would be mitigated in the next patch.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250215110411.3236773-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 68715b18df5e2..0752e8e556389 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1661,6 +1661,7 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 	dst_state->callback_unroll_depth = src->callback_unroll_depth;
 	dst_state->used_as_loop_entry = src->used_as_loop_entry;
 	dst_state->may_goto_depth = src->may_goto_depth;
+	dst_state->loop_entry = src->loop_entry;
 	for (i = 0; i <= src->curframe; i++) {
 		dst = dst_state->frame[i];
 		if (!dst) {
@@ -19264,6 +19265,8 @@ static int do_check(struct bpf_verifier_env *env)
 						return err;
 					break;
 				} else {
+					if (WARN_ON_ONCE(env->cur_state->loop_entry))
+						env->cur_state->loop_entry = NULL;
 					do_print_state = true;
 					continue;
 				}
-- 
2.39.5



