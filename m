Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3E815B0FE;
	Tue,  2 Jul 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940357; cv=none; b=fR2dBkcrzDblaCsrVF/EXJ/pGdBPwgSnT6Gr+aHwUqg+kdwQI+UjGpYzdZHZkTwRFP8Z2jgMSMm7XJPwHcJ+3LoKBhNz1cH07XUuUmb/y8rbhwJW9J0LuX1w7W6XTNXoWQWcOH9bXDb/+pN3wsm42gjph94dschAHsj9LUO4qrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940357; c=relaxed/simple;
	bh=9aCDg2uq4h732Ei97rqWYtVfRkp1Zwtq8kaKYblTw+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cioxpGz58xVMexmKcjF6AR+O+y/C/M6RuIXTNWGnEb86Il5xRIfjJYay86webTLeGNTxmRTOpooEGM1q0Eg7jFZfYlRyIXg1lVFLICwODkxZyrs7nJyej2v3aFWG1/q1UZLbxNikynU3fNspghjjRnFUepoW/3IZCbEDEjJ0lYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2Ao7Rx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2Ao7Rx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B92C116B1;
	Tue,  2 Jul 2024 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940357;
	bh=9aCDg2uq4h732Ei97rqWYtVfRkp1Zwtq8kaKYblTw+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2Ao7Rx8X/ExtZWFWTOqRcFoqzia4YAHsmwqkH8qa/6j8aJl3fUSSktiZv/haZwar
	 Gcl1JpFbykXnTaJ/AavDd2Tr6/jZt/+7oB4Ww3EMAGtCGXVnZOikD0vHNRDmKGxdq7
	 qaEajGAYdvio9jq53yTYWMa2+F1kdvE25zs4THE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 131/222] kbuild: rpm-pkg: fix build error with CONFIG_MODULES=n
Date: Tue,  2 Jul 2024 19:02:49 +0200
Message-ID: <20240702170248.976814304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 8d1001f7bdd0553a796998f4fff07ee13e1c1cad ]

When CONFIG_MODULES is disabled, 'make (bin)rpm-pkg' fails:

  $ make allnoconfig binrpm-pkg
    [ snip ]
  error: File not found: .../linux/rpmbuild/BUILDROOT/kernel-6.10.0_rc3-1.i386/lib/modules/6.10.0-rc3/kernel
  error: File not found: .../linux/rpmbuild/BUILDROOT/kernel-6.10.0_rc3-1.i386/lib/modules/6.10.0-rc3/modules.order

To make it work irrespective of CONFIG_MODULES, this commit specifies
the directory path, /lib/modules/%{KERNELRELEASE}, instead of individual
files.

However, doing so would cause new warnings:

  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.alias
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.alias.bin
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.builtin.alias.bin
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.builtin.bin
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.dep
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.dep.bin
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.devname
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.softdep
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.symbols
  warning: File listed twice: /lib/modules/6.10.0-rc3-dirty/modules.symbols.bin

These files exist in /lib/modules/%{KERNELRELEASE} and are also explicitly
marked as %ghost.

Suppress depmod because depmod-generated files are not packaged.

Fixes: 615b3a3d2d41 ("kbuild: rpm-pkg: do not include depmod-generated files")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index e095eb1e290ec..fffc8af8deb17 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -57,7 +57,8 @@ patch -p1 < %{SOURCE2}
 %install
 mkdir -p %{buildroot}/lib/modules/%{KERNELRELEASE}
 cp $(%{make} %{makeflags} -s image_name) %{buildroot}/lib/modules/%{KERNELRELEASE}/vmlinuz
-%{make} %{makeflags} INSTALL_MOD_PATH=%{buildroot} modules_install
+# DEPMOD=true makes depmod no-op. We do not package depmod-generated files.
+%{make} %{makeflags} INSTALL_MOD_PATH=%{buildroot} DEPMOD=true modules_install
 %{make} %{makeflags} INSTALL_HDR_PATH=%{buildroot}/usr headers_install
 cp System.map %{buildroot}/lib/modules/%{KERNELRELEASE}
 cp .config %{buildroot}/lib/modules/%{KERNELRELEASE}/config
@@ -70,10 +71,7 @@ ln -fns /usr/src/kernels/%{KERNELRELEASE} %{buildroot}/lib/modules/%{KERNELRELEA
 %endif
 
 {
-	for x in System.map config kernel modules.builtin \
-			modules.builtin.modinfo modules.order vmlinuz; do
-		echo "/lib/modules/%{KERNELRELEASE}/${x}"
-	done
+	echo "/lib/modules/%{KERNELRELEASE}"
 
 	for x in alias alias.bin builtin.alias.bin builtin.bin dep dep.bin \
 					devname softdep symbols symbols.bin; do
-- 
2.43.0



