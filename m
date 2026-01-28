Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8472BE04C;
	Wed, 28 Jan 2026 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614509; cv=none; b=twqC8GmK8WaquqPdooBjAfK9AsmuIxXSYaPUGJKWic4JAUke+tuh5/EW6gnNaRa/cXEq4Cwo1cIT/pVJ1CG6fFIT3JU7kVf3POZBB81l6tFeoc9Po+ojs0dQCNlvdduFxKl8Pdxsw2rETacbkU+clLfuvBTyB2y8v7O09WyGzyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614509; c=relaxed/simple;
	bh=WLB4OXty3M4oTdU4J48NT1CLqCP11F2cH6oyodKeEQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7f/ey58h1ozUT64iN12R4cyWBkx8RcaUaDLm2KouIOEOJi+rjhEhIvBpy7KK4m4YRyjxBoE7FOhWTKf8h7xP9ijF6hnNzxCI3LUGuQsilXDaUE3CHmquQK5i8JBlnqgw9uadEnYzn49qV6UJh7oCwXr42jgzQqwC4cB3ugZOgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeBNM1aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeBNM1aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5433AC4CEF1;
	Wed, 28 Jan 2026 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614508;
	bh=WLB4OXty3M4oTdU4J48NT1CLqCP11F2cH6oyodKeEQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeBNM1aWiMQtHWue1i/6ldHGlvjJw3RNuFJonJwAmaDDTpCwySqyVvDA37Jq6s9Pc
	 5cTW3CK1+n/TUmnnXpkaEIH+HS1BxOV2GAmwfkj+HVRPcaLGKTui5Mn/0BHbKbM9jC
	 TDzwQuVc4UKOgTXGM9tz2BVYPODUExjtYkqbiVTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arusekk <floss@arusekk.pl>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/254] kconfig: fix static linking of nconf
Date: Wed, 28 Jan 2026 16:22:14 +0100
Message-ID: <20260128145350.497242303@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kozdra <floss@arusekk.pl>

[ Upstream commit baaecfcac559bcac73206df447eb5c385fa22f2a ]

When running make nconfig with a static linking host toolchain,
the libraries are linked in an incorrect order,
resulting in errors similar to the following:

$ MAKEFLAGS='HOSTCC=cc\ -static' make nconfig
/usr/bin/ld: /usr/lib64/gcc/x86_64-unknown-linux-gnu/14.2.1/../../../../lib64/libpanel.a(p_new.o): in function `new_panel':
(.text+0x13): undefined reference to `_nc_panelhook_sp'
/usr/bin/ld: (.text+0x6c): undefined reference to `_nc_panelhook_sp'

Fixes: 1c5af5cf9308 ("kconfig: refactor ncurses package checks for building mconf and nconf")
Signed-off-by: Arusekk <floss@arusekk.pl>
Link: https://patch.msgid.link/20260110114808.22595-1-floss@arusekk.pl
[nsc: Added comment about library order]
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/nconf-cfg.sh | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/nconf-cfg.sh b/scripts/kconfig/nconf-cfg.sh
index f871a2160e363..59814eb3616c6 100755
--- a/scripts/kconfig/nconf-cfg.sh
+++ b/scripts/kconfig/nconf-cfg.sh
@@ -4,8 +4,9 @@
 cflags=$1
 libs=$2
 
-PKG="ncursesw menuw panelw"
-PKG2="ncurses menu panel"
+# Keep library order for static linking (HOSTCC='cc -static')
+PKG="menuw panelw ncursesw"
+PKG2="menu panel ncurses"
 
 if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	if ${HOSTPKG_CONFIG} --exists $PKG; then
@@ -26,19 +27,19 @@ fi
 # find ncurses by pkg-config.)
 if [ -f /usr/include/ncursesw/ncurses.h ]; then
 	echo -D_GNU_SOURCE -I/usr/include/ncursesw > ${cflags}
-	echo -lncursesw -lmenuw -lpanelw > ${libs}
+	echo -lmenuw -lpanelw -lncursesw > ${libs}
 	exit 0
 fi
 
 if [ -f /usr/include/ncurses/ncurses.h ]; then
 	echo -D_GNU_SOURCE -I/usr/include/ncurses > ${cflags}
-	echo -lncurses -lmenu -lpanel > ${libs}
+	echo -lmenu -lpanel -lncurses > ${libs}
 	exit 0
 fi
 
 if [ -f /usr/include/ncurses.h ]; then
 	echo -D_GNU_SOURCE > ${cflags}
-	echo -lncurses -lmenu -lpanel > ${libs}
+	echo -lmenu -lpanel -lncurses > ${libs}
 	exit 0
 fi
 
-- 
2.51.0



