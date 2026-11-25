Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622427;
	b=r5z1Js/t2qlERMKy/pTZz799CZQCVhdF/uEisifMZyU1KRXHvYw1CGdmLcK6AzyIizVb
	 KDgPAKYLbRYZdu+EpGoQ4wkoSalNFIDHkp6xIItcQRBMijJWK/Ce90jsaY7B5Iw20Q1MK
	 92WQveBQtMylSQbksJGx4SV0hwzzAf/1sH8tuoRuYWe0F7pjTNl7j/n9KoakMw7FR/YIQ
	 CZfnV+44b73XG52ytja9U3mxzxUK5k5LzIvWbfFNthzw8YWwmCm7Uvrm/P7q7xQ7gSMwg
	 eFWeBXfeo8ePW0KVCWSToths7pvnzs4rB6ulKLYiXUeSc/pWYiuogLewC4EpQ75m5Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEQ6op9azN5xZrBQfRwzcraRiiVtzf1lOngunB6B/Hw=;
	b=YgbwyoAOadtR3NHImD//wx4fevdHj10t7HBa2/Wu0WXs7YHUUnfSoxBHgxc2j6YKnIUs
	 nBC80EL2sgrLpylLdI+hqlt8Km9z8mIQ+oNMTHRV0RPsqf0Ngqc1M76YnU/y+0P348H4D
	 0lrhaWdvBg6jVM8uiLO7GNre+1Dp876uGVbgf+3YTqQEBtRbM4mmC4x7Yxrzg4t58SW8O
	 3iFBs+/9ivg3aw7qERfhChVJdk9yQxKWB9BnBavxIrQqYKu9987+3Ct7CeUjKm9Il7i7Q
	 45nxxqESb5CkYCoysAbvjjBO9H7RviA4rcU1dHDrWPqNn3gfLImkgJ1E2lf8pkwJXqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmhoslVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9F6606A33F;
	Wed, 25 Nov 2026 16:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmhoslVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820931F000C0;
	Wed, 25 Nov 2026 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622427;
	bh=qEQ6op9azN5xZrBQfRwzcraRiiVtzf1lOngunB6B/Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmhoslVcWejiVwXBab3dF9jDd6SvqskWmIHbJqP5qDY3R6yD7yfxc9ni2n696+k3c
	 kzf1eZjz0oR9fre1tF/AsgeI/zFlOft2UD4I0PWDsQ1rNe1486Gnx71ir4IiCIgJGv
	 Am+eb6FOZxzs0lGgI/9rF5KgzYzoEkanPnMDZHOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/990] bpf: Look at frame 0 when telling async callback entries apart
Date: Wed, 25 Nov 2026 15:31:40 +0100
Message-ID: <20261125143834.577630505@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit e55220162aae99622d9e80d4700e51c13a6f2a16 ]

push_async_cb() sets in_async_callback_fn and async_entry_cnt on the
callback's own frame, which is frame 0 of the fresh state it starts, and
setup_func_entry() copies neither, so a subprog called by the callback
carries neither. Two places read them from the innermost frame instead.

is_state_visited() skips the infinite loop check when two states differ
in async_entry_cnt, because seeing the same state on a second entry into
an async callback is not a loop. A callback which re-arms itself and
calls a subprog therefore compares the two entries at a loop inside that
subprog, where the innermost frame is the subprog's and has no flag set,
and the state is rejected:

  infinite loop detected at insn 60

push_callback_call() numbers a new entry as the caller's count plus one.
When the callback re-arms itself from a subprog, the caller is that
subprog's frame with a count of 0, so every entry is numbered 1, the
check above never sees a difference, and a loop anywhere in such a
callback is rejected the same way.

Read the flag and the count from frame 0 in both places. A loop within a
single entry still has a matching count and is still caught, and frame 0
of a non-async state does not have the flag set, so nothing else changes.

The two other readers are already correct: check_return_code() reads
frame[0], and the one in do_check() is reached only after an early return
for curframe != 0.

Fixes: bfc6bb74e4f1 ("bpf: Implement verifier support for validation of async callbacks.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924162609.1746610-2-puranjay@kernel.org
[ sashal: Ported the is_state_visited() hunk into kernel/bpf/verifier.c because the state-pruning code hasn't been split out into states.c in this tree; the push_callback_call() hunk applied unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e146b860f5692..8ac91e5ced84b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10884,7 +10884,7 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 		if (IS_ERR(async_cb))
 			return PTR_ERR(async_cb);
 		callee = async_cb->frame[0];
-		callee->async_entry_cnt = caller->async_entry_cnt + 1;
+		callee->async_entry_cnt = state->frame[0]->async_entry_cnt + 1;
 
 		/* Convert bpf_timer_set_callback() args into timer callback args */
 		err = set_callee_state_cb(env, caller, callee, insn_idx);
@@ -20017,10 +20017,10 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 			continue;
 
 		if (sl->state.branches) {
-			struct bpf_func_state *frame = sl->state.frame[sl->state.curframe];
+			struct bpf_func_state *frame = sl->state.frame[0];
 
 			if (frame->in_async_callback_fn &&
-			    frame->async_entry_cnt != cur->frame[cur->curframe]->async_entry_cnt) {
+			    frame->async_entry_cnt != cur->frame[0]->async_entry_cnt) {
 				/* Different async_entry_cnt means that the verifier is
 				 * processing another entry into async callback.
 				 * Seeing the same state is not an indication of infinite
-- 
2.53.0



