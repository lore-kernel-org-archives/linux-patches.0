Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2147080E;
	Mon, 23 Jun 2025 22:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716554; cv=none; b=SxMj5kdZbCqCHXh4kjB53QFkpybg1YIH0QZp17tG+EvVpWvUWpCEK8S79W3fduwXg4NJlJm5IOH5akQjSL+krqxVOO/8kjmcesJb29rr7IWHkg05Y97pmfVudkXacNpczlQZa8h/eS+wXTgW9YmPGpTZRG39bH1hMzjBHNkaDe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716554; c=relaxed/simple;
	bh=dQ9okW+kjNXGwlIW2xQySm/RHqum9EW6qzrHOvgXQdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZtZCrzim+KpTJqv9LBFeN2VvdtsWAkwKKc5DGvaOrgtOmkluAjd7eB8kFvmYQ6k0vNFKs+0aIzZISERCnhUK4kz2OTyuHziZ0H6MR+hWGKsh7j249boZv+nd7MUo9C82ecPo1WX92yP5gdEgcKSCWrxI16C43I6F1vS/SS548w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TylPsCDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TylPsCDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6C5C4CEEA;
	Mon, 23 Jun 2025 22:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716554;
	bh=dQ9okW+kjNXGwlIW2xQySm/RHqum9EW6qzrHOvgXQdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TylPsCDwBDJSHm3Qv5+wuhciEENvHEaVb7kjMqP4leqUob2EP/apuZlanfkXGVH8u
	 5dn74CxKotd43+1Q9WWsOIy3malI+rGGUNM7R3CqQUe3YWBDCfuEhEe9oQEDaKIm05
	 zr5HeFG0Z7Nh7lmBzLcExyd8gfzQxDvEGj4ML9G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Ruben Devos <rdevos@oxya.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 561/592] smb: Log an error when close_all_cached_dirs fails
Date: Mon, 23 Jun 2025 15:08:39 +0200
Message-ID: <20250623130713.786907842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Aurich <paul@darkrain42.org>

commit a2182743a8b4969481f64aec4908ff162e8a206c upstream.

Under low-memory conditions, close_all_cached_dirs() can't move the
dentries to a separate list to dput() them once the locks are dropped.
This will result in a "Dentry still in use" error, so add an error
message that makes it clear this is what happened:

[  495.281119] CIFS: VFS: \\otters.example.com\share Out of memory while dropping dentries
[  495.281595] ------------[ cut here ]------------
[  495.281887] BUG: Dentry ffff888115531138{i=78,n=/}  still in use (2) [unmount of cifs cifs]
[  495.282391] WARNING: CPU: 1 PID: 2329 at fs/dcache.c:1536 umount_check+0xc8/0xf0

Also, bail out of looping through all tcons as soon as a single
allocation fails, since we're already in trouble, and kmalloc() attempts
for subseqeuent tcons are likely to fail just like the first one did.

Signed-off-by: Paul Aurich <paul@darkrain42.org>
Acked-by: Bharath SM <bharathsm@microsoft.com>
Suggested-by: Ruben Devos <rdevos@oxya.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -486,8 +486,17 @@ void close_all_cached_dirs(struct cifs_s
 		spin_lock(&cfids->cfid_list_lock);
 		list_for_each_entry(cfid, &cfids->entries, entry) {
 			tmp_list = kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
-			if (tmp_list == NULL)
-				break;
+			if (tmp_list == NULL) {
+				/*
+				 * If the malloc() fails, we won't drop all
+				 * dentries, and unmounting is likely to trigger
+				 * a 'Dentry still in use' error.
+				 */
+				cifs_tcon_dbg(VFS, "Out of memory while dropping dentries\n");
+				spin_unlock(&cfids->cfid_list_lock);
+				spin_unlock(&cifs_sb->tlink_tree_lock);
+				goto done;
+			}
 			spin_lock(&cfid->fid_lock);
 			tmp_list->dentry = cfid->dentry;
 			cfid->dentry = NULL;
@@ -499,6 +508,7 @@ void close_all_cached_dirs(struct cifs_s
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
+done:
 	list_for_each_entry_safe(tmp_list, q, &entry, entry) {
 		list_del(&tmp_list->entry);
 		dput(tmp_list->dentry);


