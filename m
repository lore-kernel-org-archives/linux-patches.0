Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB4373BEF;
	Sat, 28 Feb 2026 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301532; cv=none; b=GzsxZmvQKatgxSzcbRvl16gafy2QnApyrvxA1E3lD8qE7l+6qxA4dbrNy2Z9vbfrZ3N51gJQE2wDJVMtAfPMnr1/pI32jGE5Tx+jGj/452JeAlR/BifnFythiZKydDt5T++drMlhJ099zmxSPVrbe14QIqxmcwGGYPDV63TX9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301532; c=relaxed/simple;
	bh=9c42ecIz9hQ9+pcNEMXWiBZo4N95fyeynxQzrsL/Tg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1ZImF95ycucn/IIQzEPdUsUsD5bquLDFzKT6TIylQWD6+Lh8Lo0ZbKzo4Q9biCv1UN6KTNyjtCJb6DEKYGw6AotIJA5+1figjlH4JdoDx6l1QclhnxCdMCQOqgI1lK0+qJrYs4zBAdivdTxqp6oQ5R1B3JQW3/HpQQkZt+DWSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBi039UE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBi039UE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A15C19425;
	Sat, 28 Feb 2026 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301532;
	bh=9c42ecIz9hQ9+pcNEMXWiBZo4N95fyeynxQzrsL/Tg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBi039UEl3j3RxFgwH4xYBMPz3/sBHNBfkrwVi/7TmSJ4q5ZXDh1oV66OWAXVat/v
	 XtDVVCg39TzMhe81E3LEraL+qfM7npZmN993ldU5hLyGOk0J0xbm6icg4nzZRF8jj7
	 dIw3/aD8F6V4seBCRbOjAvr1cb3aUeK40s1UCDFf5Cpf4HS9OOXcv5hgHa8IzF0lfq
	 XN/j0/qVrU5wOCzSK1X2UP3tcVwyv72KM6yFJdMApYnithC14YSwqivvCHzSfPnmtZ
	 TKgp6x/aWXTsbtEhs2+zvRNPICgmy1dIUNHZTzayxcuzVDr47Zpg/MopQtkh9lGbX3
	 Xmgb7vEkIzP3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nathan Chancellor <nathan@kernel.org>,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Juergen Gross <jgross@suse.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 714/752] kbuild: rpm-pkg: Restrict manual debug package creation
Date: Sat, 28 Feb 2026 12:47:05 -0500
Message-ID: <20260228174750.1542406-714-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 6d6b8b0e28c468263d7fcb071e5cb284ae343df2 ]

Commit 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package
manually") moved away from the built-in RPM machinery for generating
-debuginfo packages to a more manual way to be compatible with module
signing, as the built-in machinery strips the modules after the
installation process, breaking the signatures.

Unfortunately, prior to rpm 4.20.0, there is a bug where a custom %files
directive is ignored for a -debuginfo subpackage [1], meaning builds
using older versions of RPM (such as on RHEL9 or RHEL10) fail with:

  Checking for unpackaged file(s): /usr/lib/rpm/check-files .../rpmbuild/BUILDROOT/kernel-6.19.0_dirty-1.x86_64
  error: Installed (but unpackaged) file(s) found:
     /debuginfo.list
     /usr/lib/debug/.build-id/09/748c214974bfba1522d434a7e0a02e2fd7f29b.debug
     /usr/lib/debug/.build-id/0b/b96dd9c7d3689d82e56d2e73b46f53103cc6c7.debug
     /usr/lib/debug/.build-id/0e/979a2f34967c7437fd30aabb41de1f0c8b6a66.debug
    ...

To workaround this, restrict the manual debug info package creation
process to when it is necessary (CONFIG_MODULE_SIG=y) and possible (when
using RPM >= 4.20.0). A follow up change will restore the RPM debuginfo
creation process using a separate internal flag to allow the package to
be built in more situations, as RPM 4.20.0 is a fairly recent version
and the built-in -debuginfo generation works fine when module signing is
disabled.

Cc: stable@vger.kernel.org
Fixes: 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package manually")
Link: https://github.com/rpm-software-management/rpm/commit/49f906998f3cf1f4152162ca61ac0869251c380f [1]
Reported-by: Steve French <smfrench@gmail.com>
Closes: https://lore.kernel.org/CAH2r5mugbrHTwnaQwQiYEUVwbtqmvFYf0WZiLrrJWpgT8iwftw@mail.gmail.com/
Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Tested-by: Steve French <stfrench@microsoft.com>
Tested-by: Juergen Gross <jgross@suse.com>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260210-kbuild-fix-debuginfo-rpm-v1-1-0730b92b14bc@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec |  9 +++++----
 scripts/package/mkspec      | 33 ++++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index 0f1c8de1bd95f..b7deb159f404d 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -47,12 +47,13 @@ This package provides kernel headers and makefiles sufficient to build modules
 against the %{version} kernel package.
 %endif
 
