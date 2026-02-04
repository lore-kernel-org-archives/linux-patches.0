Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA63441C312;
	Wed,  4 Feb 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217834; cv=none; b=I6NjAKeXKilyQHrZuuvErKrM49CrOwWWyh6TVQ7rzlENrt38EgMxtQOYomwSzCYuiBDd58RQb7Oq3mLU3hjnEjjxWvOUwAIy8SxqbZUsYziG5jh5kNOORrk6qnqsZg4We13TMMJN+fH/4RTaPCb4WVUBoEvjLmz591d8j5opokE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217834; c=relaxed/simple;
	bh=UhUjfEfKsRMrMl9tCudsdMnJIXLZffnwa3zEU2DQPig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtE5MuSVxsH/Iw1Im/76BiTjihCHEiMMBVRZ74o/D3MTvBM7K0PCpoWzpYI2rA6msFPsvzbNBlvbqn11Tb63IGwu9UGynPSWXAh4rJoSOEgqeNCnigrIXBRwvSGUpAaeGAf4Pabqm7j0e9+FO5iSSM24O4q1E9jhFj2KfSI1GM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HddrBP8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HddrBP8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388BAC4CEF7;
	Wed,  4 Feb 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217834;
	bh=UhUjfEfKsRMrMl9tCudsdMnJIXLZffnwa3zEU2DQPig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HddrBP8zfwoAyO5zTcpOj0fFx+LUUtJmaObUtgjVJolIoa0cUESCJf1cmvxWQKQv3
	 Tj17Qh2IEijxh9736S4CeOcIuXXvpWjuKbYqYpdM//HqTh0FoSh7JAwKRrTCYXM1h1
	 Y8XH0UzmbY5w9bfu5nMS8gX2izr0/X5MRdl4A+48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/280] kconfig: refactor Makefile to reduce process forks
Date: Wed,  4 Feb 2026 15:38:28 +0100
Message-ID: <20260204143914.463050403@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3122c84409d578a5df8bcb1953547e0b871ac4c2 ]

Refactor Makefile and use read-file macro. For Make >= 4.2, it can read
out a file by using the built-in function.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Stable-dep-of: baaecfcac559 ("kconfig: fix static linking of nconf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/.gitignore   |  4 +++-
 scripts/kconfig/Makefile     | 45 +++++++++++++++++++-----------------
 scripts/kconfig/gconf-cfg.sh |  7 ++++--
 scripts/kconfig/mconf-cfg.sh | 25 +++++++++++---------
 scripts/kconfig/nconf-cfg.sh | 23 ++++++++++--------
 scripts/kconfig/qconf-cfg.sh | 10 +++++---
 scripts/remove-stale-files   |  2 ++
 7 files changed, 68 insertions(+), 48 deletions(-)

diff --git a/scripts/kconfig/.gitignore b/scripts/kconfig/.gitignore
index 500e7424b3ef9..c8a3f9cd52f02 100644
--- a/scripts/kconfig/.gitignore
+++ b/scripts/kconfig/.gitignore
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /conf
 /[gmnq]conf
-/[gmnq]conf-cfg
+/[gmnq]conf-cflags
+/[gmnq]conf-libs
+/qconf-bin
 /qconf-moc.cc
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index b8ef0fb4bbef7..0b1d15efaeb0c 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -159,11 +159,12 @@ conf-objs	:= conf.o $(common-objs)
 hostprogs	+= nconf
 nconf-objs	:= nconf.o nconf.gui.o $(common-objs)
 
-HOSTLDLIBS_nconf	= $(shell . $(obj)/nconf-cfg && echo $$libs)
-HOSTCFLAGS_nconf.o	= $(shell . $(obj)/nconf-cfg && echo $$cflags)
-HOSTCFLAGS_nconf.gui.o	= $(shell . $(obj)/nconf-cfg && echo $$cflags)
+HOSTLDLIBS_nconf       = $(call read-file, $(obj)/nconf-libs)
+HOSTCFLAGS_nconf.o     = $(call read-file, $(obj)/nconf-cflags)
+HOSTCFLAGS_nconf.gui.o = $(call read-file, $(obj)/nconf-cflags)
 
-$(obj)/nconf.o $(obj)/nconf.gui.o: $(obj)/nconf-cfg
+$(obj)/nconf: | $(obj)/nconf-libs
+$(obj)/nconf.o $(obj)/nconf.gui.o: | $(obj)/nconf-cflags
 
 # mconf: Used for the menuconfig target based on lxdialog
 hostprogs	+= mconf
@@ -171,27 +172,28 @@ lxdialog	:= $(addprefix lxdialog/, \
 		     checklist.o inputbox.o menubox.o textbox.o util.o yesno.o)
 mconf-objs	:= mconf.o $(lxdialog) $(common-objs)
 
-HOSTLDLIBS_mconf = $(shell . $(obj)/mconf-cfg && echo $$libs)
+HOSTLDLIBS_mconf = $(call read-file, $(obj)/mconf-libs)
 $(foreach f, mconf.o $(lxdialog), \
-  $(eval HOSTCFLAGS_$f = $$(shell . $(obj)/mconf-cfg && echo $$$$cflags)))
+  $(eval HOSTCFLAGS_$f = $$(call read-file, $(obj)/mconf-cflags)))
 
