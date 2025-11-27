Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DBF286416;
	Thu, 27 Nov 2025 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255129; cv=none; b=Snh4SCmdT4Os9BMgkjOo3wws0quIoiSgGBTgyrExuI65atKiJjWdtSgRl4hh12seY7V7GEewCK3VmXU3JkPkUK9Vf56sKQfxlIcXH/n+FS6hXdhbxueBXsth+rZi3FfPUesGmjbJm+zGATsMcxpGS03jyVgZG9C0AolFxLjZqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255129; c=relaxed/simple;
	bh=0IfAz7slasUxkOA4w4xjdJBl917UNdsc5mnCijYVf0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLZwwT4rZIM2Tokr8huoXn2kr11/AwC/eXfQYEXVpKixO2OSUpsqeG8y1B8GsNQlBCZP7WsFZKXDB+XtZy8lYXe0e5FZvAKA/wKhsl8bQx4LuFVF86JaTFJHvqqKV+dkjHZ6n79wrkfs3RsqH/olaVKDpCYhVHJGcEGGu7v094Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gkze1bPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gkze1bPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31EAC113D0;
	Thu, 27 Nov 2025 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255129;
	bh=0IfAz7slasUxkOA4w4xjdJBl917UNdsc5mnCijYVf0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gkze1bPWxsqdsMu7qtpl0af+bWKJrQdcrKCtuwmiDZ8/8SjOq9A/9NUodc/QB/tUe
	 Rp5ksuIlrc01WlwRyV8axuYZmEOHLz4APRQkOL92lE471tywB/B4PMDjYAhpv7OHfP
	 5/XJ8bwLEd1BrY1AROZeNek/QUFKv3qXYjGUDL4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 018/112] smb: client: introduce close_cached_dir_locked()
Date: Thu, 27 Nov 2025 15:45:20 +0100
Message-ID: <20251127144033.401440064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit a9d1f38df7ecd0e21233447c9cc6fa1799eddaf3 upstream.

Replace close_cached_dir() calls under cfid_list_lock with a new
close_cached_dir_locked() variant that uses kref_put() instead of
kref_put_lock() to avoid recursive locking when dropping references.

While the existing code works if the refcount >= 2 invariant holds,
this area has proven error-prone. Make deadlocks impossible and WARN
on invariant violations.

Cc: stable@vger.kernel.org
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,6 +16,7 @@ static struct cached_fid *init_cached_di
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
+static void close_cached_dir_locked(struct cached_fid *cfid);
 
 struct cached_dir_dentry {
 	struct list_head entry;
@@ -362,7 +363,7 @@ out:
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			close_cached_dir(cfid);
+			close_cached_dir_locked(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
@@ -448,18 +449,52 @@ void drop_cached_dir_by_name(const unsig
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		close_cached_dir(cfid);
+		close_cached_dir_locked(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
 }
 
-
+/**
+ * close_cached_dir - drop a reference of a cached dir
+ *
+ * The release function will be called with cfid_list_lock held to remove the
+ * cached dirs from the list before any other thread can take another @cfid
+ * ref. Must not be called with cfid_list_lock held; use
+ * close_cached_dir_locked() called instead.
+ *
+ * @cfid: cached dir
+ */
 void close_cached_dir(struct cached_fid *cfid)
 {
+	lockdep_assert_not_held(&cfid->cfids->cfid_list_lock);
 	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
+/**
+ * close_cached_dir_locked - put a reference of a cached dir with
+ * cfid_list_lock held
+ *
+ * Calling close_cached_dir() with cfid_list_lock held has the potential effect
+ * of causing a deadlock if the invariant of refcount >= 2 is false.
+ *
+ * This function is used in paths that hold cfid_list_lock and expect at least
+ * two references. If that invariant is violated, WARNs and returns without
+ * dropping a reference; the final put must still go through
+ * close_cached_dir().
+ *
+ * @cfid: cached dir
+ */
+static void close_cached_dir_locked(struct cached_fid *cfid)
+{
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
+	if (WARN_ON(kref_read(&cfid->refcount) < 2))
+		return;
+
+	kref_put(&cfid->refcount, smb2_close_cached_fid);
+}
+
 /*
  * Called from cifs_kill_sb when we unmount a share
  */


