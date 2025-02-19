Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01B71CBA18;
	Wed, 19 Feb 2025 08:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954140; cv=none; b=I8k9pGO23HEePIz6l6wX28ehkmrQteQchf7HdApY8QJ58Yp5O7HXFw9BwlhYD0qRU5T2zNn2QVKT+N9I0G2Nh71lkczW0O9HvXzVOBftPqHPbl6Ma4KTlRP6Nwe+5KGorVSOhJK5q8Ihw1TasetG+o6L78JWBwq8hXwHS1hP5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954140; c=relaxed/simple;
	bh=AZZYlbxOoR2tjW0JK+31SjsEr1VjmCcqm/AHNINgIGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejL+2XWVNxKrAsxJIpUn7JKFv8at1dU82Jkk2U193ocJSLWciYm3st4dkTqsotvJ0g1CboJ66PUK0Lq4ah5O0JQOnDEjSmGm71DzYyJnv/8Oi2E1t66evqWMN8kQRgTHBQbOjkTRZR3fu8Ln7xszCWDhWR6ga7mDJJo+HsKN/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BK4cYw92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BK4cYw92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E73C4CED1;
	Wed, 19 Feb 2025 08:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954140;
	bh=AZZYlbxOoR2tjW0JK+31SjsEr1VjmCcqm/AHNINgIGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK4cYw92itOdz1KY+OB7qjNaYBZcCmJrYzjgSeMbwKBXurFmOTCtg0hr7m14kcyPZ
	 6FsobvCSv+FI8tSSe8k3nVslMSBTk2W/7yznKSp+KqIXpagah/Br4Fq73JKSbIeRMy
	 sF/e1THwGDIhcpLNC6bhFvS6TzMd/T3nSEPNjuPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 068/274] tools: fix annoying "mkdir -p ..." logs when building tools in parallel
Date: Wed, 19 Feb 2025 09:25:22 +0100
Message-ID: <20250219082612.283669400@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit d1d0963121769d8d16150b913fe886e48efefa51 ]

When CONFIG_OBJTOOL=y or CONFIG_DEBUG_INFO_BTF=y, parallel builds
show awkward "mkdir -p ..." logs.

  $ make -j16
    [ snip ]
  mkdir -p /home/masahiro/ref/linux/tools/objtool && make O=/home/masahiro/ref/linux subdir=tools/objtool --no-print-directory -C objtool
  mkdir -p /home/masahiro/ref/linux/tools/bpf/resolve_btfids && make O=/home/masahiro/ref/linux subdir=tools/bpf/resolve_btfids --no-print-directory -C bpf/resolve_btfids

Defining MAKEFLAGS=<value> on the command line wipes out command line
switches from the resultant MAKEFLAGS definition, even though the command
line switches are active. [1]

MAKEFLAGS puts all single-letter options into the first word, and that
word will be empty if no single-letter options were given. [2]
However, this breaks if MAKEFLAGS=<value> is given on the command line.

The tools/ and tools/% targets set MAKEFLAGS=<value> on the command
line, which breaks the following code in tools/scripts/Makefile.include:

    short-opts := $(firstword -$(MAKEFLAGS))

If MAKEFLAGS really needs modification, it should be done through the
environment variable, as follows:

    MAKEFLAGS=<value> $(MAKE) ...

That said, I question whether modifying MAKEFLAGS is necessary here.
The only flag we might want to exclude is --no-print-directory, as the
tools build system changes the working directory. However, people might
find the "Entering/Leaving directory" logs annoying.

I simply removed the offending MAKEFLAGS=<value>.

[1]: https://savannah.gnu.org/bugs/?62469
[2]: https://www.gnu.org/software/make/manual/make.html#Testing-Flags

Fixes: ea01fa9f63ae ("tools: Connect to the kernel build system")
Fixes: a50e43332756 ("perf tools: Honor parallel jobs")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 423d087afad2d..5a6d2646b1e55 100644
--- a/Makefile
+++ b/Makefile
@@ -1416,18 +1416,13 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
 	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
 endif
 
-# Clear a bunch of variables before executing the submake
-ifeq ($(quiet),silent_)
-tools_silent=s
-endif
-
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(tools_silent) $(filter --j% -j,$(MAKEFLAGS))" O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
+	$(Q)$(MAKE) LDFLAGS= O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(tools_silent) $(filter --j% -j,$(MAKEFLAGS))" O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
 
 # ---------------------------------------------------------------------------
 # Kernel selftest
-- 
2.39.5



