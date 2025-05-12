Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB09297109;
	Mon, 12 May 2025 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073381; cv=none; b=m8LT6lCpjPAnPKHsu/dQaUOi74u0h5QqJTIlEUbsimN3k9zkbXSyKNnRlU4BI2t896zyQMu+I08lcF76+GMNtcFytMnwkIDdQHJaIXkWXZjEACj0wXiTmoYYcgJXxe+oFuLfF8qXtybsCH8tdugUcrAMlMHu3VJvevQTusOBDXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073381; c=relaxed/simple;
	bh=Z5kCbkSZwlN16U1HiT+HWmwRzarrt7jEVKlLgUMTsbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jevqBHRxQbNMxDH3B0OwItTPbRetu7nkbN2Y6Oiy26br3agJrGxi1zl6mOaAAgIhaX5gZIaMOYnoSA+5UfcNDYUpeF0eRUGmI6tIwrqQMRPL4IJTt1GqahgZqgU+NBLT/S+YO2QWd7+YELkdXyclrpBtjRCtXHbEbCOwcxTruBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj0XyGjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj0XyGjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD7DC4CEE7;
	Mon, 12 May 2025 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073381;
	bh=Z5kCbkSZwlN16U1HiT+HWmwRzarrt7jEVKlLgUMTsbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bj0XyGjxwWWkQT8Y8aI4vbTMsXnCsTlcRbasYNibdrDrlO1pcRmpPEObj1aar8bUA
	 MxHGAGaV7ebtcm88XEl8dSIaJ3K390Bp5eKOTt8wbrZ19Yug2oPsOkUEaiBCHhFQvM
	 UyZlgUw70Q56mFp4GNySH5U9Pr2yh64DwxsnXV6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Paul Aurich <paul@darkrain42.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 058/113] smb: client: Avoid race in open_cached_dir with lease breaks
Date: Mon, 12 May 2025 19:45:47 +0200
Message-ID: <20250512172030.040852219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Paul Aurich <paul@darkrain42.org>

commit 3ca02e63edccb78ef3659bebc68579c7224a6ca2 upstream.

A pre-existing valid cfid returned from find_or_create_cached_dir might
race with a lease break, meaning open_cached_dir doesn't consider it
valid, and thinks it's newly-constructed. This leaks a dentry reference
if the allocation occurs before the queued lease break work runs.

Avoid the race by extending holding the cfid_list_lock across
find_or_create_cached_dir and when the result is checked.

Cc: stable@vger.kernel.org
Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -29,7 +29,6 @@ static struct cached_fid *find_or_create
 {
 	struct cached_fid *cfid;
 
-	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (!strcmp(cfid->path, path)) {
 			/*
@@ -38,25 +37,20 @@ static struct cached_fid *find_or_create
 			 * being deleted due to a lease break.
 			 */
 			if (!cfid->time || !cfid->has_lease) {
-				spin_unlock(&cfids->cfid_list_lock);
 				return NULL;
 			}
 			kref_get(&cfid->refcount);
-			spin_unlock(&cfids->cfid_list_lock);
 			return cfid;
 		}
 	}
 	if (lookup_only) {
-		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	if (cfids->num_entries >= max_cached_dirs) {
-		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	cfid = init_cached_dir(path);
 	if (cfid == NULL) {
-		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	cfid->cfids = cfids;
@@ -74,7 +68,6 @@ static struct cached_fid *find_or_create
 	 */
 	cfid->has_lease = true;
 
-	spin_unlock(&cfids->cfid_list_lock);
 	return cfid;
 }
 
@@ -185,8 +178,10 @@ replay_again:
 	if (!utf16_path)
 		return -ENOMEM;
 
+	spin_lock(&cfids->cfid_list_lock);
 	cfid = find_or_create_cached_dir(cfids, path, lookup_only, tcon->max_cached_dirs);
 	if (cfid == NULL) {
+		spin_unlock(&cfids->cfid_list_lock);
 		kfree(utf16_path);
 		return -ENOENT;
 	}
@@ -195,7 +190,6 @@ replay_again:
 	 * Otherwise, it is either a new entry or laundromat worker removed it
 	 * from @cfids->entries.  Caller will put last reference if the latter.
 	 */
-	spin_lock(&cfids->cfid_list_lock);
 	if (cfid->has_lease && cfid->time) {
 		spin_unlock(&cfids->cfid_list_lock);
 		*ret_cfid = cfid;


