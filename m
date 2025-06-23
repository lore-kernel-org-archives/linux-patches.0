Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266070838;
	Mon, 23 Jun 2025 21:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713042; cv=none; b=pAZuLyUWaBPjhi4c0PY3S+sGQYqnRxqeFXnQNKR2X43wulpiZsvCSaSLDx4NA5SSVBQKpLujl1/9zd/DK21QF1YuXEp13T7ey7JIlD6T7vcWCT1W6tZdsByzOjwzkq4tLCQFWMcW6Pvhdcp33vgml/tY8bseVfDVO1hE0OLNE0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713042; c=relaxed/simple;
	bh=2iKerRQWW30x0EAvpuTYI+zmwyXGI3eOOpDYcK3XFRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6IujoiGpvBNlsje4FyexgBZiCnbieAqssq7mHDhSAGwV2Wx0yAkjOOATqpn+8uYcYJovw2pOy/oHVNKxREUEWMwmV+TUUzK3skOKLcfPFhGvsAOTL/71Oo2PQRdvXAOrqGOk9OfDOTtnwntUkp2GlSbqcYQlk+jSnRD+aIC/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d38SFk51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d38SFk51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC57C4CEEA;
	Mon, 23 Jun 2025 21:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713041;
	bh=2iKerRQWW30x0EAvpuTYI+zmwyXGI3eOOpDYcK3XFRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d38SFk51+F4i/811ysPLdZnxz2/xz/XssG4moLr27K2oLVxKs+9Yvr/S6QSptbgoe
	 2mWb9pmMBfie0v5IaolZjGc7dXdgd8ihhfnozpiN4cTFmZSffSDfPjV8f6Tiy0N0Zx
	 nZw0CBWHS/odEXP8h4cDEf2zVqVtNcZ5XMcx3+nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 142/355] MIPS: Move -Wa,-msoft-float check from as-option to cc-option
Date: Mon, 23 Jun 2025 15:05:43 +0200
Message-ID: <20250623130630.985165219@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-6.1.y and earlier, it has no direct mainline
equivalent.

In order to backport commit d5c8d6e0fa61 ("kbuild: Update assembler
calls to use proper flags and language target") to resolve a separate
issue regarding PowerPC, the problem noticed and fixed by
commit 80a20d2f8288 ("MIPS: Always use -Wa,-msoft-float and eliminate
GAS_HAS_SET_HARDFLOAT") needs to be addressed. Unfortunately, 6.1 and
earlier do not contain commit e4412739472b ("Documentation: raise
minimum supported version of binutils to 2.25"), so it cannot be assumed
that all supported versions of GNU as have support for -msoft-float.

In order to switch from KBUILD_CFLAGS to KBUILD_AFLAGS in as-option
without consequence, move the '-Wa,-msoft-float' check to cc-option,
including '$(cflags-y)' directly to avoid the issue mentioned in
commit 80a20d2f8288 ("MIPS: Always use -Wa,-msoft-float and eliminate
GAS_HAS_SET_HARDFLOAT").

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -110,7 +110,7 @@ endif
 # (specifically newer than 2.24.51.20140728) we then also need to explicitly
 # set ".set hardfloat" in all files which manipulate floating point registers.
 #
-ifneq ($(call as-option,-Wa$(comma)-msoft-float,),)
+ifneq ($(call cc-option,$(cflags-y) -Wa$(comma)-msoft-float,),)
 	cflags-y		+= -DGAS_HAS_SET_HARDFLOAT -Wa,-msoft-float
 endif
 


