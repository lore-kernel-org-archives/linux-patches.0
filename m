Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE73372B31;
	Wed, 20 May 2026 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301297; cv=none; b=BqdHT5YIIe35UVMYmdyWX8BJZCiKLe3uPLgjylcCzhhvCFnTzWFtjLwPl4/QqvX3JRKa3kL1erna39b7gXvzK9ZXQUviJiPcEeimaULt8lj+Tn8VgvLCZZkiSh1PjftVUMFrRsKB0V5I6OR6WONYky90whEX4KKbeSI9SeGtrhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301297; c=relaxed/simple;
	bh=jJXzHpoeEOYO0l4L4U1WOpTscOCUNOAwdcYei7lFFp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rn3lkK4C9S154YYLC0Jbr6UgHtPcD4jA2LM3lL/4s6FUeK64wnvdX20XT/ffikHx1kFoyM5964Eze3BKpHvPp+3R2ci3TPIgABDuDCKUuO4YXj6pqi9LnhOmzAAtopJt4XrAvoVeELgGtDLGEc/8hryyXAnPJr79Nq5iZSiU5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGKcV/9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGKcV/9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DB71F000E9;
	Wed, 20 May 2026 18:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301296;
	bh=fWk6OXGuOlzrV3nxotl/e5AW3Zt2hBM1rQKQTJyKyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGKcV/9ZuQL6r9O2aE8FbImD4GC3kQVYPotb6QOzOmwqeOsLKEP7abF0mGg6JbSt4
	 IRCvkfJN4AXVs0MhYGFPoqglC5FymoQLGAp51odmCN15IGZLb9Sb/0TP/gGlQCSkzb
	 Fpgiu88drCs5yDUhn10B/ZY+kztwhqMCNWbQHXEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 501/666] kbuild: builddeb - avoid recompiles for non-cross-compiles
Date: Wed, 20 May 2026 18:21:52 +0200
Message-ID: <20260520162122.119607946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Mathias Krause <minipli@grsecurity.net>

[ Upstream commit 2452dcf4d740effff5aa71b7f6529ee8c04fd8f6 ]

Commit e2c318225ac1 ("kbuild: deb-pkg: add
pkg.linux-upstream.nokernelheaders build profile") changed how
install-extmod-build gets called, making it always rebuild the host
programs below scripts/ if HOSTCC wasn't specified with its full triplet
on the make command line. That is, apparently, needed to fix up commit
f1d87664b82a ("kbuild: cross-compile linux-headers package when
possible") for cross-compiles. However, in the much more common case of
non-cross-compile builds this will lead to unnecessary rebuilding of
host tools including gcc plugins. This, in turn, will lead to a full
kernel rebuild on the next 'make bindeb-pkg' which is unfortunate.

Avoid that by only triggering the rebuild of host tools for actual
cross-compile builds.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Fixes: e2c318225ac1 ("kbuild: deb-pkg: add pkg.linux-upstream.nokernelheaders build profile")
Cc: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260402145116.1010901-1-minipli@grsecurity.net
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/builddeb | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index fb686fd3266f0..1d7d4838eebd4 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -125,7 +125,13 @@ install_kernel_headers () {
 	pdir=debian/$1
 	version=${1#linux-headers-}
 
-	CC="${DEB_HOST_GNU_TYPE}-gcc" "${srctree}/scripts/package/install-extmod-build" "${pdir}/usr/src/linux-headers-${version}"
+	# Override $CC only for cross-compiles, to not unnecessarily rebuild
+	# scripts/ including plugins, which may lead to a full kernel rebuild.
+	if [ -n "${CROSS_COMPILE}" ]; then
+		CC="${DEB_HOST_GNU_TYPE}-gcc" "${srctree}/scripts/package/install-extmod-build" "${pdir}/usr/src/linux-headers-${version}"
+	else
+		"${srctree}/scripts/package/install-extmod-build" "${pdir}/usr/src/linux-headers-${version}"
+	fi
 
 	mkdir -p $pdir/lib/modules/$version/
 	ln -s /usr/src/linux-headers-$version $pdir/lib/modules/$version/build
-- 
2.53.0



