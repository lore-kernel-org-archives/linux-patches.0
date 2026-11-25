Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625157;
	b=BIO8Qy1jFZg36/ePSkSj5AfbO5DCkBO28iVYG23P/EqFDrb90ygp+V/7bgd16jTw2jSW
	 /IXt2fxvZgqmmVUn1aUEDwQH7GqSzB+Oy7jyYblhA8DthVd0HaJxq39rpfIs5M3WkE/RL
	 u/d4hweDiJVRXQKjH2MFVt4h2GPVD3GuQ1Mxfb7gZygzaGPrPzccXOfz1R42cKnalMkXf
	 mD2cOibizEcn8B38p2IcRz91OEfJZWg7MITFdb3yYx9oX9D9Mb4KkDLByPZGtc9kq/AB8
	 8FQw7c5fWbTrtSD0K1VQAq9c4ofp1PxpS1TNVfat0DfnObTqr7zL4DgjJPuPzVzMmVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/JZl03W+69edSXL91uj+XdqPU8I2QMS76h0AevnJjNY=;
	b=VogLL9GkHwlWcQKWt22dYDcJG3EkBE+VSqzSCadj+W3/FduV6VvH5hQQBXiIpbT2lps1
	 6f6nXC6Zigv0gw5AG7R9cf8Rr/Jym91qK5WZJONra6+HA0cuYGvySsKU63Ni6bnC4D8xu
	 VzmO5MQ5tXA/L+WoDT36aUqHxdsu2UJpUjCSUL2HLdTHfPRRQOECkKzYKjVJAAO5JeNJx
	 8THiRHI2K5Kh6RMU5BXXaqqpjxAS0HY6sTZi/JStMU/7KbCxt6Ld/0fs9kb0FjEIVllee
	 fACz8Gxod70cbPvE9jJ2ZDP354NoK+n9WW/4TWJAYPDRMnOQKqljvc8l3jWn/yZl9+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEm0pPFm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DA9606A323;
	Wed, 25 Nov 2026 16:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEm0pPFm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7761F000C0;
	Wed, 25 Nov 2026 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625156;
	bh=/JZl03W+69edSXL91uj+XdqPU8I2QMS76h0AevnJjNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEm0pPFmcgtav2NHeDxZ/X6rR1TopKo7m8kDdmBjxlpzqDR3vMVrriFBy8qge4YVI
	 e2hBbh8XojjLJKFtLfEGUIIcXoFfy4aqVgKsX0I3zGGb1DIUaFqGGbXuj2XC+T5a4l
	 Yx/WSU3/jU4EHte9vZYmPkt5v4vCSY5CuxfIgGwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/816] bpf: Dont converge a loop on an iterator that was created anew
Date: Wed, 25 Nov 2026 15:32:54 +0100
Message-ID: <20261125143859.056178542@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6f3ee3516305da3043f1787e3890381a54151730 ]

When the verifier reaches bpf_iter_*_next() in a state that is equal to
a state that is still being explored it concludes that the loop
converged, since an active iterator will be drained eventually.
states_equal() matches ids through idmap, so the same is concluded for
an iterator that was destroyed and created again since the old state:

  bpf_iter_num_new(&it, 0, 10);
  loop:
          if (bpf_ktime_get_ns())
                  goto remake;
  next:
          if (!bpf_iter_num_next(&it))
                  goto out;
          goto loop;
  remake:
          bpf_iter_num_destroy(&it);
          bpf_iter_num_new(&it, 0, 10);
          goto next;

Such prog is accepted when the call of bpf_iter_num_next() is the first
prune point after bpf_iter_num_new() and it never returns. Otherwise
it's rejected with "infinite loop detected".

Require the iterator to have the same id in both states.

Fixes: 06accc8779c1 ("bpf: add support for open-coded iterator loops")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924233130.1213812-8-alexei.starovoitov@gmail.com
[ sashal: Applied the hunk to is_state_visited() in verifier.c since states.c doesn't exist here, using open-coded frame/stack lookups and comparing ref_obj_id instead of id because iterator slots never set id. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 86482f36329dd..b66d0487444f1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18659,8 +18659,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 			 */
 			if (is_iter_next_insn(env, insn_idx)) {
 				if (states_equal(env, &sl->state, cur, RANGE_WITHIN)) {
-					struct bpf_func_state *cur_frame;
+					struct bpf_func_state *cur_frame, *old_frame;
 					struct bpf_reg_state *iter_state, *iter_reg;
+					struct bpf_reg_state *old_iter;
 					int spi;
 
 					cur_frame = cur->frame[cur->curframe];
@@ -18674,7 +18675,16 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 					 */
 					spi = __get_spi(iter_reg->off + iter_reg->var_off.value);
 					iter_state = &func(env, iter_reg)->stack[spi].spilled_ptr;
-					if (iter_state->iter.state == BPF_ITER_STATE_ACTIVE) {
+					old_frame = sl->state.frame[iter_reg->frameno];
+					old_iter = &old_frame->stack[spi].spilled_ptr;
+					/*
+					 * states_equal() matches ids through idmap.
+					 * The loop converged only if it's the same
+					 * iterator. The one that was destroyed and
+					 * created again starts from the beginning.
+					 */
+					if (iter_state->iter.state == BPF_ITER_STATE_ACTIVE &&
+					    iter_state->ref_obj_id == old_iter->ref_obj_id) {
 						update_loop_entry(cur, &sl->state);
 						goto hit;
 					}
-- 
2.53.0



