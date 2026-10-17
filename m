Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE197370ACE;
	Sat, 17 Oct 2026 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252584; cv=none; b=tLUgTCb1EMuDYTcgWUuq3OCdQu82LiHJV17weJqgkkw5ygydhBLmLIORZ7GrHrJwOPTPHPUypTXQzcilBZvAu0er6lZ+5t/AJ129t5ahKDBv//4+ohywKrHO3xTNNhfCIVYB1pbmvOe8bZScTomKUexb98xtM0uug8pYUQaZ0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252584; c=relaxed/simple;
	bh=NAotRxEtGMKQ3tS9qTISfgXaNlRX6MhhQz3l9pnPVtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyXDo6vsLrRs3fypDg1Rtkk72ic4BEu3Ici9dDAl92FpyXpRzZkP14PPVO8ClSzFMhFKUwqZWEtMwJUuXHUyAU0y/eMJzxTMTZ9RcxIGksGti8ZyxcTOunVXYVIWQyHFJTkoDhbsAY4BkCZs1P8kowaiuvry/+z6Bdl0bSC5K4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkTu5sW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkTu5sW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9001F000C4;
	Sat, 17 Oct 2026 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252583;
	bh=p/hg6ljOWj2sr8Oxn2uC7IeUwdW6aM0SYQ/X1dD/n/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkTu5sW/1zqN5vN6wN+Pk3ysOjucoptS0/et5JO2dRx7uacIDSFurTP9tEwUqEmyT
	 x7LDiya6Lth31kRDdqh8VgtkkxZD1Kg0PX+v/pyHKJcQY2dLuNeum1Zw+2O73JtYRN
	 IYaCUfytn/vabfQvTx2wGXPlCnkuGtmBOe1p21fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 29/52] cifs: fix time_last_write stamp placement in setattr/truncate paths
Date: Sat, 17 Oct 2026 17:54:30 +0200
Message-ID: <20261017155105.792601086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit ecababf08905958ba8c125979c4e39fc2f1a8a05 ]

cifs_file_set_size() calls cifs_setsize() on success, which calls
i_size_write(), updating i_size to the new value.  The subsequent
check attrs->ia_size != i_size_read() in both cifs_setattr_unix()
and cifs_setattr_nounix() therefore always evaluates false after a
successful cifs_file_set_size(), making the smp_store_release() of
time_last_write dead code.  The truncate path was unprotected against
stale readdir size updates.

Move the stamp to before the cifs_file_set_size() RPC call, guarded
by attrs->ia_size != i_size_read() to exclude no-op same-size
ftruncate(2) calls from stamping time_last_write unnecessarily.

On the error path the stamp remains rather than being restored:
restoring a stale snapshot (prev_tlw) could silently erase a
concurrent _cifsFileInfo_put() close stamp if that close arrived
between the READ_ONCE and the smp_store_release.  readdir is
suppressed until the stamp expires, which extends beyond one acregmax
if the caller retries failed truncations.  stat() is unaffected: the
cifs_revalidate_dentry_attr() path calls cifs_fattr_to_inode() with
from_readdir=false, which bypasses the time_last_write check in
is_size_safe_to_change() entirely and always writes the authoritative
QUERY_INFO result to i_size.

Remove the now-unreachable stamp from the dead block in both functions.

Fixes: e8a8d54c2d50 ("cifs: prevent readdir from changing file size due to stale directory metadata")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ sashal: removed the timestamp write from cifs_file_set_size() because the original size-update blocks were already deleted ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index ec6d27ba4083d..995d6df9304f4 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3135,11 +3135,8 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	cifs_put_tlink(tlink);
 
 set_size_out:
-	if (rc == 0) {
-		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-		smp_store_release(&cifsInode->time_last_write, jiffies);
+	if (rc == 0)
 		cifs_resize_file_locked(inode, size);
-	}
 
 	return rc;
 }
@@ -3202,6 +3199,17 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
+		if (attrs->ia_size != i_size_read(inode)) {
+			/* Stamp before RPC. On failure the stamp remains: restoring a
+			 * stale snapshot could silently erase a concurrent
+			 * _cifsFileInfo_put() close stamp.  readdir is suppressed
+			 * until the stamp expires; stat() bypasses this via the
+			 * from_readdir=false path in is_size_safe_to_change() and
+			 * always returns an authoritative QUERY_INFO result.
+			 * Pairs with smp_load_acquire() in is_size_safe_to_change().
+			 */
+			smp_store_release(&cifsInode->time_last_write, jiffies);
+		}
 		rc = cifs_file_set_size(xid, direntry, full_path,
 					open_file, attrs->ia_size);
 		if (rc != 0)
@@ -3378,6 +3386,17 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	if (attrs->ia_valid & ATTR_SIZE) {
+		if (attrs->ia_size != i_size_read(inode)) {
+			/* Stamp before RPC. On failure the stamp remains: restoring a
+			 * stale snapshot could silently erase a concurrent
+			 * _cifsFileInfo_put() close stamp.  readdir is suppressed
+			 * until the stamp expires; stat() bypasses this via the
+			 * from_readdir=false path in is_size_safe_to_change() and
+			 * always returns an authoritative QUERY_INFO result.
+			 * Pairs with smp_load_acquire() in is_size_safe_to_change().
+			 */
+			smp_store_release(&cifsInode->time_last_write, jiffies);
+		}
 		rc = cifs_file_set_size(xid, direntry, full_path,
 					cfile, attrs->ia_size);
 		if (rc != 0)
-- 
2.53.0



