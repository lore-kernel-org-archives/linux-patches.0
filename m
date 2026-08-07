Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E96418379;
	Fri,  7 Aug 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113758; cv=none; b=Snf/prxsfr6k4P9zhdScSbUHO35KM1KYPdpW/yDUklTMKsDFFZsPhKBnDfBRPyE+0TZnW26670jQNsZ3U0WPLMmjbePOwJJs8RXR8fnRmN09e9FJfIOr+Gv1J6GrRmzfCBdB3Emoaw/B/u9TZDAM5i8kX5htH8EjEHnSQAuo8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113758; c=relaxed/simple;
	bh=wpuSVQDq/5kexiSjfUSWNgjNLAQt+TVboqjqLudGQJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLUwZuPSbRqi5kH6VXqH6FvKmSIXRK0yUotGxBhh2NYTGNIyLVU2223cTUbG0qSb3wO/uYvWfgQZElLZVQgXYOtPBkPNts4pTMuYkW+rZ2taG3ivbH7OLguw7Q9A5vgp3NuJxzROvZg3odqLVxE3/5wyzk5R/wVT0M2sQgXPSIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2czzdi2P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2czzdi2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921881F00A3A;
	Fri,  7 Aug 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113734;
	bh=cFthRWzzULuz3kYInFFjzMaWXGVE9v+2zwJzfSs1zFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2czzdi2PkgKj8v/dMHSdzLGl0FD1vVMwoHiSNtsfSgv6vnGY3PeEx+aj+l2csciyQ
	 R3SiFKQAvQZhH9O2DvrlfFCD4FJ2pcotkd8dnDDUg5IxriSj5csWupGiqvL883Rxd5
	 ZVScbPC5N4qnm9g9Ix711n5hPSh+mEqUc6Bm1VDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/337] bpf: Reset register bounds before narrowing retval range in check_mem_access()
Date: Fri,  7 Aug 2026 16:33:40 +0200
Message-ID: <20260807143418.893602209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 5e0b273e0a62cc04ec338c7b502797c66c2ed42a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8c3c4ab989a05..77183b436da5e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7234,6 +7234,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			 */
 			if (reg_type == SCALAR_VALUE) {
 				if (is_retval && get_func_retval_range(env->prog, &range)) {
+					mark_reg_unknown(env, regs, value_regno);
 					err = __mark_reg_s32_range(env, regs, value_regno,
 								   range.minval, range.maxval);
 					if (err)
-- 
2.53.0



