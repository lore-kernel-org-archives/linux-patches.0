Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A10129A73;
	Tue, 23 Jan 2024 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971006; cv=none; b=j1bKmfEc0aIiIKbyjGTOAlwrB0JF18HtVflUHyfpHCpy5fhgNhuJH0JvXFjn3iWt2KcC0gcA/LxY1kz5GltTBTZCvnFnvX70YegmgtH4EpFQ2Zv0Ox6+x/G6bazh6mKory93hxqZ44zBeS74opB50el266gN6EV/qCqT1ykeH2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971006; c=relaxed/simple;
	bh=JplukBa+PsSMnq9Xa6ba5EsGTzc9CnB+dZ1torIFjEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r28ZpszCs+PlSEVMueygEYtnGRQPmbBuBOXd9FsFG4V2Do2KSnNIBXmPQEoQP6qYRRhHinVgopP+wl6y6mQ7Vx3LDDjaU2rUlrtZUgORr8TYOJ8X2KoeU984et1OqHwS6s9uSJdMw8nDC8WnJm5hvjMrQaa47TFSXmObi/PNROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ox/BE0iU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ox/BE0iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B687DC43390;
	Tue, 23 Jan 2024 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971005;
	bh=JplukBa+PsSMnq9Xa6ba5EsGTzc9CnB+dZ1torIFjEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ox/BE0iUTtqOftxvZIp+MHdRhHBwVPpjvPkD68mLMWE++s/hNBMOyiAgT4FrmMJ47
	 30DOMaAseSKJ3JbisNfLg3x9RUutpHzaAITXRRo5qKzjqeELmpGqhyXg+wrnvbrEM6
	 2rEiUWl2MEB1SsJD9SOuFQa8V/8DH3uep7y9WxCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/286] powerpc: add crtsavres.o to always-y instead of extra-y
Date: Mon, 22 Jan 2024 15:55:57 -0800
Message-ID: <20240122235733.998653498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1b1e38002648819c04773647d5242990e2824264 ]

crtsavres.o is linked to modules. However, as explained in commit
d0e628cd817f ("kbuild: doc: clarify the difference between extra-y
and always-y"), 'make modules' does not build extra-y.

For example, the following command fails:

  $ make ARCH=powerpc LLVM=1 KBUILD_MODPOST_WARN=1 mrproper ps3_defconfig modules
    [snip]
    LD [M]  arch/powerpc/platforms/cell/spufs/spufs.ko
  ld.lld: error: cannot open arch/powerpc/lib/crtsavres.o: No such file or directory
  make[3]: *** [scripts/Makefile.modfinal:56: arch/powerpc/platforms/cell/spufs/spufs.ko] Error 1
  make[2]: *** [Makefile:1844: modules] Error 2
  make[1]: *** [/home/masahiro/workspace/linux-kbuild/Makefile:350: __build_one_by_one] Error 2
  make: *** [Makefile:234: __sub-make] Error 2

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Fixes: baa25b571a16 ("powerpc/64: Do not link crtsavres.o in vmlinux")
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231120232332.4100288-1-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 0697a0e014ae..321cab5c3ea0 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
 ifeq ($(call ld-ifversion, -lt, 225000000, y),y)
-extra-$(CONFIG_PPC64)	+= crtsavres.o
+always-$(CONFIG_PPC64)	+= crtsavres.o
 endif
 
 obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \
-- 
2.43.0



