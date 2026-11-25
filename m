Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622445;
	b=DiNtoHWdBMSP3RPrIjn54tqld7ytlryJW2ZjyuZS9dxs+O3GnB+bnS8MX/mp4XJRp0fg
	 GWz27KA1aQzdQnJPQb42M4eM78+QPScf/UBLUiFU0+BYxGvaJT7b0N6jhTLJiXQv5QMVT
	 9wqLruGRmZMk4WqTapYCi8slrBwizv7Qb2nm5E0FfeZ08TSpFrROfGgyXMCEJ0KDDRnIa
	 YAE3zcXwss7c+xnpSs6sw+SJnkwZLubZocMIiMRt+lbZkdaDlhsuaw6e8c4FBxXq5zd95
	 Cm6/sFa+dw1z+JX82Nu7hNRjEaM+Awi0Sl8V81MhPPHxNTULSmPG1FysC0ySnKZH0ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJmK8+wvw1Uq1zcLPs0QOU8Z2TV6/GFOj+UcbViut1M=;
	b=NNxXxfm4cTcQD9VloW6fXHwdAF61HFCkouZmuFTuxTQwdvEUwrgGZNvdSCLtYYn33aeG
	 75S1X4aN4NdkjP7QcGZi7FyYFHM1yZ40t4S9UfZ5VPiwKE72Jtvskoma602bWWkDvVGm+
	 wzcjtHlLdeZegePGwHbAagFmUfRYdnqPWNl2Hi1fKwAqdkthRVDuVzGF7Zj8grL0nnxML
	 aOcdmMPYi6FANB5rXTXiPBR9u+xsmVUCVA9GX98HpEFNLYyLZ/vCQwVTNXTsTJ38dAqpX
	 UC+q0moCsx1Q0mj2TzZn6BnZsuAhzrah+uiI6nUT9Tr2sydXIDhtbSm0jRTSmhvvvXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VE6o6VLM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E7606A321;
	Wed, 25 Nov 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VE6o6VLM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F5C1F000CA;
	Wed, 25 Nov 2026 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622444;
	bh=uJmK8+wvw1Uq1zcLPs0QOU8Z2TV6/GFOj+UcbViut1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VE6o6VLMtxcwic12Zllm1aLCb/D2ynL3eqVxjcf/v48m0+ejlWleBMjUlzXjY2wTM
	 2D0dkOV4S9XkJrKHvM6p3YUCqxQyz4MwFBoXeyx7Ez4H7tTPkDVOWq+xPttWgX5P40
	 FGgrhqclTemWwjsR+A0qpIyfIEmOqbalwgD/Qlos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/990] bpf: Dont converge a loop on an iterator that was created anew
Date: Wed, 25 Nov 2026 15:31:45 +0100
Message-ID: <20261125143834.695342991@linuxfoundation.org>
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
[ sashal: Compares ref_obj_id instead of id for iterator identity, since iterators have no id here, and applies the check in is_state_visited() in the old verifier layout with old_frame added to the existing declaration. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 407526349ccfa..2c1afef34070d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20072,8 +20072,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 			 */
 			if (is_iter_next_insn(env, insn_idx)) {
 				if (states_equal(env, &sl->state, cur, RANGE_WITHIN)) {
-					struct bpf_func_state *cur_frame;
+					struct bpf_func_state *cur_frame, *old_frame;
 					struct bpf_reg_state *iter_state, *iter_reg;
+					struct bpf_reg_state *old_iter;
 					int spi;
 
 					cur_frame = cur->frame[cur->curframe];
@@ -20087,7 +20088,16 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
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
 						loop = true;
 						goto hit;
 					}
-- 
2.53.0



