Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C144D15218A;
	Tue,  2 Jul 2024 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940980; cv=none; b=D3ZyYIB+lWXMp1xgy+6Q2T9Fg6IrCqrC0JWMhW8yqowfxpNr9/BVQ7M9RWoTPirQga8xSjLNh25OB/3kpRGSmSWfiTqoHQfV3aLa12yEeTOL8apk9MV4oNRbTSz2ofIpdiHGu3ojr/xvTVIyImOpXx3fUFrKdTgWerH49EPFKrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940980; c=relaxed/simple;
	bh=dMNmQElDCd68BUT/pifpch407bp6yypIsQ804p7uGlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g113eruS66/kzLdTHPTW47LN8tU34i0327+w1oet31V+R4dpke5tGUO58Pnj5Qq8z1nD6Ij5GX2ZP5L9et08c7zL9us4d2i+Hb07MhAEa/27hll8DzOuH0xvKfz0Nl4eVKzzUIfdOKPGxeNVSP6jF6bvzTD27o0LXajDBrQZ7s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNtBOkIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNtBOkIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315BAC116B1;
	Tue,  2 Jul 2024 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940980;
	bh=dMNmQElDCd68BUT/pifpch407bp6yypIsQ804p7uGlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNtBOkIt+iWACbQzguZZt5UKhWdVQ7vJEQbgJqalbWSOZCjlDEaKekGBLf8Slcu+A
	 GRYZueP7ARkkXoRUMcJSF6YxArRFNT+ot44pc5grB8DxmrPdQInAXMMhsib95l5eTS
	 IgPmvUhLM/TAQuvK3rCocv0VbNv5d9reScObDqko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thayne Harbaugh <thayne@mastodonlabs.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/163] kbuild: Fix build target deb-pkg: ln: failed to create hard link
Date: Tue,  2 Jul 2024 19:03:27 +0200
Message-ID: <20240702170236.582783899@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thayne Harbaugh <thayne@mastodonlabs.com>

[ Upstream commit c61566538968ffb040acc411246fd7ad38c7e8c9 ]

The make deb-pkg target calls debian-orig which attempts to either
hard link the source .tar to the build-output location or copy the
source .tar to the build-output location.  The test to determine
whether to ln or cp is incorrectly expanded by Make and consequently
always attempts to ln the source .tar.  This fix corrects the escaping
of '$' so that the test is expanded by the shell rather than by Make
and appropriately selects between ln and cp.

Fixes: b44aa8c96e9e ("kbuild: deb-pkg: make .orig tarball a hard link if possible")
Signed-off-by: Thayne Harbaugh <thayne@mastodonlabs.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.package | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.package b/scripts/Makefile.package
index 2bcab02da9653..a16d60a4b3fd7 100644
--- a/scripts/Makefile.package
+++ b/scripts/Makefile.package
@@ -126,7 +126,7 @@ debian-orig: private version = $(shell dpkg-parsechangelog -S Version | sed 's/-
 debian-orig: private orig-name = $(source)_$(version).orig.tar$(debian-orig-suffix)
 debian-orig: mkdebian-opts = --need-source
 debian-orig: linux.tar$(debian-orig-suffix) debian
-	$(Q)if [ "$(df  --output=target .. 2>/dev/null)" = "$(df --output=target $< 2>/dev/null)" ]; then \
+	$(Q)if [ "$$(df  --output=target .. 2>/dev/null)" = "$$(df --output=target $< 2>/dev/null)" ]; then \
 		ln -f $< ../$(orig-name); \
 	else \
 		cp $< ../$(orig-name); \
-- 
2.43.0



