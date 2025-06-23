Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F0B2367B0;
	Mon, 23 Jun 2025 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685072; cv=none; b=eI/Lr614EqUMqX8ZNkfs0Zf8c2zHsVRtvbBLY57hBqdtBS6Gc3yIbPan9+W1buQqCsLxuiSwRzarkdtYiQ1gxEUOF7/nJcYMj0h+S956ZktJlYr5Et2uBwwWs+/YT32ZnAdDbyN3/MTgJO9NsqGiBhzcVka8uum1cSAzYq/T3tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685072; c=relaxed/simple;
	bh=42XGv2aV8VCJXfqV1+8NNh/vlckzTtUQB1/nYm0l10g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbY/yAZp9WTrB76ZUert5p/XNhG7x21eU6oLUrMOaxy4JQWNRil4aAK9l4pvkYaSIooduF7hFix3mG3vweLyfcPO3LRECMujHgjMn7H3qQ2JL4jWCzY0Z+8g1zpXJEJufaOrw3VcoIr6F20nWAPtBk8azMI02J4iHFs/TgHf82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiUIYake; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiUIYake"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A8FC4CEEA;
	Mon, 23 Jun 2025 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685072;
	bh=42XGv2aV8VCJXfqV1+8NNh/vlckzTtUQB1/nYm0l10g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiUIYaket50qsKjcDgzFvac2RDkoQ8DgwcaaZ5MwFKrBKNsUBscMs2XxGhHNHgHC4
	 j8F4QOn8JREfCpalr2ti+b/ITJ6VxmiH2xxyrTIi/XkUug9ToxAWl9kVqs848kkHXX
	 g2d/spfIiCKhsSGV4xpmMqx72TS5tF2ZE/jwBMWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 091/222] mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation
Date: Mon, 23 Jun 2025 15:07:06 +0200
Message-ID: <20250623130614.836926785@linuxfoundation.org>
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
@@ -319,7 +319,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 KBUILD_LDFLAGS		+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif


