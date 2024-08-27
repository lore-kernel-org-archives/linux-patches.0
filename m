Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E51E520;
	Tue, 27 Aug 2024 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771197; cv=none; b=nauMi9ZQeeu1MRVbPwPLzA+AWaAO6JM8oMHCLmu/GID2IEwllAx8EQGd0l7kHo79BvuHkzpYtArHy1qxpf9iN1JFF+zNiU/fs59wizFFCTpD//6zXmc+/xJJ4/tQAW+0Y1pWSK850VfEizDgmsy8ef5OvADRSALYvnCd6Iu45tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771197; c=relaxed/simple;
	bh=fUnaD+ijGIWSHzDmbyZlpWEE1FCqNSkAylJgIngNBcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niqkTQ5gLaJOK+iF3r7DHTZ0CBJmD6nDnQeZiswBDLClNecSZfr4+x/4Mbi/sg1f58/iwGp9kmu5EwI7rKrJDZFSCCP+SRMntavrG8MKP7Q7xJBS2FUOmGWL+BqHCl4jCtywzgNvwSyvUhIdUppgjiNXTK2KqZYwiQwHmtMxLYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt6WNWdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt6WNWdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D794C6107C;
	Tue, 27 Aug 2024 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771197;
	bh=fUnaD+ijGIWSHzDmbyZlpWEE1FCqNSkAylJgIngNBcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt6WNWdTuC9GKkAlxDA1cqTtECY/3qoijS5UAfso/1ZZaOrmdFLnaHvo48wmNCUz3
	 ykEpktOAo+478G+BrdT6KCDD1K1oOzH8QfR3ZgPe9Sad6Yg2UkqFZl5Uf4QhG0rUsB
	 9mrKyoD0QEeuPROgc604OuBsoFlwWaAbwaQhc3d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 116/273] kbuild: refactor variables in scripts/link-vmlinux.sh
Date: Tue, 27 Aug 2024 16:37:20 +0200
Message-ID: <20240827143837.823612182@linuxfoundation.org>
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

[ Upstream commit ddf41329839f49dadf26973cd845ea160ac1784d ]

Clean up the variables in scripts/link-vmlinux.sh

 - Specify the extra objects directly in vmlinux_link()
 - Move the AS rule to kallsyms()
 - Set kallsymso and btf_vmlinux_bin_o where they are generated
 - Remove unneeded variable, kallsymso_prev
 - Introduce the btf_data variable
 - Introduce the strip_debug flag instead of checking the output name

No functional change intended.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Stable-dep-of: 020925ce9299 ("kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 65 +++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 518c70b8db507..3d9d7257143a0 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -45,7 +45,6 @@ info()
 
 # Link of vmlinux
 # ${1} - output file
-# ${2}, ${3}, ... - optional extra .o files
 vmlinux_link()
 {
 	local output=${1}
@@ -90,7 +89,7 @@ vmlinux_link()
 	ldflags="${ldflags} ${wl}--script=${objtree}/${KBUILD_LDS}"
 
 	# The kallsyms linking does not need debug symbols included.
-	if [ "$output" != "${output#.tmp_vmlinux.kallsyms}" ] ; then
+	if [ -n "${strip_debug}" ] ; then
 		ldflags="${ldflags} ${wl}--strip-debug"
 	fi
 
@@ -101,7 +100,7 @@ vmlinux_link()
 	${ld} ${ldflags} -o ${output}					\
 		${wl}--whole-archive ${objs} ${wl}--no-whole-archive	\
 		${wl}--start-group ${libs} ${wl}--end-group		\
-		$@ ${ldlibs}
+		${kallsymso} ${btf_vmlinux_bin_o} ${ldlibs}
 }
 
 # generate .BTF typeinfo from DWARF debuginfo
@@ -110,6 +109,7 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
+	local btf_data=${2}
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -124,16 +124,16 @@ gen_btf()
 
 	vmlinux_link ${1}
 
-	info "BTF" ${2}
+	info BTF "${btf_data}"
 	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${PAHOLE_FLAGS} ${1}
 
-	# Create ${2} which contains just .BTF section but no symbols. Add
+	# Create ${btf_data} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
 	# deletes all symbols including __start_BTF and __stop_BTF, which will
 	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
 	# objcopy warnings: "empty loadable segment detected at ..."
 	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
-		--strip-all ${1} ${2} 2>/dev/null
+		--strip-all ${1} "${btf_data}" 2>/dev/null
 	# Change e_type to ET_REL so that it can be used to link final vmlinux.
 	# GNU ld 2.35+ and lld do not allow an ET_EXEC input.
 	if is_enabled CONFIG_CPU_BIG_ENDIAN; then
@@ -141,10 +141,12 @@ gen_btf()
 	else
 		et_rel='\1\0'
 	fi
-	printf "${et_rel}" | dd of=${2} conv=notrunc bs=1 seek=16 status=none
+	printf "${et_rel}" | dd of="${btf_data}" conv=notrunc bs=1 seek=16 status=none
+
+	btf_vmlinux_bin_o=${btf_data}
 }
 
