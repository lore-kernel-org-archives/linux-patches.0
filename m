Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35275381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2F2C433C8;
	Mon, 19 Jun 2023 10:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171347;
	bh=3bbKk0b9iXrqcYuyr0gUz9s8leb+8kXGN5FLPowqGZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juwBkJC/fjBRrUfJzXc4wBbPtFmE8xLPIfcU7XAqZhXcgCr1ehQewp39YXv/bf0KQ
	 v7pBbkv7jjM52yz3eSuDFK7cqK0/1KcTOt8tg9+dZO0e5M0h7o9n87PDpgZw6fGRSf
	 R7tcjJ6f99l28cXDCoJqo5MyfXfRpUMV4mYHG2kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Alyssa Ross <hi@alyssa.is>
Subject: [PATCH 4.19 48/49] powerpc: Fix defconfig choice logic when cross compiling
Date: Mon, 19 Jun 2023 12:30:26 +0200
Message-ID: <20230619102132.426400631@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

commit af5cd05de5dd38cf25d14ea4d30ae9b791d2420b upstream.

Our logic for choosing defconfig doesn't work well in some situations.

For example if you're on a ppc64le machine but you specify a non-empty
CROSS_COMPILE, in order to use a non-default toolchain, then defconfig
will give you ppc64_defconfig (big endian):

  $ make CROSS_COMPILE=~/toolchains/gcc-8/bin/powerpc-linux- defconfig
  *** Default configuration is based on 'ppc64_defconfig'

This is because we assume that CROSS_COMPILE being set means we
can't be on a ppc machine and rather than checking we just default to
ppc64_defconfig.

We should just ignore CROSS_COMPILE, instead check the machine with
uname and if it's one of ppc, ppc64 or ppc64le then use that
defconfig. If it's none of those then we fall back to ppc64_defconfig.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Makefile |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -30,11 +30,10 @@ endif
 endif
 endif
 
-ifeq ($(CROSS_COMPILE),)
-KBUILD_DEFCONFIG := $(shell uname -m)_defconfig
-else
-KBUILD_DEFCONFIG := ppc64_defconfig
-endif
+# If we're on a ppc/ppc64/ppc64le machine use that defconfig, otherwise just use
+# ppc64_defconfig because we have nothing better to go on.
+uname := $(shell uname -m)
+KBUILD_DEFCONFIG := $(if $(filter ppc%,$(uname)),$(uname),ppc64)_defconfig
 
 ifdef CONFIG_PPC64
 new_nm := $(shell if $(NM) --help 2>&1 | grep -- '--synthetic' > /dev/null; then echo y; else echo n; fi)


