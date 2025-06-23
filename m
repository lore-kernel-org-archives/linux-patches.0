Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B52218580;
	Mon, 23 Jun 2025 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716478; cv=none; b=O8G57GcdPzBucw3ARB9WTNOgmcVhuDwiTBXItFIcnWiBxDSS+OTi86MxxqGKxEmSK9Z/7/vWvKSJNqU81NBrWUtiDNr3CmYXOMEm2gbGAQIvq7u4Bg5OJ1//VcqVugGm3qOQ2ZMZEtBTKwwAZuAgldVbJR8AaUZTmsiuQhSQcDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716478; c=relaxed/simple;
	bh=6WL4D9sIvC7xkWt6zD8Qv6+tA79ma4od6ZP3VBQphAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDsShVJO8aHruwxRIwKtFC+4HheXwc8F3KGe2nPfz93AhCXlaXbIgs6dI1VMJ3RzYzlWyuGuyi9uWuToDwFlwywE5mJtLRdmXREhwWGjAsEcV9MCTQZRY/IplbnC3rbJDl+R31pdE2BkLXMR8W+wJDYrmuH8f7BG6sC3rNV0LX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEbY1NYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEbY1NYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DE4C4CEEA;
	Mon, 23 Jun 2025 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716478;
	bh=6WL4D9sIvC7xkWt6zD8Qv6+tA79ma4od6ZP3VBQphAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEbY1NYAGZauo+qKnbz4Zr/DZgHN1nhXcDRPuixNwTn7oUfSEnJtggpvKU/kbypQO
	 pRAEk5P/4A8/n9WmIZd4Wq50gXoaH7kdaJLPlyDhcaeKHfW3S1/Iv3WMdU3h6fPnUE
	 VhDOShzC37K2cMApXbumJvcZPNhyHN5pkREaHl78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wei <weiwei.danny@bytedance.com>,
	Aaron Lu <ziqianlu@bytedance.com>
Subject: [PATCH 5.10 351/355] Revert "bpf: aggressively forget precise markings during state checkpointing"
Date: Mon, 23 Jun 2025 15:09:12 +0200
Message-ID: <20250623130637.273490973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <ziqianlu@bytedance.com>

This reverts commit 1952a4d5e4cf610336b9c9ab52b1fc4e42721cf3 which is
commit 7a830b53c17bbadcf99f778f28aaaa4e6c41df5f upstream.

The backport of bpf precision tracking related changes has caused bpf
verifier to panic while loading some certain bpf prog so revert them.

Link: https://lkml.kernel.org/r/20250605070921.GA3795@bytedance/
Reported-by: Wei Wei <weiwei.danny@bytedance.com>
Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2053,31 +2053,6 @@ static void mark_all_scalars_precise(str
 	}
 }
 
-static void mark_all_scalars_imprecise(struct bpf_verifier_env *env, struct bpf_verifier_state *st)
-{
-	struct bpf_func_state *func;
-	struct bpf_reg_state *reg;
-	int i, j;
-
-	for (i = 0; i <= st->curframe; i++) {
-		func = st->frame[i];
-		for (j = 0; j < BPF_REG_FP; j++) {
-			reg = &func->regs[j];
-			if (reg->type != SCALAR_VALUE)
-				continue;
-			reg->precise = false;
-		}
-		for (j = 0; j < func->allocated_stack / BPF_REG_SIZE; j++) {
-			if (!is_spilled_reg(&func->stack[j]))
-				continue;
-			reg = &func->stack[j].spilled_ptr;
-			if (reg->type != SCALAR_VALUE)
-				continue;
-			reg->precise = false;
-		}
-	}
-}
-
 /*
  * __mark_chain_precision() backtracks BPF program instruction sequence and
  * chain of verifier states making sure that register *regno* (if regno >= 0)
@@ -2156,14 +2131,6 @@ static void mark_all_scalars_imprecise(s
  * be imprecise. If any child state does require this register to be precise,
  * we'll mark it precise later retroactively during precise markings
  * propagation from child state to parent states.
- *
- * Skipping precise marking setting in current state is a mild version of
- * relying on the above observation. But we can utilize this property even
- * more aggressively by proactively forgetting any precise marking in the
- * current state (which we inherited from the parent state), right before we
- * checkpoint it and branch off into new child state. This is done by
- * mark_all_scalars_imprecise() to hopefully get more permissive and generic
- * finalized states which help in short circuiting more future states.
  */
 static int __mark_chain_precision(struct bpf_verifier_env *env, int frame, int regno,
 				  int spi)
@@ -9928,10 +9895,6 @@ next:
 	env->prev_jmps_processed = env->jmps_processed;
 	env->prev_insn_processed = env->insn_processed;
 
-	/* forget precise markings we inherited, see __mark_chain_precision */
-	if (env->bpf_capable)
-		mark_all_scalars_imprecise(env, cur);
-
 	/* add new state to the head of linked list */
 	new = &new_sl->state;
 	err = copy_verifier_state(new, cur);