-$(addprefix $(obj)/, mconf.o $(lxdialog)): $(obj)/mconf-cfg
+$(obj)/mconf: | $(obj)/mconf-libs
+$(addprefix $(obj)/, mconf.o $(lxdialog)): | $(obj)/mconf-cflags
 
 # qconf: Used for the xconfig target based on Qt
 hostprogs	+= qconf
 qconf-cxxobjs	:= qconf.o qconf-moc.o
 qconf-objs	:= images.o $(common-objs)
 
-HOSTLDLIBS_qconf	= $(shell . $(obj)/qconf-cfg && echo $$libs)
-HOSTCXXFLAGS_qconf.o	= $(shell . $(obj)/qconf-cfg && echo $$cflags)
-HOSTCXXFLAGS_qconf-moc.o = $(shell . $(obj)/qconf-cfg && echo $$cflags)
-
-$(obj)/qconf.o: $(obj)/qconf-cfg
+HOSTLDLIBS_qconf         = $(call read-file, $(obj)/qconf-libs)
+HOSTCXXFLAGS_qconf.o     = -std=c++11 -fPIC $(call read-file, $(obj)/qconf-cflags)
+HOSTCXXFLAGS_qconf-moc.o = -std=c++11 -fPIC $(call read-file, $(obj)/qconf-cflags)
+$(obj)/qconf: | $(obj)/qconf-libs
+$(obj)/qconf.o $(obj)/qconf-moc.o: | $(obj)/qconf-cflags
 
 quiet_cmd_moc = MOC     $@
-      cmd_moc = $(shell . $(obj)/qconf-cfg && echo $$moc) $< -o $@
+      cmd_moc = $(call read-file, $(obj)/qconf-bin)/moc $< -o $@
 
-$(obj)/qconf-moc.cc: $(src)/qconf.h $(obj)/qconf-cfg FORCE
+$(obj)/qconf-moc.cc: $(src)/qconf.h FORCE | $(obj)/qconf-bin
 	$(call if_changed,moc)
 
 targets += qconf-moc.cc
@@ -200,15 +202,16 @@ targets += qconf-moc.cc
 hostprogs	+= gconf
 gconf-objs	:= gconf.o images.o $(common-objs)
 
-HOSTLDLIBS_gconf    = $(shell . $(obj)/gconf-cfg && echo $$libs)
-HOSTCFLAGS_gconf.o  = $(shell . $(obj)/gconf-cfg && echo $$cflags)
+HOSTLDLIBS_gconf   = $(call read-file, $(obj)/gconf-libs)
+HOSTCFLAGS_gconf.o = $(call read-file, $(obj)/gconf-cflags)
 
-$(obj)/gconf.o: $(obj)/gconf-cfg
+$(obj)/gconf: | $(obj)/gconf-libs
+$(obj)/gconf.o: | $(obj)/gconf-cflags
 
 # check if necessary packages are available, and configure build flags
