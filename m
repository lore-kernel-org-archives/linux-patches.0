Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D273E5ECF;
	Wed, 20 May 2026 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299315; cv=none; b=OIAjr2N4IpuraXNTbSKzetuwbo8jDMW9mVPWP3tmdTiGUsCG9nCy4yqTcyp4T5L4EKL0K2OK+jOwhK+Sa/XHkyUxqST3nhTiLvcYmVG/XNGb3VPMOPB8DjsZs0WeaYSPEDGOIxF9n5jzAAvMwdEPDLKMGg592c7kJkq4TqPH0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299315; c=relaxed/simple;
	bh=hghlJTZ5y2K1qDtjideBb1iSDWa39GR6AZyHDTihzPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9ihw5yp+lQyegCdxQuLiW3QuxtKC/hj9BwoA0x9Xkg7BIPuI1bPe7k5e6z1YWaWjtNZHzA/LJvuX2RdSLmM+hm78jljDdfeK4bV+/X5qADT9niqyVh/JQbuB7X8lvZTDRvCBC0+bwPA2w1Xbe0AbBwjcRlinL4HZaVs0Xo1szc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Li+mbqQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Li+mbqQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EEA1F000E9;
	Wed, 20 May 2026 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299313;
	bh=/XNB7H1jw9clHUA25BSACTUJF0tQTLJWTGuZAQO5Xt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Li+mbqQq7L7V/Da1zWe7ZCPbF3KflH/D+fT14lIHkvC43hJltwMg1R5au+IGfqYsu
	 rLuS/xUg3Yqv5rg33R2hnnHmfJh86vj4+omDiaIrOdnojuL5XRAwgcQrcIYn7y5avk
	 ays9SX+uz4q5iHTYiyUFcfxQo3HVnCahTo4lqp94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 725/957] kbuild: builddeb - avoid recompiles for non-cross-compiles
Date: Wed, 20 May 2026 18:20:08 +0200
Message-ID: <20260520162150.276541469@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 3627ca227e5a5..ba1defc616524 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -139,7 +139,13 @@ install_kernel_headers () {
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



