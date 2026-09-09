Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B57576ECB;
	Wed,  9 Sep 2026 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962998; cv=none; b=G/JpQTm3fWt+pAzvIpbXdjBIaHwG1H2r63tKMwtHVxWBRJ4QpA3L4T+9929LSoQlJwgSyzVeflH6HouVV4xaiOmMC4eJJMDxLzPzq9uKtsfo0PFMwuRh9nxI67Ew2KaUk4NAyaU+tLZXRHrRLpngCuvs9QRwrRRF6C0rAqkIRo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962998; c=relaxed/simple;
	bh=O+mZFJwOsoo46Qb3OWZWVDaY/McDUIe2CnJkkCom/eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv0wO+NWd1xqkupTrTRweuFBf2jdfdwm59NCF06mkCvKuQAihCU3dy0+3Bq1GZKwdNIHa7pJqlzxjIUViIT4rcAFcuS0xwU56b2U1nGuNklCsAWk8IoKQ1m9OHa8ghbeY87K/g5AADToR2jAizurUdZqO5GJBBQhi5HYu2TK8TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCfv7OVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCfv7OVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0797D1F00A3A;
	Wed,  9 Sep 2026 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962997;
	bh=6N0quSgp8yPXY7ib7zRlZfNaOHq0VskP5fkWkOQ0aq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCfv7OVvpBOXur+G9oLCvjeLosJIka44Yr0+kKAgOYYlJG6TM76ocPefcI0QgU1nL
	 PzDbXulrqGKQbiy8zndaQ60FHp6Ao9O/G+WHerXR1afmwxAIU6HuioY1a2G2HXXOUq
	 O0lFj8jnlTtaca7YcjLdsq5t6/u3GA7Y+NQJull8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 452/556] f2fs: use the mount idmap for the owner check in f2fs_xattr_advise_set()
Date: Wed,  9 Sep 2026 15:42:12 +0200
Message-ID: <20260909134246.478419431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit a54ffce4637acb0db8e695188a6c7f99f14c3576 upstream.

f2fs_xattr_advise_set() calls inode_owner_or_capable() with &nop_mnt_idmap
before allowing the "system.advise" xattr to be set, instead of the idmap
that the VFS passes to the ->set() handler.

f2fs supports idmapped mounts, so on such a mount this checks the caller's
fsuid against the unmapped on-disk owner rather than the mapped owner: the
actual owner can be wrongly denied with -EPERM and an unrelated caller
wrongly allowed.  Pass the handler's idmap instead.

Fixes: 01beba7957a2 ("fs: port inode_owner_or_capable() to mnt_idmap")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Acked-by: Christian Brauner (Amutable) <braurg>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -119,7 +119,7 @@ static int f2fs_xattr_advise_set(const s
 	unsigned char old_advise = F2FS_I(inode)->i_advise;
 	unsigned char new_advise;
 
-	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
 	if (value == NULL)
 		return -EINVAL;


