Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CF23597E;
	Mon, 23 Jun 2025 22:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716463; cv=none; b=DEaWWYOCYlM7yJqlKOte327LWpSJTMyk+oDbfXmluDKp8gP6M/LVIdbyiZ4hTrsZtRYX2RR+Dy43fVo3OSkDd1gJ3vPezHDL7INjWEoVaUxCFcrTqwK9G2g6M1eyOUgvztJeZbXfTaIy8rb7u3AhbkO54L6bLIhi4ucbqNoiPp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716463; c=relaxed/simple;
	bh=Svwh1NmwXBqTbInxLpB8VZMC0ncT4AfL67I0JuOuwFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8oBiCZgVHotcBZSi+9Ry3udOsBw9sfH5S8rQHEr5Igikp0AjsdSN81jl7CBd630eR+/pm8RzRoG0vaO9WZt/Y5sqxrTXLTp25h2OerNjzX7d6/tkg/D2sXlwTA4X5HSjezoyofLpTrfHtbEVVhKl92kj0hy/phcU23fCC4T1SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blbBTbgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blbBTbgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D34EC4CEEA;
	Mon, 23 Jun 2025 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716463;
	bh=Svwh1NmwXBqTbInxLpB8VZMC0ncT4AfL67I0JuOuwFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blbBTbgPt4L2/DbnzUA+n7d9szQaX5YXFJSwKxhg5nFLWQvXWjMCFxW0EFGSXRLgn
	 OkeuhPE91rDIenptLIDTB6BdAHR2db+w8ZTmY003OKO25iWQZ4oXpW5xYjmqHljnQa
	 d53t2ujhmffGv2TQQC881RGA/Ev9bqJCHgF69WMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wei <weiwei.danny@bytedance.com>,
	Aaron Lu <ziqianlu@bytedance.com>
Subject: [PATCH 5.10 350/355] Revert "selftests/bpf: make test_align selftest more robust"
Date: Mon, 23 Jun 2025 15:09:11 +0200
Message-ID: <20250623130637.244059748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <ziqianlu@bytedance.com>

This reverts commit 4af2d9ddb7e78f97c23f709827e5075c6d866e34 which is
commit 4f999b767769b76378c3616c624afd6f4bb0d99f upstream.

The backport of bpf precision tracking related changes has caused bpf
verifier to panic while loading some certain bpf prog so revert them.

Link: https://lkml.kernel.org/r/20250605070921.GA3795@bytedance/
Reported-by: Wei Wei <weiwei.danny@bytedance.com>
Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/align.c |   36 +++++++++----------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/align.c
+++ b/tools/testing/selftests/bpf/prog_tests/align.c
@@ -2,7 +2,7 @@
 #include <test_progs.h>
 
 #define MAX_INSNS	512
-#define MAX_MATCHES	24
+#define MAX_MATCHES	16
 
 struct bpf_reg_match {
 	unsigned int line;
@@ -267,7 +267,6 @@ static struct bpf_align_test tests[] = {
 			 */
 			BPF_MOV64_REG(BPF_REG_5, BPF_REG_2),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_5, BPF_REG_6),
-			BPF_MOV64_REG(BPF_REG_4, BPF_REG_5),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_5, 14),
 			BPF_MOV64_REG(BPF_REG_4, BPF_REG_5),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 4),
@@ -281,7 +280,6 @@ static struct bpf_align_test tests[] = {
 			BPF_MOV64_REG(BPF_REG_5, BPF_REG_2),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_5, 14),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_5, BPF_REG_6),
-			BPF_MOV64_REG(BPF_REG_4, BPF_REG_5),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_5, 4),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_5, BPF_REG_6),
 			BPF_MOV64_REG(BPF_REG_4, BPF_REG_5),
@@ -313,52 +311,44 @@ static struct bpf_align_test tests[] = {
 			{15, "R4=pkt(id=1,off=18,r=18,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			{15, "R5=pkt(id=1,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Variable offset is added to R5 packet pointer,
-			 * resulting in auxiliary alignment of 4. To avoid BPF
-			 * verifier's precision backtracking logging
-			 * interfering we also have a no-op R4 = R5
-			 * instruction to validate R5 state. We also check
-			 * that R4 is what it should be in such case.
+			 * resulting in auxiliary alignment of 4.
 			 */
-			{19, "R4_w=pkt(id=2,off=0,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
-			{19, "R5_w=pkt(id=2,off=0,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
+			{18, "R5_w=pkt(id=2,off=0,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Constant offset is added to R5, resulting in
 			 * reg->off of 14.
 			 */
-			{20, "R5_w=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
+			{19, "R5_w=pkt(id=2,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off
 			 * (14) which is 16.  Then the variable offset is 4-byte
 			 * aligned, so the total offset is 4-byte aligned and
 			 * meets the load's requirements.
 			 */
-			{24, "R4=pkt(id=2,off=18,r=18,umax_value=1020,var_off=(0x0; 0x3fc))"},
-			{24, "R5=pkt(id=2,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc))"},
+			{23, "R4=pkt(id=2,off=18,r=18,umax_value=1020,var_off=(0x0; 0x3fc))"},
+			{23, "R5=pkt(id=2,off=14,r=18,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Constant offset is added to R5 packet pointer,
 			 * resulting in reg->off value of 14.
 			 */
-			{27, "R5_w=pkt(id=0,off=14,r=8"},
+			{26, "R5_w=pkt(id=0,off=14,r=8"},
 			/* Variable offset is added to R5, resulting in a
-			 * variable offset of (4n). See comment for insn #19
-			 * for R4 = R5 trick.
+			 * variable offset of (4n).
 			 */
-			{29, "R4_w=pkt(id=3,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
-			{29, "R5_w=pkt(id=3,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
+			{27, "R5_w=pkt(id=3,off=14,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Constant is added to R5 again, setting reg->off to 18. */
-			{30, "R5_w=pkt(id=3,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
+			{28, "R5_w=pkt(id=3,off=18,r=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* And once more we add a variable; resulting var_off
 			 * is still (4n), fixed offset is not changed.
 			 * Also, we create a new reg->id.
 			 */
-			{32, "R4_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
-			{32, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
+			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (18)
 			 * which is 20.  Then the variable offset is (4n), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{35, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
-			{35, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
+			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
+			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
 		},
 	},
 	{


