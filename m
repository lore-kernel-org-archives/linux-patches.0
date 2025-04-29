Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFAC1DF73C;
	Tue, 29 Apr 2025 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946604; cv=none; b=ovh383Hg9vg3fGuyYWIbDUhEd0qy5fziWxT/HmMW+6aIbEt4iv/dc9HioPzFWTXgSqMwI4EAbjgWAdljyqBjgON9HZK/0H+bAFl184IO6JP9EhhEaUSHZS8JiVC4exDFauQCYySE8pSPpE5q8mA2XO48Wmr0T7BE7+Ti2bjET5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946604; c=relaxed/simple;
	bh=058q7uj5MdbEx/gZBuQyCmPMQTbIpM0S7XJotAmLuYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlVikunS9oDlVgkTezMMbu+N3B82/5BhzQ5kfnohgqFWv3l8LCz8aaNBqZioUsggf5MMn/dkWzOGxOqRdss4IJH9PUnIIBkX9aASPxYO8Wo0W7n887nZgeODNEO4ldF5FX2z6/h/lsR93GJxkHezidpBzkmOyfNdhJ/WKcF4cJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpC/xfRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpC/xfRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F80EC4CEE3;
	Tue, 29 Apr 2025 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946604;
	bh=058q7uj5MdbEx/gZBuQyCmPMQTbIpM0S7XJotAmLuYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpC/xfRqzOrQUhBpiYvyCIQh+AxMntTG2NY7U4kGDJz+r9OcKD4Qv5EjVbt4YnYli
	 iZqQZmMnk8aiqeLq0DrzGRFUNsT2RTJhZ0Glz5rh/RMqctlVDKrXzl7rd4gU5cLC65
	 3lfH6ot0I69lt9DJnPkybALgGzUQF7valvzb4mwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/286] umount: Allow superblock owners to force umount
Date: Tue, 29 Apr 2025 18:38:34 +0200
Message-ID: <20250429161108.277686156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e1ff7aa34dec7e650159fd7ca8ec6af7cc428d9f ]

Loosen the permission check on forced umount to allow users holding
CAP_SYS_ADMIN privileges in namespaces that are privileged with respect
to the userns that originally mounted the filesystem.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/r/12f212d4ef983714d065a6bb372fbb378753bf4c.1742315194.git.trond.myklebust@hammerspace.com
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7e67db7456b3d..2f97112657adc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1716,6 +1716,7 @@ static inline bool may_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -1725,7 +1726,7 @@ static int can_umount(const struct path *path, int flags)
 		return -EINVAL;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED) /* Check optimistically */
 		return -EINVAL;
-	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+	if (flags & MNT_FORCE && !ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
-- 
2.39.5



