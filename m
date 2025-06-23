Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCBE1EE7C6;
	Mon, 23 Jun 2025 21:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714784; cv=none; b=WP5ArU85/mBzflRVYzvRVvvDZy9whptI1RtLgH6pUmv++BHHio2M9eUyGHllDOYIKS10eFRqlpDF5nzmOQrAWWSibzpyPtyIeECZQdp1T2TWdjT6NqcdX4Kg41fEpebK+pL6MifU94E1uSV6bww/uHjnvf2B3cZcftEvx78Lo2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714784; c=relaxed/simple;
	bh=7UwPdoB1KqsK03/r9ouVIoJVkRZfcbduaAsdGXBls/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdtGiS1dxHQ+D50YEueskxGCS9rwi7m1py4TCRfh2du3xs1NRaVDgvI0FSvisAJUswMyLoNKxdms8N5M5Z5VR1GG5eRa+4/gln8kZm3Ybkn8NDbG7mrXrVGDXWZa9KXuWO1pnQwSusUXR+sUg4GXSMt+rXdgfffPCAheuvbh00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCRttMS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCRttMS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4486AC4CEEA;
	Mon, 23 Jun 2025 21:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714784;
	bh=7UwPdoB1KqsK03/r9ouVIoJVkRZfcbduaAsdGXBls/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCRttMS+e3Uqw4GHimwSI51gdJHaIN+xvuNBoLlIJIV3H1yfuu+OzNN0EzloXYmJY
	 awumrND3r4B/uCop4k3rCIhm385GSMvZ5iFIkE3V1B3iLzRABfT5gPTu5I1sHR37tj
	 OEQhiRP+tMxr5L2Zckjdu/egwdvNluuMhrfOcgzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khem Raj <raj.khem@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 137/414] mips: Add -std= flag specified in KBUILD_CFLAGS to vdso CFLAGS
Date: Mon, 23 Jun 2025 15:04:34 +0200
Message-ID: <20250623130645.479384050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -27,6 +27,7 @@ endif
 # offsets.
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
+	$(filter -std=%,$(KBUILD_CFLAGS)) \
 	-O3 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \
 	-mrelax-pic-calls $(call cc-option, -mexplicit-relocs) \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \


