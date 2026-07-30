Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D05437847;
	Thu, 30 Jul 2026 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426943; cv=none; b=HTinZqhHdmzWRwpl3Sg+xH925G0nkCRb0oCyzxQtP7maNdb4ghvFnF9X1MAI5C+lOi642GUMv4P3DbacxQ0uMNAfte70Ojx1x4fq8rtR4yEC8H/JhQjXbe8wN9VrmkST6sJLtXOU04XJs4jTvCrGcjHxMAJxEJ0sl4aVJs+Kn84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426943; c=relaxed/simple;
	bh=LX6e33u/AMt3yY/B9Qs/Ra0xFDENKtckCB7krjwSWhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHoRH0dsmTk8j55GT+fNe7nCO+iVHjGrbAyGWEiKONBXBl55iY7p0wF/YO6D+/iotHhVuhnvoa47HbHTN9rcpGSNZ71vH+Zk5Kd3k5uq9boCxeqCfwDQGfax5H4FleFnw68pyUssibZDb/O7f4rJGfvqbuP8jPbDl9+nOPqHKaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOrDeEOI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOrDeEOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874311F000E9;
	Thu, 30 Jul 2026 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426942;
	bh=Ta3BpWNlvJjIzBxyCpEE4ck8DdJqjuCYLwlsxLSlr4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOrDeEOIqkPGAO5O7iJAOp1wLVk23lLILdRIWJ7LdIYt6IzlLAQEpjQla+x5xrOQD
	 oQwR18X23a7MeWEcl2aDY3J1lKFsITyM/P5YU+bgzWX1d71PC8LsfYyP+6OckQzxjn
	 lrPEz+fpCcJyzRllRiNint6ovfFpd4Cne1COvRhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+41c68824eefb67cdf00c@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 595/602] afs: Fix delayed allocation of a cells anonymous key
Date: Thu, 30 Jul 2026 16:16:27 +0200
Message-ID: <20260730141448.557069934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit d27c71257825dced46104eefe42e4d9964bd032e upstream.

The allocation of a cell's anonymous key is done in a background thread
along with other cell setup such as doing a DNS upcall.  In the reported
bug, this is triggered by afs_parse_source() parsing the device name given
to mount() and calling afs_lookup_cell() with the name of the cell.

The normal key lookup then tries to use the key description on the
anonymous authentication key as the reference for request_key() - but it
may not yet be set and so an oops can happen.

This has been made more likely to happen by the fix for dynamic lookup
failure.

Fix this by firstly allocating a reference name and attaching it to the
afs_cell record when the record is created.  It can share the memory
allocation with the cell name (unfortunately it can't just overlap the cell
name by prepending it with "afs@" as the cell name already has a '.'
prepended for other purposes).  This reference name is then passed to
request_key().

Secondly, the anon key is now allocated on demand at the point a key is
requested in afs_request_key() if it is not already allocated.  A mutex is
used to prevent multiple allocation for a cell.

Thirdly, make afs_request_key_rcu() return NULL if the anonymous key isn't
yet allocated (if we need it) and then the caller can return -ECHILD to
drop out of RCU-mode and afs_request_key() can be called.

Note that the anonymous key is kind of necessary to make the key lookup
cache work as that doesn't currently cache a negative lookup, but it's
probably worth some investigation to see if NULL can be used instead.

Fixes: 330e2c514823 ("afs: Fix dynamic lookup to fail on cell lookup failure")
Reported-by: syzbot+41c68824eefb67cdf00c@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/800328.1764325145@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cell.c     |   43 ++++++++-----------------------------------
 fs/afs/internal.h |    1 +
 fs/afs/security.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 49 insertions(+), 43 deletions(-)

