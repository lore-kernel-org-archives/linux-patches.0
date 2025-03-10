Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3432D023;
	Mon, 10 Mar 2025 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629374; cv=none; b=LijramaGDjvjBDljjO/OaCK2luT52KcxTGXT4T5Ga5EwPJJ37CySlx8Aqszc+eIkeuFFI5vnlIaGrX/lt00tzQHzTCJ2viLPgIa2etE2iaL+ZKRTHziSdXjr7S45qK84HP6cEMBV+PK+RF08WIA4GBFDhmlO84UPqz/lQ6Qdp9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629374; c=relaxed/simple;
	bh=L7hftUPo5GkGkHMdmm8txKHuAJp0PJx4BYClYzyDJoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rW0yXk6ggXpl3JJSL0WeweeGZJsd/nNfToN1kttSR87UCVuRJ5SjprYCm2ekrhYNiMuVW1xAmd23EdJTwDQMoHRImlD6epLQtzbDUI86Nus7DPPEeq1Zexypjg6GVJek6BukgFN7hPTb8EHuS2nntX3Ufsj7dBDja1q5yz2FV40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIzbd5Ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIzbd5Ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321FBC4CEE5;
	Mon, 10 Mar 2025 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629374;
	bh=L7hftUPo5GkGkHMdmm8txKHuAJp0PJx4BYClYzyDJoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIzbd5BazYCgnpkAg4IqgA9JW2sAu65c0+LExtoBI6mqqMnz4tCBP+L5LQiXyVeBm
	 z5wXohAj6bdGxFi0T95F9viVZZIUT+a6e+zipAWxyYTq11FP6uP/H848d6z2D8Hc8h
	 yFRsoR5+9bcx995KLCcIWFjybgtC07LF6lefSqLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kostadin Shishmanov <kostadinshishmanov@protonmail.com>,
	Jakub Jelinek <jakub@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 272/620] efi: libstub: Use -std=gnu11 to fix build with GCC 15
Date: Mon, 10 Mar 2025 18:01:58 +0100
Message-ID: <20250310170556.359996170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


