Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61BB2BE7B2;
	Tue, 26 Aug 2025 11:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207346; cv=none; b=WNL/zIWu4WztvKnksDE4C8tZEc8shi1KqCZoroZlObVljbN+6NAYo5MFUgRvM6sirjVWWQV1qBNbZCUcw7XUG6tbE0FFO/YLi9oOcSIgk2VtiTVtA1EdLsO2CaGihioakzUpLdtlaSHDmj2A+YKfjKQzf8/yO8hbLAvy3cmdwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207346; c=relaxed/simple;
	bh=VK7DXIujM8EeHtVq3nd+kd9AHXwH5UMkpx1nMnIC3uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oh9sttkHzaGuMHV7dPZjcEvweoiGUrlIDCSqJ9QJ+Y3AgvUhCjMocIvLftIW7AHtzdjbo3ioBuyFK5L4ZoeHilIt0NtfjgkxcljleA2IzISBTs8pCraZ0d4TJw62oxCPscLA0KnZcr98CxbLEg98M87xO7uAzO3MR+UAgMHptCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mS7RLI3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mS7RLI3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C97C4CEF1;
	Tue, 26 Aug 2025 11:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207346;
	bh=VK7DXIujM8EeHtVq3nd+kd9AHXwH5UMkpx1nMnIC3uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mS7RLI3OkI3np/ItjIHHGOrFZ5dK3zSHMz5Cbc5BRiFS9PGS2c+vh052wP+nUGgbr
	 JMMBqcpmzHlciTrB++hyPo+mghIztKBMqcVlILdmrEx/A6BH+ZZ5bfZ2KkPxE8o31e
	 tbivkClffU+Qz1REI99+pvODFe1YAcDKWV8soBUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.16 116/457] kbuild: userprogs: use correct linker when mixing clang and GNU ld
Date: Tue, 26 Aug 2025 13:06:40 +0200
Message-ID: <20250826110940.240504334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1134,7 +1134,7 @@ KBUILD_USERCFLAGS  += $(filter -m32 -m64
 KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
-ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+ifdef CONFIG_CC_IS_CLANG
 KBUILD_USERLDFLAGS += --ld-path=$(LD)
 endif
 


