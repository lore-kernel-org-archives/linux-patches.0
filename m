Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9392C4E73D9;
	Thu, 17 Sep 2026 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658833; cv=none; b=qKpC0jjsdorgidBLvKHp1fXWwSESgryXEXK+6VDrpDhpRrJ3n7cEOItsD3cd8EXamrAugb2SybjzvOC9L4jTIPhaKbmA9kwPBfTysc/ftMhRfojsFX0GMGLEpmgmSCAEkzqHMs0FOupTd8zr9JQrGAO6U851CrGNFrGVnY7S9VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658833; c=relaxed/simple;
	bh=SIdf4A5cja4MyobNlw02dl/6EYV896QEekt9dwlkzJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wbf+rY45gabpbYnGvixhjGKBGSfAAZs332dIcmDW2TuJYwiUoDNlWp66KaUBDMwLd5C/3Xc0U9r4T/kULC26uXR2pp47mmwf3iDLKZ02pecPfr7kI43ZL/27freEAh7guLRn7AQjZgvHS95ZL7AdYu4m/FXglFiA7IZVf5L3PjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQObbYHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQObbYHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352441F0089A;
	Thu, 17 Sep 2026 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658820;
	bh=ZJ1qnNq3UvmTyOeDnpyXxtpB5ZqehbNGrPikrWx6GQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQObbYHy6upNxI6qvI+X0QLtJUVpoQeJOnysnWoZsh0w2kubdTTfdq/zz/WbtSjCj
	 3+Yz4K0DoceOA2dpthc4SIjDtTsFOJJKApFEVlTtNZTrJwZPn/ex1HQkWrF65zqAkh
	 R2xYwKcwZ6gKgHlbzXyLmK5+jmLDqV7+REIGIAys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 051/733] bpf: dont downgrade half-dead scalar zero spills to STACK_ZERO
Date: Thu, 17 Sep 2026 16:05:59 +0100
Message-ID: <20260917151352.056245478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 2f3536bff8823d3c5fdbbe15e17bfca696cc2b2e ]

states.c:__clean_func_state() can downgrade scalar zero spill to
STACK_ZERO in the following case:

  *(u64 *)(r10 - 8) = 0;
  ... checkpoint ...
  r1 = *(u32 *)(r10 - 4);
  ... no reads from r10-8 ...

Here 4 bytes at r10-8 are dead and verifier changes scalar spill to a
combination: 0000pppp (p stands for poison). Such a change breaks
precision propagation chains. All places that produce STACK_ZERO
should call bpf_mark_chain_precision() for the zero source.

This patch fixes the bug in a simplest way possible:
avoids converting stack spills of zero to STACK_ZERO.
Two smarter approaches are possible:
- do bpf_mark_chain_precision() from __clean_func_state()
- check slot liveness information in check_stack_write_fixed_off()

I investigated both and the changes required are a bit tricky,
hence go with a simple fix for the time being.

Fixes: be23266b4a08 ("bpf: 4-byte precise clean_verifier_state")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260827-bug-011-cleanfunc-stack-zero-simple-v1-v1-1-c0e996589a52@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/states.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index 4e6aafad33bd2..66fb11b6c6a76 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -445,22 +445,19 @@ static void __clean_func_state(struct bpf_verifier_env *env,
 				struct bpf_reg_state *spill = &st->stack[i].spilled_ptr;
 
 				if (lo_live && stype == STACK_SPILL) {
-					u8 val = STACK_MISC;
-
 					if (spill->type != SCALAR_VALUE)
 						continue;
-
 					/*
-					 * 8 byte spill of scalar 0 where half slot is dead
-					 * should become STACK_ZERO in lo 4 bytes.
+					 * Can't replace with STACK_ZERO, because
+					 * that requires bpf_mark_chain_precision().
 					 */
 					if (bpf_register_is_null(spill))
-						val = STACK_ZERO;
+						continue;
 					for (j = 0; j < 4; j++) {
 						u8 *t = &st->stack[i].slot_type[j];
 
 						if (*t == STACK_SPILL)
-							*t = val;
+							*t = STACK_MISC;
 					}
 				}
 				bpf_mark_reg_not_init(env, spill);
-- 
2.53.0



