Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966121B9C9;
	Mon, 23 Jun 2025 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713999; cv=none; b=X8ucEzdeG2ha7OnSX/9AHc68/q/pRC5UoSlG3AdkEheLEpUd3d3rbawWtCggIkcuEEWKEDX8y/kYLmbEVib/IoV/ChfvUgS3bnVsYGhBj1KtAI48oDRkwVUIYzdkEpT8FyW/KbDSqx7hNVJBIASsTGXYrWTCqEH+XFnYVGax4ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713999; c=relaxed/simple;
	bh=elH5IQGF1t0PwlGaZkNnSZvFYhul5gYuVgh2dZDKPgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck1dYPdUxmhZ6XiAGhDQ7GmAOPTtlNXK3MKL9PFDIozsYGtImHvOvvmk06jyk69P/Vd+8JFJsY9dcB3Ki1Xc6zM6pPerqv8gxdvdCf4ZgTW/HOrVAkWiFDqK6yvNokG9zG8+WFLlVxd0jNpiE+L7LhRGKzVW+BY7YeOk/7C6/6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkxwVhWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkxwVhWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88602C4CEED;
	Mon, 23 Jun 2025 21:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713998;
	bh=elH5IQGF1t0PwlGaZkNnSZvFYhul5gYuVgh2dZDKPgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkxwVhWF4NoT0HSm35zoFWS25T9IgqN0qw1vFpUUIhTBw8GqZCuBzd/uKWr1/MLtW
	 kllOylX+ufkP8ASh4xRjwVT2j7/2ny/DyFhYL/Pn039KT3h/8t4QnB9w0JgztIFsRF
	 t26tVJMvM2d+20GG9NtJuhvk2p+9YEZCLZT9L8IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khem Raj <raj.khem@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 098/290] mips: Add -std= flag specified in KBUILD_CFLAGS to vdso CFLAGS
Date: Mon, 23 Jun 2025 15:05:59 +0200
Message-ID: <20250623130629.916074755@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Khem Raj <raj.khem@gmail.com>

commit 0f4ae7c6ecb89bfda026d210dcf8216fb67d2333 upstream.

GCC 15 changed the default C standard dialect from gnu17 to gnu23,
which should not have impacted the kernel because it explicitly requests
the gnu11 standard in the main Makefile. However, mips/vdso code uses
its own CFLAGS without a '-std=' value, which break with this dialect
change because of the kernel's own definitions of bool, false, and true
conflicting with the C23 reserved keywords.

  include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
     11 |         false   = 0,
        |         ^~~~~
  include/linux/stddef.h:11:9: note: 'false' is a keyword with '-std=c23' onwards
  include/linux/types.h:35:33: error: 'bool' cannot be defined via 'typedef'
     35 | typedef _Bool                   bool;
        |                                 ^~~~
  include/linux/types.h:35:33: note: 'bool' is a keyword with '-std=c23' onwards

Add -std as specified in KBUILD_CFLAGS to the decompressor and purgatory
CFLAGS to eliminate these errors and make the C standard version of these
areas match the rest of the kernel.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/vdso/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -30,6 +30,7 @@ endif
 # offsets.
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
+	$(filter -std=%,$(KBUILD_CFLAGS)) \
 	-O3 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \
 	-mrelax-pic-calls $(call cc-option, -mexplicit-relocs) \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \


