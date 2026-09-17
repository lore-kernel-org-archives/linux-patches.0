Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E4A3E40EF;
	Thu, 17 Sep 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666214; cv=none; b=kS3aIowxl6vLR7o3nr09B7/kMDKqqhWw6bUv/cgiOSlyTSPMRZuSxoqqJE0J9s1RrOmE4ScMFOYq09SHmzqcchTlGbTDBSkHJWvOc2D+t4hwLg1TrefjcODoRbK1k7PaNTUl8SYpAL6Rcigw/WsFOPTwHN8kti2Kx0922AEQJog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666214; c=relaxed/simple;
	bh=pEVEctZz1XkAu9SkE/cvA62COHlWDqK9V4tasZncCDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuYVQjj+wtsV80auPQFeyVpSbS93xFgr+iFwpt67qk8+7NBXCGX9VHONBE1daNIwIQIK/jGPK+ITjD41/mXTwO4GwEHykltz8b3WxjAi94GFNUDM0eAkhmE0RkcOjm691pPfd2e2ROQ33hUXVykH8k1ouxDdNqp7GtxeiFV5Wv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5nqQOFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5nqQOFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E911F000FF;
	Thu, 17 Sep 2026 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666212;
	bh=BK9xbhKd98/5ldMIQxQWEmcDBU/SCjfsSvRg3ADwhOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5nqQOFRm4yb1vW7VyNmaUjHCGEN7ndq3dGWKRRId02L5t0S8+7X828vPXrFjZuF1
	 X2moDs6p45yDnfkksv8chY0GKY2TRFsqz5FOEeLBFOkl67HFPQxv7KhOOWrhZ0IAdj
	 2UuiVF0oKwvNQ/dUiIwwYaF7owDRVNv+2sqEsF2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soheil Hassas Yeganeh <soheil.kdev@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 0962/1250] x86/cfi: Fix FineIBT hash offset in cfi_get_func_hash()
Date: Thu, 17 Sep 2026 16:12:37 +0100
Message-ID: <20260917151618.090498495@linuxfoundation.org>
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

From: Soheil Hassas Yeganeh <soheil.kdev@gmail.com>

commit 5a5d26f2cfe13467166219f6bf58099326912ddb upstream.

The switch of the FineIBT preamble from "subl $hash, %r10d" to the
shorter "subl $hash, %eax" moved the hash immediate from offset 7 to
offset 5 of the preamble. fineibt_preamble_hash was updated to match,
but the open-coded offset in cfi_get_func_hash() was missed and it
still reads the hash at offset 7.

cfi_get_func_hash() is used by the BPF JIT to give a struct_ops
trampoline the CFI hash of the stub function it stands in for. With
FineIBT the trampoline now gets the upper half of the real hash
followed by the first two bytes of the next instruction, so the first
indirect call from the kernel into a struct_ops program,
tcp_init_congestion_control() calling ->init() of a BPF congestion
control for example, fails the FineIBT check and the kernel dies with
a CFI failure.

Move the FineIBT preamble template and its offset defines above
cfi_get_func_hash() and use fineibt_preamble_hash there, so every
reader of the preamble shares one definition of its layout. The
CFI_FINEIBT arm is only built with CONFIG_FINEIBT, the only
configuration in which cfi_mode can take that value.
cfi_get_func_arity() does not need the same treatment: the __bhi_args
call whose displacement it reads still ends at the function address.

Fixes: 85a2d4a890dc ("x86,ibt: Use UDB instead of 0xEA")
Assisted-by: LLM
Signed-off-by: Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260831-b4-x86-cfi-fineibt-func-hash-v1-1-6ffc0af5c4ec@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |   72 ++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1193,6 +1193,41 @@ static bool cfi_debug __ro_after_init;
 bool cfi_bhi __ro_after_init = false;
 #endif
 
