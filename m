Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466F3335BB3;
	Mon, 18 Aug 2025 13:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524254; cv=none; b=maT99JdIQjBTXbZQzZaPT6/8rFjHpPxhF6yHUQpS7FdLOfnIjZZ3CddjheVsvPWkQm37u5gOJ5MXE1dGox95TaS1bjClhXB5XOGuXivreEJMMcjt7Z84GyKFshPCKSjjJPPEvhqP8ky5zYKlR3KIszMPkHevS2LmKMMebWRHm6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524254; c=relaxed/simple;
	bh=RiiYEEHCBNL9l3/k2lzQlL8yMg2IBhydi1OGOWsXWF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbJDEk9BsnkNXxntiMzfuePXLfE6/u0mjL0fivWd//P/25E/LBmrbvXY4Fmhn7pSS3+jCc99HvWiY66E78CGJB5QXYg0B8GwcvI1SoyDZFNyqwtyFF4rXAqQAqCwhJ2hOm/KfRoFGsdw23/veJiEtk8oTniSuVxEJ80t1M68uLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yn3JywiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yn3JywiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB57C116B1;
	Mon, 18 Aug 2025 13:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524254;
	bh=RiiYEEHCBNL9l3/k2lzQlL8yMg2IBhydi1OGOWsXWF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn3JywiLnjgHExPFfynvZNOLT+oigTJ1QrvP1+AZ7LrtPnRcMIRPuSmKnX39wu6Gz
	 YotYaXmMAnqaFtOyWrE4vzaptpnRiWEYAaWPccmvgmK/LZK78cPA1HmGclp7Dn5D2O
	 s2lo5bo1Kt2PXlEB8/CfheoK8COtLEqDeZqla03c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 415/515] kheaders: rebuild kheaders_data.tar.xz when a file is modified within a minute
Date: Mon, 18 Aug 2025 14:46:41 +0200
Message-ID: <20250818124514.391710813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 626c54af35764b0b8a4ed5c446458ba6ddfe9cc8 ]

When a header file is changed, kernel/gen_kheaders.sh may fail to update
kernel/kheaders_data.tar.xz.

[steps to reproduce]

[1] Build kernel/kheaders_data.tar.xz

  $ make -j$(nproc) kernel/kheaders.o
    DESCEND objtool
    INSTALL libsubcmd_headers
    CALL    scripts/checksyscalls.sh
    CHK     kernel/kheaders_data.tar.xz
    GEN     kernel/kheaders_data.tar.xz
    CC      kernel/kheaders.o

[2] Modify a header without changing the file size

  $ sed -i s/0xdeadbeef/0xfeedbeef/ include/linux/elfnote.h

[3] Rebuild kernel/kheaders_data.tar.xz

  $ make -j$(nproc) kernel/kheaders.o
    DESCEND objtool
    INSTALL libsubcmd_headers
    CALL    scripts/checksyscalls.sh
    CHK     kernel/kheaders_data.tar.xz

kernel/kheaders_data.tar.xz is not updated if steps [1] - [3] are run
within the same minute.

The headers_md5 variable stores the MD5 hash of the 'ls -l' output
for all header files. This hash value is used to determine whether
kheaders_data.tar.xz needs to be rebuilt. However, 'ls -l' prints the
modification times with minute-level granularity. If a file is modified
within the same minute and its size remains the same, the MD5 hash does
not change.

To reliably detect file modifications, this commit rewrites
kernel/gen_kheaders.sh to output header dependencies to
kernel/.kheaders_data.tar.xz.cmd. Then, Make compares the timestamps
and reruns kernel/gen_kheaders.sh when necessary. This is the standard
mechanism used by Make and Kbuild.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/.gitignore      |  2 +
 kernel/Makefile        | 47 ++++++++++++++++++---
 kernel/gen_kheaders.sh | 94 ++++++++++--------------------------------
 3 files changed, 66 insertions(+), 77 deletions(-)

