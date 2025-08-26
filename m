Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6932356905;
	Tue, 26 Aug 2025 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218157; cv=none; b=nJUxUciyGepguMRA13TZnzzONIwGFZRg9uJpH0LaCIivjN4C5onah4pOfE3B56VgfsSF1BlYXzwcGcYW9pCoTwCY0vlmSHUSLzOnvKP4TUm/rcH4RxcAON2Jq+i0w/h89QSI47c8RdlHWnFwWt4g/epZNWcf5SxEe88S1wNvKPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218157; c=relaxed/simple;
	bh=y0i4aIB3yO66VAxSj3f8idntKc3F8RhqY0S0B0X7SAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYqG8efprV3P9OeMB/INaX9pcVdIxsIErkZDv38zBgkUAhd+vDsoILwOuToRbj/9NEqiXsuYt3Asjkqr+ywbe7xmCYw11KINJ+JAyegKlYGEoV28gVTUpa3q7g7mUVPzMbxV4g6X8n2guL4Gw8EUf7Cl0dnFzLXHEcEz2t7PxTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYgnK2il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYgnK2il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A3C113CF;
	Tue, 26 Aug 2025 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218156;
	bh=y0i4aIB3yO66VAxSj3f8idntKc3F8RhqY0S0B0X7SAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYgnK2ilRsqpPK5QoZWkPJ0nqiul0TI0GzfslpY6Aii5lLA3iy+WVbvpEJB0KABSS
	 dcx6Uq8bi7yghaM1SlNiI0d4K1uU/ESn24IOYXeckUMvjrfRmQbY8OqcPfJL0gsLlz
	 pJ4frznDRJWOy9pi2uvpilFP+8uJLF8FyTdf+JiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 415/523] kbuild: userprogs: use correct linker when mixing clang and GNU ld
Date: Tue, 26 Aug 2025 13:10:25 +0200
Message-ID: <20250826110934.691841597@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 936599ca514973d44a766b7376c6bbdc96b6a8cc upstream.

The userprogs infrastructure does not expect clang being used with GNU ld
and in that case uses /usr/bin/ld for linking, not the configured $(LD).
This fallback is problematic as it will break when cross-compiling.
Mixing clang and GNU ld is used for example when building for SPARC64,
as ld.lld is not sufficient; see Documentation/kbuild/llvm.rst.

Relax the check around --ld-path so it gets used for all linkers.

Fixes: dfc1b168a8c4 ("kbuild: userprogs: use correct lld when linking through clang")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nathan: Work around wrapping '--ld-path' in cc-option in older stable
         branches due to older minimum LLVM version]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1037,7 +1037,7 @@ KBUILD_USERCFLAGS  += $(filter -m32 -m64
 KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
-ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+ifdef CONFIG_CC_IS_CLANG
 KBUILD_USERLDFLAGS += $(call cc-option, --ld-path=$(LD))
 endif
 


