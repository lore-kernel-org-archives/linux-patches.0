Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3619261B91;
	Wed,  4 Feb 2026 15:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219030; cv=none; b=d0YGiEOqSjv3XjOqzGWBdthYRDdTe69ZMXt4RQ+M8A0BIcEKcZav8GBdwqxyoMlkYHgLxD/Pw2Ij0qJLczWxgOyiCtkjWC5ao7C/8IMBMd5UdL1IrcoEt2tGV1e+dMNxk0ROhGjrojvuaCHqlSzYrVKnQRter60Fyjq9kRP1Imo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219030; c=relaxed/simple;
	bh=Ylyf5DCCueSe27sPGfvsDOQt5k/JNbPx9xhLBYpzfq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzHzt5YZ6VVSrTFGQISNu+OpF7/w1g/luxc3V9aD/ZKH00PMLyKwkuhGv4h8/0GAlvMDVHJbiLHViOJMpaqSMmphbvJc+3RcHsZG2gNLHvW7YPG9B4z+I21zQuQ6nrGT1ntHDoZMvuQfAMiYmHKNIDvLXxf+ZzFAyHTKFvCLdqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNi+qvIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNi+qvIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A701C4CEF7;
	Wed,  4 Feb 2026 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219030;
	bh=Ylyf5DCCueSe27sPGfvsDOQt5k/JNbPx9xhLBYpzfq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNi+qvIbhaDb5UQsbnSnXC5Y17T2bvgjcNPl7UaNGOXmsL3Enn58IFQElaqD3jKuV
	 blfxtRxEdh62t2sFVBQQd0U1XZ8RdPyAKK9ji3r9ToNaOg5k+zuJ2cIvxDWPHx09Wr
	 EOkqWalt9J39r1qbVu8NC2bSaShA15pk7YoMOJBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Kiehl <Holger.Kiehl@dwd.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/122] kbuild: rpm-pkg: Generate debuginfo package manually
Date: Wed,  4 Feb 2026 15:40:28 +0100
Message-ID: <20260204143853.515965893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 62089b804895e845f82e132ea9d46a1fc53ed5a7 ]

Commit a7c699d090a1 ("kbuild: rpm-pkg: build a debuginfo RPM") adjusted
the __spec_install_post macro to include __os_install_post, which runs
brp-strip. This ends up stripping module signatures, breaking loading
modules with lockdown enabled.

