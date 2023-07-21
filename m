Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309C81F94D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8218C433C7;
	Fri, 21 Jul 2023 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956604;
	bh=SLVMyE0WW45pIT1xpGg8NavF7sD3ELJS4bM28l8AHhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/S55MDHv046ncpsa8sdniIwC4oEgxKxjgAq3EjR8I3BxXm+52RKCTNaPsmFLW+Oz
	 4UbQiG8wzi6TkH762YHLIbuxJD+tAwJwldBy6J5LxlfCrswqB18GNzJ/1tuUswUHf8
	 X+ZYUuK9+/wFBI3ivIQLIuX7Gq8SRFsNQ/iyAswA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	CKI <cki-project@redhat.com>,
	Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.4 235/292] s390/decompressor: fix misaligned symbol build error
Date: Fri, 21 Jul 2023 18:05:44 +0200
Message-ID: <20230721160538.955548554@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

commit 938f0c35d7d93a822ab9c9728e3205e8e57409d0 upstream.

Nathan Chancellor reported a kernel build error on Fedora 39:

$ clang --version | head -1
clang version 16.0.5 (Fedora 16.0.5-1.fc39)

$ s390x-linux-gnu-ld --version | head -1
GNU ld version 2.40-1.fc39

$ make -skj"$(nproc)" ARCH=s390 CC=clang CROSS_COMPILE=s390x-linux-gnu- olddefconfig all
s390x-linux-gnu-ld: arch/s390/boot/startup.o(.text+0x5b4): misaligned symbol `_decompressor_end' (0x35b0f) for relocation R_390_PC32DBL
make[3]: *** [.../arch/s390/boot/Makefile:78: arch/s390/boot/vmlinux] Error 1

It turned out that the problem with misaligned symbols on s390 was fixed
with commit 80ddf5ce1c92 ("s390: always build relocatable kernel") for the
kernel image, but did not take into account that the decompressor uses its
own set of CFLAGS, which come without -fPIE.

Add the -fPIE flag also to the decompresser CFLAGS to fix this.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: CKI <cki-project@redhat.com>
Suggested-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1747
Link: https://lore.kernel.org/32935.123062114500601371@us-mta-9.us.mimecast.lan/
Link: https://lore.kernel.org/r/20230622125508.1068457-1-hca@linux.ibm.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -27,6 +27,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -fno-delet
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS_DECOMPRESSOR += -ffreestanding
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-stack-protector
+KBUILD_CFLAGS_DECOMPRESSOR += -fPIE
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))


