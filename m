Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520441C318;
	Wed,  4 Feb 2026 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217838; cv=none; b=XXAV+nIs24idm0REnGSwlQIS6zezy7kENhLWNRxDJxcBB2eQJlrM7blAAsMqgBai5LW+N0MBJCLI7Wu0taumH4DgXbz518/RaEQuzNA9nBwk+AK8MLPcV4rcpaztQMYQTtAD4Zq4jqM7MNS06IrhSWXRd/hQAQJ4U/xuyeFtHO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217838; c=relaxed/simple;
	bh=NCLSdZw1wwpwjGw8wOov8nExP/zUv78T08K1DwMUEEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4pT33ng61Y/fQnKGxNGzlnyTaTRjV51jj7ZvoOz+fkEQLmLOXPEYH2HHIeCnpSoisHCUKPlPDItd5GW5F0SuiI0HxdLs+YfsWqBo+4K5eqMGOpZvJnTyg1SqOLhC94iK3yIa0zHT6/apmeWcuoF773bwcw06QS24UE64R3N49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOu+I3Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOu+I3Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEEDC4CEF7;
	Wed,  4 Feb 2026 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217838;
	bh=NCLSdZw1wwpwjGw8wOov8nExP/zUv78T08K1DwMUEEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOu+I3Q3KnL9DdDkS1GmkjbUDNdtiuvXxPrJpVfshB1IYJ5S6o94reWipV09JQ8YU
	 7itOHgm2NECZ6ordWEUHr/Hj/gKbWXlgUTpH4a6mK+Q0iJcfzfa9Fcfhql4KcxtYq8
	 Fq5bOoBsocwFsGULGcP5CGJo22dgstFuULhprjkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arusekk <floss@arusekk.pl>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/280] kconfig: fix static linking of nconf
Date: Wed,  4 Feb 2026 15:38:29 +0100
Message-ID: <20260204143914.499022303@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



