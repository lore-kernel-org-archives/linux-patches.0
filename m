Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568D537C92C;
	Thu, 30 Jul 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425850; cv=none; b=EbS2D9GNUTEhi4XAw16K6Ylc0Sy+BBy1v+76S+vUE4luwEj/R3ooCFCZew1jeisqSveNa4jZJRZJR5eV4SvUuuNfXVzSo9hETUA7zzD2rGLeOu+NxE91Ck9qZdFv3vV+Xr85kSs1LKqVwtFRWSx5x7nEcANhlg9GuA94TAdTZpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425850; c=relaxed/simple;
	bh=zga4imTGSmXVfsVBqo77EdNDj/1RFMMUUYXWpAauafk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFL3uwCqvz0Ry/ErJTJd8wR+yh0ZjdOI2IpSyaiQgHf6pzQjH/Y3ljRCxqeSTQ1RHRzGogpiLdT2RGmsoVcU5TURGfAs+QQhAycKC9tcqyV+dMUF04Hiq9KhxQCv8JxPedYOMDeZe9ULDsHGglcFiaG3Gc4iiVwMvFP3hyclxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maAGa62T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maAGa62T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ADA1F000E9;
	Thu, 30 Jul 2026 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425849;
	bh=K+Zs1XKvR6x9C8UI9N5crftPYtfe+ui+zfPi/1zvEU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maAGa62TOaGpccRZZYyGJjQuSEGoQh2MKeyErYHAGkaVCuuL4NDvUzc1nY8tZQKSN
	 3O7LtdRENKuoDPhTrnxLkEmB/fKtQ2ZtjOyGSlZ4pz71M3tsB0+N4CYnc6HNn0poqd
	 IYtxJl44c9c8aEl9ZUPP06cdhxncosTRNYfFGVuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/602] ovl: fix trusted xattr escape prefix matching
Date: Thu, 30 Jul 2026 16:10:05 +0200
Message-ID: <20260730141440.430555450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit a8e72879cd0d8422c0b47d6d3c1802274fe73b98 ]

In the trusted.* xattr namespace, ovl_is_escaped_xattr() compares
one byte less than the escaped overlay xattr prefix length. This makes
it match "trusted.overlay.overlay" without requiring the trailing dot.

As a result, an xattr such as "trusted.overlay.overlayfoo" is
incorrectly treated as an escaped overlay xattr. This can be reproduced
by setting "trusted.overlay.overlayfoo" on a lower file and listing xattrs
through an overlay mount. listxattr() then exposes it as
"trusted.overlay.oo", and a following getxattr() on that listed name fails
with ENODATA.

Compare the full escaped prefix, including the trailing dot, so
similarly-prefixed private xattrs are not misclassified.

Fixes: dad02fad84cbc ("ovl: Support escaped overlay.* xattrs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260708082221.633602-1-chenyichong@uniontech.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/xattrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index 383978e4663c2a..6ba79ee00f7370 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -13,7 +13,7 @@ static bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
 			       OVL_XATTR_ESCAPE_USER_PREFIX_LEN) == 0;
 	else
 		return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
-			       OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1) == 0;
+			       OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN) == 0;
 }
 
 static bool ovl_is_own_xattr(struct super_block *sb, const char *name)
-- 
2.53.0



