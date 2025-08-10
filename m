Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD04430;
	Sun, 10 Aug 2025 00:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785273; cv=none; b=fokrFRIdjKU75yadgFmEdBe4aBfAzVgj2dFfmwE7by/l+Qb0nO+tEdXjvJ4LphoxIlg8JBVSu/J+jxvHyK3FQQz/TP4jPXSFXLYttyA6osMRgto13u/VVvMTrQLGXhYZR9Hqsnfo+ngyvLlM+6K4ULJ8WuKqIjO3J3Bnnx/nyIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785273; c=relaxed/simple;
	bh=7dIv0wfmhYkmSbTudsHYdoZDkT/OVAuCk/MteOLRFZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwwUCFmBxcSpu0AonJItRktDzn/oDcHi+PBxp2MAIbVyYNennUlXndCTLxwcPPKMpowQgbTJdwwve/c5zrBBp9b6jVdBcN7v9cUOlpoGUJLa+YIBhl+o0CaLoO9b4LI48+gYkAv79dVCtMKwpSs1r9AOVQx4AUQjdBosdon63E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGbh6hYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGbh6hYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D7AC4CEE7;
	Sun, 10 Aug 2025 00:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785272;
	bh=7dIv0wfmhYkmSbTudsHYdoZDkT/OVAuCk/MteOLRFZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGbh6hYRczHHgyDDeacIjLrzawcNLR9E+8I+Ebe79GUNOXWZiJeuprT1A7ol0h3mN
	 q7ETO0w81BC60ZybRg3Ae7hqqwKzXMZIj/zaezqjCaCIy5o6GcLdq2vywmb3p5/oHl
	 luBL2CkArtH4sqkbaL/1H/ZaxUcw0utjybbWO8//ry9OgyTGmFYhXm5gkQ/9j7z1PO
	 uf+d+WakyY0kX+DsS1b1E1zh+gBgSqzCOJwCvKsA5pmsdlMnFxVpIv3TJ/kysU8/r+
	 +SgtCIa0Hxx4f4OsO0ycqDgMVmh8yMMlqmn0EgjUezmGrGTJiGzVmOcXckEmJZkjXP
	 i4if1NJxNzupw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	akpm@linux-foundation.org,
	jpoimboe@kernel.org,
	kees@kernel.org,
	rppt@kernel.org,
	graf@amazon.com,
	thomas.weissschuh@linutronix.de,
	sam@gentoo.org,
	mgorny@gentoo.org,
	dhowells@redhat.com,
	elsk@google.com
Subject: [PATCH AUTOSEL 6.16-6.15] kheaders: rebuild kheaders_data.tar.xz when a file is modified within a minute
Date: Sat,  9 Aug 2025 20:20:51 -0400
Message-Id: <20250810002104.1545396-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Nature
The commit fixes a genuine bug where header file modifications fail to
trigger a rebuild of `kheaders_data.tar.xz` when changes occur within
the same minute. This is a **reliability issue** that affects the
correctness of the kernel build system, particularly for
CONFIG_IKHEADERS functionality.

## Specific Problem Being Fixed
The previous implementation had a **race condition** where:
- The MD5 hash was calculated from `ls -l` output which shows
  modification times with minute-level granularity
- If a file was modified within the same minute without changing its
  size, the MD5 hash wouldn't change
- This caused the build system to miss legitimate file changes,
  resulting in stale header archives

## Impact on Users
This bug directly affects:
1. Kernel developers doing incremental builds
2. Tools and scripts that rely on CONFIG_IKHEADERS having accurate
   header information
3. Automated build systems that may make rapid successive changes

## Size and Complexity Analysis
The changes are:
- **Contained to a single subsystem** (kheaders build infrastructure)
- **Relatively small** (3 files, +66/-77 lines net change)
- **Uses standard Kbuild mechanisms** - the fix replaces the custom
  MD5-based change detection with Make's standard dependency tracking
  via `.cmd` files
- **No architectural changes** - just improves the existing build
  dependency tracking

## Risk Assessment
The fix has **minimal regression risk** because:
1. It replaces a brittle custom mechanism with the well-tested standard
   Kbuild dependency tracking
2. The changes are isolated to the kheaders build process
3. It doesn't affect runtime behavior, only build-time behavior
4. The new implementation is actually simpler and more maintainable than
   the old one

## Code Quality Improvements
The commit also brings these benefits:
- Removes 77 lines of complex shell script logic
- Uses standard Make dependency files (`.kheaders_data.tar.xz.cmd`)
- Properly tracks both source files (`kheaders-srclist`) and object
  files (`kheaders-objlist`)
- More reliable change detection using file timestamps rather than MD5
  of `ls -l` output

## Stable Tree Criteria
This commit meets stable tree requirements:
- ✅ Fixes a real bug that affects users (incremental builds failing to
  detect changes)
- ✅ Small and contained changes
- ✅ No new features introduced
- ✅ Uses existing, proven mechanisms (standard Make dependency tracking)
- ✅ Low risk of regression
- ✅ Clear reproduction steps provided in commit message

The commit is particularly important for stable because build system
reliability is crucial for kernel development workflows, and this bug
could lead to subtle issues where developers think they're testing
updated headers when they're actually using stale ones.

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
index 32e80dd626af..9a9ff405ea89 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -158,11 +158,48 @@ filechk_cat = cat $<
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

