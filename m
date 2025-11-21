Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FDB34CFAF;
	Fri, 21 Nov 2025 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733375; cv=none; b=eeQJFiqjnhUffUavCyrpawp8Jl4AzJn4YOPr7T27sSMIJaOawVBExOBQh0tsRerKiDxPj6hiSu/HgP5PEn8ExxLvK2cVUTTlzKdc2Kw+AWmBzYvhJmdoJc8bgdJI3/Jww9+hPF81cr/21IliUrJGGnyIWLxEXzGjt4sWcyxjOkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733375; c=relaxed/simple;
	bh=qTbcEVrq63/uKX3NY6lm1TC4O7g1mR10m4jdO3QbNjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixeOyEDg7JrVxVPkIUF+Oj16PVw2nLwGZp/a8V8H/NHCgdb5HhQFFRXBw2lNBFJDAapAgplgiAX2gMQpaQhPLbcK9ATBfOBCMzK9xyAB5lr8IRy0z/AVdWmsqq6UWo2UCeC4NmfjMafcGUw1JoIDrmUDQGN9GdcqLtLBLiSoWn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gN6MwnkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gN6MwnkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CA5C4CEF1;
	Fri, 21 Nov 2025 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733375;
	bh=qTbcEVrq63/uKX3NY6lm1TC4O7g1mR10m4jdO3QbNjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN6MwnkJTWzYnRHdVchewtTcmqB0C2BTzZwCi3VNNcZk9f+p61KgHKCueFUECDNR5
	 Dq90ek8DijS450Ig4rsz8RXVYwkIF5ePUZQ6BMFGVae/FvUcQeA38SBn82R9vJT24I
	 NDhvN8C42pfBSt/wWuc5efvCCb2fp8zZ6xGE2P/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 447/529] bpf: account for current allocated stack depth in widen_imprecise_scalars()
Date: Fri, 21 Nov 2025 14:12:26 +0100
Message-ID: <20251121130246.916337971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit b0c8e6d3d866b6a7f73877f71968dbffd27b7785 ]

The usage pattern for widen_imprecise_scalars() looks as follows:

    prev_st = find_prev_entry(env, ...);
    queued_st = push_stack(...);
    widen_imprecise_scalars(env, prev_st, queued_st);

Where prev_st is an ancestor of the queued_st in the explored states
tree. This ancestor is not guaranteed to have same allocated stack
depth as queued_st. E.g. in the following case:

    def main():
      for i in 1..2:
        foo(i)        // same callsite, differnt param

    def foo(i):
      if i == 1:
        use 128 bytes of stack
      iterator based loop

Here, for a second 'foo' call prev_st->allocated_stack is 128,
while queued_st->allocated_stack is much smaller.
widen_imprecise_scalars() needs to take this into account and avoid
accessing bpf_verifier_state->frame[*]->stack out of bounds.

Fixes: 2793a8b015f7 ("bpf: exact states comparison for iterator convergence checks")
Reported-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20251114025730.772723-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5e644b1b12aaa..45b2f06de452c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7839,7 +7839,7 @@ static int widen_imprecise_scalars(struct bpf_verifier_env *env,
 				   struct bpf_verifier_state *cur)
 {
 	struct bpf_func_state *fold, *fcur;
-	int i, fr;
+	int i, fr, num_slots;
 
 	reset_idmap_scratch(env);
 	for (fr = old->curframe; fr >= 0; fr--) {
@@ -7852,7 +7852,9 @@ static int widen_imprecise_scalars(struct bpf_verifier_env *env,
 					&fcur->regs[i],
 					&env->idmap_scratch);
 
-		for (i = 0; i < fold->allocated_stack / BPF_REG_SIZE; i++) {
+		num_slots = min(fold->allocated_stack / BPF_REG_SIZE,
+				fcur->allocated_stack / BPF_REG_SIZE);
+		for (i = 0; i < num_slots; i++) {
 			if (!is_spilled_reg(&fold->stack[i]) ||
 			    !is_spilled_reg(&fcur->stack[i]))
 				continue;
-- 
2.51.0