diff --git a/kernel/.gitignore b/kernel/.gitignore
index c6b299a6b786..a501bfc80694 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /config_data
 /kheaders.md5
+/kheaders-objlist
+/kheaders-srclist
diff --git a/kernel/Makefile b/kernel/Makefile
index 434929de17ef..96a8798c9c64 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -156,11 +156,48 @@ filechk_cat = cat $<
 $(obj)/config_data: $(KCONFIG_CONFIG) FORCE
 	$(call filechk,cat)
 
+# kheaders_data.tar.xz
 $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
 
-quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz
-      cmd_genikh = $(CONFIG_SHELL) $(srctree)/kernel/gen_kheaders.sh $@
-$(obj)/kheaders_data.tar.xz: FORCE
-	$(call cmd,genikh)
+quiet_cmd_kheaders_data = GEN     $@
+      cmd_kheaders_data = "$<" "$@" "$(obj)/kheaders-srclist" "$(obj)/kheaders-objlist"
+      cmd_kheaders_data_dep = cat $(depfile) >> $(dot-target).cmd; rm -f $(depfile)
 
-clean-files := kheaders_data.tar.xz kheaders.md5
+define rule_kheaders_data
+	$(call cmd_and_savecmd,kheaders_data)
+	$(call cmd,kheaders_data_dep)
+endef
+
+targets += kheaders_data.tar.xz
+$(obj)/kheaders_data.tar.xz: $(src)/gen_kheaders.sh $(obj)/kheaders-srclist $(obj)/kheaders-objlist $(obj)/kheaders.md5 FORCE
+	$(call if_changed_rule,kheaders_data)
+
+# generated headers in objtree
+#
+# include/generated/utsversion.h is ignored because it is generated
+# after gen_kheaders.sh is executed. (utsversion.h is unneeded for kheaders)
+filechk_kheaders_objlist = \
+	for d in include "arch/$(SRCARCH)/include"; do \
+		find "$${d}/generated" ! -path "include/generated/utsversion.h" -a -name "*.h" -print; \
+	done
+
+$(obj)/kheaders-objlist: FORCE
+	$(call filechk,kheaders_objlist)
+
+# non-generated headers in srctree
+filechk_kheaders_srclist = \
+	for d in include "arch/$(SRCARCH)/include"; do \
+		find "$(srctree)/$${d}" -path "$(srctree)/$${d}/generated" -prune -o -name "*.h" -print; \
+	done
+
+$(obj)/kheaders-srclist: FORCE
+	$(call filechk,kheaders_srclist)
+
+# Some files are symlinks. If symlinks are changed, kheaders_data.tar.xz should
+# be rebuilt.
+filechk_kheaders_md5sum = xargs -r -a $< stat -c %N | md5sum
+
+$(obj)/kheaders.md5: $(obj)/kheaders-srclist FORCE
+	$(call filechk,kheaders_md5sum)
+
+clean-files := kheaders.md5 kheaders-srclist kheaders-objlist
diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index c9e5dc068e85..0ff7beabb21a 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -4,79 +4,33 @@
 # This script generates an archive consisting of kernel headers
 # for CONFIG_IKHEADERS.
 set -e
-sfile="$(readlink -f "$0")"
-outdir="$(pwd)"
 tarfile=$1