-# Create ${2} .S file with all symbols from the ${1} object file
+# Create ${2}.o file with all symbols from the ${1} object file
 kallsyms()
 {
 	local kallsymopt;
@@ -165,27 +167,25 @@ kallsyms()
 		kallsymopt="${kallsymopt} --lto-clang"
 	fi
 
-	info KSYMS ${2}
-	scripts/kallsyms ${kallsymopt} ${1} > ${2}
+	info KSYMS "${2}.S"
+	scripts/kallsyms ${kallsymopt} "${1}" > "${2}.S"
+
+	info AS "${2}.o"
+	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
+	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} -c -o "${2}.o" "${2}.S"
+
+	kallsymso=${2}.o
 }
 
 # Perform one step in kallsyms generation, including temporary linking of
 # vmlinux.
 kallsyms_step()
 {
-	kallsymso_prev=${kallsymso}
 	kallsyms_vmlinux=.tmp_vmlinux.kallsyms${1}
-	kallsymso=${kallsyms_vmlinux}.o
-	kallsyms_S=${kallsyms_vmlinux}.S
-
-	vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}
-	mksysmap ${kallsyms_vmlinux} ${kallsyms_vmlinux}.syms
-	kallsyms ${kallsyms_vmlinux}.syms ${kallsyms_S}
 
-	info AS ${kallsymso}
-	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
-	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} \
-	      -c -o ${kallsymso} ${kallsyms_S}
+	vmlinux_link "${kallsyms_vmlinux}"
+	mksysmap "${kallsyms_vmlinux}" "${kallsyms_vmlinux}.syms"
+	kallsyms "${kallsyms_vmlinux}.syms" "${kallsyms_vmlinux}"
 }
 
 # Create map file with all symbols from ${1}
@@ -223,19 +223,18 @@ fi
 
 ${MAKE} -f "${srctree}/scripts/Makefile.build" obj=init init/version-timestamp.o
 
-btf_vmlinux_bin_o=""
+btf_vmlinux_bin_o=
+kallsymso=
+strip_debug=
+
 if is_enabled CONFIG_DEBUG_INFO_BTF; then
-	btf_vmlinux_bin_o=.btf.vmlinux.bin.o
-	if ! gen_btf .tmp_vmlinux.btf $btf_vmlinux_bin_o ; then
+	if ! gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
 		echo >&2 "Failed to generate BTF for vmlinux"
 		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"
 		exit 1
 	fi
 fi
 
-kallsymso=""
-kallsymso_prev=""
-kallsyms_vmlinux=""
 if is_enabled CONFIG_KALLSYMS; then
 
 	# kallsyms support
@@ -261,11 +260,13 @@ if is_enabled CONFIG_KALLSYMS; then
 	# a)  Verify that the System.map from vmlinux matches the map from
 	#     ${kallsymso}.
 
+	# The kallsyms linking does not need debug symbols included.
+	strip_debug=1
+
 	kallsyms_step 1
-	kallsyms_step 2
+	size1=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso})
 
-	# step 3
-	size1=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso_prev})
+	kallsyms_step 2
 	size2=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso})
 
 	if [ $size1 -ne $size2 ] || [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
@@ -273,7 +274,9 @@ if is_enabled CONFIG_KALLSYMS; then
 	fi
 fi
 
-vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
+strip_debug=
+
+vmlinux_link vmlinux
 
 # fill in BTF IDs
 if is_enabled CONFIG_DEBUG_INFO_BTF && is_enabled CONFIG_BPF; then
-- 
2.43.0



