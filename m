Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DCA6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF41C433C8;
	Sun, 17 Sep 2023 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980666;
	bh=qCq6k/gQNnloDQHJnIcmU4nphPxyqxkn4XUygxtuXxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdk0J6mLxu2fLzj2b5T/AcYB84kH+AgDN7LZlfmYsFfm5yHH8HjfxdP5TJy/O5IIu
	 AT5Lg54FeCljfp12ZPKVhwWpf0hkJNGgmwRxTyhz19YcfBT4And2XCohsyI13iLe5B
	 ninz7f2n8ufipJ2TEXkH8tO4uKhDBIG6vlSJkYRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan-Benedict Glaw <jbglaw@lug-owl.de>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.5 231/285] MIPS: Fix CONFIG_CPU_DADDI_WORKAROUNDS `modules_install regression
Date: Sun, 17 Sep 2023 21:13:51 +0200
Message-ID: <20230917191059.432804909@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit a79a404e6c2241ebc528b9ebf4c0832457b498c3 upstream.

Remove a build-time check for the presence of the GCC `-msym32' option.
This option has been there since GCC 4.1.0, which is below the minimum
required as at commit 805b2e1d427a ("kbuild: include Makefile.compiler
only when compiler is needed"), when an error message:

arch/mips/Makefile:306: *** CONFIG_CPU_DADDI_WORKAROUNDS unsupported without -msym32.  Stop.

started to trigger for the `modules_install' target with configurations
such as `decstation_64_defconfig' that set CONFIG_CPU_DADDI_WORKAROUNDS,
because said commit has made `cc-option-yn' an undefined function for
non-build targets.

Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 805b2e1d427a ("kbuild: include Makefile.compiler only when compiler is needed")
Cc: stable@vger.kernel.org # v5.13+
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -299,8 +299,8 @@ ifdef CONFIG_64BIT
     endif
   endif
 
-  ifeq ($(KBUILD_SYM32)$(call cc-option-yn,-msym32), yy)
-    cflags-y += -msym32 -DKBUILD_64BIT_SYM32
+  ifeq ($(KBUILD_SYM32), y)
+    cflags-$(KBUILD_SYM32) += -msym32 -DKBUILD_64BIT_SYM32
   else
     ifeq ($(CONFIG_CPU_DADDI_WORKAROUNDS), y)
       $(error CONFIG_CPU_DADDI_WORKAROUNDS unsupported without -msym32)


