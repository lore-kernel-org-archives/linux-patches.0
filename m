Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F5E509F06;
	Wed, 30 Sep 2026 18:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792444; cv=none; b=FbfqCG+/WGNrSXPX0UX28PM3rzAlftoP/ETENscd/5GYBEQHW/sSowrC+PRq5i43oHSbnh12oW9ulqqSu1WC8P7iPmMp4vTpqVvyDa5NLY9+iJZ6rnKbwxCu0leIDSdC1L1e4ghGjXcVlrAwhwLpztZhk+4FyLAtkfmxTgdIa/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792444; c=relaxed/simple;
	bh=XtnfgNHm3lKgQDbsimfKgPnaSMwV1LVjahE3QFoaGTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioVK/pUtKnOUtPBic+WE7eOB2s5X3ROiNFXdC4Po8jPCrr9LqiMk9TJ+KYzgik7muF39t4UpuMwoYNaGZUZbkqvijpc+MNvR+5Sc6/o1DlEKahp+LsYpq7o3mPqIqNsbI/xdRZPzCs/2+wwFOpSynX9neSgnCLuqCKbCAUeQK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbNwl77S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbNwl77S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01851F000FF;
	Wed, 30 Sep 2026 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792443;
	bh=v1LCltI6XXvwQL3qxbr7sFeTXVPK1Sww5j0R8zauUJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbNwl77So2zG7trT6SoBttg3yswA/mndsw1gjTu9xvLbGnq6qixua80FCHvIeqR94
	 QbQTRcmGVRripAkNoSvoY6B5q91qExsrhSYpJUhZXJMCe6JoXjQodawhxozG9IKXlF
	 Pyh5QWie1wvz7RmKEkO7PQMvc/9JHAQGN7bcx2Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Yonghong Song <yhs@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 612/752] libbpf: Fix an error in 64bit relocation value computation
Date: Wed, 30 Sep 2026 17:28:02 +0200
Message-ID: <20260930152411.527163667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yhs@fb.com>

[ Upstream commit b58b2b3a31228bd9aaed9b96e9452dafd0d46024 ]

Currently, the 64bit relocation value in the instruction
is computed as follows:
  __u64 imm = insn[0].imm + ((__u64)insn[1].imm << 32)

Suppose insn[0].imm = -1 (0xffffffff) and insn[1].imm = 1.
With the above computation, insn[0].imm will first sign-extend
to 64bit -1 (0xffffffffFFFFFFFF) and then add 0x1FFFFFFFF,
producing incorrect value 0xFFFFFFFF. The correct value
should be 0x1FFFFFFFF.

Changing insn[0].imm to __u32 first will prevent 64bit sign
extension and fix the issue. Merging high and low 32bit values
also changed from '+' to '|' to be consistent with other
similar occurences in kernel and libbpf.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Dave Marchevsky <davemarchevsky@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220607062610.3717378-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 394ae398337c ("bpf: Restrict CO-RE poisoning to relocatable instructions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/relo_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index 5976a8e6c7d19..871a2ea8674ae 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -1017,7 +1017,7 @@ static int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			return -EINVAL;
 		}
 
-		imm = insn[0].imm + ((__u64)insn[1].imm << 32);
+		imm = (__u32)insn[0].imm | ((__u64)insn[1].imm << 32);
 		if (res->validate && imm != orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: got %llu, exp %u -> %u\n",
 				prog_name, relo_idx,
-- 
2.53.0



