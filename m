Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC2243F097;
	Thu, 30 Jul 2026 14:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422028; cv=none; b=PzF1nvbji3LUCI/F0x5HkVF1N4K4o30d4ezvjURVMlaIimJvbvyU5nHOEjf+PXoSZjiKERi79Im5Np8XfXbIt/ogXWywazpRuuXZ4N1wbwXC3MLsCX+5FDWkqXtL2UTkMrQQsCz5hM+5DadQVY1IbMj0FkkFyuLpbhSqBo9CcwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422028; c=relaxed/simple;
	bh=KhlHx27T0tjYKGRf1njXbun79qtsPaC5YhTchTQlWjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJDZ19/Qy2icqFWoxxHqmuPoCyHD1qaqgxvEk0IME7TkF3QFhsw3/VwV1qDH1JgsmuQVPFssUzfffkCjU7DrEWyd5F4LctyJpYdoTAZ0Scf8cwJJgsg16f2avPYooTOqyXukIFWSFHro9svbJ6MEnpnoj4mmEEqlhlBkX05HMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGNW2ef4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGNW2ef4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E761F000E9;
	Thu, 30 Jul 2026 14:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422026;
	bh=jLE+ViAHGVeJTySqFqtzbYRFtsiyBcTJRHeo6jNMqaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGNW2ef4ZG4S50MoOe9Nwz+lYMMxs7Aw8H3zH/9NXP6lLup4gOTmA6WjejDs51D+4
	 nsXGKZt81mr9w574y25A+idxYigDGqNlrEEITH6f2OWdn9JnMyQEE79LJ4o8g5c0lM
	 Mh67FHwGCCXdOFKzfYwRFYLngkQvGJ3SutmI4Id8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 299/744] ovl: fix trusted xattr escape prefix matching
Date: Thu, 30 Jul 2026 16:09:32 +0200
Message-ID: <20260730141450.647992905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa95855c70237b..859e80ae6f4057 100644
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



