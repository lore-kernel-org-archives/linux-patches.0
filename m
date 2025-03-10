Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12AEEC5;
	Mon, 10 Mar 2025 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628849; cv=none; b=kXH20hxWMngUZKPvYBfCWBX0AoaNaZDD9qMYpOf5Zv2NeTa4Xi6ZQDdZ8BtuqGwseRhjDVk9X1DM65iQYIo+yIFcleea17hI222mrkVhKkjfzkmtRQTmgfNUB9jhcj9VYWH0xpookYy+t+QcQK0TQ/D2Or55LuTYBj3YptiypRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628849; c=relaxed/simple;
	bh=QZBtaj5FZjeMCPygAih7Mj1l8a7DKogKAZghr/Csz2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i91StpowjqBcy9px/q9PETLcWnMZgt4i8nJAtWN6uhvTEZzzAUhuEriY5ntXWB+12If8BdxoZMR7Pt6o/Kc8X2Gy5xjDNJwT0rgCAbaSUgRr45ET+Az3r87RUXhgIn3p0vyTyXv3MsS4IMgLmeKCzoBU6oKB+DmKE7BUqed6tG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj9+nAEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj9+nAEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0E4C4CEE5;
	Mon, 10 Mar 2025 17:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628849;
	bh=QZBtaj5FZjeMCPygAih7Mj1l8a7DKogKAZghr/Csz2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj9+nAEi3t7wqq7v42J6ZFP0cHIgLK+na3bW3TiJeRD5OXQNvraPCXLDZ2Dbrt+Qd
	 MX2Y92lI61XppNXyhYFjm7UfCPF7Hfbn1unnTd87h5/2i/MH7Y5DA7Lg+qYYJhHWT8
	 rriuiBdUo9QKBIzhsG6n7p6VKs01ExeExGylOj1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/620] padata: fix sysfs store callback check
Date: Mon, 10 Mar 2025 17:58:57 +0100
Message-ID: <20250310170549.174153003@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 39faea30d76a5..a5699c5ba58da 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -959,7 +959,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



