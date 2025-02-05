Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F26119006B;
	Wed,  5 Feb 2025 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766537; cv=none; b=s9D/lSbsiSDuNXSvqKjDxeAZFdEYX+4qm7VLCUuyulzTKLmnqmeQY+KXJ0xeJZSe5Wb5o1wjKd9Hk1UuQLOAJFxu513iTiTPHrQ7P7pHGnX2nJrhB4sel10BojWo0K6aR8wsHl6OOXnEw5p0cjs/uRzZ4z+uaNnQ5Z5ljF4Y2/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766537; c=relaxed/simple;
	bh=KzDya19lkhBgG4WLjsynJEcvNtB5/we+zegJWMe9b0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nln3M4LvPbhQX51jnK/Hdfa7eL8zzwuXIIvdmdmH7sKL36Sk6rAbmAkjmequPSEVLzpRAjhK1hcP1baE89K6B3nDr7vMgQd5n6Z07PP6Y7QFJ6Ih02rTsh3BIf8f9rG9pFVkCJz0B0d1D6TNXdcut44+2Bihg1SkM1xyvJXHRWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv3/VDvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv3/VDvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B420C4CED6;
	Wed,  5 Feb 2025 14:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766536;
	bh=KzDya19lkhBgG4WLjsynJEcvNtB5/we+zegJWMe9b0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fv3/VDvEwzO8oL/3pXttP+z5jKUnq2unx4zoJZpYBugVSa+nNJmRADVgifN1CrnSm
	 IdD31bdOSTNdgJiblQt1zwX+kaeLFsFaQrBid4+wvyYOXPa/XWBwzrUYJXfskkkjMk
	 y4HVkkQsYFzTPRVkm5WOCvS59+lT41DHtb5bqLas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 285/623] padata: fix sysfs store callback check
Date: Wed,  5 Feb 2025 14:40:27 +0100
Message-ID: <20250205134507.134122755@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9ff6e943bce67d125781fe4780a5d6f072dc44c0 ]

padata_sysfs_store() was copied from padata_sysfs_show() but this check
was not adapted. Today there is no attribute which can fail this
check, but if there is one it may as well be correct.

Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d51bbc76b2279..cf63d9bcf4822 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -970,7 +970,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



