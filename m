Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AF32E2DF4;
	Wed, 28 Jan 2026 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615056; cv=none; b=VQoezr+ti534fkw45kdCesXLtb9GMg6BWDbfqYTR5DuE0wzwRyEWd43w5OJAlhag36STPmuwgu4JJjxJf0ru3C+otBTel1zEIcM6z08Wcqin/D/sfR3+FITzA5+OvQNWKbOKEfQJEmhTh0LJicPJ8t9hocZql+UAa3V06TZ+GGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615056; c=relaxed/simple;
	bh=OJttEeTfSmak6YzR1jRn1qIsjDnoBlBVdcGB2JactXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+8gfZLhKsipawRTctbv6Ls3QVlw4NrE1+yUT+vZ+GNqdf6vSO8ENwEZ2FOfuxthUsQAnH9nrouOB7TjCEOqoSeXuqoEnG7STBKcsXgSLrPCG09id1KfC4zr1ZPPEwOGScsPS78oDJ0pfeM1+Fc6lZcW2hXx5gSY9vpxAsNMQbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3JpP7ZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3JpP7ZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02B9C4CEF1;
	Wed, 28 Jan 2026 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615056;
	bh=OJttEeTfSmak6YzR1jRn1qIsjDnoBlBVdcGB2JactXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3JpP7ZL0OZ8W5DPIreUNHDKxfS89/XNFtLUs3PP/uQpRJOB9LzF+dtw2nBeY/62A
	 5/1r/mqEb3onAZt1hijBcwwYr3KvCWhszZfee3pKlkq7ZY8rDwUk4QckSf9fDKBwnT
	 sObdctLRicVQi9CBR9nT2cYrRa4y0/2ZZzcTEADE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arusekk <floss@arusekk.pl>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/169] kconfig: fix static linking of nconf
Date: Wed, 28 Jan 2026 16:22:28 +0100
Message-ID: <20260128145336.349773859@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



