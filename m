Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EBF283FDF;
	Tue, 26 Aug 2025 11:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208374; cv=none; b=BMN+JIh+SXjDDy+Z7MS8BZ69Ssvy3evVYiGFWEJMPe5e6niR1osNTsSfPuk3NZhGSBmbV0z7qx/yaDgS50BEKBlTrJL5r2J2YJhWWjtaIza07/IM+gKkYEp5UUiATnY2a/7SsLLSU4oYXeiWFm79aSGJ9JGJ7JReZbU2cBryLkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208374; c=relaxed/simple;
	bh=torqszSfg/TKo70gm55gG0xrvIjxkwrK/rZcRTlZjVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdV96XDN+vlw/n3jmVJlsuPJPusJSlavtHjtD34mkjK7BerdUoI4zJTmRAak5L6mp8CiRXcFw0d3ZVd92J57i2HV76qx+r3c4yvmlBWVuliYvewH9s6cynQKv/Po4ftrfVpO87x90nsYc6LsSwqlqIwLYQaiwO5cxOpeC7eonzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXEc32bI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXEc32bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8AFC4CEF1;
	Tue, 26 Aug 2025 11:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208374;
	bh=torqszSfg/TKo70gm55gG0xrvIjxkwrK/rZcRTlZjVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXEc32bILVD/19ZSz0mes1Eah5f8hhT6ZuK7//vuCX0k99g37L1lCHwrUSz9P4Ss2
	 hSC8gYgutK1XTsZ0kc2jMrhAi44tChnbWcfTecnkHvb66zoBYWmFANOBukjZWi033V
	 ZYrbGbIrdmlQ/U/pfMo2YOcJrE5hr8lXvzX74JHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.12 087/322] kbuild: userprogs: use correct linker when mixing clang and GNU ld
Date: Tue, 26 Aug 2025 13:08:22 +0200
Message-ID: <20250826110917.801449430@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1069,7 +1069,7 @@ KBUILD_USERCFLAGS  += $(filter -m32 -m64
 KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
-ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+ifdef CONFIG_CC_IS_CLANG
 KBUILD_USERLDFLAGS += --ld-path=$(LD)
 endif
 


