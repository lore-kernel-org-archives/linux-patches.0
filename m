Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA9158A01;
	Tue, 23 Jul 2024 18:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759904; cv=none; b=icLxrPTefXY3gyXTzuc2sVfTRS9qn2EZN0vQkSfKSEA1316uMvTktdGSsX7cVOspIvqd02SDgfzkd0r6vQaXOn7eH14mFFy9NmRIt0+wXsDdWmnYZwb3LdoOGr0aRiyH4k6JmbO4nOwUweKrRHOHd2j61uQ+Pm6gABgPCLIboJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759904; c=relaxed/simple;
	bh=pQDh12rE2IA4/Ms91rn05IimNwPjATiNBQhaVBy+OmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnogSaA2ho/OH7Cq8IGaTh0jKwBHbTWwwZL/EMSnuEzuXfvf9az1upOzVdFkrO927g7xPRUUP2MSijDwsOdLttLg9FRbighnAuD3P0hvgmulhF07ZrItQ+C/hBhIyhcGQJBkX6DreT/+jxbRcTI1QDWBv7O7s25RuL4y9c18HAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHI0XiOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHI0XiOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6460DC4AF09;
	Tue, 23 Jul 2024 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759904;
	bh=pQDh12rE2IA4/Ms91rn05IimNwPjATiNBQhaVBy+OmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHI0XiOlAsVaov5oqCWZAsO/XkkN3wlI97YRdK0PkbWD+KkvG8Ara71Kza3k42Cq5
	 9xkSg1LVAc4OKwfgdiEjmGA/uMyxslYtYB3bCGOyBxTph0QnggHhNLV+WAbsOeRN4f
	 LtzLH7CFLXeOBghLQ4D5zv7eJLudeBAxSalnfDnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 007/163] efi/libstub: zboot.lds: Discard .discard sections
Date: Tue, 23 Jul 2024 20:22:16 +0200
Message-ID: <20240723180143.749807220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 5134acb15d9ef27aa2b90aad46d4e89fcef79fdc ]

When building ARCH=loongarch defconfig + CONFIG_UNWINDER_ORC=y using
LLVM, there is a warning from ld.lld when linking the EFI zboot image
due to the use of unreachable() in number() in vsprintf.c:

  ld.lld: warning: drivers/firmware/efi/libstub/lib.a(vsprintf.stub.o):(.discard.unreachable+0x0): has non-ABS relocation R_LARCH_32_PCREL against symbol ''

If the compiler cannot eliminate the default case for any reason, the
.discard.unreachable section will remain in the final binary but the
entire point of any section prefixed with .discard is that it is only
used at compile time, so it can be discarded via /DISCARD/ in a linker
script. The asm-generic vmlinux.lds.h includes .discard and .discard.*
in the COMMON_DISCARDS macro but that is not used for zboot.lds, as it
is not a kernel image linker script.

Add .discard and .discard.* to /DISCARD/ in zboot.lds, so that any
sections meant to be discarded at link time are not included in the
final zboot image. This issue is not specific to LoongArch, it is just
the first architecture to select CONFIG_OBJTOOL, which defines
annotate_unreachable() as an asm statement to add the
.discard.unreachable section, and use the EFI stub.

Closes: https://github.com/ClangBuiltLinux/linux/issues/2023
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/zboot.lds | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index ac8c0ef851581..af2c82f7bd902 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -41,6 +41,7 @@ SECTIONS
 	}
 
 	/DISCARD/ : {
+		*(.discard .discard.*)
 		*(.modinfo .init.modinfo)
 	}
 }
-- 
2.43.0



