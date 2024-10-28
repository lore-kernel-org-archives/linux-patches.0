Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A0A47;
	Mon, 28 Oct 2024 06:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097967; cv=none; b=BDksa0qCkrvYN0603a4n+DZKfMkScmP9z5J5Hh9SRA1xcLVITf/Yubg8MIwnMOwAn2R/2c6s5fttOg5/fgpH3TVsnIJd8FlJHKIuUUhT0Y3Moos+Mo17O3mHd4lty4AE/D+JEYxlU4wHIjVNSGG3K76Li2EeUyuPpgmWuiFila0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097967; c=relaxed/simple;
	bh=pPaJbsg6ylaN8T6/fKBFcluBL8/NboAFsAHyVSwA9KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9mE6K7IytTtBN7piErKRvgfbpynbCFajE8KLUMBMmS73PK6TlMo2z2W3Hw16FFJa/foAznVUWJsXwkfuFivuE4JFIsMN9/iwgAchwZA9dxND4UyrEG/T61Hcnhn9D2JoG8UBJyMzUeqBEEQjhYJ0ftrOoDnMPOxvXkMJc9ijLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNmJbjFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNmJbjFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88B1C4CEC3;
	Mon, 28 Oct 2024 06:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097967;
	bh=pPaJbsg6ylaN8T6/fKBFcluBL8/NboAFsAHyVSwA9KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNmJbjFZM/iIrREHf+meHBrv3INBiTWzX7s5wJtsWCi5pRy1RVGf3BDhAUzNb/WjO
	 hFoqn/Ojb1V3Cy3pqpcQV/npZaRe/WpybRSkXy2n5ljOTRmHvOcNEhqj5afYWw9+rV
	 gb+Me8Sg9X/j/hGTfu6Q2N3K5vNb7YqPTg3ETzmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lonial Con <kongln9170@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 004/261] bpf: sync_linked_regs() must preserve subreg_def
Date: Mon, 28 Oct 2024 07:22:26 +0100
Message-ID: <20241028062312.121180262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit e9bd9c498cb0f5843996dbe5cbce7a1836a83c70 ]

Range propagation must not affect subreg_def marks, otherwise the
following example is rewritten by verifier incorrectly when
BPF_F_TEST_RND_HI32 flag is set:

  0: call bpf_ktime_get_ns                   call bpf_ktime_get_ns
  1: r0 &= 0x7fffffff       after verifier   r0 &= 0x7fffffff
  2: w1 = w0                rewrites         w1 = w0
  3: if w0 < 10 goto +0     -------------->  r11 = 0x2f5674a6     (r)
  4: r1 >>= 32                               r11 <<= 32           (r)
  5: r0 = r1                                 r1 |= r11            (r)
  6: exit;                                   if w0 < 0xa goto pc+0
                                             r1 >>= 32
                                             r0 = r1
                                             exit

(or zero extension of w1 at (2) is missing for architectures that
 require zero extension for upper register half).

The following happens w/o this patch:
- r0 is marked as not a subreg at (0);
- w1 is marked as subreg at (2);
- w1 subreg_def is overridden at (3) by copy_register_state();
- w1 is read at (5) but mark_insn_zext() does not mark (2)
  for zero extension, because w1 subreg_def is not set;
- because of BPF_F_TEST_RND_HI32 flag verifier inserts random
  value for hi32 bits of (2) (marked (r));
- this random value is read at (5).

Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register assignments.")
Reported-by: Lonial Con <kongln9170@gmail.com>
Signed-off-by: Lonial Con <kongln9170@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://lore.kernel.org/bpf/7e2aa30a62d740db182c170fdd8f81c596df280d.camel@gmail.com
Link: https://lore.kernel.org/bpf/20240924210844.1758441-1-eddyz87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d5215cb1747f1..5c5dea5e137e7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15140,8 +15140,12 @@ static void find_equal_scalars(struct bpf_verifier_state *vstate,
 			continue;
 		if ((!(reg->id & BPF_ADD_CONST) && !(known_reg->id & BPF_ADD_CONST)) ||
 		    reg->off == known_reg->off) {
+			s32 saved_subreg_def = reg->subreg_def;
+
 			copy_register_state(reg, known_reg);
+			reg->subreg_def = saved_subreg_def;
 		} else {
+			s32 saved_subreg_def = reg->subreg_def;
 			s32 saved_off = reg->off;
 
 			fake_reg.type = SCALAR_VALUE;
@@ -15154,6 +15158,7 @@ static void find_equal_scalars(struct bpf_verifier_state *vstate,
 			 * otherwise another find_equal_scalars() will be incorrect.
 			 */
 			reg->off = saved_off;
+			reg->subreg_def = saved_subreg_def;
 
 			scalar32_min_max_add(reg, &fake_reg);
 			scalar_min_max_add(reg, &fake_reg);
-- 
2.43.0



