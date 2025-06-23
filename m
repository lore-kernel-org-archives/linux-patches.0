Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC37F2367B0;
	Mon, 23 Jun 2025 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685100; cv=none; b=MNfV4b23Kem0DBuiAHhRgTNGoc9cEHDSD9tGqbPKGXCKnMTBt8iJe1LzXPrYONyiXIUtdgAs9Vgxxwr3jwGysVJcQpeRQzYkhweDNMGdO+aowtlPMeRDIOY5p2LMbC50XQqz2sU9YuaoVb7996Cfp6LVySRLer3kuScqkJLzblA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685100; c=relaxed/simple;
	bh=4yA9JNC+fUicaPcbh1feMTMCLXzAYJSzldel2PsxSyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drf1H8Xx+LWWBJeeO0rQ+A1RDk3oh2VAUUP+WLtykS0OehrBGjjtRBJWHQLfW4KD9j4pE2pldLn6aeqwOZnKcaOE9MpqjvTsLKFXpkN9CEjelWwS16QvO6nc+sN1zuc0nkUNH2pkW6V8lzmAkRekPhFFXA+LjZxJmDn3XVF9S1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JQ/FeRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JQ/FeRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA29C4CEEA;
	Mon, 23 Jun 2025 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685100;
	bh=4yA9JNC+fUicaPcbh1feMTMCLXzAYJSzldel2PsxSyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JQ/FeRZE3b0G2mlAng9kXtwcx7XnXZTGGJqQ0sIJ3VgoTUjYYhwka/uP50jz5upA
	 dcFbMyz+UXoogyNQDYnv1uSteN2rTXFOpFCSqodBOEMn2LrAt00aCBNuI9e46R926P
	 4sw5/hN4vZfftLCAy+5fgl0+08ZpMF1+He8GuDZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rini <trini@konsulko.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 093/222] kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS
Date: Mon, 23 Jun 2025 15:07:08 +0200
Message-ID: <20250623130614.898254935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -568,8 +568,7 @@ ifneq ($(LLVM_IAS),1)
 CLANG_FLAGS	+= -no-integrated-as
 endif
 CLANG_FLAGS	+= -Werror=unknown-warning-option
-KBUILD_CFLAGS	+= $(CLANG_FLAGS)
-KBUILD_AFLAGS	+= $(CLANG_FLAGS)
+KBUILD_CPPFLAGS	+= $(CLANG_FLAGS)
 export CLANG_FLAGS
 endif
 


