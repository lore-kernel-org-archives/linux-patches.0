Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76263350D46;
	Tue, 26 Aug 2025 14:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216807; cv=none; b=MgBddP8STbFdaUpLD2CXi6fCkgR7ISpu+9xL9m6E9iFWN4TW8hjZs2+G1IGcY+yHn4fmWQHaR8C4a9t7ELJnMfW1hVrcYHnfUXSKeSAoqceGh9Orb2Pnw36PzSCPEzQOBt8QTkjTrKpPnVAOAHksNkFFpZyenZZfwtAdKqsmQMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216807; c=relaxed/simple;
	bh=7/N0Zb4uk7g3/zEv48hsMHMY2TxUQX/8JgtAXz123wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyQ7iRJnb02bDDf7F/bu7a/vq8/mSrkD6N2UFbjbBL5WiSnGAzlrkwt3QWpshvYergthw/VXg3SvBMvNK8YZCY2sMWG+fk+Z4JxAZFfAGkMlHhZ5DUefzYJCk9UvsUo96QlbJyKAw/v+ieALBgIfpIJCmHxbGGkk2YegjH6ty9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLNdWCtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLNdWCtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A376EC113D0;
	Tue, 26 Aug 2025 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216807;
	bh=7/N0Zb4uk7g3/zEv48hsMHMY2TxUQX/8JgtAXz123wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLNdWCtED5HNhBgh4Mrf21IL41NnoUY29/YvS+e8+Pxjynv54jvlHJgXu6UYFpbFy
	 6FHKdgoDdwoiRBGvFcsLUPA5/XYbrIrZxxb7B2iYvb/W761rbtMEAS/fM+k+3DPe5B
	 CVuyE5+d6WGKjEo0HX7AEvzZXiTcYFgATydX0A1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 551/644] kbuild: userprogs: use correct linker when mixing clang and GNU ld
Date: Tue, 26 Aug 2025 13:10:42 +0200
Message-ID: <20250826111000.181427460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1130,7 +1130,7 @@ KBUILD_USERCFLAGS  += $(filter -m32 -m64
 KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
-ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+ifdef CONFIG_CC_IS_CLANG
 KBUILD_USERLDFLAGS += $(call cc-option, --ld-path=$(LD))
 endif
 


