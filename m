Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB8A1D86DC;
	Mon, 23 Jun 2025 22:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716007; cv=none; b=MPFsA7O59LxC4n2OFDot2p25xWdwE05mk+K/AhiqZU9iWrEa5lzSA4R0Cg4mW3P2Leq4haou7PdBydzHNfq2YTwzS6N0druIqY1JuTvkK/Sih6G3Favfp2efUV4rnjwpNdTMdh8ELQ9xY2aI2zuWsL6GpntvZzr/Wp9htyl+v1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716007; c=relaxed/simple;
	bh=0EMVsIMbvzbaBG+twu5th4sRVusv1KBg9E9Hx+zLwZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+PC8H4Tu8acXKem3KTqqJEeqww49KIb62IJBZ2sOLhQDF2+OLWOt79zgIVK4TbLIzKxehBXRogvXo1VGfrZHZObcChHMi9V6UKYyWtX+mr3USVdby66FYlv+jGkkqgYmW6UtVbedSK+Xgv7IOl0yQms/SAkbRZEapPZHOwgswA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVqjdhPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVqjdhPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E354BC4CEF1;
	Mon, 23 Jun 2025 22:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716007;
	bh=0EMVsIMbvzbaBG+twu5th4sRVusv1KBg9E9Hx+zLwZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVqjdhPBMmth3Av6Wts/Ms8h1y26HpnRVmRt2nOm4lNLlk961jtg2HbC0wrN+KRTw
	 Eh8N9MBzdNdiJNMiYzKxMJBQI9piec1cDXzJGsIfbjm10gbiTFS6W1X6vfTcy8lIbP
	 JZw2FGP8Nb1VIU06KqEj6hNrATIn9rCpGP1/vZhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rini <trini@konsulko.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 274/508] kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS
Date: Mon, 23 Jun 2025 15:05:19 +0200
Message-ID: <20250623130651.989915796@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

commit feb843a469fb0ab00d2d23cfb9bcc379791011bb upstream.

When preprocessing arch/*/kernel/vmlinux.lds.S, the target triple is
not passed to $(CPP) because we add it only to KBUILD_{C,A}FLAGS.

As a result, the linker script is preprocessed with predefined macros
for the build host instead of the target.

Assuming you use an x86 build machine, compare the following:

 $ clang -dM -E -x c /dev/null
 $ clang -dM -E -x c /dev/null -target aarch64-linux-gnu

There is no actual problem presumably because our linker scripts do not
rely on such predefined macros, but it is better to define correct ones.

Move $(CLANG_FLAGS) to KBUILD_CPPFLAGS, so that all *.c, *.S, *.lds.S
will be processed with the proper target triple.

[Note]
After the patch submission, we got an actual problem that needs this
commit. (CBL issue 1859)

Link: https://github.com/ClangBuiltLinux/linux/issues/1859
Reported-by: Tom Rini <trini@konsulko.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.clang |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/Makefile.clang
+++ b/scripts/Makefile.clang
@@ -36,6 +36,5 @@ endif
 # so they can be implemented or wrapped in cc-option.
 CLANG_FLAGS	+= -Werror=unknown-warning-option
 CLANG_FLAGS	+= -Werror=ignored-optimization-argument
-KBUILD_CFLAGS	+= $(CLANG_FLAGS)
-KBUILD_AFLAGS	+= $(CLANG_FLAGS)
+KBUILD_CPPFLAGS	+= $(CLANG_FLAGS)
 export CLANG_FLAGS


