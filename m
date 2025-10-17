Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507B332C931;
	Fri, 17 Oct 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714147; cv=none; b=N6MGtV2EtGSLvfRmfZYLK2xWh/aaWQrYnaTJVC45LpcbjXzMRwRiTRVclFx15yKdOFSJXYQFgSTtjDBwDCVlZahxbiisLJNfWQFZrecfgPPZO8QxbexrnOb9dT3CFGhZfOdyJBy0BGM/2eMO4BVV229Kr0/SxqvyHCugW1yLO+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714147; c=relaxed/simple;
	bh=5hNdn7U98rnPPqsWOGcwMhwFQYPIErkwqWFSK32lnY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA0Tyj3UccqC/lLkJSQHAEJTwR+ixp6iZ1AhpQS1dGDTpRt7XQd9R1Xvz//FQAU9YP915JOR9wIQoMRE8fRvn/vpy0wurFUfFuGAXXNHoytcsCOcWvBnZpaWf0/z9ex3y3FN1kZ3q9pa4Hs7TiSPa5oLf3kTZrnX72Uzu4QMHBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiWHR0eV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiWHR0eV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CD5C4CEE7;
	Fri, 17 Oct 2025 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714147;
	bh=5hNdn7U98rnPPqsWOGcwMhwFQYPIErkwqWFSK32lnY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiWHR0eVyGO2v38be29NhDysGrb88zm1Z0REdGo3nQ4gsQKEx2Ff03W4YDQb+PQo4
	 jJlHXV94oeeJoxxyx1LkIl3qw3fEWAqKwJQIuVeCfzWFo9YkxII7FO2g1mWT/jnFcP
	 4M9C8IQE3202JLktpZwtPDXkCwh6EeMlSZ1dVZAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/277] LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference
Date: Fri, 17 Oct 2025 16:50:51 +0200
Message-ID: <20251017145148.754250031@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 567bd122a9ee4..c14ae21075c5f 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -114,7 +114,7 @@ KBUILD_RUSTFLAGS_KERNEL		+= -Crelocation-model=pie
 LDFLAGS_vmlinux			+= -static -pie --no-dynamic-linker -z notext $(call ld-option, --apply-dynamic-relocs)
 endif
 
-cflags-y += $(call cc-option, -mno-check-zero-division)
+cflags-y += $(call cc-option, -mno-check-zero-division -fno-isolate-erroneous-paths-dereference)
 
 ifndef CONFIG_KASAN
 cflags-y += -fno-builtin-memcpy -fno-builtin-memmove -fno-builtin-memset
-- 
2.51.0



