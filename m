Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8919B1F09AC;
	Fri, 21 Nov 2025 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731261; cv=none; b=my5Bng2Q9BeFuDrCfH/4ug7zGEASUMYwb1R0FRtYUyzRe1GLeauqSWPFClQJPz9DZMr2QHKgOnjJfU+/17be1fI5wbfjcDQRCXkCLNnVL/o/atLfTVSTn/lUqvAdRPlR4WEhM8eNL2sR0/2oeLfiw6M6L2u6MkszuqI8g8zqzHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731261; c=relaxed/simple;
	bh=Ff7qaxVgGvbTKXG0eHY8eOf7ZCHAbRiLlXt2CwxIFcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF8MLMVCi0LRVh22+//sw5yUtg0Pfgno9dqnrfwAF3xFdwfOuDZ3OlDlwHO2waLSznHRmjuA4s2fJoNzJYjCKp2dcsBJZHE5NPqExGRo8GXl8UoyKMklw3AXyodsmzR/7EdOqvfb+omBL6UJxSKxbBPEuie6a7ro9jRscG0Z6mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXFQOScO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXFQOScO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125E0C4CEF1;
	Fri, 21 Nov 2025 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731261;
	bh=Ff7qaxVgGvbTKXG0eHY8eOf7ZCHAbRiLlXt2CwxIFcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXFQOScOpr5AWSqLJEIeWL24DcEk++vOCE7TM4l4L1qgphg5vOudhyMM6JLzBzvxW
	 o6edTPO/K3BKSESQFgc2epxAZyD/Hdj/laewlYkJcoEGqfP2nUapWem1FMygCVjZnV
	 pN+rmIgkqHMmOsHwKiwJvmUOvM+rq91L2ap7fG/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 119/247] bpf: account for current allocated stack depth in widen_imprecise_scalars()
Date: Fri, 21 Nov 2025 14:11:06 +0100
Message-ID: <20251121130158.854142780@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 2844adf4da61a..c3cdf2bf09aa4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8917,7 +8917,7 @@ static int widen_imprecise_scalars(struct bpf_verifier_env *env,
 				   struct bpf_verifier_state *cur)
 {
 	struct bpf_func_state *fold, *fcur;
-	int i, fr;
+	int i, fr, num_slots;
 
 	reset_idmap_scratch(env);
 	for (fr = old->curframe; fr >= 0; fr--) {
@@ -8930,7 +8930,9 @@ static int widen_imprecise_scalars(struct bpf_verifier_env *env,
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



