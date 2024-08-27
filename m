Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9EF1E520;
	Tue, 27 Aug 2024 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771308; cv=none; b=plGJ8aDNV6IPX1rtLe7KKki/83iOD+wEipSS4BHxLi0dr4Vf8uBeA7vPol6Jf1/6T82TM74JUOcgB1ZV963cX1CA5t6NfSC6QKtPh8lDx7DMxAOvY/5YtKwtxnzkY+I8QPnWBjeHAjkR04rMEq22KgbsH81lpS/qh4dblAwgFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771308; c=relaxed/simple;
	bh=uNaWvgSxGYRWwvqwNeXnIQyu5dxD7sNcM4j9SL0bdsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFMNQXXd/XJ7aDw50yUxnyZC3DmqdtF2YbB7kdRnfuCa6+5WIWHgXEctUpZjs4AYGzZkTAYJcYPnSze8+Kl2DQ0q8H+A4CdJl424TuV3OUTPQjc10f+tYdhHzQ84fyeMPFRNOXaZPi5VX89w6/B2P4LJ+HbqfqbiwTWZq6syEO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gao+2ZPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gao+2ZPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE3FC61074;
	Tue, 27 Aug 2024 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771308;
	bh=uNaWvgSxGYRWwvqwNeXnIQyu5dxD7sNcM4j9SL0bdsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gao+2ZPX/TnughpPmzAPutiIHLJ2jahlHYAU9Ko2IJ76PF9dMtmetZX327tPfGzgX
	 OGDRGg5gR1azqN22SjxD8Ptcli9n2EwR8czYSwJKRr0m2dyJz5RbvcY6l5xmhDSnmq
	 w33oBmuo/Z1hSaxF0PALa2hVjS9DrbpC0gZnSTac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 149/273] kbuild: merge temporary vmlinux for BTF and kallsyms
Date: Tue, 27 Aug 2024 16:37:53 +0200
Message-ID: <20240827143839.074449294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit b1a9a5e04767e2a78783e19c9e55c25812ceccc3 ]

CONFIG_DEBUG_INFO_BTF=y requires one additional link step.
(.tmp_vmlinux.btf)

CONFIG_KALLSYMS=y requires two additional link steps.
(.tmp_vmlinux.kallsyms1 and .tmp_vmlinux.kallsyms2)

Enabling both requires three additional link steps.

When CONFIG_DEBUG_INFO_BTF=y and CONFIG_KALLSYMS=y, the current build
process is as follows:

    KSYMS   .tmp_vmlinux.kallsyms0.S
    AS      .tmp_vmlinux.kallsyms0.o
    LD      .tmp_vmlinux.btf             # temporary vmlinux for BTF
    BTF     .btf.vmlinux.bin.o
    LD      .tmp_vmlinux.kallsyms1       # temporary vmlinux for kallsyms step 1
    NM      .tmp_vmlinux.kallsyms1.syms
    KSYMS   .tmp_vmlinux.kallsyms1.S
    AS      .tmp_vmlinux.kallsyms1.o
    LD      .tmp_vmlinux.kallsyms2       # temporary vmlinux for kallsyms step 2
    NM      .tmp_vmlinux.kallsyms2.syms
    KSYMS   .tmp_vmlinux.kallsyms2.S
    AS      .tmp_vmlinux.kallsyms2.o
    LD      vmlinux                      # final vmlinux

This is redundant because the BTF generation and the kallsyms step 1 can
be performed against the same temporary vmlinux.

When both CONFIG_DEBUG_INFO_BTF and CONFIG_KALLSYMS are enabled, we can
reduce the number of link steps by one.

