Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9927A2E7163;
	Tue, 17 Jun 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177061; cv=none; b=PWu/tJUrX1Gd9w/lT7T4hRAxAhDMIAy6ZTxbiprqDjoQ/fimBj1owYq782N5NCGkllRxOmkqZ5snNG5QcMyhq/wNr90NqKCnXrdFVdK48i8fDcHk3ekEvUqpYtATerBV4OQ6OB/YqpOoahn/Tm9P2YUy8lpnmDecDbD/AnNTG0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177061; c=relaxed/simple;
	bh=eTKNM8o1/oam6DjP3TrOcH4d9HR95M3D4mrwojfkGnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QgE8J/WMMmV/BZTXYvKiGpjyFQvJHDFE4uujl9E5Y1Z9kAGNNjzxSzSd6K4lwuJDX9jPV4UEh3B5Gx/S45n6d5stfFDB9KmvEWjKYmOouz8ybOfW3mFNaNuWJeSD8YM6eX+nLhumZNfqT+n2e7Ytp5M1OgUbET6hkoh3T+zbiOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkeFDZ01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkeFDZ01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B9C4CEE3;
	Tue, 17 Jun 2025 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177061;
	bh=eTKNM8o1/oam6DjP3TrOcH4d9HR95M3D4mrwojfkGnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkeFDZ01tZRjAV6gvx8UEnfxRKfuLaro5O4OMeYhf0f+FEj5dr7HsgRj04LPn8ALW
	 h9d+VaCM3G67qjjc8SCwNBrUpZvOqn53uM2IYTE4ESyduKY+I8PFMz24+UCCpUlz/n
	 HU/sr7a9y36BTKTerttB9dKWclq0i7NQBLHo+e8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Peilin Ye <yepeilin@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>
Subject: [PATCH 6.15 253/780] selftests/bpf: Avoid passing out-of-range values to __retval()
Date: Tue, 17 Jun 2025 17:19:21 +0200
Message-ID: <20250617152501.762109171@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peilin Ye <yepeilin@google.com>

[ Upstream commit 6e492ffcab6064cd7b317dc1f49fb9f92407aaa7 ]

Currently, we pass 0x1234567890abcdef to __retval() for the following
two tests:

  verifier_load_acquire/load_acquire_64
  verifier_store_release/store_release_64

However, the upper 32 bits of that value are being ignored, since
__retval() expects an int.  Actually, the tests would still pass even if
I change '__retval(0x1234567890abcdef)' to e.g. '__retval(0x90abcdef)'.

Restructure the tests a bit to test the entire 64-bit values properly.
Do the same to their 8-, 16- and 32-bit variants as well to keep the
style consistent.

Fixes: ff3afe5da998 ("selftests/bpf: Add selftests for load-acquire and store-release instructions")
Acked-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Tested-by: Björn Töpel <bjorn@rivosinc.com> # QEMU/RVA23
Signed-off-by: Peilin Ye <yepeilin@google.com>
Link: https://lore.kernel.org/r/d67f4c6f6ee0d0388cbce1f4892ec4176ee2d604.1746588351.git.yepeilin@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/verifier_load_acquire.c         | 40 +++++++++++++------
 .../bpf/progs/verifier_store_release.c        | 32 +++++++++++----
 2 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_load_acquire.c b/tools/testing/selftests/bpf/progs/verifier_load_acquire.c
index 77698d5a19e44..a696ab84bfd66 100644
--- a/tools/testing/selftests/bpf/progs/verifier_load_acquire.c
+++ b/tools/testing/selftests/bpf/progs/verifier_load_acquire.c
@@ -10,65 +10,81 @@
 
 SEC("socket")
 __description("load-acquire, 8-bit")
-__success __success_unpriv __retval(0x12)
+__success __success_unpriv __retval(0)
 __naked void load_acquire_8(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"w1 = 0x12;"
 	"*(u8 *)(r10 - 1) = w1;"
-	".8byte %[load_acquire_insn];" // w0 = load_acquire((u8 *)(r10 - 1));
+	".8byte %[load_acquire_insn];" // w2 = load_acquire((u8 *)(r10 - 1));
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(load_acquire_insn,
-		     BPF_ATOMIC_OP(BPF_B, BPF_LOAD_ACQ, BPF_REG_0, BPF_REG_10, -1))
+		     BPF_ATOMIC_OP(BPF_B, BPF_LOAD_ACQ, BPF_REG_2, BPF_REG_10, -1))
 	: __clobber_all);
 }
 
 SEC("socket")
 __description("load-acquire, 16-bit")
