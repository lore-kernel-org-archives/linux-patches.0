Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F96B2AD04;
	Mon, 23 Jun 2025 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714233; cv=none; b=uP41xowB9A+D5SGYmIpt32JGeDDeqPV5Ki68EBn5+pFKsx/sEui8MawXKzQEwtONephx1Acgn6iZHs3ItY+QSYXDkM9zorhGpJbvKnJi6IAbzQBcK8985YMb8VNnvz4Fr9g6DcCIy3oGz/TzlBEYLLy0SE5RocVDxYXazfJ3Pa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714233; c=relaxed/simple;
	bh=an7SThgsD+07Zlafn2EEy7coE44PUHn54vLFLWcIszE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heEE6Iwx4403FQ80j7Kpl1b2fHbzkhbf2pJhI55kQQ6LGRNcI7OwoODG9iZP0wGN5MG6mNoARmBjR1rzgj5kizZhOtLpcM3X9qZ55XbpNsZxN8BNSghq9ZqYyiPkAfx1C5zsu4Dl3MHaM4ZEaVTOPySLAHSp2/wPb+UhpTZwHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfchNGCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfchNGCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65A2C4CEEA;
	Mon, 23 Jun 2025 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714233;
	bh=an7SThgsD+07Zlafn2EEy7coE44PUHn54vLFLWcIszE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfchNGCGWPLEjFiBNMLhCTRdpz3BizFAjjnS0w6B1mJ4C0ILNUc2M6UrMRjAe4Uuw
	 FyTPztAZLoLJeywZACvrJxsMox8iHofj5whXwqwh+D4VDWlw7NOXdCMtKSpNqkBW29
	 Pp/TTA1yWEsHyINOEups158bUwC6YYEjqSQnWQ5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rini <trini@konsulko.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 175/411] kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS
Date: Mon, 23 Jun 2025 15:05:19 +0200
Message-ID: <20250623130638.095624728@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -35,6 +35,5 @@ endif
 # so they can be implemented or wrapped in cc-option.
 CLANG_FLAGS	+= -Werror=unknown-warning-option
 CLANG_FLAGS	+= -Werror=ignored-optimization-argument
-KBUILD_CFLAGS	+= $(CLANG_FLAGS)
-KBUILD_AFLAGS	+= $(CLANG_FLAGS)
+KBUILD_CPPFLAGS	+= $(CLANG_FLAGS)
 export CLANG_FLAGS


