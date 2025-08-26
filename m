Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ABD350851;
	Tue, 26 Aug 2025 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219373; cv=none; b=mBXJ8S0glrbUB+WjvkTCL2pyg6PrN+MwTZhsFrNhP76P6V3XJfEOnbO9E/Gl+EX+8r7lAbVi3HF8lIgqFd7RDWmlHfguZtgWMOtsf1/G+1BYOtmxGcz1aqlU6NXcBenigknz85u9He93lzExDuXzAK/pIP0+VF7bN0RFtqaiNec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219373; c=relaxed/simple;
	bh=42XGv2aV8VCJXfqV1+8NNh/vlckzTtUQB1/nYm0l10g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpY+FIFVgwTpcUKnDpkmrJ+MmJgKpnZSSKYiRd4CYEiwHwCnwa/mOenyHo+1wANLYJEOMxW6liULFffgx7G7C92TlSgeG0B1sCAhNpC9UInNVyshfyY/RuEmy8RoNtVSTo3/dx8jrUVXnPb25yKb8fUEJYRgkESChUuS5+qjDIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZRPh7J0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZRPh7J0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A378C4CEF1;
	Tue, 26 Aug 2025 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219372;
	bh=42XGv2aV8VCJXfqV1+8NNh/vlckzTtUQB1/nYm0l10g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZRPh7J0rHnDzJEh65bot6QbvkcdhVKo3sNYNFbn7kYXn5q6N5YT90VABb85Eh1hJ
	 kM6ena1kLvVfDW5Zxx3LCfBdKl2ru6Eww3Ulr9CY6l8lTw7gYIF/hL4+ZtKCkIrSy3
	 +M7sWa5giW+xfBhQ5WBDCw7I/M4AyHdHwr2gAFiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 325/403] mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation
Date: Tue, 26 Aug 2025 13:10:51 +0200
Message-ID: <20250826110915.799246830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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


