Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62D81ADC97;
	Tue, 17 Jun 2025 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177916; cv=none; b=pmWs1Ozy9McOaMA4SLyDEizjKRXYUMSV0iAbxOmRT7cyTBMU6MoxuS0cFB9aPCcLIc4KWaBcRbqujErJG0ZdNji8W/OGkDQCbUANwgs+Vjk5wHsFmv0quVR0gw9x8oiApJOzlLxDvDCCoSFulhRnm7QeITAJhAbK9IdAhA4b+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177916; c=relaxed/simple;
	bh=7q05u2ghaZk6YnJYaCyKAcX4caVVvb5KAVBXHUo2nxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpXzbAyX2/SdzwdxpOD9GBfrkp0jntLk6CZBX1ZcM995QiB7/AfJEsp7TKXq6fbx2wn2CBwUjihObD7okhWCI41U1KDFBizeHWE1k8wVvflYGyJJy6cyOL6cZu6WCOWus+bfDghB8r9DvxeECJhi6uVeeg7wWrnmqyqzg2ZBo0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeqZJTP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeqZJTP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DADC4CEE3;
	Tue, 17 Jun 2025 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177915;
	bh=7q05u2ghaZk6YnJYaCyKAcX4caVVvb5KAVBXHUo2nxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeqZJTP72rjAggbNb+CVOFweeo8XWQRKx+RiUwMGT7R7eMqjUFvLou/q4xa/SwDpZ
	 xxi45a/yOdg6i5WJ3xIbKoWScTaSN8E0jegIddCTlSLR9eujHhs97XRyY7ARFqx/em
	 UBbGo8V8I+Z9vDQNHtKTEHNxS0ptd8a7RfaVT6fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 393/512] path_overmount(): avoid false negatives
Date: Tue, 17 Jun 2025 17:25:59 +0200
Message-ID: <20250617152435.511543354@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c1ac585e41e36..1cb236af29bec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3176,18 +3176,25 @@ static int do_set_group(struct path *from_path, struct path *to_path)
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



