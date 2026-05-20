Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323336F421;
	Wed, 20 May 2026 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296639; cv=none; b=CNxKJnndQhvo9sLkZjee5fDPiHOIeDKz18kUuptYTHAP3IBzp/VBsQxf61DF/Ny/sXRrV1cwCVS6bM+kXkrdMfZNxpN5JI8vNjHt3oDn1PBDKoxhwvRnRsCaV8XLkHsrSPE14iIRx4Sh85AnYtqK0L+t8dMJjlK609WW5qIp920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296639; c=relaxed/simple;
	bh=nmzDsmxYIJJXwYx5gT40JYGHdDZFKKC77zwRgafTHLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6aqoRpJRIhOfNm/W56t5uUM032CqwD2dqHh3rc2tjt3PAxlRKtpFSVxFeUNIgdNh1ZXo2VATYdgwVcHKBQV5mRjum06NwN9c7qs3Xnc6qfIrrI6ngvcpLHs+pbwa6iOTAwYkizXslicI3W/glCPKO6ZiEQ0Xw0i9CJj5NBd90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKSZMyC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKSZMyC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A761F000E9;
	Wed, 20 May 2026 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296638;
	bh=Tzq67Pg2QS47hBsFsi9eHm1xv7JESxeog5VIiVabWwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKSZMyC9TwDrtWCbRUEUhF27aagbXHGrF6ZjWQ759XqVdqcFIHYiegK86XZFWZGsc
	 0oYAd30C7KXasUsO+yIcHe6/W+FkXm/avOL2Y/PYbwwxJJR5+dOo2CjlSr2EFQ3KDe
	 KTYgu2psTl+PRqJ09bu3DU0qkr5VK4KVP8b3/W9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0876/1146] kbuild: Never respect CONFIG_WERROR / W=e to fixdep
Date: Wed, 20 May 2026 18:18:46 +0200
Message-ID: <20260520162208.063862751@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 9da9c1f3b2382..1e646735a8cc2 100644
--- a/Makefile
+++ b/Makefile
@@ -658,6 +658,8 @@ export RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o    \
 
 # Basic helpers built in scripts/basic/
 PHONY += scripts_basic
+scripts_basic: KBUILD_HOSTCFLAGS := $(KBUILD_HOSTCFLAGS)
+scripts_basic: KBUILD_HOSTLDFLAGS := $(KBUILD_HOSTLDFLAGS)
 scripts_basic:
 	$(Q)$(MAKE) $(build)=scripts/basic
 
-- 
2.53.0



