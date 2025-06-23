Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C633B1E5B71;
	Mon, 23 Jun 2025 21:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714191; cv=none; b=jXExAOKQnZ2Q9NMGISgZtJSoBd/AMbPtt0IBBr4IGuXuTkT2d6g9mQYQVvYqnJz7YB2EGWDivJJ4B/zD9j9FfU7JwRqmgKu+ni/QjMNQo9pNaPl6Lx8OGRPp8qXMOTxKgGIIfh1OESVGUC2KiKK3KFZmIABvKNR4h2XNjnYzEzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714191; c=relaxed/simple;
	bh=Ly/oH3BoDVWmBR3znof1FS6Q+792LOdzErVvCxMZutE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYcndt+WC9eVfBbiAAGrBRRHb9qnCwxLmLwh/wxBzALahw2KOaB5+98hrFPxL4EOa2j6AbasQBWVZ3gqcDSQHIJBp8SwRB1HuYnDIsEs1suDSea4Mp2w2mZz1oUpH2oKcGxfHzPfd3B2A/jHwdVAqrgi4HBkt9T8J50TZQoeSTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu+SBoWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu+SBoWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CA0C4CEEA;
	Mon, 23 Jun 2025 21:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714191;
	bh=Ly/oH3BoDVWmBR3znof1FS6Q+792LOdzErVvCxMZutE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu+SBoWd2Xn9RiC11ni4BDnIYX3FVsneXKYmLlhQfr1ANrzXwYEZtNC2TbAL6+Z2O
	 bQmnme9pFE60VDkQYnHFiHIpTdDY4md5i7m1qphvfiE5RTjdXyn6Ko/k/rGz4okOHg
	 ktUYPRns7IxEtQ2gXv3b7yvqfshJSCekRq3ZBRq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 173/411] mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation
Date: Mon, 23 Jun 2025 15:05:17 +0200
Message-ID: <20250623130638.046097364@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 08f6554ff90ef189e6b8f0303e57005bddfdd6a7 upstream.

A future change will move CLANG_FLAGS from KBUILD_{A,C}FLAGS to
KBUILD_CPPFLAGS so that '--target' is available while preprocessing.
When that occurs, the following error appears when building ARCH=mips
with clang (tip of tree error shown):

  clang: error: unsupported option '-mabi=' for target 'x86_64-pc-linux-gnu'

Add KBUILD_CPPFLAGS in the CHECKFLAGS invocation to keep everything
working after the move.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -322,7 +322,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 KBUILD_LDFLAGS		+= -m $(ld-emul)
 
 ifdef need-compiler
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif


