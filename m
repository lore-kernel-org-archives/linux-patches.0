Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64EF28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9167C433D2;
	Mon, 12 Dec 2022 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853116;
	bh=x4JAFBBbta5u9iTeIOXd0Io/x1FuBHA32QWM9sNR7sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaAkAabkDyyWlINU07kXoGV6jyFVfLpQwkeNX7bNJMfPajk60EMv/Tl3OgUhGHCA/
	 rxaHx5UmZPiFAKHVfpWED4XbSjTAIaBKk1cdiltkvYCNhOel5e0m58MtBFmKVHzwkI
	 Vdl91TqRqeaMhTuGmJy4IV1vxMNLf5/abByDsZpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Connor Shu <Connor.Shu@ibm.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/38] rcutorture: Automatically create initrd directory
Date: Mon, 12 Dec 2022 14:19:14 +0100
Message-Id: <20221212130912.782133347@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Connor Shu <Connor.Shu@ibm.com>

[ Upstream commit 8f15c682ac5a778feb8e343f9057b89beb40d85b ]

The rcutorture scripts currently expect the user to create the
tools/testing/selftests/rcutorture/initrd directory.  Should the user
fail to do this, the kernel build will fail with obscure and confusing
error messages.  This commit therefore adds explicit checks for the
tools/testing/selftests/rcutorture/initrd directory, and if not present,
creates one on systems on which dracut is installed.  If this directory
could not be created, a less obscure error message is emitted and the
test is aborted.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Connor Shu <Connor.Shu@ibm.com>
[ paulmck: Adapt the script to fit into the rcutorture framework and
  severely abbreviate the initrd/init script. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh |  8 +++
 .../selftests/rcutorture/bin/mkinitrd.sh      | 60 +++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100755 tools/testing/selftests/rcutorture/bin/mkinitrd.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index b55895fb10ed..2299347b8e37 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -182,6 +182,14 @@ do
 	shift
 done
 
+if test -z "$TORTURE_INITRD" || tools/testing/selftests/rcutorture/bin/mkinitrd.sh
+then
+	:
+else
+	echo No initrd and unable to create one, aborting test >&2
+	exit 1
+fi
+
 CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
 
 if test -z "$configs"
diff --git a/tools/testing/selftests/rcutorture/bin/mkinitrd.sh b/tools/testing/selftests/rcutorture/bin/mkinitrd.sh
new file mode 100755
index 000000000000..ae773760f396
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/mkinitrd.sh
@@ -0,0 +1,60 @@
+#!/bin/bash
+#
+# Create an initrd directory if one does not already exist.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Author: Connor Shu <Connor.Shu@ibm.com>
+
+D=tools/testing/selftests/rcutorture
+
+# Prerequisite checks
+[ -z "$D" ] && echo >&2 "No argument supplied" && exit 1
+if [ ! -d "$D" ]; then
+    echo >&2 "$D does not exist: Malformed kernel source tree?"
+    exit 1
+fi
+if [ -d "$D/initrd" ]; then
+    echo "$D/initrd already exists, no need to create it"
+    exit 0
+fi
+
+T=${TMPDIR-/tmp}/mkinitrd.sh.$$
+trap 'rm -rf $T' 0 2
+mkdir $T
+
+cat > $T/init << '__EOF___'
+#!/bin/sh
+while :
+do
+	sleep 1000000
+done
+__EOF___
+
+# Try using dracut to create initrd
+command -v dracut >/dev/null 2>&1 || { echo >&2 "Dracut not installed"; exit 1; }
+echo Creating $D/initrd using dracut.
+
+# Filesystem creation
+dracut --force --no-hostonly --no-hostonly-cmdline --module "base" $T/initramfs.img
+cd $D
+mkdir initrd
+cd initrd
+zcat $T/initramfs.img | cpio -id
+cp $T/init init
+echo Done creating $D/initrd using dracut
+exit 0
-- 
2.35.1