-filechk_conf_cfg = $(CONFIG_SHELL) $<
+cmd_conf_cfg = $< $(addprefix $(obj)/$*conf-, cflags libs bin)
 
-$(obj)/%conf-cfg: $(src)/%conf-cfg.sh FORCE
-	$(call filechk,conf_cfg)
+$(obj)/%conf-cflags $(obj)/%conf-libs $(obj)/%conf-bin: $(src)/%conf-cfg.sh
+	$(call cmd,conf_cfg)
 
-clean-files += *conf-cfg
+clean-files += *conf-cflags *conf-libs *conf-bin
diff --git a/scripts/kconfig/gconf-cfg.sh b/scripts/kconfig/gconf-cfg.sh
index cbd90c28c05f2..040d8f3388202 100755
--- a/scripts/kconfig/gconf-cfg.sh
+++ b/scripts/kconfig/gconf-cfg.sh
@@ -1,6 +1,9 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+cflags=$1
+libs=$2
+
 PKG="gtk+-2.0 gmodule-2.0 libglade-2.0"
 
 if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
@@ -26,5 +29,5 @@ if ! ${HOSTPKG_CONFIG} --atleast-version=2.0.0 gtk+-2.0; then
 	exit 1
 fi
 
-echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
-echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
+${HOSTPKG_CONFIG} --cflags ${PKG} > ${cflags}
+${HOSTPKG_CONFIG} --libs ${PKG} > ${libs}
diff --git a/scripts/kconfig/mconf-cfg.sh b/scripts/kconfig/mconf-cfg.sh
index 025b565e0b7cd..1e61f50a59050 100755
--- a/scripts/kconfig/mconf-cfg.sh
+++ b/scripts/kconfig/mconf-cfg.sh
@@ -1,19 +1,22 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+cflags=$1
+libs=$2
+
 PKG="ncursesw"
 PKG2="ncurses"
 
 if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	if ${HOSTPKG_CONFIG} --exists $PKG; then
-		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
-		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
+		${HOSTPKG_CONFIG} --cflags ${PKG} > ${cflags}
+		${HOSTPKG_CONFIG} --libs ${PKG} > ${libs}
 		exit 0
 	fi
 
-	if ${HOSTPKG_CONFIG} --exists $PKG2; then
-		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG2)\"
-		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG2)\"
+	if ${HOSTPKG_CONFIG} --exists ${PKG2}; then
+		${HOSTPKG_CONFIG} --cflags ${PKG2} > ${cflags}
+		${HOSTPKG_CONFIG} --libs ${PKG2} > ${libs}
 		exit 0
 	fi
 fi
@@ -22,22 +25,22 @@ fi
 # (Even if it is installed, some distributions such as openSUSE cannot
 # find ncurses by pkg-config.)
 if [ -f /usr/include/ncursesw/ncurses.h ]; then
-	echo cflags=\"-D_GNU_SOURCE -I/usr/include/ncursesw\"
-	echo libs=\"-lncursesw\"
+	echo -D_GNU_SOURCE -I/usr/include/ncursesw > ${cflags}
+	echo -lncursesw > ${libs}
 	exit 0
 fi
 
 if [ -f /usr/include/ncurses/ncurses.h ]; then
-	echo cflags=\"-D_GNU_SOURCE -I/usr/include/ncurses\"
-	echo libs=\"-lncurses\"
+	echo -D_GNU_SOURCE -I/usr/include/ncurses > ${cflags}
+	echo -lncurses > ${libs}
 	exit 0
 fi
 
 # As a final fallback before giving up, check if $HOSTCC knows of a default
 # ncurses installation (e.g. from a vendor-specific sysroot).
 if echo '#include <ncurses.h>' | ${HOSTCC} -E - >/dev/null 2>&1; then
-	echo cflags=\"-D_GNU_SOURCE\"
-	echo libs=\"-lncurses\"
+	echo -D_GNU_SOURCE > ${cflags}
+	echo -lncurses > ${libs}
 	exit 0
 fi
 
