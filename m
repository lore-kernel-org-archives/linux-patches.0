Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F596415F29;
	Fri,  4 Sep 2026 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502252; cv=none; b=InUt30C5yemB0g1zj108gl2mTLgjP9p4OPzO9lcYxEklifcG3K9CT39Hh5h45XqH+ySbePn+VRpF3cOTowM49oTryjnwE9J+7nA/S91oAzvyo1WviSN/zakkpP7I5elgYbtfegMw4sQBvT0xmZwoe6Iy0cX2LOEb+djxrVVDUeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502252; c=relaxed/simple;
	bh=FmTJGJw7ekv558FKeNdVnjV3dJZJtQvCq21b5YcAv14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBxLWvaGPJ0WH9fOEQCqrewrSawNzIIxhRJqESxPQkZZzEt3NNURy3zSqneAOvMJvsyyWk+T6qHgo5WsVpq7iFpxjJ8SneZiMUihDAmECZiCPO8dEyeznJI6Fwn/vn02xXY7dq+55QQwWZhaADGWMVX5rBn54XvcjMkLHPjBOaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8pG57jy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8pG57jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B9C1F00A3D;
	Fri,  4 Sep 2026 06:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502251;
	bh=VOHh7pcRsiZxCHGJQpHrMu+TzC4EqPKELJVds01V4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8pG57jygMrSVsFQrd1B8+x9bFbLQwjUhMXM/6rPzB2rdvaU8+7A0+N2U55U2Vu5b
	 EOYNejZh2KQTRi0DSyDTPWWEibKLELkPVGHqk0+U9l3yEZuHnHpK55cw/bULuN4Bzq
	 gvjniyV5MvAUkK7TJIf7NtbK+OI4RJYXVxMYypD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemu Lu <prcups@krgm.moe>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 143/403] fat: restore original value when fat_ent_write failed
Date: Fri,  4 Sep 2026 06:59:06 +0200
Message-ID: <20260904045738.097244822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Yemu Lu <prcups@krgm.moe>

commit 64d9183203eebe33de6188b70a8c1e91f52885db upstream.

fat_ent_write() may have committed the new link to the primary FAT but
then failed on the mirror copy, leaving the chain pointing to new_dclus
even though the caller will free it.  Restore the original value to keep
the chain consistent.

Link: https://lore.kernel.org/20260525085649.781643-1-n05ec@lzu.edu.cn
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yemu Lu <prcups@krgm.moe>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fat/misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -133,7 +133,11 @@ int fat_chain_add(struct inode *inode, i
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
+			int old = ret;
+
 			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
+			if (ret < 0)
+				fat_ent_write(inode, &fatent, old, wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)