This commit changes the build process as follows:

    KSYMS   .tmp_vmlinux0.kallsyms.S
    AS      .tmp_vmlinux0.kallsyms.o
    LD      .tmp_vmlinux1                # temporary vmlinux for BTF and kallsyms step 1
    BTF     .tmp_vmlinux1.btf.o
    NM      .tmp_vmlinux1.syms
    KSYMS   .tmp_vmlinux1.kallsyms.S
    AS      .tmp_vmlinux1.kallsyms.o
    LD      .tmp_vmlinux2                # temporary vmlinux for kallsyms step 2
    NM      .tmp_vmlinux2.syms
    KSYMS   .tmp_vmlinux2.kallsyms.S
    AS      .tmp_vmlinux2.kallsyms.o
    LD      vmlinux                      # final vmlinux

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: 1472464c6248 ("kbuild: avoid scripts/kallsyms parsing /dev/null")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 1e41b330550e6..22d0bc8439863 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -105,11 +105,10 @@ vmlinux_link()
 
 # generate .BTF typeinfo from DWARF debuginfo
 # ${1} - vmlinux image
-# ${2} - file to dump raw BTF data into
 gen_btf()
 {
 	local pahole_ver
-	local btf_data=${2}
+	local btf_data=${1}.btf.o
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -122,8 +121,6 @@ gen_btf()
 		return 1
 	fi
 
-	vmlinux_link ${1}
-
 	info BTF "${btf_data}"
 	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${PAHOLE_FLAGS} ${1}
 
@@ -169,15 +166,13 @@ kallsyms()
 	kallsymso=${2}.o
 }
 
-# Perform one step in kallsyms generation, including temporary linking of
-# vmlinux.
-kallsyms_step()
+# Perform kallsyms for the given temporary vmlinux.
+sysmap_and_kallsyms()
 {
-	kallsyms_vmlinux=.tmp_vmlinux.kallsyms${1}
+	mksysmap "${1}" "${1}.syms"
+	kallsyms "${1}.syms" "${1}.kallsyms"
 
-	vmlinux_link "${kallsyms_vmlinux}"
-	mksysmap "${kallsyms_vmlinux}" "${kallsyms_vmlinux}.syms"
-	kallsyms "${kallsyms_vmlinux}.syms" "${kallsyms_vmlinux}"
+	kallsyms_sysmap=${1}.syms
 }
 
 # Create map file with all symbols from ${1}
@@ -220,11 +215,21 @@ kallsymso=
 strip_debug=
 
 if is_enabled CONFIG_KALLSYMS; then
-	kallsyms /dev/null .tmp_vmlinux.kallsyms0
+	kallsyms /dev/null .tmp_vmlinux0.kallsyms
+fi
+
+if is_enabled CONFIG_KALLSYMS || is_enabled CONFIG_DEBUG_INFO_BTF; then
+
+	# The kallsyms linking does not need debug symbols, but the BTF does.
+	if ! is_enabled CONFIG_DEBUG_INFO_BTF; then
+		strip_debug=1
+	fi
+
+	vmlinux_link .tmp_vmlinux1
 fi
 
 if is_enabled CONFIG_DEBUG_INFO_BTF; then
-	if ! gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
+	if ! gen_btf .tmp_vmlinux1; then
 		echo >&2 "Failed to generate BTF for vmlinux"
 		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"
 		exit 1
@@ -260,14 +265,16 @@ if is_enabled CONFIG_KALLSYMS; then
 	# The kallsyms linking does not need debug symbols included.
 	strip_debug=1
 
-	kallsyms_step 1
+	sysmap_and_kallsyms .tmp_vmlinux1
 	size1=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso})
 
-	kallsyms_step 2
+	vmlinux_link .tmp_vmlinux2
+	sysmap_and_kallsyms .tmp_vmlinux2
 	size2=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso})
 
 	if [ $size1 -ne $size2 ] || [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
-		kallsyms_step 3
+		vmlinux_link .tmp_vmlinux3
+		sysmap_and_kallsyms .tmp_vmlinux3
 	fi
 fi
 
@@ -293,7 +300,7 @@ fi
 
 # step a (see comment above)
 if is_enabled CONFIG_KALLSYMS; then
-	if ! cmp -s System.map ${kallsyms_vmlinux}.syms; then
+	if ! cmp -s System.map "${kallsyms_sysmap}"; then
 		echo >&2 Inconsistent kallsyms data
 		echo >&2 'Try "make KALLSYMS_EXTRA_PASS=1" as a workaround'
 		exit 1
-- 
2.43.0



