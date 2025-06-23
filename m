Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1C7223714;
	Mon, 23 Jun 2025 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715975; cv=none; b=IJQ7wP/qO3C2kW5SXsq/5mkoqbTUVWJIVpomNIQj1hK1B3BcNgeD0z8FurBr3+z4gNlaW54djbWFO3qVv29IfZNCL2RCRlwuze35nh1iaKf3PS65qJ0BFbZRcpzhzBYkQPu1d+cyCMNdrMbpuTrdJgdwYhESEHYccp8NcBI0XAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715975; c=relaxed/simple;
	bh=MD/LjQ84VL3D1nPs9Wr37la3eDONWpxxLT2eChVn5bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTT3dToPiZdf9Z38qwT6vP2p1hYXeG62L+xrB5i0haJJG4NFvmxWZMG0+sgBugsQqeWnx/gpyU1zaAvkiyGR6NB3XWq3UrgumkKVr9ezlCSSz//nemare+CY8xT7UpxFKnyPPrc5/hOFXZSC/q+DsN4bi9LN2FpfyfOyvVlf1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSBqmVvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSBqmVvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D32C4CEEA;
	Mon, 23 Jun 2025 21:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715975;
	bh=MD/LjQ84VL3D1nPs9Wr37la3eDONWpxxLT2eChVn5bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSBqmVvQIXBSdMcPoYRWXPA9+uyUsw4slDZvMqOcbpMgVF2FhhjUAjniWTcLhV32y
	 8ZQsbeopB4pyLmri3vKYN1Gp80CxmM3Pg5ZEVQtQWg7GTPUiQoUbpePvxiki77qVj7
	 bOhyhRdZFijwHxJT69D6ZAHpzR3o3XRuKhiZRO5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 272/508] mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation
Date: Mon, 23 Jun 2025 15:05:17 +0200
Message-ID: <20250623130651.940039287@linuxfoundation.org>
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
@@ -351,7 +351,7 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 KBUILD_LDFLAGS		+= -m $(ld-emul)
 
 ifdef need-compiler
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif


