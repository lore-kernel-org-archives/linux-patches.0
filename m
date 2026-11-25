Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624048;
	b=jCSfa8hhW0Iorj9IVJRO74cL5zewYKuoEVjKN8c1u8mI779wqrjl2mfRzoUEp5YS6yce
	 mGrEEAwIMudpF2Qsm+/uFDOjyAqpfImqooyUu5GOnJ7P9BUmcEEcM6VymKly/GUNOq5vs
	 UAmzw1sxPs4o/5+xamT8OhzSV7oIfwRENLr+SOXZuoeHQxCLCYdlmpbZ7oSyKoCmslYgl
	 1SOIyrVBIC/1wyye8gub5L9a6xBmrvIUGeGsnS1ecL0naELKKnCyNPyi06Aocl7t4FfsV
	 miL4WA42aeiiiRoTCDvZOwzW4rPVhTnlcL3Mpwd0juqA8YFdgQ2QppBguJyKgw1LfEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bhFjmDIpajhA8Zismi3czxq0Ff2LeHlylbGTNkrK9ek=;
	b=QcAstJ0arMIggvoLXg0kB585bIWQ/FqL6rzACiLqeVsK7L5xgUpEtuN9yvi2Px0xp0rh
	 WZjTVqM17LqeTGbm9UBYoyvC3aMZyNRLhJrZTCYchEG8Ty2zBRLgyVaZESue20E/4rNbf
	 NS1Hfxg5/YnjUywT4rpdhEQjGgrqWnSL2EJpbOo+pakbiGgHlDB+SOp+1L0tyi+8/3SWz
	 od3HbzPq3puQ6mm4Qky+XraomycddnPUnu8NKh5NHvBNUDJa6fML2B6usuw994JV8ICyu
	 3tSh58YNqJOA3dZkSDKKXaKvNqgBQWH7Zc6hmWo61i8bOkcG7wmhuWaSBYbJA7YFgZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnHM0MxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FEC606A323;
	Wed, 25 Nov 2026 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnHM0MxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0418F1F000D1;
	Wed, 25 Nov 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624048;
	bh=bhFjmDIpajhA8Zismi3czxq0Ff2LeHlylbGTNkrK9ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnHM0MxCZk/bsBR7xgyV0ojah5yMUC0/6V5mgEANo6CPpA/opXrOrYB1rMRGk+qU+
	 S/iZMZuhRDsDbAdyutCcsR+o8XddE6kI3HLTfgHYQr/rXDMfTcVLdDseWUMvTC1GXS
	 vVBaudguBdRB4J9B2BE4dDa6VzrUDVa4KOKkEUXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/816] bpf: Fix jited line info off by the CFI preamble
Date: Wed, 25 Nov 2026 15:26:56 +0100
Message-ID: <20261125143850.794957742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

[ Upstream commit 3e4279dc5144a5afcda101df23792b13e94c3859 ]

With CONFIG_CFI=y, every jited line info entry after a function's
first is cfi_get_offset() bytes too high on x86-64, riscv64 and arm64,
so tools that use it show the wrong source line.

The JITs count the insn_to_jit_off[] offsets from the start of the
image. Since the CFI commits below, prog->bpf_func starts
cfi_get_offset() bytes into the image, and bpf_prog_fill_jited_linfo()
adds the offsets to prog->bpf_func. s390 corrects its offsets before
the call, the other three JITs do not.

Subtract cfi_get_offset() once in bpf_prog_fill_jited_linfo() and drop
the s390 correction. jited_linfo[0] stays prog->bpf_func, the
function's ksym address. Without CONFIG_CFI, cfi_get_offset() is 0 and
nothing changes.

Fixes: 4f9087f16651 ("x86/cfi,bpf: Fix BPF JIT call")
Fixes: e63985ecd226 ("bpf, riscv64/cfi: Support kCFI + BPF on riscv64")
Fixes: 710618c760c0 ("arm64/cfi,bpf: Support kCFI + BPF on arm64")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261030-b4-arm64-bpf-linfo-cfi-v2-1-4eac83435d4b@linux.dev
Closes: https://lore.kernel.org/all/20260904014748.C04AA1F000E9@smtp.kernel.org/
Closes: https://lore.kernel.org/all/DLNXZ2WK7TPD.2RZBUNRS4FA4L@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 643ccb230ddda..df529db44f35c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -199,7 +199,9 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
  * here is relative to the prog itself instead of the main prog.
  * This array has one entry for each xlated bpf insn.
  *
- * jited_off is the byte off to the end of the jited insn.
+ * jited_off is the byte off to the end of the jited insn, counted from
+ * the start of the jited image, which is cfi_get_offset() bytes before
+ * prog->bpf_func.
  *
  * Hence, with
  * insn_start:
@@ -213,7 +215,7 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
  *
  * For i > linfo_idx,
  *
- * jited_linfo[i] = prog->bpf_func +
+ * jited_linfo[i] = prog->bpf_func - cfi_get_offset() +
  *	insn_to_jit_off[linfo[i].insn_off - insn_start - 1]
  */
 void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
@@ -241,7 +243,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 		/* The verifier ensures that linfo[i].insn_off is
 		 * strictly increasing
 		 */
-		jited_linfo[i] = prog->bpf_func +
+		jited_linfo[i] = prog->bpf_func - cfi_get_offset() +
 			insn_to_jit_off[linfo[i].insn_off - insn_start - 1];
 }
 
-- 
2.53.0



