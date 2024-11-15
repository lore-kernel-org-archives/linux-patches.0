Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A940187FE8;
	Fri, 15 Nov 2024 06:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653239; cv=none; b=e3SBZ2c1qD82c9GlyaCybTTaNtIDL/6ha2WRbW0HHgqzb+tp0ee5vUBZSpthGhJ5fLD9PJCi5aYDIHhneHBl6ZP6K49lE4TMwy3z6/2XVeuPnyIHFMPy/IA9LkhM6BvwGMs433KtUFNUvkGNU+lkdU2QUH0xRX5n+YbTWaI97L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653239; c=relaxed/simple;
	bh=PEdMssoUc4eRY+qkh9hkpjet2gy+5VL2F4HOXKO8djE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCAdH++hUH4Ms2hAekpbCG24AtjAneer6Qt5TUykpidcN+5YlhG3zZXIJ8tVsnwDE6T1G/kl2KznFjll/Ck+VgU0f+YvLBaBAr05Ol1n0/HDIr8rLsyvaARtT7pzsqQkHAvQGWbDyOjaqI4DEyx2drORzdEy1Ei+PjTofHhhzpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeAg2qmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeAg2qmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0889C4CECF;
	Fri, 15 Nov 2024 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653239;
	bh=PEdMssoUc4eRY+qkh9hkpjet2gy+5VL2F4HOXKO8djE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeAg2qmTlD9jPOh9lZxKD6u8/ErMdtpIN+QT+8CiJOwB/Ol9Wp1n37Hbz8UlpxZ5U
	 bGkxB0O/6F36npK1x0u7xjy/06YmGbuY45hMaUCWxm4zV0Ro1t6BwSBSjSdIlfibgE
	 n5qSoyGV/oVQCl8Y0Dch1gz1LTTUFv+8+izuo6MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 05/63] selftests/bpf: Verify that sync_linked_regs preserves subreg_def
Date: Fri, 15 Nov 2024 07:37:28 +0100
Message-ID: <20241115063726.089614478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

[ Upstream commit a41b3828ec056a631ad22413d4560017fed5c3bd ]

This test was added because of a bug in verifier.c:sync_linked_regs(),
upon range propagation it destroyed subreg_def marks for registers.
The test is written in a way to return an upper half of a register
that is affected by range propagation and must have it's subreg_def
preserved. This gives a return value of 0 and leads to undefined
return value if subreg_def mark is not preserved.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240924210844.1758441-2-eddyz87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_scalar_ids.c | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
index 13b29a7faa71a..d24d3a36ec144 100644
--- a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
+++ b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
@@ -656,4 +656,71 @@ __naked void two_old_ids_one_cur_id(void)
 	: __clobber_all);
 }
 
+SEC("socket")
+/* Note the flag, see verifier.c:opt_subreg_zext_lo32_rnd_hi32() */
+__flag(BPF_F_TEST_RND_HI32)
+__success
+/* This test was added because of a bug in verifier.c:sync_linked_regs(),
+ * upon range propagation it destroyed subreg_def marks for registers.
+ * The subreg_def mark is used to decide whether zero extension instructions
+ * are needed when register is read. When BPF_F_TEST_RND_HI32 is set it
+ * also causes generation of statements to randomize upper halves of
+ * read registers.
+ *
+ * The test is written in a way to return an upper half of a register
+ * that is affected by range propagation and must have it's subreg_def
+ * preserved. This gives a return value of 0 and leads to undefined
+ * return value if subreg_def mark is not preserved.
+ */
+__retval(0)
+/* Check that verifier believes r1/r0 are zero at exit */
+__log_level(2)
+__msg("4: (77) r1 >>= 32                     ; R1_w=0")
+__msg("5: (bf) r0 = r1                       ; R0_w=0 R1_w=0")
+__msg("6: (95) exit")
+__msg("from 3 to 4")
+__msg("4: (77) r1 >>= 32                     ; R1_w=0")
+__msg("5: (bf) r0 = r1                       ; R0_w=0 R1_w=0")
+__msg("6: (95) exit")
+/* Verify that statements to randomize upper half of r1 had not been
+ * generated.
+ */
+__xlated("call unknown")
+__xlated("r0 &= 2147483647")
+__xlated("w1 = w0")
+/* This is how disasm.c prints BPF_ZEXT_REG at the moment, x86 and arm
+ * are the only CI archs that do not need zero extension for subregs.
+ */
+#if !defined(__TARGET_ARCH_x86) && !defined(__TARGET_ARCH_arm64)
+__xlated("w1 = w1")
+#endif
+__xlated("if w0 < 0xa goto pc+0")
+__xlated("r1 >>= 32")
+__xlated("r0 = r1")
+__xlated("exit")
+__naked void linked_regs_and_subreg_def(void)
+{
+	asm volatile (
+	"call %[bpf_ktime_get_ns];"
+	/* make sure r0 is in 32-bit range, otherwise w1 = w0 won't
+	 * assign same IDs to registers.
+	 */
+	"r0 &= 0x7fffffff;"
+	/* link w1 and w0 via ID */
+	"w1 = w0;"
+	/* 'if' statement propagates range info from w0 to w1,
+	 * but should not affect w1->subreg_def property.
+	 */
+	"if w0 < 10 goto +0;"
+	/* r1 is read here, on archs that require subreg zero
+	 * extension this would cause zext patch generation.
+	 */
+	"r1 >>= 32;"
+	"r0 = r1;"
+	"exit;"
+	:
+	: __imm(bpf_ktime_get_ns)
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.43.0



