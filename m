Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673CE3D9DA2;
	Thu, 17 Sep 2026 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665160; cv=none; b=SLitq2JAfG8FS7uzuFfuZfGmoE80HhNe5QLlteSBANJH6b3JHwAhJaIGL2C9VIY+V/P6olNxKo18kuS6R5Cn449FZ9MDNNal3smzxMPMGkC+79auBu1zXQgHQmsyJUWECG1e0+56PN9tRBFF0/49BwG/YngN5iynLcaquttTS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665160; c=relaxed/simple;
	bh=PhWnb+EvyWHUMcN8L7gyOOezCx6YG+GPlNjKzb/LN4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfJ58uiR37GOvUHMbN/FI7Z6cymlb7kEE/giOwsl7VAn+TuLHTDpLGFkEcsmQPh/dngw8e90zleWVGBZjON0vShF1kyEwMlv9vtIVruEbYdOuHRXbTNbe0L7vHcNN8vZlNq2wRThOpu0nSLRfVeXU3dgIkvHASwecaoFZaY2FLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl4+LW1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl4+LW1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0151F00893;
	Thu, 17 Sep 2026 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665159;
	bh=tdDA8zetb4OkoHOk9ci3aYsRPXNXmUkvtxm9OUnluyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sl4+LW1T/Jf4CYXV48/ziEBeA7CEPKuYiw1jTnhpmnqyBSK0i92Bvzfd/fwgp+1yz
	 007StOSLLZ6txjsCggYfMdBwQ5pK3plPuzbfZ7Vqn80L15jJSb7IQUUxiUtVPINovC
	 p/KpMlivHkPC6+TkapAxZSRA1jnDsei9iFC/vflI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hiker Cl <clhiker365@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0613/1250] bpf: Fix REG INVARIANTS VIOLATION on speculative pointer arithmetic
Date: Thu, 17 Sep 2026 16:06:48 +0100
Message-ID: <20260917151608.490187021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 150aeba624e8b7cac51c39440d7e8e1fd11de9a0 ]

Take the following unprivileged program as an example:

	r0 = bpf_map_lookup_elem(...)	/* PTR_TO_MAP_VALUE, offset 0 */
	...
	14: r0 += r1			/* r1 is a bounded scalar */
	15: r9 = r0

Loading it triggers a verifier warning from reg_bounds_sanity_check():

	verifier bug: REG INVARIANTS VIOLATION (alu): const subreg tnum out
	of sync with range bounds r64={.base=0x0, .size=0x0}
	r32={.base=0x0, .size=0xffffffff} var_off=(0x0, 0x0)

What happens:

1. Processing insn 14 (r0 += r1) in adjust_ptr_min_max_vals(), the new
   offset is computed into dst_reg's var_off and 32/64-bit ranges.

2. Because pointer registers do not track 32-bit subregister bounds,
   __mark_reg32_unbounded() first sets r32 to the full range; r32 is
   re-derived from the offset at the end of the function by
   reg_bounds_sync().

3. On the unprivileged path, sanitize_ptr_alu() is called and, via
   sanitize_speculative_path() -> push_stack(), snapshots the current
   register state and schedules the next instruction (insn 15) to be
   verified directly as a speculative path.

4. That snapshot is taken between step 2 and the final reg_bounds_sync():
   at this point dst_reg's var_off still holds the (const) original
   offset while r32 has just been blanked to the full range, i.e. the two
   are out of sync. When the speculative path later verifies insn 15
   (r9 = r0), the inconsistent state reaches reg_bounds_sanity_check() and
   trips the warning.

var_off and the 32-bit range must always be consistent. There are two
ways to keep the snapshot consistent:

  1. sync var_off and r32 before the snapshot so they match, or
  2. leave r32 at its original (already consistent) value and blank it
     only after the snapshot.

The whole point of sanitize_ptr_alu() is to insert a harmless masking
sequence that keeps the access in bounds under speculation, so the state
it snapshots should faithfully represent that. Take approach 2: move
__mark_reg32_unbounded() to after sanitize_ptr_alu(), so the speculative
snapshot keeps the pointer's original, consistent r32. The non-speculative
path is unchanged: r32 is still blanked before the offset is applied and
re-derived by reg_bounds_sync().

Fixes: 5f99f312bd3b ("bpf: add register bounds sanity checks and sanitization")
Reported-by: Hiker Cl <clhiker365@gmail.com>
Closes: https://lore.kernel.org/bpf/CAGM=xGB1fJ9kT8XTitVo74B0WGqgjkoUHdLwzytwV0AyqeVApw@mail.gmail.com/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260819125840.286434-1-jiayuan.chen@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c19eb8a7d3967..0a4198335c9b9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14805,9 +14805,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    !check_reg_sane_offset_ptr(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
 
-	/* pointer types do not carry 32-bit bounds at the moment. */
-	__mark_reg32_unbounded(dst_reg);
-
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
 				       &info, false);
@@ -14815,6 +14812,14 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}
 
+	/*
+	 * Pointer types do not carry 32-bit bounds at the moment. Blank r32
+	 * only after sanitize_ptr_alu() may have snapshotted dst_reg into a
+	 * speculative path: otherwise reg_bounds_sanity_check() might hit some
+	 * constraints violations.
+	 */
+	__mark_reg32_unbounded(dst_reg);
+
 	switch (opcode) {
 	case BPF_ADD:
 		/* We can take a fixed offset as long as it doesn't overflow
-- 
2.53.0