-__success __success_unpriv __retval(0x1234)
+__success __success_unpriv __retval(0)
 __naked void load_acquire_16(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"w1 = 0x1234;"
 	"*(u16 *)(r10 - 2) = w1;"
-	".8byte %[load_acquire_insn];" // w0 = load_acquire((u16 *)(r10 - 2));
+	".8byte %[load_acquire_insn];" // w2 = load_acquire((u16 *)(r10 - 2));
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(load_acquire_insn,
-		     BPF_ATOMIC_OP(BPF_H, BPF_LOAD_ACQ, BPF_REG_0, BPF_REG_10, -2))
+		     BPF_ATOMIC_OP(BPF_H, BPF_LOAD_ACQ, BPF_REG_2, BPF_REG_10, -2))
 	: __clobber_all);
 }
 
 SEC("socket")
 __description("load-acquire, 32-bit")
-__success __success_unpriv __retval(0x12345678)
+__success __success_unpriv __retval(0)
 __naked void load_acquire_32(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"w1 = 0x12345678;"
 	"*(u32 *)(r10 - 4) = w1;"
-	".8byte %[load_acquire_insn];" // w0 = load_acquire((u32 *)(r10 - 4));
+	".8byte %[load_acquire_insn];" // w2 = load_acquire((u32 *)(r10 - 4));
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(load_acquire_insn,
-		     BPF_ATOMIC_OP(BPF_W, BPF_LOAD_ACQ, BPF_REG_0, BPF_REG_10, -4))
+		     BPF_ATOMIC_OP(BPF_W, BPF_LOAD_ACQ, BPF_REG_2, BPF_REG_10, -4))
 	: __clobber_all);
 }
 
 SEC("socket")
 __description("load-acquire, 64-bit")
-__success __success_unpriv __retval(0x1234567890abcdef)
+__success __success_unpriv __retval(0)
 __naked void load_acquire_64(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"r1 = 0x1234567890abcdef ll;"
 	"*(u64 *)(r10 - 8) = r1;"
-	".8byte %[load_acquire_insn];" // r0 = load_acquire((u64 *)(r10 - 8));
+	".8byte %[load_acquire_insn];" // r2 = load_acquire((u64 *)(r10 - 8));
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(load_acquire_insn,
-		     BPF_ATOMIC_OP(BPF_DW, BPF_LOAD_ACQ, BPF_REG_0, BPF_REG_10, -8))
+		     BPF_ATOMIC_OP(BPF_DW, BPF_LOAD_ACQ, BPF_REG_2, BPF_REG_10, -8))
 	: __clobber_all);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/verifier_store_release.c b/tools/testing/selftests/bpf/progs/verifier_store_release.c
index c0442d5bb049d..022d03d983595 100644
--- a/tools/testing/selftests/bpf/progs/verifier_store_release.c
+++ b/tools/testing/selftests/bpf/progs/verifier_store_release.c
@@ -11,13 +11,17 @@
 
 SEC("socket")
 __description("store-release, 8-bit")
-__success __success_unpriv __retval(0x12)
+__success __success_unpriv __retval(0)
 __naked void store_release_8(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"w1 = 0x12;"
 	".8byte %[store_release_insn];" // store_release((u8 *)(r10 - 1), w1);
-	"w0 = *(u8 *)(r10 - 1);"
+	"w2 = *(u8 *)(r10 - 1);"
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(store_release_insn,
@@ -27,13 +31,17 @@ __naked void store_release_8(void)
 
 SEC("socket")
 __description("store-release, 16-bit")
-__success __success_unpriv __retval(0x1234)
+__success __success_unpriv __retval(0)
 __naked void store_release_16(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"w1 = 0x1234;"
 	".8byte %[store_release_insn];" // store_release((u16 *)(r10 - 2), w1);
-	"w0 = *(u16 *)(r10 - 2);"
+	"w2 = *(u16 *)(r10 - 2);"
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(store_release_insn,
@@ -43,13 +51,17 @@ __naked void store_release_16(void)
 
 SEC("socket")
 __description("store-release, 32-bit")
-__success __success_unpriv __retval(0x12345678)
+__success __success_unpriv __retval(0)
 __naked void store_release_32(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"w1 = 0x12345678;"
 	".8byte %[store_release_insn];" // store_release((u32 *)(r10 - 4), w1);
-	"w0 = *(u32 *)(r10 - 4);"
+	"w2 = *(u32 *)(r10 - 4);"
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(store_release_insn,
@@ -59,13 +71,17 @@ __naked void store_release_32(void)
 
 SEC("socket")
 __description("store-release, 64-bit")
-__success __success_unpriv __retval(0x1234567890abcdef)
+__success __success_unpriv __retval(0)
 __naked void store_release_64(void)
 {
 	asm volatile (
+	"r0 = 0;"
 	"r1 = 0x1234567890abcdef ll;"
 	".8byte %[store_release_insn];" // store_release((u64 *)(r10 - 8), r1);
-	"r0 = *(u64 *)(r10 - 8);"
+	"r2 = *(u64 *)(r10 - 8);"
+	"if r2 == r1 goto 1f;"
+	"r0 = 1;"
+"1:"
 	"exit;"
 	:
 	: __imm_insn(store_release_insn,
-- 
2.39.5