diff --git a/scripts/kconfig/nconf-cfg.sh b/scripts/kconfig/nconf-cfg.sh
index 3a10bac2adb3a..f871a2160e363 100755
--- a/scripts/kconfig/nconf-cfg.sh
+++ b/scripts/kconfig/nconf-cfg.sh
@@ -1,19 +1,22 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+cflags=$1
+libs=$2
+
 PKG="ncursesw menuw panelw"
 PKG2="ncurses menu panel"
 
 if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	if ${HOSTPKG_CONFIG} --exists $PKG; then
-		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
-		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
+		${HOSTPKG_CONFIG} --cflags ${PKG} > ${cflags}
+		${HOSTPKG_CONFIG} --libs ${PKG} > ${libs}
 		exit 0
 	fi
 
 	if ${HOSTPKG_CONFIG} --exists $PKG2; then
-		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG2)\"
-		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG2)\"
+		${HOSTPKG_CONFIG} --cflags ${PKG2} > ${cflags}
+		${HOSTPKG_CONFIG} --libs ${PKG2} > ${libs}
 		exit 0
 	fi
 fi
@@ -22,20 +25,20 @@ fi
 # (Even if it is installed, some distributions such as openSUSE cannot
 # find ncurses by pkg-config.)
 if [ -f /usr/include/ncursesw/ncurses.h ]; then
-	echo cflags=\"-D_GNU_SOURCE -I/usr/include/ncursesw\"
-	echo libs=\"-lncursesw -lmenuw -lpanelw\"
+	echo -D_GNU_SOURCE -I/usr/include/ncursesw > ${cflags}
+	echo -lncursesw -lmenuw -lpanelw > ${libs}
 	exit 0
 fi
 
 if [ -f /usr/include/ncurses/ncurses.h ]; then
-	echo cflags=\"-D_GNU_SOURCE -I/usr/include/ncurses\"
-	echo libs=\"-lncurses -lmenu -lpanel\"
+	echo -D_GNU_SOURCE -I/usr/include/ncurses > ${cflags}
+	echo -lncurses -lmenu -lpanel > ${libs}
 	exit 0
 fi
 
 if [ -f /usr/include/ncurses.h ]; then
-	echo cflags=\"-D_GNU_SOURCE\"
-	echo libs=\"-lncurses -lmenu -lpanel\"
+	echo -D_GNU_SOURCE > ${cflags}
+	echo -lncurses -lmenu -lpanel > ${libs}
 	exit 0
 fi
 
diff --git a/scripts/kconfig/qconf-cfg.sh b/scripts/kconfig/qconf-cfg.sh
index ad652cb539474..117f36e568fc5 100755
--- a/scripts/kconfig/qconf-cfg.sh
+++ b/scripts/kconfig/qconf-cfg.sh
@@ -1,6 +1,10 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+cflags=$1
+libs=$2
+bin=$3
+
 PKG="Qt5Core Qt5Gui Qt5Widgets"
 
 if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
@@ -11,9 +15,9 @@ if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
 fi
 
 if ${HOSTPKG_CONFIG} --exists $PKG; then
-	echo cflags=\"-std=c++11 -fPIC $(${HOSTPKG_CONFIG} --cflags $PKG)\"
-	echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
-	echo moc=\"$(${HOSTPKG_CONFIG} --variable=host_bins Qt5Core)/moc\"
+	${HOSTPKG_CONFIG} --cflags ${PKG} > ${cflags}
+	${HOSTPKG_CONFIG} --libs ${PKG} > ${libs}
+	${HOSTPKG_CONFIG} --variable=host_bins Qt5Core > ${bin}
 	exit 0
 fi
 
diff --git a/scripts/remove-stale-files b/scripts/remove-stale-files
index ccadfa3afb2b8..64b14aa5aebf4 100755
--- a/scripts/remove-stale-files
+++ b/scripts/remove-stale-files
@@ -47,3 +47,5 @@ rm -f arch/riscv/purgatory/kexec-purgatory.c
 rm -f scripts/extract-cert
 
 rm -f arch/x86/purgatory/kexec-purgatory.c
+
+rm -f scripts/kconfig/[gmnq]conf-cfg
-- 
2.51.0