Undo most of the changes of the aforementioned debuginfo patch and
mirror commit 16c36f8864e3 ("kbuild: deb-pkg: use build ID instead of
debug link for dbg package") in kernel.spec to generate a functionally
equivalent debuginfo package while avoiding touching the modules after
they have already been signed during modules_install.

Fixes: a7c699d090a1 ("kbuild: rpm-pkg: build a debuginfo RPM")
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Closes: https://lore.kernel.org/68c375f6-e07e-fec-434d-6a45a4f1390@praktifix.dwd.de/
Tested-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260121-fix-module-signing-binrpm-pkg-v1-1-8fc5832b6cbc@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec | 65 +++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index 98f206cb7c607..0f1c8de1bd95f 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -2,6 +2,8 @@
 %{!?_arch: %define _arch dummy}
 %{!?make: %define make make}
 %define makeflags %{?_smp_mflags} ARCH=%{ARCH}
+%define __spec_install_post /usr/lib/rpm/brp-compress || :
+%define debug_package %{nil}
 
 Name: kernel
 Summary: The Linux Kernel
@@ -46,34 +48,12 @@ against the %{version} kernel package.
 %endif
 
 %if %{with_debuginfo}
-# list of debuginfo-related options taken from distribution kernel.spec
-# files
-%undefine _include_minidebuginfo
-%undefine _find_debuginfo_dwz_opts
-%undefine _unique_build_ids
-%undefine _unique_debug_names
-%undefine _unique_debug_srcs
-%undefine _debugsource_packages
-%undefine _debuginfo_subpackages
-%global _find_debuginfo_opts -r
-%global _missing_build_ids_terminate_build 1
-%global _no_recompute_build_ids 1
-%{debug_package}
+%package debuginfo
+Summary: Debug information package for the Linux kernel
+%description debuginfo
+This package provides debug information for the kernel image and modules from the
+%{version} package.
 %endif
-# some (but not all) versions of rpmbuild emit %%debug_package with
-# %%install. since we've already emitted it manually, that would cause
-# a package redefinition error. ensure that doesn't happen
-%define debug_package %{nil}
-
-# later, we make all modules executable so that find-debuginfo.sh strips
-# them up. but they don't actually need to be executable, so remove the
-# executable bit, taking care to do it _after_ find-debuginfo.sh has run
-%define __spec_install_post \
-	%{?__debug_package:%{__debug_install_post}} \
-	%{__arch_install_post} \
-	%{__os_install_post} \
-	find %{buildroot}/lib/modules/%{KERNELRELEASE} -name "*.ko" -type f \\\
-		| xargs --no-run-if-empty chmod u-x
 
 %prep
 %setup -q -n linux
@@ -87,7 +67,7 @@ patch -p1 < %{SOURCE2}
 mkdir -p %{buildroot}/lib/modules/%{KERNELRELEASE}
 cp $(%{make} %{makeflags} -s image_name) %{buildroot}/lib/modules/%{KERNELRELEASE}/vmlinuz
 # DEPMOD=true makes depmod no-op. We do not package depmod-generated files.
-%{make} %{makeflags} INSTALL_MOD_PATH=%{buildroot} DEPMOD=true modules_install
+%{make} %{makeflags} INSTALL_MOD_PATH=%{buildroot} INSTALL_MOD_STRIP=1 DEPMOD=true modules_install
 %{make} %{makeflags} INSTALL_HDR_PATH=%{buildroot}/usr headers_install
 cp System.map %{buildroot}/lib/modules/%{KERNELRELEASE}
 cp .config %{buildroot}/lib/modules/%{KERNELRELEASE}/config
@@ -118,22 +98,31 @@ ln -fns /usr/src/kernels/%{KERNELRELEASE} %{buildroot}/lib/modules/%{KERNELRELEA
 	echo "%exclude /lib/modules/%{KERNELRELEASE}/build"
 } > %{buildroot}/kernel.list
 
-# make modules executable so that find-debuginfo.sh strips them. this
-# will be undone later in %%__spec_install_post
-find %{buildroot}/lib/modules/%{KERNELRELEASE} -name "*.ko" -type f \
-	| xargs --no-run-if-empty chmod u+x
-
 %if %{with_debuginfo}
 # copying vmlinux directly to the debug directory means it will not get
 # stripped (but its source paths will still be collected + fixed up)
 mkdir -p %{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}
 cp vmlinux %{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}
+
+echo /usr/lib/debug/lib/modules/%{KERNELRELEASE}/vmlinux > %{buildroot}/debuginfo.list
+
+while read -r mod; do
+	mod="${mod%.o}.ko"
+	dbg="%{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}/kernel/${mod}"
+	buildid=$("${READELF}" -n "${mod}" | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p')
+	link="%{buildroot}/usr/lib/debug/.build-id/${buildid}.debug"
+
+	mkdir -p "${dbg%/*}" "${link%/*}"
+	"${OBJCOPY}" --only-keep-debug "${mod}" "${dbg}"
+	ln -sf --relative "${dbg}" "${link}"
+
+	echo "${dbg#%{buildroot}}" >> %{buildroot}/debuginfo.list
+	echo "${link#%{buildroot}}" >> %{buildroot}/debuginfo.list
+done < modules.order
 %endif
 
 %clean
 rm -rf %{buildroot}
-rm -f debugfiles.list debuglinks.list debugsourcefiles.list debugsources.list \
-	elfbins.list
 
 %post
 if [ -x /usr/bin/kernel-install ]; then
@@ -172,3 +161,9 @@ fi
 /usr/src/kernels/%{KERNELRELEASE}
 /lib/modules/%{KERNELRELEASE}/build
 %endif
+
+%if %{with_debuginfo}
+%files -f %{buildroot}/debuginfo.list debuginfo
+%defattr (-, root, root)
+%exclude /debuginfo.list
+%endif
-- 
2.51.0



