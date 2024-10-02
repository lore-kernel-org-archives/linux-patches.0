Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11A61D0488;
	Wed,  2 Oct 2024 14:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879735; cv=none; b=Ryq+GcgdfcgpewfdheX8QcHvLpLrKAydSaSKAuQTpKvjN91FdIJkNSipHoOEaDoyBs6f653eqjnFzUryyCC/JfLZbYeon2tMX2q4thP4QC/StI09hQRhkPA8EnEMN9vxZEQOa3xLkoRAuJt7rvYnQRhuF0g4tOl9Zj+Nuo08BvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879735; c=relaxed/simple;
	bh=/0MoFEsEH5C6B42JeJ/tmT7sS0TrlSk5oDStbRoCVNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHX/rfv0tXjWYcwhXkDaXODnpuOpGJnPjsTSRL2w7EL0XX2szBeL8CVQsIiKbC6wyEVczRq348qLeCtfYLVtxNee20ITLmovcLh5CL8e5wTBjqKlUlUwAk4jV4CRldGkUic9Ooa6uOCJdnjZpTZDhLX85oVwrnJkOm7UhSsH5Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5BmFDQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5BmFDQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6719FC4CEC2;
	Wed,  2 Oct 2024 14:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879734;
	bh=/0MoFEsEH5C6B42JeJ/tmT7sS0TrlSk5oDStbRoCVNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5BmFDQNbMXiZ5ZqsholT/pv6k92w2/Y1UUpUjWNVxVWqTHxkhSP3I4L7tnnSP1GI
	 c7MSgeTIVy+m8RmzVgyYl4rp/lR4Ozt88EwSVyWAF8M0F8LaLFdhYy47XAJaL0y49K
	 7A/L4sEBrByx0h0eIgi/iaJ1pEVn0OIGcAK+KUlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Qiang Wang <wangqiang1@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/538] samples/bpf: Fix compilation errors with cf-protection option
Date: Wed,  2 Oct 2024 14:57:39 +0200
Message-ID: <20241002125800.940299224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit fdf1c728fac541891ef1aa773bfd42728626769c ]

Currently, compiling the bpf programs will result the compilation errors
with the cf-protection option as follows in arm64 and loongarch64 machine
when using gcc 12.3.1 and clang 17.0.6. This commit fixes the compilation
errors by limited the cf-protection option only used in x86 platform.

[root@localhost linux]# make M=samples/bpf
	......
  CLANG-bpf  samples/bpf/xdp2skb_meta_kern.o
error: option 'cf-protection=return' cannot be specified on this target
error: option 'cf-protection=branch' cannot be specified on this target
2 errors generated.
  CLANG-bpf  samples/bpf/syscall_tp_kern.o
error: option 'cf-protection=return' cannot be specified on this target
error: option 'cf-protection=branch' cannot be specified on this target
2 errors generated.
	......

Fixes: 34f6e38f58db ("samples/bpf: fix warning with ignored-attributes")
Reported-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Qiang Wang <wangqiang1@kylinos.cn>
Link: https://lore.kernel.org/bpf/20240815135524.140675-1-13667453960@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4ccf4236031c1..3fa16412db15c 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -166,6 +166,10 @@ BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
 endif
 
+ifeq ($(ARCH), x86)
+BPF_EXTRA_CFLAGS += -fcf-protection
+endif
+
 TPROGS_CFLAGS += -Wall -O2
 TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes
@@ -394,7 +398,7 @@ $(obj)/%.o: $(src)/%.c
 		-Wno-gnu-variable-sized-type-not-at-end \
 		-Wno-address-of-packed-member -Wno-tautological-compare \
 		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
-		-fno-asynchronous-unwind-tables -fcf-protection \
+		-fno-asynchronous-unwind-tables \
 		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
 		-O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
 		$(OPT) -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
-- 
2.43.0



