Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F263176E4;
	Wed,  8 Apr 2026 18:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674204; cv=none; b=Mgo1iL4ufA12FxhVScVJKac6sbsTxebkXBh4Mk58cL5Ts7oq26VDNu6GY7ktcwOw5Z4t6NCB2mhOqG6/+Rt1gDmAt5TX/mTUh/YetfHp2p58xrRapbRmb6x22M0IXSMC2RoNnvccOo8+igUU6wlx/AaK9t16GL5ZtSXjkQaXyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674204; c=relaxed/simple;
	bh=U0GB9GY25p1yNGPITQRm3oK5h1AVeiq8LnpduvvSNxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cu7/2x9bHce1nhirXb/hWafCSDFp1AQe2TNYTH8JsQCV5b7IoQUHPMA0Eq4KbmqhKvR4Q+3Z8sPAoQNHWISHLgdbj1GZf2BaCSu198DLzwi23sXhTz6SF81SWvxrnHGBQTFOv88xVqN9z3lqaEu91IMpXR+VqPCFtEI1Xh+Bhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPMEixLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPMEixLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CB6C19421;
	Wed,  8 Apr 2026 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674203;
	bh=U0GB9GY25p1yNGPITQRm3oK5h1AVeiq8LnpduvvSNxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPMEixLqUGc6U7VXaGO+w+8OJRqAwvCR6cXcZwSwfKNAxJxc8lSWuyEWg05coDjtd
	 fRlNX+uwps5orB/Pi/EIT77J72yZarROQNEOSy8+MyhKLQp31VSZBIUMeudwmPDKyu
	 wAXou5yfka4lHDuyBI+RWdpBrQeeWQJkMWbbMoeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 242/242] selftests/bpf: test refining u32/s32 bounds when ranges cross min/max boundary
Date: Wed,  8 Apr 2026 20:04:42 +0200
Message-ID: <20260408175936.163099394@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit f81fdfd16771e266753146bd83f6dd23515ebee9 ]

Two test cases for signed/unsigned 32-bit bounds refinement
when s32 range crosses the sign boundary:
- s32 range [S32_MIN..1] overlapping with u32 range [3..U32_MAX],
  s32 range tail before sign boundary overlaps with u32 range.
- s32 range [-3..5] overlapping with u32 range [0..S32_MIN+3],
  s32 range head after the sign boundary overlaps with u32 range.

This covers both branches added in the __reg32_deduce_bounds().

Also, crossing_32_bit_signed_boundary_2() no longer triggers invariant
violations.

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260306-bpf-32-bit-range-overflow-v3-2-f7f67e060a6b@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_bounds.c |   39 +++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/verifier_bounds.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bounds.c
@@ -1110,7 +1110,7 @@ l0_%=:	r0 = 0;						\
 SEC("xdp")
 __description("bound check with JMP32_JSLT for crossing 32-bit signed boundary")
 __success __retval(0)
-__flag(!BPF_F_TEST_REG_INVARIANTS) /* known invariants violation */
+__flag(BPF_F_TEST_REG_INVARIANTS)
 __naked void crossing_32_bit_signed_boundary_2(void)
 {
 	asm volatile ("					\
@@ -1316,6 +1316,43 @@ l0_%=:	r0 = 0;				\
 "	:
 	: __imm(bpf_get_prandom_u32)
 	: __clobber_all);
+}
+
+SEC("socket")
+__success
+__flag(BPF_F_TEST_REG_INVARIANTS)
+__naked void signed_unsigned_intersection32_case1(void *ctx)
+{
+	asm volatile("									\
+	call %[bpf_get_prandom_u32];							\
+	w0 &= 0xffffffff;								\
+	if w0 < 0x3 goto 1f;		/* on fall-through u32 range [3..U32_MAX]  */	\
+	if w0 s> 0x1 goto 1f;		/* on fall-through s32 range [S32_MIN..1]  */	\
+	if w0 s< 0x0 goto 1f;		/* range can be narrowed to  [S32_MIN..-1] */	\
+	r10 = 0;			/* thus predicting the jump. */			\
+1:	exit;										\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
+SEC("socket")
+__success
+__flag(BPF_F_TEST_REG_INVARIANTS)
+__naked void signed_unsigned_intersection32_case2(void *ctx)
+{
+	asm volatile("									\
+	call %[bpf_get_prandom_u32];							\
+	w0 &= 0xffffffff;								\
+	if w0 > 0x80000003 goto 1f;	/* on fall-through u32 range [0..S32_MIN+3] */	\
+	if w0 s< -3 goto 1f;		/* on fall-through s32 range [-3..S32_MAX] */	\
+	if w0 s> 5 goto 1f;		/* on fall-through s32 range [-3..5] */		\
+	if w0 <= 5 goto 1f;		/* range can be narrowed to  [0..5] */		\
+	r10 = 0;			/* thus predicting the jump */			\
+1:	exit;										\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
 }
 
 char _license[] SEC("license") = "GPL";


