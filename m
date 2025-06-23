Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947BE1F4628;
	Mon, 23 Jun 2025 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715878; cv=none; b=gAo5PZQ6mD7gMo5u3DNBKieHy2EN2nHirEr12d//T9NGWf/R1Ej+1wklQHjUX1L1PMM+eCoSdLiEl9fUvs1RGea4W9PO9bVYkf3J18vyVGYJS9TnLRRUJr7ZDWin5HNrPGRoKVDdcpViqhjQSXR9Ujf1OjuSO+rg9lYtbIUJ78c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715878; c=relaxed/simple;
	bh=jhUiJNXaFCeLz/Zhe/RZlots3Zu2tL/SwzF9XhHxnfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oxe0R/6pBj8TQ7yUwfLqLNlSdpPDg2Pl64YqTdt5UlmqVxSVgROyUHnevi33II7rEPziGApF24w/zKg4ARXZ54ugGA/VTLKj8MoQVGWojv8e2zw7J1BELJyj7dor2aDATIqweuTExdWC2LU/RcEDIjs/HR6b2BFiAL2/ooADR/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+MdLmeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+MdLmeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F1DC4CEEA;
	Mon, 23 Jun 2025 21:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715878;
	bh=jhUiJNXaFCeLz/Zhe/RZlots3Zu2tL/SwzF9XhHxnfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+MdLmehG905WEDNqRBog1TFk8Ad66MeJWL+zZmQDp8OZsrU93JnYyXT2boTFwOsw
	 KQd3Zo4FG5GI4gXeLWF+YRb/Le/IVIqu4Miux5Cr0kfZ4ZuiDAnzzkpkhns4ltxMkW
	 CFDBzGvi2ZpvYRSGPvafbBV/lquc1wWM4q1OK6/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 287/508] kbuild: userprogs: fix bitsize and target detection on clang
Date: Mon, 23 Jun 2025 15:05:32 +0200
Message-ID: <20250623130652.333050563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 1b71c2fb04e7a713abc6edde4a412416ff3158f2 upstream.

scripts/Makefile.clang was changed in the linked commit to move --target from
KBUILD_CFLAGS to KBUILD_CPPFLAGS, as that generally has a broader scope.
However that variable is not inspected by the userprogs logic,
breaking cross compilation on clang.

Use both variables to detect bitsize and target arguments for userprogs.

Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1139,8 +1139,8 @@ LDFLAGS_vmlinux += --orphan-handling=war
 endif
 
 # Align the bit size of userspace programs with the kernel
-KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
-KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
+KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
 ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)


