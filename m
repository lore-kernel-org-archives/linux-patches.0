Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3300851C2E;
	Mon,  8 Jan 2024 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQkoGXwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD2C433C7;
	Mon,  8 Jan 2024 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728657;
	bh=VIDIQX8XpJLRM/7MjeCxOM7MBkFT+V/8d2LtBVQ/kXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQkoGXwZNeLLZr1ALF09p9V/SRAlI6tYUoucYtx2S4GqoNZG77hApR+ojpe0W0Crm
	 gCBpZNxUg6F/fgYNGXcBOoyJ95Wx19xiXWiEeHgShrF0Oscm3o2g1IMX7DK0S7cUOF
	 shErUNVJ9/DNbygRc070TIrMFEAnKqgtYuGf+peE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.1 146/150] bpf: Fix a verifier bug due to incorrect branch offset comparison with cpu=v4
Date: Mon,  8 Jan 2024 16:36:37 +0100
Message-ID: <20240108153517.932369000@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

commit dfce9cb3140592b886838e06f3e0c25fea2a9cae upstream.

Bpf cpu=v4 support is introduced in [1] and Commit 4cd58e9af8b9
("bpf: Support new 32bit offset jmp instruction") added support for new
32bit offset jmp instruction. Unfortunately, in function
bpf_adj_delta_to_off(), for new branch insn with 32bit offset, the offset
(plus/minor a small delta) compares to 16-bit offset bound
[S16_MIN, S16_MAX], which caused the following verification failure:
  $ ./test_progs-cpuv4 -t verif_scale_pyperf180
  ...
  insn 10 cannot be patched due to 16-bit range
  ...
  libbpf: failed to load object 'pyperf180.bpf.o'
  scale_test:FAIL:expect_success unexpected error: -12 (errno 12)
  #405     verif_scale_pyperf180:FAIL

Note that due to recent llvm18 development, the patch [2] (already applied
in bpf-next) needs to be applied to bpf tree for testing purpose.

The fix is rather simple. For 32bit offset branch insn, the adjusted
offset compares to [S32_MIN, S32_MAX] and then verification succeeded.

  [1] https://lore.kernel.org/all/20230728011143.3710005-1-yonghong.song@linux.dev
  [2] https://lore.kernel.org/bpf/20231110193644.3130906-1-yonghong.song@linux.dev

Fixes: 4cd58e9af8b9 ("bpf: Support new 32bit offset jmp instruction")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231201024640.3417057-1-yonghong.song@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -365,14 +365,18 @@ static int bpf_adj_delta_to_imm(struct b
 static int bpf_adj_delta_to_off(struct bpf_insn *insn, u32 pos, s32 end_old,
 				s32 end_new, s32 curr, const bool probe_pass)
 {
-	const s32 off_min = S16_MIN, off_max = S16_MAX;
+	s64 off_min, off_max, off;
 	s32 delta = end_new - end_old;
-	s32 off;
 
-	if (insn->code == (BPF_JMP32 | BPF_JA))
+	if (insn->code == (BPF_JMP32 | BPF_JA)) {
 		off = insn->imm;
-	else
+		off_min = S32_MIN;
+		off_max = S32_MAX;
+	} else {
 		off = insn->off;
+		off_min = S16_MIN;
+		off_max = S16_MAX;
+	}
 
 	if (curr < pos && curr + off + 1 >= end_old)
 		off += delta;


