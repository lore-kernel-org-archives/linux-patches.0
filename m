Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD623F1AB8;
	Wed, 20 May 2026 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299331; cv=none; b=eT174r5OI2/XG69kvyZbqSvskIA95bslmjEDyYu7MzUpS2RCH0uacdVQExDyJSd9Q5XhTiiRLNG1DtZmIEugZ/nCkECDWPf2TbHsk2lkUqFyJpQyE/Rr/3hyLiN4meUDpxozaaPsgC2TApTuYw/nKksxaSmLD1iUm1JYbRpuxII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299331; c=relaxed/simple;
	bh=0tLbY+y/x5Oq0EGlqsbf7xc8ohuKTnJL8pK9JdH3xmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COF0Xf+cHsJJXoVUYE7a7n6t8YI8yGTpLkkLBlhKaAIuPHfPyQBnHXUXLI7t8yErR6uUidf55xg+dfMgY0NzW+yO/e7khdtX+Gd0WZuIFtMd4ZHxxIkSu64ByjTy3hYbNEYEfNKS09fbgAh0FE3HHj0/4e/RNWZa+iZR/NANNTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bin5m8DK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bin5m8DK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC171F000E9;
	Wed, 20 May 2026 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299329;
	bh=VZ8YGK+ulsweBKv82/98pHHNZ12zEWrPneuYmfZ5I/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bin5m8DKsDWSq9dQ6Ny7BR4tdxAOJIfMUT9uQVWUQ/ILHuT+SqYPN5kZpAc0LdV4d
	 SsWCZKJMokIaqt2DyYofW5jVlib/agf7wLi73f2jCL3y3RqsWHWVPgPmKBe00KBvGe
	 l6hnURhYISIbwCIWt0YaeSQaNGN6bhNf+w2yUXfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 731/957] kbuild: Never respect CONFIG_WERROR / W=e to fixdep
Date: Wed, 20 May 2026 18:20:14 +0200
Message-ID: <20260520162150.408403648@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 75f7c47ccd78c947cf1b6ddb18ea453ff0555716 ]

The fixdep hostprog may be built multiple times during a single build.
Once during the configuration phase and later during the regular phase.
As only the regular build phase respects CONFIG_WERROR / W=e, the
compiler flags might change between the phases, leading to rebuilds.

Example, the rebuilds will happen twice on each invocation of the build:

  $ make allyesconfig prepare
  make[1]: Entering directory '/tmp/deleteme'
    HOSTCC  scripts/basic/fixdep
  #
  # No change to .config
  #
    HOSTCC  scripts/basic/fixdep
    DESCEND objtool
    INSTALL libsubcmd_headers
  make[1]: Leaving directory '/tmp/deleteme'

Fix the compilation flags used for scripts/basic/ before
scripts/Makefile.warn is evaluated to stop CONFIG_WERROR / W=e
influencing the fixdep build to avoid the spurious rebuilds.

Fixes: 7ded7d37e5f5 ("scripts/Makefile.extrawarn: Respect CONFIG_WERROR / W=e for hostprogs")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260422-kbuild-scripts-basic-werror-v1-1-8c6912ff22e0@weissschuh.net
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index d1fcec7cf9568..70e10b29b3859 100644
--- a/Makefile
+++ b/Makefile
@@ -655,6 +655,8 @@ export RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o    \
 
 # Basic helpers built in scripts/basic/
 PHONY += scripts_basic
+scripts_basic: KBUILD_HOSTCFLAGS := $(KBUILD_HOSTCFLAGS)
+scripts_basic: KBUILD_HOSTLDFLAGS := $(KBUILD_HOSTLDFLAGS)
 scripts_basic:
 	$(Q)$(MAKE) $(build)=scripts/basic
 
-- 
2.53.0



