Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6827546EC7C;
	Tue, 21 Jul 2026 18:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658958; cv=none; b=QrWqTPGQaLfMmP9P7LeOQBIKSIXQwqERhh5e5Qi1vdMljnt0kUWyJGo9rS5z3Lc6x349c0dwKYKBbmpe5NA5m8XzTh/ZMz28bd1iUxLQUwYv4qD/yLFVlmYPS3Py2O4NzBevKSzqggjZDguXhuflUCXpD2tWhocByJEKh1AqoWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658958; c=relaxed/simple;
	bh=ZbtT5BAH4oiYjkA0AuD0TGgRqU+A71DRXoivMb8AOL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnGFogNH9BYCwBWnvrKTbcvfF8BvrxAuzIqpL6eqib3+Vf7ER3ERYWbh6guJuEMV2uAC0j42HTxNZnTHKFB452nnW3wMeH8tzp6paT+9Ai5hSpiv7sTinBFunAR5jw0JcTRUEANJQuyf5/jfAj9DVhXojamD32u0FUjQoouqkBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR6bIfJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR6bIfJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E801F000E9;
	Tue, 21 Jul 2026 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658957;
	bh=YLyhJyRyRvD7jkpTUNOEpwv5pw6iPDJx2qFlGlKa0LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fR6bIfJzJYCVGykuAXzkj8MDlkZkTbPINz6XbBf94uo1UvRxJkA9W4FtElmGUiFkh
	 KBwO1TqzfmOHNgMffvujE5r4M2Tt+GtiLhySvjWerjxb/0dYCmqJSVpZ2isn8kmJPI
	 PP74YRSk45H/d7AnxHpjiNeBEeiKYaVTpsaM9OIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.18 1338/1611] bpf: Reset register bounds before narrowing retval range in check_mem_access()
Date: Tue, 21 Jul 2026 17:24:14 +0200
Message-ID: <20260721152545.547802491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 5e0b273e0a62cc04ec338c7b502797c66c2ed42a upstream.

When the BPF verifier processes a context load of an LSM hook return
value, it calls __mark_reg_s32_range() to narrow the register to the
hook's valid range. However, __mark_reg_s32_range() intersects the new
range with the register's existing bounds using max_t()/min_t() rather
than replacing them.

If the destination register carries stale bounds from a prior instruction
(e.g. BPF_MOV64_IMM), the intersection can produce a range narrower than
reality. The verifier then believes it knows the register's exact value,
while at runtime the actual hook return value is loaded, creating a
verifier/runtime mismatch that can be used to bypass BPF memory safety
checks.

The else branch already calls mark_reg_unknown() to reset register state
before any narrowing. Apply the same reset in the is_retval path so
stale bounds are cleared before __mark_reg_s32_range() intersects.

Fixes: 5d99e198be27 ("bpf, lsm: Add check for BPF LSM return value")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260622230123.3695446-2-tristmd@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7672,6 +7672,7 @@ static int check_mem_access(struct bpf_v
 			 */
 			if (info.reg_type == SCALAR_VALUE) {
 				if (info.is_retval && get_func_retval_range(env->prog, &range)) {
+					mark_reg_unknown(env, regs, value_regno);
 					err = __mark_reg_s32_range(env, regs, value_regno,
 								   range.minval, range.maxval);
 					if (err)