-tmpdir=$outdir/${tarfile%/*}/.tmp_dir
-
-dir_list="
-include/
-arch/$SRCARCH/include/
-"
-
-# Support incremental builds by skipping archive generation
-# if timestamps of files being archived are not changed.
-
-# This block is useful for debugging the incremental builds.
-# Uncomment it for debugging.
-# if [ ! -f /tmp/iter ]; then iter=1; echo 1 > /tmp/iter;
-# else iter=$(($(cat /tmp/iter) + 1)); echo $iter > /tmp/iter; fi
-# find $all_dirs -name "*.h" | xargs ls -l > /tmp/ls-$iter
-
-all_dirs=
-if [ "$building_out_of_srctree" ]; then
-	for d in $dir_list; do
-		all_dirs="$all_dirs $srctree/$d"
-	done
-fi
-all_dirs="$all_dirs $dir_list"
-
-# include/generated/utsversion.h is ignored because it is generated after this
-# script is executed. (utsversion.h is unneeded for kheaders)
-#
-# When Kconfig regenerates include/generated/autoconf.h, its timestamp is
-# updated, but the contents might be still the same. When any CONFIG option is
-# changed, Kconfig touches the corresponding timestamp file include/config/*.
-# Hence, the md5sum detects the configuration change anyway. We do not need to
-# check include/generated/autoconf.h explicitly.
-#
-# Ignore them for md5 calculation to avoid pointless regeneration.
-headers_md5="$(find $all_dirs -name "*.h" -a			\
-		! -path include/generated/utsversion.h -a	\
-		! -path include/generated/autoconf.h		|
-		xargs ls -l | md5sum | cut -d ' ' -f1)"
-
-# Any changes to this script will also cause a rebuild of the archive.
-this_file_md5="$(ls -l $sfile | md5sum | cut -d ' ' -f1)"
-if [ -f $tarfile ]; then tarfile_md5="$(md5sum $tarfile | cut -d ' ' -f1)"; fi
-if [ -f kernel/kheaders.md5 ] &&
-	[ "$(head -n 1 kernel/kheaders.md5)" = "$headers_md5" ] &&
-	[ "$(head -n 2 kernel/kheaders.md5 | tail -n 1)" = "$this_file_md5" ] &&
-	[ "$(tail -n 1 kernel/kheaders.md5)" = "$tarfile_md5" ]; then
-		exit
-fi
-
-echo "  GEN     $tarfile"
+srclist=$2
+objlist=$3
+
+dir=$(dirname "${tarfile}")
+tmpdir=${dir}/.tmp_dir
+depfile=${dir}/.$(basename "${tarfile}").d
+
+# generate dependency list.
+{
+	echo
+	echo "deps_${tarfile} := \\"
+	sed 's:\(.*\):  \1 \\:' "${srclist}"
+	sed -n '/^include\/generated\/autoconf\.h$/!s:\(.*\):  \1 \\:p' "${objlist}"
+	echo
+	echo "${tarfile}: \$(deps_${tarfile})"
+	echo
+	echo "\$(deps_${tarfile}):"
+
+} > "${depfile}"
 
 rm -rf "${tmpdir}"
 mkdir "${tmpdir}"
 
-if [ "$building_out_of_srctree" ]; then
-	(
-		cd $srctree
-		for f in $dir_list
-			do find "$f" -name "*.h";
-		done | tar -c -f - -T - | tar -xf - -C "${tmpdir}"
-	)
-fi
-
-for f in $dir_list;
-	do find "$f" -name "*.h";
-done | tar -c -f - -T - | tar -xf - -C "${tmpdir}"
-
-# Always exclude include/generated/utsversion.h
-# Otherwise, the contents of the tarball may vary depending on the build steps.
-rm -f "${tmpdir}/include/generated/utsversion.h"
+# shellcheck disable=SC2154 # srctree is passed as an env variable
+sed "s:^${srctree}/::" "${srclist}" | tar -c -f - -C "${srctree}" -T - | tar -xf - -C "${tmpdir}"
+tar -c -f - -T "${objlist}" | tar -xf - -C "${tmpdir}"
 
 # Remove comments except SDPX lines
 # Use a temporary file to store directory contents to prevent find/xargs from
@@ -92,8 +46,4 @@ tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
     --owner=0 --group=0 --sort=name --numeric-owner --mode=u=rw,go=r,a+X \
     -I $XZ -cf $tarfile -C "${tmpdir}/" . > /dev/null
 
-echo $headers_md5 > kernel/kheaders.md5
-echo "$this_file_md5" >> kernel/kheaders.md5
-echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
-
 rm -rf "${tmpdir}"
-- 
2.39.5



