Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FBC37757A;
	Sat, 12 Sep 2026 09:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204430; cv=none; b=F2GeM9I+dN0BRZquWs6JazO4Mj1PTaJqOhLXyEFKR6ZBPKYZ//hvaw3zHLyXF0xMufLmsWKx3VgG3RADNy983VOBoiUlXscPVxf2vlZXF5KSS2BhFq1/6ikFPACBky0QfqBS/gkIzTLu0SXhR9LfCexKVlF2z2i9DSptt+zcHEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204430; c=relaxed/simple;
	bh=3u8YVo0EF8nDU+t0Y9wl7zB3jr8HvB6dqX0wCv77BN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbYRLJnKgddlqwzVDWXGwZSyzlD1G+lWDRSIDD3S67LobQNZgeI0iWDlybUFIj4z+lygNpFvV10lWml6pmr/7PPvOftS+naqzv97d9fs9malTVVSCyOFrjZKiFEY3/vqobDixI9urrn+7+ijP2IwF9VhZqNipT5E8hsvZbdAp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMhhQ6wE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMhhQ6wE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72CC1F000FF;
	Sat, 12 Sep 2026 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204429;
	bh=Dp6sTUYgbdGhLezyJUuRAKA5fx2XuY4RpDbucWDYIN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMhhQ6wEjFBydQXygla+j7kCbrxsVJQSyAtOB8qRjAPlD/9QIJI2x/yX4HCzHUOFE
	 E4ngXAyliCg8KTwYlfMPcTp/b9YetpxDcrRqgY0vDrjuO5GHPktvfztFgHEfU0rnRA
	 b6HZ8bcmJtzzWuPZH+aB1H8UJjiFTxA+r8YK2rZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pisit Preechapramoth <kml.delusion501@slmail.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1612/1815] ntfs: reject unprivileged writes to reserved $LX* xattrs
Date: Sat, 12 Sep 2026 08:56:02 +0200
Message-ID: <20260912065726.835792329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Pisit Preechapramoth <kml.delusion501@slmail.me>

[ Upstream commit ea6a67ef64451d2da298f15baa35865b4bb6372a ]

Reject setxattr of the reserved $LXUID, $LXGID, $LXMOD and $LXDEV names
from userspace unless the caller has CAP_SYS_ADMIN.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Pisit Preechapramoth <kml.delusion501@slmail.me>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index a1784c0a725fc..578ee00ea9315 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -751,6 +751,12 @@ static int ntfs_new_attr_flags(struct ntfs_inode *ni, __le32 fattr)
 	return err;
 }
 
+static bool ntfs_is_reserved_lxattr(const char *name)
+{
+	return !strcmp(name, "$LXUID") || !strcmp(name, "$LXGID") ||
+	       !strcmp(name, "$LXMOD") || !strcmp(name, "$LXDEV");
+}
+
 static int ntfs_setxattr(const struct xattr_handler *handler,
 		struct mnt_idmap *idmap, struct dentry *unused,
 		struct inode *inode, const char *name, const void *value,
@@ -763,6 +769,9 @@ static int ntfs_setxattr(const struct xattr_handler *handler,
 	if (NVolShutdown(ni->vol))
 		return -EIO;
 
+	if (ntfs_is_reserved_lxattr(name) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!strcmp(name, SYSTEM_DOS_ATTRIB)) {
 		if (sizeof(u8) != size) {
 			err = -EINVAL;
-- 
2.53.0



