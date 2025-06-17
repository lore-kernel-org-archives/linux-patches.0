Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EC72DFF10;
	Tue, 17 Jun 2025 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176405; cv=none; b=Qvjnsq3FILA/4DG7Pj4WvQox46AdUvx28nG9gUrA75Um8vxUWAi5YfxqTukp7RuL/PI2CZ1Ybg2avKQ1+PiwEZ6varPczxPfJRhQiTVhXJQmnGtX/33j73YGWWHszLmCoenfktTtaApCrATB8a/7g6mNzUsonHXBPjVcAHaoQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176405; c=relaxed/simple;
	bh=9tCqIa0oY87+hi2UfkrB7fpl6uxSXwZujsywTM10DrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO6Y6RAxsGDgbOVoSpvGJlMdKofzMh5MwS6OtmE3xjS26PEp/3b0/IceqNSoW+lCu1x2rWkob4gTsONx8XhY4aBu/hZT4hZHWlb4WhCBvsngglaCvj7iEOFRNe9XPkoGJ6VryX6guLP3JFV+d24KeIizGF5Ej1BD7lkDoC6R8iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyB26fgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyB26fgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B68C4CEE3;
	Tue, 17 Jun 2025 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176405;
	bh=9tCqIa0oY87+hi2UfkrB7fpl6uxSXwZujsywTM10DrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyB26fgMIFhjMh1Bx3RvXwNvdfggXhBh7CeX+KpV7jXLaL9oEYsICn8lQ0Z8TycMY
	 rX2l3aPa4IssNVmTjcYymubE+0cnX8Y0MjOWooM2NarKJ0jDcMTqxdhicGw3B01qV4
	 BQWmyW1OBkdq2lGQu+oif3BUcuBZmCP8WRWIkTms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/356] path_overmount(): avoid false negatives
Date: Tue, 17 Jun 2025 17:26:29 +0200
Message-ID: <20250617152349.225203148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 5f31c549382bcddbbd754c72c5433b19420d485d ]

Holding namespace_sem is enough to make sure that result remains valid.
It is *not* enough to avoid false negatives from __lookup_mnt().  Mounts
can be unhashed outside of namespace_sem (stuck children getting detached
on final mntput() of lazy-umounted mount) and having an unrelated mount
removed from the hash chain while we traverse it may end up with false
negative from __lookup_mnt().  We need to sample and recheck the seqlock
component of mount_lock...

Bug predates the introduction of path_overmount() - it had come from
the code in finish_automount() that got abstracted into that helper.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 26df6034fdb2 ("fix automount/automount race properly")
Fixes: 6ac392815628 ("fs: allow to mount beneath top mount")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ef3b2ae2957ec..7942a33451ba0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3020,18 +3020,25 @@ static int do_set_group(struct path *from_path, struct path *to_path)
  * Check if path is overmounted, i.e., if there's a mount on top of
  * @path->mnt with @path->dentry as mountpoint.
  *
- * Context: This function expects namespace_lock() to be held.
+ * Context: namespace_sem must be held at least shared.
+ * MUST NOT be called under lock_mount_hash() (there one should just
+ * call __lookup_mnt() and check if it returns NULL).
  * Return: If path is overmounted true is returned, false if not.
  */
 static inline bool path_overmounted(const struct path *path)
 {
+	unsigned seq = read_seqbegin(&mount_lock);
+	bool no_child;
+
 	rcu_read_lock();
-	if (unlikely(__lookup_mnt(path->mnt, path->dentry))) {
-		rcu_read_unlock();
-		return true;
-	}
+	no_child = !__lookup_mnt(path->mnt, path->dentry);
 	rcu_read_unlock();
-	return false;
+	if (need_seqretry(&mount_lock, seq)) {
+		read_seqlock_excl(&mount_lock);
+		no_child = !__lookup_mnt(path->mnt, path->dentry);
+		read_sequnlock_excl(&mount_lock);
+	}
+	return unlikely(!no_child);
 }
 
 /**
-- 
2.39.5