+#ifdef CONFIG_FINEIBT
+/*
+ * <fineibt_preamble_start>:
+ *  0:   f3 0f 1e fa             endbr64
+ *  4:   2d 78 56 34 12          sub    $0x12345678, %eax
+ *  9:   2e 0f 85 03 00 00 00    jne,pn 13 <fineibt_preamble_start+0x13>
+ * 10:   0f 1f 40 d6             nopl   -0x2a(%rax)
+ *
+ * Note that the JNE target is the 0xD6 byte inside the NOPL, this decodes as
+ * UDB on x86_64 and raises #UD.
+ */
+asm(	".pushsection .rodata				\n"
+	"fineibt_preamble_start:			\n"
+	"	endbr64					\n"
+	"	subl	$0x12345678, %eax		\n"
+	"fineibt_preamble_bhi:				\n"
+	"	cs jne.d32 fineibt_preamble_start+0x13	\n"
+	"#fineibt_func:					\n"
+	"	nopl	-42(%rax)			\n"
+	"fineibt_preamble_end:				\n"
+	".popsection\n"
+);
+
+extern u8 fineibt_preamble_start[];
+extern u8 fineibt_preamble_bhi[];
+extern u8 fineibt_preamble_end[];
+
+#define fineibt_preamble_size (fineibt_preamble_end - fineibt_preamble_start)
+#define fineibt_preamble_bhi  (fineibt_preamble_bhi - fineibt_preamble_start)
+#define fineibt_preamble_ud   0x13
+#define fineibt_preamble_hash 5
+
+#define fineibt_prefix_size (fineibt_preamble_size - ENDBR_INSN_SIZE)
+#endif /* CONFIG_FINEIBT */
+
 #ifdef CONFIG_CFI
 u32 cfi_get_func_hash(void *func)
 {
@@ -1200,9 +1235,11 @@ u32 cfi_get_func_hash(void *func)
 
 	func -= cfi_get_offset();
 	switch (cfi_mode) {
+#ifdef CONFIG_FINEIBT
 	case CFI_FINEIBT:
-		func += 7;
+		func += fineibt_preamble_hash;
 		break;
+#endif
 	case CFI_KCFI:
 		func += 1;
 		break;
@@ -1345,39 +1382,6 @@ early_param("cfi", cfi_parse_cmdline);
  */
 
 /*
- * <fineibt_preamble_start>:
- *  0:   f3 0f 1e fa             endbr64
- *  4:   2d 78 56 34 12          sub    $0x12345678, %eax
- *  9:   2e 0f 85 03 00 00 00    jne,pn 13 <fineibt_preamble_start+0x13>
- * 10:   0f 1f 40 d6             nopl   -0x2a(%rax)
- *
- * Note that the JNE target is the 0xD6 byte inside the NOPL, this decodes as
- * UDB on x86_64 and raises #UD.
- */
-asm(	".pushsection .rodata				\n"
-	"fineibt_preamble_start:			\n"
-	"	endbr64					\n"
-	"	subl	$0x12345678, %eax		\n"
-	"fineibt_preamble_bhi:				\n"
-	"	cs jne.d32 fineibt_preamble_start+0x13	\n"
-	"#fineibt_func:					\n"
-	"	nopl	-42(%rax)			\n"
-	"fineibt_preamble_end:				\n"
-	".popsection\n"
-);
-
-extern u8 fineibt_preamble_start[];
-extern u8 fineibt_preamble_bhi[];
-extern u8 fineibt_preamble_end[];
-
-#define fineibt_preamble_size (fineibt_preamble_end - fineibt_preamble_start)
-#define fineibt_preamble_bhi  (fineibt_preamble_bhi - fineibt_preamble_start)
-#define fineibt_preamble_ud   0x13
-#define fineibt_preamble_hash 5
-
-#define fineibt_prefix_size (fineibt_preamble_size - ENDBR_INSN_SIZE)
-
-/*
  * <fineibt_caller_start>:
  *  0:   b8 78 56 34 12          mov    $0x12345678, %eax
  *  5:   4d 8d 5b f0             lea    -0x10(%r11), %r11


