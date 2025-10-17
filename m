Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7092532E131;
	Fri, 17 Oct 2025 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715038; cv=none; b=SGvpdm71WQqK6dAncjkLf8vowRfQKL6DFayoKrMiAqKRHQ1LFwZzzrOlRrT1XuKQSJmJMIBMeLXWlZAv+5jtYbTPYiBCqNGNi7TCtkbvArSD1wTX/ZL1bgTUT+acd1is7YpTBfTCA8p1DrF+CLSzg9CTgLqNM5dcB/TIpxeizjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715038; c=relaxed/simple;
	bh=Jh7MQRQfT+XQb56sQNF4fF6e2719ycv/OTkY5Dh65cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRmHlSI1RNX3QWvwozgZ0N1jB4HxBgXhkPUkh9j32zOvYzppYHPVzEdkwHhzqsp5g1f1jZZDbEM9x++CCg6taP6xDVMZw6W+ewgsjPLtTeproRlXeLlKBKVYt0tHcK/LpcKkiY4vNcTvUcMn0jmEufTpnf4kqXxOLHkc1DzoKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AT7jnbxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT7jnbxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E911CC4CEE7;
	Fri, 17 Oct 2025 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715038;
	bh=Jh7MQRQfT+XQb56sQNF4fF6e2719ycv/OTkY5Dh65cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT7jnbxzDqvAJg0okMezxrLciXXZOYPxCDxgmexBVBS8LFxGbxkJt+2IRgad4x65E
	 YuJoOQ6LEvJJvNvlmtsljlWzGiU1YY/dmpeBt1xA01Xtk+SjWekj7kEx6D66LhZ6YT
	 sut84ZiFGZl/q+Nl+J31kMQlcV+n33+N9HGCqJss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 076/371] LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference
Date: Fri, 17 Oct 2025 16:50:51 +0200
Message-ID: <20251017145204.690121907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit abb2a5572264b425e6dd9c213b735a82ab0ca68a ]

Currently, when compiling with GCC, there is no "break 7" instruction
for zero division due to using the option -mno-check-zero-division, but
the compiler still generates "break 0" instruction for zero division.

Here is a simple example:

  $ cat test.c
  int div(int a)
  {
	  return a / 0;
  }
  $ gcc -O2 -S test.c -o test.s

GCC generates "break 0" on LoongArch and "ud2" on x86, objtool decodes
"ud2" as INSN_BUG for x86, so decode "break 0" as INSN_BUG can fix the
objtool warnings for LoongArch, but this is not the intention.

When decoding "break 0" as INSN_TRAP in the previous commit, the aim is
to handle "break 0" as a trap. The generated "break 0" for zero division
by GCC is not proper, it should generate a break instruction with proper
bug type, so add the GCC option -fno-isolate-erroneous-paths-dereference
to avoid generating the unexpected "break 0" instruction for now.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202509200413.7uihAxJ5-lkp@intel.com/
Fixes: baad7830ee9a ("objtool/LoongArch: Mark types based on break immediate code")
Suggested-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index ae419e32f22e2..f2a585b4a9375 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -129,7 +129,7 @@ KBUILD_RUSTFLAGS_KERNEL		+= -Crelocation-model=pie
 LDFLAGS_vmlinux			+= -static -pie --no-dynamic-linker -z notext $(call ld-option, --apply-dynamic-relocs)
 endif
 
-cflags-y += $(call cc-option, -mno-check-zero-division)
+cflags-y += $(call cc-option, -mno-check-zero-division -fno-isolate-erroneous-paths-dereference)
 
 ifndef CONFIG_KASAN
 cflags-y += -fno-builtin-memcpy -fno-builtin-memmove -fno-builtin-memset
-- 
2.51.0



