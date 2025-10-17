Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F412B337110;
	Fri, 17 Oct 2025 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715082; cv=none; b=ceykT6zEv9UC29EUvnCj7p58Lp+8QgyQ17Fnsb4LozlWfpy+kBY+JVk7yyI3d5KsXdvyTdKxEvfhIP7MlErlYs6ZMGFObF8phHeZKSfUepL0SbNW7+0Mwp1jnD8fKRP9fKTeTx0mDuAQk5bEw91qv+IeSXK4nbK+vwbRbvprac0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715082; c=relaxed/simple;
	bh=0KLv9Ej3P4itgctQqCDbCKJNpG9CdFI5Oi5DcN3R03Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqk3bq1eNdnYu90j9mt2Cvcd4Jr2Z5szOl4mb5/A8dhGqohCfcbyCcUDWer2Atr7P4dEmN5hEA7l252oWgiTv+e8lvc643CY+VxUQ04QlK08qX8az7YgvpvXFY4g2BVP1A+X/ojdorUyECSe/Nz95Fu/B6+jwnwc91aUasHs98M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6RyMROY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6RyMROY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B56BC4CEFE;
	Fri, 17 Oct 2025 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715081;
	bh=0KLv9Ej3P4itgctQqCDbCKJNpG9CdFI5Oi5DcN3R03Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6RyMROYyacbMuA+M7zPbxOY8kzn2mVFlvNrp1qUulXk4tedfodrCWzGZy8smhcuQ
	 gHrsXZ9/mdTZ2p6w2ZGOSurx2I07y06abDpstwCFt8a0O79rOkESiEPT5G7NOvUFsQ
	 DHY6AyvievQF5X61Pq8WySAeF7LIctHB79pZXxts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 058/371] vfs: add ATTR_CTIME_SET flag
Date: Fri, 17 Oct 2025 16:50:33 +0200
Message-ID: <20251017145203.898225287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit afc5b36e29b95fbd31a60b9630d148857e5e513d ]

When ATTR_ATIME_SET and ATTR_MTIME_SET are set in the ia_valid mask, the
notify_change() logic takes that to mean that the request should set
those values explicitly, and not override them with "now".

With the advent of delegated timestamps, similar functionality is needed
for the ctime. Add a ATTR_CTIME_SET flag, and use that to indicate that
the ctime should be accepted as-is. Also, clean up the if statements to
eliminate the extra negatives.

In setattr_copy() and setattr_copy_mgtime() use inode_set_ctime_deleg()
when ATTR_CTIME_SET is set, instead of basing the decision on ATTR_DELEG.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: c066ff58e5d6 ("nfsd: use ATTR_CTIME_SET for delegated ctime updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/attr.c          | 44 +++++++++++++++++++-------------------------
 include/linux/fs.h |  1 +
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 5425c1dbbff92..795f231d00e8e 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -286,20 +286,12 @@ static void setattr_copy_mgtime(struct inode *inode, const struct iattr *attr)
 	unsigned int ia_valid = attr->ia_valid;
 	struct timespec64 now;
 
-	if (ia_valid & ATTR_CTIME) {
-		/*
-		 * In the case of an update for a write delegation, we must respect
-		 * the value in ia_ctime and not use the current time.
-		 */
-		if (ia_valid & ATTR_DELEG)
-			now = inode_set_ctime_deleg(inode, attr->ia_ctime);
-		else
-			now = inode_set_ctime_current(inode);
-	} else {
-		/* If ATTR_CTIME isn't set, then ATTR_MTIME shouldn't be either. */
-		WARN_ON_ONCE(ia_valid & ATTR_MTIME);
+	if (ia_valid & ATTR_CTIME_SET)
+		now = inode_set_ctime_deleg(inode, attr->ia_ctime);
+	else if (ia_valid & ATTR_CTIME)
+		now = inode_set_ctime_current(inode);
+	else
 		now = current_time(inode);
-	}
 
 	if (ia_valid & ATTR_ATIME_SET)
 		inode_set_atime_to_ts(inode, attr->ia_atime);
@@ -359,12 +351,11 @@ void setattr_copy(struct mnt_idmap *idmap, struct inode *inode,
 		inode_set_atime_to_ts(inode, attr->ia_atime);
 	if (ia_valid & ATTR_MTIME)
 		inode_set_mtime_to_ts(inode, attr->ia_mtime);
-	if (ia_valid & ATTR_CTIME) {
-		if (ia_valid & ATTR_DELEG)
-			inode_set_ctime_deleg(inode, attr->ia_ctime);
-		else
-			inode_set_ctime_to_ts(inode, attr->ia_ctime);
-	}
+
+	if (ia_valid & ATTR_CTIME_SET)
+		inode_set_ctime_deleg(inode, attr->ia_ctime);
+	else if (ia_valid & ATTR_CTIME)
+		inode_set_ctime_to_ts(inode, attr->ia_ctime);
 }
 EXPORT_SYMBOL(setattr_copy);
 
@@ -463,15 +454,18 @@ int notify_change(struct mnt_idmap *idmap, struct dentry *dentry,
 
 	now = current_time(inode);
 
-	attr->ia_ctime = now;
-	if (!(ia_valid & ATTR_ATIME_SET))
-		attr->ia_atime = now;
-	else
+	if (ia_valid & ATTR_ATIME_SET)
 		attr->ia_atime = timestamp_truncate(attr->ia_atime, inode);
-	if (!(ia_valid & ATTR_MTIME_SET))
-		attr->ia_mtime = now;
 	else
+		attr->ia_atime = now;
+	if (ia_valid & ATTR_CTIME_SET)
+		attr->ia_ctime = timestamp_truncate(attr->ia_ctime, inode);
+	else
+		attr->ia_ctime = now;
+	if (ia_valid & ATTR_MTIME_SET)
 		attr->ia_mtime = timestamp_truncate(attr->ia_mtime, inode);
+	else
+		attr->ia_mtime = now;
 
 	if (ia_valid & ATTR_KILL_PRIV) {
 		error = security_inode_need_killpriv(dentry);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 601d036a6c78e..74f2bfc519263 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -238,6 +238,7 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_ATIME_SET	(1 << 7)
 #define ATTR_MTIME_SET	(1 << 8)
 #define ATTR_FORCE	(1 << 9) /* Not a change, but a change it */
+#define ATTR_CTIME_SET	(1 << 10)
 #define ATTR_KILL_SUID	(1 << 11)
 #define ATTR_KILL_SGID	(1 << 12)
 #define ATTR_FILE	(1 << 13)
-- 
2.51.0



