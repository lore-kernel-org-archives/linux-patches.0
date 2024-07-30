Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A4218B46F;
	Tue, 30 Jul 2024 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356088; cv=none; b=AO+VT2okFgavQlSzZ/ogA3AKmS7nKX7LOOzPyrXq6iP64WrHCnCsbyE4H7DJ+R/M8WWFvFarmh/zkeRg4/lUtRIQGk8xYE0mVJ7YJCMK+zivZZzyPhSK4yODV6BOpqXyNqGNguLE+JVWtRKwx/Y6685OhE0Pq+Y4x00DTMINMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356088; c=relaxed/simple;
	bh=upIoB+PE0gxQ94D3ZzO7yl8SrVSIumKrTwhSePvLGbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POm4pA/ho7NaBxfORP9B46t9yHcJ3yHstOi8W7uvZpHHDBgo66Uzgn1NG5n0j8tS1p3juyedCklRTHWCJ48pqiR2o0COAONdKhd2P4mopkbXYYMsAXZUQNfl0EoPRG7GVEsHI4j9owQPkjx/vt7TYJ9t7JNJz/Kg8ThJA4mQQqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOLzSTgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOLzSTgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA1FC32782;
	Tue, 30 Jul 2024 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356088;
	bh=upIoB+PE0gxQ94D3ZzO7yl8SrVSIumKrTwhSePvLGbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOLzSTgQQps09GpBvks/M+uGeNkibecsuWhzOx2cBPEp0/S3J7/tWPRHNifm2iHJC
	 sQ/hKQtotpLqvmvHD22yCfuqU7XLHh/nmouNN8sjJ9IlaxsfGpspyGfv7GhXWiNjAZ
	 rJu3ncmhcemCdkWmJvoDuPc+kApnNtNaYMmQoHus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/568] bpftool: Un-const bpf_func_info to fix it for llvm 17 and newer
Date: Tue, 30 Jul 2024 17:43:40 +0200
Message-ID: <20240730151644.291495308@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 958e92acca8e2..9b75639434b81 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -410,7 +410,7 @@ void get_prog_full_name(const struct bpf_prog_info *prog_info, int prog_fd,
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



