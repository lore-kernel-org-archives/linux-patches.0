Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07DD25E807;
	Tue, 11 Mar 2025 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706912; cv=none; b=THVWXPur/EXyIqZWQEl/NJZrBxr9GsP5xSgveLMTK/gkjsGHDU2NAHEIPSRWcH/k6LQQ+NDLpFmYvU2tOTpVNyCXye2hNo/PB9o87yVUCmBH5XEKtvkSjkbIQ55J0ht1pOK8Tv2uE+Qgi1C2rDIZ02rt3VtxFdNYlLlH25Cl3LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706912; c=relaxed/simple;
	bh=4Vjv+nSnwLV1X5xuP8MIxRJgyTrPPcW8OMAo6kmZ8Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s43JbujUcQdNOOdv7U2GP5IvmSoW11+fzOwiKdCEaFcEcpBxBUlu9Op2+Xdhn/EmV5TnDGvqV67vL9qZI5jSFpM8udwzh6yIxtTBEtAiBiXj2pqXnVQptTl5HaDnEFEEpGg8YVzqoeV1vYUlO9//GxPMZiYVk8uZJtyOAsMpKeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxGrh0Of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxGrh0Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DDEC4CEEA;
	Tue, 11 Mar 2025 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706912;
	bh=4Vjv+nSnwLV1X5xuP8MIxRJgyTrPPcW8OMAo6kmZ8Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxGrh0OfmKzJXc5+1p6sDPSgDvdEA+YN1J8FaeES/ZViDvYbT2QsGXP+D5OJD5faF
	 NtlYWkR5fLdGiizxhs/h+MnxeRyhBoK1BryU33wa4b/15yJ21Xt644maWGA/3Nw5M2
	 W1u1EMiKePAx2wsixJssW9E9GZgm+phSaxGbIhmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kostadin Shishmanov <kostadinshishmanov@protonmail.com>,
	Jakub Jelinek <jakub@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 179/462] efi: libstub: Use -std=gnu11 to fix build with GCC 15
Date: Tue, 11 Mar 2025 15:57:25 +0100
Message-ID: <20250311145805.427657931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 8ba14d9f490aef9fd535c04e9e62e1169eb7a055 upstream.

GCC 15 changed the default C standard version to C23, which should not
have impacted the kernel because it requests the gnu11 standard via
'-std=' in the main Makefile. However, the EFI libstub Makefile uses its
own set of KBUILD_CFLAGS for x86 without a '-std=' value (i.e., using
the default), resulting in errors from the kernel's definitions of bool,
true, and false in stddef.h, which are reserved keywords under C23.

  ./include/linux/stddef.h:11:9: error: expected identifier before ‘false’
     11 |         false   = 0,
  ./include/linux/types.h:35:33: error: two or more data types in declaration specifiers
     35 | typedef _Bool                   bool;

Set '-std=gnu11' in the x86 cflags to resolve the error and consistently
use the same C standard version for the entire kernel. All other
architectures reuse KBUILD_CFLAGS from the rest of the kernel, so this
issue is not visible for them.

Cc: stable@vger.kernel.org
Reported-by: Kostadin Shishmanov <kostadinshishmanov@protonmail.com>
Closes: https://lore.kernel.org/4OAhbllK7x4QJGpZjkYjtBYNLd_2whHx9oFiuZcGwtVR4hIzvduultkgfAIRZI3vQpZylu7Gl929HaYFRGeMEalWCpeMzCIIhLxxRhq4U-Y=@protonmail.com/
Reported-by: Jakub Jelinek <jakub@redhat.com>
Closes: https://lore.kernel.org/Z4467umXR2PZ0M1H@tucnak/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -7,7 +7,7 @@
 #
 cflags-$(CONFIG_X86_32)		:= -march=i386
 cflags-$(CONFIG_X86_64)		:= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ \
+cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu11 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
 				   -mno-mmx -mno-sse -fshort-wchar \
 				   -Wno-pointer-sign \


