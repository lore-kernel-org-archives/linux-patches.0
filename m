Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B9C1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FCCC433C7;
	Tue, 25 Jul 2023 11:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284417;
	bh=okic9eINQg359aR7rUMBQnNaBM6Y9mu1pZmQA76Nk2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOLH8UtlFzvauuoZDePY8ULMv6iumseejDMD2TvPrj9iA4+YpDnBMo5tFypn/7cmS
	 tLYImU/xZ9XztliMCkpkz79rH4nieMNInWF3nQbaIJJliISYt9sqEmu3mTang/Pko1
	 d4mDErO4jzG8Y1WsL+X+BCMSROPB9XOSFYrO8Lt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilad Reti <gilad.reti@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Lorenz Bauer <lmb@isovalent.com>
Subject: [PATCH 5.10 309/509] selftests/bpf: Add verifier test for PTR_TO_MEM spill
Date: Tue, 25 Jul 2023 12:44:08 +0200
Message-ID: <20230725104607.888966133@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gilad Reti <gilad.reti@gmail.com>

commit 4237e9f4a96228ccc8a7abe5e4b30834323cd353 upstream.

Add a test to check that the verifier is able to recognize spilling of
PTR_TO_MEM registers, by reserving a ringbuf buffer, forcing the spill
of a pointer holding the buffer address to the stack, filling it back
in from the stack and writing to the memory area pointed by it.

The patch was partially contributed by CyberArk Software, Inc.

Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/bpf/20210113053810.13518-2-gilad.reti@gmail.com
Cc: Lorenz Bauer <lmb@isovalent.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c       |   12 ++++++++
 tools/testing/selftests/bpf/verifier/spill_fill.c |   30 ++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	20
+#define MAX_NR_MAPS	21
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -87,6 +87,7 @@ struct bpf_test {
 	int fixup_sk_storage_map[MAX_FIXUPS];
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
+	int fixup_map_ringbuf[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t insn_processed;
@@ -640,6 +641,7 @@ static void do_test_fixup(struct bpf_tes
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
+	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -817,6 +819,14 @@ static void do_test_fixup(struct bpf_tes
 			fixup_map_reuseport_array++;
 		} while (*fixup_map_reuseport_array);
 	}
+	if (*fixup_map_ringbuf) {
+		map_fds[20] = create_map(BPF_MAP_TYPE_RINGBUF, 0,
+					   0, 4096);
+		do {
+			prog[*fixup_map_ringbuf].imm = map_fds[20];
+			fixup_map_ringbuf++;
+		} while (*fixup_map_ringbuf);
+	}
 }
 
 struct libcap {
--- a/tools/testing/selftests/bpf/verifier/spill_fill.c
+++ b/tools/testing/selftests/bpf/verifier/spill_fill.c
@@ -29,6 +29,36 @@
 	.result_unpriv = ACCEPT,
 },
 {
+	"check valid spill/fill, ptr to mem",
+	.insns = {
+	/* reserve 8 byte ringbuf memory */
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_MOV64_IMM(BPF_REG_2, 8),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_reserve),
+	/* store a pointer to the reserved memory in R6 */
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	/* check whether the reservation was successful */
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
+	/* spill R6(mem) into the stack */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_6, -8),
+	/* fill it back in R7 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_10, -8),
+	/* should be able to access *(R7) = 0 */
+	BPF_ST_MEM(BPF_DW, BPF_REG_7, 0, 0),
+	/* submit the reserved ringbuf memory */
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_submit),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_ringbuf = { 1 },
+	.result = ACCEPT,
+	.result_unpriv = ACCEPT,
+},
+{
 	"check corrupted spill/fill",
 	.insns = {
 	/* spill R1(ctx) into stack */


