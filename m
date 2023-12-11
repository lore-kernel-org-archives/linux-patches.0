Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F073F5101A;
	Mon, 11 Dec 2023 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A9w0gxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D92C433C8;
	Mon, 11 Dec 2023 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319234;
	bh=j0USQOdhPCKAOQUwxXeIxVfUzqbYPexJenADJVtTG88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A9w0gxNgLrFoOuyPxX2SHPm8tF91CbEZ7sRDaan3C6N4p6swZsaB3mrGBBqaBzxm
	 oEjCtW5H3V8NukbOdGi1B+BGcVTsshKgYx87EQmx9DKfc0gHfYdFxbz+qbgpbizGpg
	 TKn6+vV6lwGQYyp6spLJY9uQ0F6e9Qs5biGhVIYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/244] bpf: Fix a verifier bug due to incorrect branch offset comparison with cpu=v4
Date: Mon, 11 Dec 2023 19:18:43 +0100
Message-ID: <20231211182047.150038062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit dfce9cb3140592b886838e06f3e0c25fea2a9cae ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 64fcd81ad3da4..5d1efe5200ba3 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -371,14 +371,18 @@ static int bpf_adj_delta_to_imm(struct bpf_insn *insn, u32 pos, s32 end_old,
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
-- 
2.42.0



