Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B773F46C4B5;
	Tue, 21 Jul 2026 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648527; cv=none; b=tgvNOAqZe+YcUBXcekDVTasHU3itOTaE+HBQhsNefddk2ryCd5U00Q3LfMsYKCXMbrfqEqzVQyq82/sfl/I0iZG8EoaZx/1aIZv7SHyuVDvyJp0VbmuLJVTxbAe00OOxnSkrJHmJV/XHbBD19SJ0/BIv7zO8fFEr7e8/gsHZo1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648527; c=relaxed/simple;
	bh=pyMfxkT6rUXBhkjU1xz4GpPaOY0QU2ph0+0XZ2F9j3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtPvOp8E8yWvgK9vGF7Jxx90yKCOP3L9HccpLU79tv7X75B9pGVPYiYh0ySrBXJqZYJFfAcFAXAqi3IPEIs6brxvFLS5cjaSeBC/8EGj1SNJk0GlPcmqNew4MNeLCW+MYdfM4P3SCKp37/HSgd+HbzE3GmNcCju59Egue2TlCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFDQQMga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFDQQMga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E891F00A3A;
	Tue, 21 Jul 2026 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648523;
	bh=cejOj7YIHihPOVONisGimw2lu9PxjBkaP8jiuOAWGH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFDQQMgauKn1uD6DzuJgeELW/0Io0H344hkj85H04M5/s3xwf/Z/x0dIiJhqbIh+f
	 9aGhUa4pM9XAGACddAlF6XLgiYD2htYAXY2tHnTsKQjlO+mP6bNoxkwh3KKybEFzNs
	 3mYKmHgzZ1Xp3nI4iNp8dB7KKgRy8p78dKLntzuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0233/2077] selftests/bpf: Fix test for refinement of single-value tnum
Date: Tue, 21 Jul 2026 16:58:26 +0200
Message-ID: <20260721152558.171402959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 523d2f42b406f5be2989f436b03eacebf3679835 ]

This patch fixes the "bounds refinement with single-value tnum on umin"
verifier selftest. This selftest was introduced in commit e6ad477d1bf8
("selftests/bpf: Test refinement of single-value tnum") to cover the
logic from __update_reg64_bounds(), introduced in commit efc11a667878
("bpf: Improve bounds when tnum has a single possible value"). However,
the test still passes if that last commit is reverted.

The test is supposed to cover the case when the tnum and u64 range (or
cnum64 now) overlap in a single value. __update_reg64_bounds() detects
that case and refines the bounds to a known constant. However, the
constants for the test were poorly chosen and the bounds get refined to
a known constant even without __update_reg64_bounds(). The code is as
follows:

  0: call bpf_get_prandom_u32#7  ; R0=scalar()
  1: r0 |= 224                   ; R0=scalar(umin=umin32=224,var_off=(0xe0; 0xffffffffffffff1f))
  2: r0 &= 240                   ; R0=scalar(smin=umin=smin32=umin32=224,smax=umax=smax32=umax32=240,var_off=(0xe0; 0x10))
  3: if r0 == 0xf0 goto pc+2     ; R0=224

After instruction 3, we have u64=[0xe0; 0xef] and tnum=(0xe0; 0x10).
__reg_bound_offset() is able to deduce a new tnum from the u64,
tnum=(0xe0; 0x0f), which combined with the existing tnum gives us a
constant: 0xe0 or 224.

We can easily fix this by choosing different starting bounds. If we make
it u64=[0xe1; 0xf0], then __reg_bound_offset() doesn't have any impact.

Fixes: e6ad477d1bf8 ("selftests/bpf: Test refinement of single-value tnum")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/be2dc2c3d85120286e60b3029b3338fff339f942.1779121582.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/verifier_bounds.c  | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_bounds.c b/tools/testing/selftests/bpf/progs/verifier_bounds.c
index c1ae013dee29ce..bc431f46aafdbb 100644
--- a/tools/testing/selftests/bpf/progs/verifier_bounds.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bounds.c
@@ -1890,25 +1890,25 @@ __naked void bounds_refinement_tnum_umax(void *ctx)
 /* This test covers the bounds deduction when the u64 range and the tnum
  * overlap only at umin. After instruction 3, the ranges look as follows:
  *
- * 0    umin=0xe00     umax=0xeff                              U64_MAX
+ * 0    umin=0xe1      umax=0xf0                               U64_MAX
  * |    [xxxxxxxxxxxxxx]                                       |
  * |----------------------------|------------------------------|
  * |    x               x                                      | tnum values
  *
- * The verifier can therefore deduce that the R0=0xe0=224.
+ * The verifier can therefore deduce that the R0=0xe1=225.
  */
 SEC("socket")
 __description("bounds refinement with single-value tnum on umin")
-__msg("3: (15) if r0 == 0xf0 {{.*}} R0=224")
+__msg("3: (15) if r0 == 0xf1 {{.*}} R0=225")
 __success __log_level(2)
 __naked void bounds_refinement_tnum_umin(void *ctx)
 {
 	asm volatile("			\
 	call %[bpf_get_prandom_u32];	\
-	r0 |= 0xe0;			\
-	r0 &= 0xf0;			\
-	if r0 == 0xf0 goto +2;		\
-	if r0 == 0xe0 goto +1;		\
+	r0 |= 0xe1;			\
+	r0 &= 0xf1;			\
+	if r0 == 0xf1 goto +2;		\
+	if r0 == 0xe1 goto +1;		\
 	r10 = 0;			\
 	exit;				\
 "	:
-- 
2.53.0



