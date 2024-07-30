Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BE3189539;
	Tue, 30 Jul 2024 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355324; cv=none; b=a59bSfv/x8pUH3YPSfhuhMd5QqCXjsxWRfr1NF5AJ+be69Sgd9Lhf66F6aqti7Gky9TKPt1mHVCKdPjiFIrxFtMrGC9XUQ8Vcv0u/w7+ZfdZDuNhaR5HaZ/gtTAQ4Tj2NMb4OUPwic4pi3dEvfXxTrTGG750NRjJ3Xg4KejzFjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355324; c=relaxed/simple;
	bh=uWcychPQ0n2J4IIl/aWtJOBXhQiJYCv2fj998dvUzNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZjZ7ZwmIyfQK3IrcEBke5WkMnuxL0wpHWidZ8kk838Wewd9xoM06X1ANBssdsUsv6z4BhA1FcVRNpvobmnAnYQ8bpzDhxub/uXpRszNdO1PDAW+EHeuC8CukotfHfaLCQBorLm0Q1xu44cByGNbsEekdmJ93gLY+rP5legPORA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z23Mhx1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z23Mhx1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B407C32782;
	Tue, 30 Jul 2024 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355323;
	bh=uWcychPQ0n2J4IIl/aWtJOBXhQiJYCv2fj998dvUzNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z23Mhx1jmxwkbjoqKgor7NRRvjrU8ZMmBMTdfMs+IZSK22ki92fizjbS8P+HYiQLw
	 YCZ8boMrYhmGlw6b+OnY6nftd+9VP2oPtFMe8Mfvm5hxHDGzaK7neJlqibl2YF8u9m
	 aNIaTC5Vu7/2pgCXiSAaZ5di9kB3jyvhmgXzSqi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/440] bpftool: Un-const bpf_func_info to fix it for llvm 17 and newer
Date: Tue, 30 Jul 2024 17:45:16 +0200
Message-ID: <20240730151619.001179193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Ivan Babrou <ivan@cloudflare.com>

[ Upstream commit f4aba3471cfb9ccf69b476463f19b4c50fef6b14 ]

LLVM 17 started treating const structs as constants:

* https://github.com/llvm/llvm-project/commit/0b2d5b967d98

Combined with pointer laundering via ptr_to_u64, which takes a const ptr,
but in reality treats the underlying memory as mutable, this makes clang
always pass zero to btf__type_by_id, which breaks full name resolution.

Disassembly before (LLVM 16) and after (LLVM 17):

    -    8b 75 cc                 mov    -0x34(%rbp),%esi
    -    e8 47 8d 02 00           call   3f5b0 <btf__type_by_id>
    +    31 f6                    xor    %esi,%esi
    +    e8 a9 8c 02 00           call   3f510 <btf__type_by_id>

It's a bigger project to fix this properly (and a question whether LLVM
itself should detect this), but for right now let's just fix bpftool.

For more information, see this thread in bpf mailing list:

* https://lore.kernel.org/bpf/CABWYdi0ymezpYsQsPv7qzpx2fWuTkoD1-wG1eT-9x-TSREFrQg@mail.gmail.com/T/

Fixes: b662000aff84 ("bpftool: Adding support for BTF program names")
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20240520225149.5517-1-ivan@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index e7a11cff7245a..db02b000fbebd 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -333,7 +333,7 @@ void get_prog_full_name(const struct bpf_prog_info *prog_info, int prog_fd,
 {
 	const char *prog_name = prog_info->name;
 	const struct btf_type *func_type;
-	const struct bpf_func_info finfo = {};
+	struct bpf_func_info finfo = {};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	struct btf *prog_btf = NULL;
-- 
2.43.0