--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -140,7 +140,9 @@ static struct afs_cell *afs_alloc_cell(s
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cell->name = kmalloc(1 + namelen + 1, GFP_KERNEL);
+	/* Allocate the cell name and the key name in one go. */
+	cell->name = kmalloc(1 + namelen + 1 +
+			     4 + namelen + 1, GFP_KERNEL);
 	if (!cell->name) {
 		kfree(cell);
 		return ERR_PTR(-ENOMEM);
@@ -151,7 +153,11 @@ static struct afs_cell *afs_alloc_cell(s
 	cell->name_len = namelen;
 	for (i = 0; i < namelen; i++)
 		cell->name[i] = tolower(name[i]);
-	cell->name[i] = 0;
+	cell->name[i++] = 0;
+
+	cell->key_desc = cell->name + i;
+	memcpy(cell->key_desc, "afs@", 4);
+	memcpy(cell->key_desc + 4, cell->name, cell->name_len + 1);
 
 	cell->net = net;
 	refcount_set(&cell->ref, 1);
@@ -719,33 +725,6 @@ void afs_set_cell_timer(struct afs_cell
 }
 
 /*
- * Allocate a key to use as a placeholder for anonymous user security.
- */
-static int afs_alloc_anon_key(struct afs_cell *cell)
-{
-	struct key *key;
-	char keyname[4 + AFS_MAXCELLNAME + 1], *cp, *dp;
-
-	/* Create a key to represent an anonymous user. */
-	memcpy(keyname, "afs@", 4);
-	dp = keyname + 4;
-	cp = cell->name;
-	do {
-		*dp++ = tolower(*cp);
-	} while (*cp++);
-
-	key = rxrpc_get_null_key(keyname);
-	if (IS_ERR(key))
-		return PTR_ERR(key);
-
-	cell->anonymous_key = key;
-
-	_debug("anon key %p{%x}",
-	       cell->anonymous_key, key_serial(cell->anonymous_key));
-	return 0;
-}
-
-/*
  * Activate a cell.
  */
 static int afs_activate_cell(struct afs_net *net, struct afs_cell *cell)
@@ -754,12 +733,6 @@ static int afs_activate_cell(struct afs_
 	struct afs_cell *pcell;
 	int ret;
 
-	if (!cell->anonymous_key) {
-		ret = afs_alloc_anon_key(cell);
-		if (ret < 0)
-			return ret;
-	}
-
 	ret = afs_proc_cell_setup(cell);
 	if (ret < 0)
 		return ret;
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -423,6 +423,7 @@ struct afs_cell {
 
 	u8			name_len;	/* Length of name */
 	char			*name;		/* Cell name, case-flattened and NUL-padded */
+	char			*key_desc;	/* Authentication key description */
 };
 
 /*
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -16,6 +16,30 @@
 
 static DEFINE_HASHTABLE(afs_permits_cache, 10);
 static DEFINE_SPINLOCK(afs_permits_lock);
+static DEFINE_MUTEX(afs_key_lock);
+
+/*
+ * Allocate a key to use as a placeholder for anonymous user security.
+ */
+static int afs_alloc_anon_key(struct afs_cell *cell)
+{
+	struct key *key;
+
+	mutex_lock(&afs_key_lock);
+	if (!cell->anonymous_key) {
+		key = rxrpc_get_null_key(cell->key_desc);
+		if (!IS_ERR(key))
+			cell->anonymous_key = key;
+	}
+	mutex_unlock(&afs_key_lock);
+
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	_debug("anon key %p{%x}",
+	       cell->anonymous_key, key_serial(cell->anonymous_key));
+	return 0;
+}
 
 /*
  * get a key
@@ -23,11 +47,12 @@ static DEFINE_SPINLOCK(afs_permits_lock)
 struct key *afs_request_key(struct afs_cell *cell)
 {
 	struct key *key;
+	int ret;
 
-	_enter("{%x}", key_serial(cell->anonymous_key));
+	_enter("{%s}", cell->key_desc);
 
-	_debug("key %s", cell->anonymous_key->description);
-	key = request_key_net(&key_type_rxrpc, cell->anonymous_key->description,
+	_debug("key %s", cell->key_desc);
+	key = request_key_net(&key_type_rxrpc, cell->key_desc,
 			      cell->net->net, NULL);
 	if (IS_ERR(key)) {
 		if (PTR_ERR(key) != -ENOKEY) {
@@ -35,6 +60,12 @@ struct key *afs_request_key(struct afs_c
 			return key;
 		}
 
+		if (!cell->anonymous_key) {
+			ret = afs_alloc_anon_key(cell);
+			if (ret < 0)
+				return ERR_PTR(ret);
+		}
+
 		/* act as anonymous user */
 		_leave(" = {%x} [anon]", key_serial(cell->anonymous_key));
 		return key_get(cell->anonymous_key);
@@ -52,11 +83,10 @@ struct key *afs_request_key_rcu(struct a
 {
 	struct key *key;
 
-	_enter("{%x}", key_serial(cell->anonymous_key));
+	_enter("{%s}", cell->key_desc);
 
-	_debug("key %s", cell->anonymous_key->description);
-	key = request_key_net_rcu(&key_type_rxrpc,
-				  cell->anonymous_key->description,
+	_debug("key %s", cell->key_desc);
+	key = request_key_net_rcu(&key_type_rxrpc, cell->key_desc,
 				  cell->net->net);
 	if (IS_ERR(key)) {
 		if (PTR_ERR(key) != -ENOKEY) {
@@ -65,6 +95,8 @@ struct key *afs_request_key_rcu(struct a
 		}
 
 		/* act as anonymous user */
+		if (!cell->anonymous_key)
+			return NULL; /* Need to allocate */
 		_leave(" = {%x} [anon]", key_serial(cell->anonymous_key));
 		return key_get(cell->anonymous_key);
 	} else {
@@ -408,7 +440,7 @@ int afs_permission(struct mnt_idmap *idm
 
 	if (mask & MAY_NOT_BLOCK) {
 		key = afs_request_key_rcu(vnode->volume->cell);
-		if (IS_ERR(key))
+		if (IS_ERR_OR_NULL(key))
 			return -ECHILD;
 
 		ret = -ECHILD;


