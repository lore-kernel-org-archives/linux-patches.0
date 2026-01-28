Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6E52857CD;
	Wed, 28 Jan 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615698; cv=none; b=olEGG/rrDMiqzxCEQs5sFQg8UouaKyxxv7w6PkyIewH6mdUmt6WJudpuvyk88YdrPheIAU1Nv57z5x00exJ7wj+WiHcJ3uJpuYwLoEGOAmc2T78xTcrZ5JBsxSBPCxLu34lNxdvA5UhsuTdfxWOhgVvQFNRHLUShvDtQNaIpdg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615698; c=relaxed/simple;
	bh=+v9xhxd+nsnwJgyDJn8UStmI9kxd1dfAEu7X7TBXptg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mr0s4BG464PwMzIdyYlPLt/DQOwDR7Jy5Dycam6lLLynXatotAV8YT86bFVqxJLHOExZfT4CR/cDrjYfT9MDIVHqFIR0t4SWFS9VV7eys3TXzpAp42WKRQaqnSs+M9PM/DL2LIiK2Sy25WQ5DKRIbVicJgoCPFohtjYevlD6bW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRyvuyRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRyvuyRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837BEC4CEF1;
	Wed, 28 Jan 2026 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615698;
	bh=+v9xhxd+nsnwJgyDJn8UStmI9kxd1dfAEu7X7TBXptg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRyvuyRa418CUR/RblTihmR1hrd0asxxTFZLNZtWScbFvyIwviy1LXha7gYdw5pzQ
	 Af8k9rgeW53XKTBgSnW+hS/JjPO/DFI4u9Uipc5lVI6KZexecFBVx2DmsD7aUCEPi/
	 t3Emc/wYRlNM1+7CErh1YWmSoHVql87pIuzfqDqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arusekk <floss@arusekk.pl>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/227] kconfig: fix static linking of nconf
Date: Wed, 28 Jan 2026 16:22:12 +0100
Message-ID: <20260128145347.468540301@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a20290b1a37d8..4d08453f9bdb7 100755
--- a/scripts/kconfig/nconf-cfg.sh
+++ b/scripts/kconfig/nconf-cfg.sh
@@ -6,8 +6,9 @@ set -eu
 cflags=$1
 libs=$2
 
-PKG="ncursesw menuw panelw"
-PKG2="ncurses menu panel"
+# Keep library order for static linking (HOSTCC='cc -static')
+PKG="menuw panelw ncursesw"
+PKG2="menu panel ncurses"
 
 if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	if ${HOSTPKG_CONFIG} --exists $PKG; then
@@ -28,19 +29,19 @@ fi
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