-%if %{with_debuginfo}
+%if %{with_debuginfo_manual}
 %package debuginfo
 Summary: Debug information package for the Linux kernel
 %description debuginfo
 This package provides debug information for the kernel image and modules from the
 %{version} package.
+%define install_mod_strip 1
 %endif
 
 %prep
@@ -67,7 +68,7 @@ patch -p1 < %{SOURCE2}
 mkdir -p %{buildroot}/lib/modules/%{KERNELRELEASE}
 cp $(%{make} %{makeflags} -s image_name) %{buildroot}/lib/modules/%{KERNELRELEASE}/vmlinuz
 # DEPMOD=true makes depmod no-op. We do not package depmod-generated files.
-%{make} %{makeflags} INSTALL_MOD_PATH=%{buildroot} INSTALL_MOD_STRIP=1 DEPMOD=true modules_install
+%{make} %{makeflags} INSTALL_MOD_PATH=%{buildroot} %{?install_mod_strip:INSTALL_MOD_STRIP=1} DEPMOD=true modules_install
 %{make} %{makeflags} INSTALL_HDR_PATH=%{buildroot}/usr headers_install
 cp System.map %{buildroot}/lib/modules/%{KERNELRELEASE}
 cp .config %{buildroot}/lib/modules/%{KERNELRELEASE}/config
@@ -98,7 +99,7 @@ ln -fns /usr/src/kernels/%{KERNELRELEASE} %{buildroot}/lib/modules/%{KERNELRELEA
 	echo "%exclude /lib/modules/%{KERNELRELEASE}/build"
 } > %{buildroot}/kernel.list
 
-%if %{with_debuginfo}
+%if %{with_debuginfo_manual}
 # copying vmlinux directly to the debug directory means it will not get
 # stripped (but its source paths will still be collected + fixed up)
 mkdir -p %{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}
@@ -162,7 +163,7 @@ fi
 /lib/modules/%{KERNELRELEASE}/build
 %endif
 
-%if %{with_debuginfo}
+%if %{with_debuginfo_manual}
 %files -f %{buildroot}/debuginfo.list debuginfo
 %defattr (-, root, root)
 %exclude /debuginfo.list
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index c7375bfc25a9a..1080395ca0e16 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -23,15 +23,42 @@ else
 echo '%define with_devel 0'
 fi
 
+# manually generate -debuginfo package
+with_debuginfo_manual=0
 # debuginfo package generation uses find-debuginfo.sh under the hood,
 # which only works on uncompressed modules that contain debuginfo
 if grep -q CONFIG_DEBUG_INFO=y include/config/auto.conf &&
    (! grep -q CONFIG_MODULE_COMPRESS=y include/config/auto.conf) &&
    (! grep -q CONFIG_DEBUG_INFO_SPLIT=y include/config/auto.conf); then
-echo '%define with_debuginfo %{?_without_debuginfo: 0} %{?!_without_debuginfo: 1}'
-else
-echo '%define with_debuginfo 0'
+	# If module signing is enabled (which may be required to boot with
+	# lockdown enabled), the find-debuginfo.sh machinery cannot be used
+	# because the signatures will be stripped off the modules. However, due
+	# to an rpm bug in versions prior to 4.20.0
+	#
+	#     https://github.com/rpm-software-management/rpm/issues/3057
+	#     https://github.com/rpm-software-management/rpm/commit/49f906998f3cf1f4152162ca61ac0869251c380f
+	#
+	# We cannot provide our own debuginfo package because it does not listen
+	# to our custom files list, failing the build due to unpackaged files.
+	# Manually generate the debug info package if using rpm 4.20.0. If not
+	# using rpm 4.20.0, avoid generating a -debuginfo package altogether,
+	# as it is not safe.
+	if grep -q CONFIG_MODULE_SIG=y include/config/auto.conf; then
+		rpm_ver_str=$(rpm --version 2>/dev/null)
+		# Split the version on spaces
+		IFS=' '
+		set -- $rpm_ver_str
+		if [ "${1:-}" = RPM -a "${2:-}" = version ]; then
+			IFS=.
+			set -- $3
+			rpm_ver=$(( 1000000 * $1 + 10000 * $2 + 100 * $3 + ${4:-0} ))
+			if [ "$rpm_ver" -ge 4200000 ]; then
+				with_debuginfo_manual='%{?_without_debuginfo:0}%{?!_without_debuginfo:1}'
+			fi
+		fi
+	fi
 fi
+echo "%define with_debuginfo_manual $with_debuginfo_manual"
 
 cat<<EOF
 %define ARCH ${ARCH}
-- 
2.51.0

