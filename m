Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2F335BAA;
	Mon, 18 Aug 2025 13:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523240; cv=none; b=OAC8xjV0fu7JgfjDtmwyJRPZVJyFrs/U0/IcMtOrQBPsiF09wX+qMbvXm00D6XXSW7uEihFJrFSTZ9+ELNMwQgfIW7eeZh78g6mc5jUWwHKsEdLqiMzFTs/VA08XpBcKlRBl0Wa6Z0o4O8P/OsNLwhFUbiIPN5opOkAffA6Fiu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523240; c=relaxed/simple;
	bh=UJb9uOq31XLmRSg9tviD5cak5LxhCjveAW2cCbEICCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLczMtR5RshWT6MP0f1xiTd+KXoh1uKCdSyFj/6jJhTdpUmcLUjLNWKac7/UfwRdF399QzGJ1EvVDsBqWdCMCXP2cJGNRVYjLgGdmZNXJ97jfjNiZKjjXrFUoTMt6l/GO6Blz+M+wfeezxVINmOnMOmsUMJFgx8W7a1MvW+hcqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jft772lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jft772lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9169C4CEEB;
	Mon, 18 Aug 2025 13:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523240;
	bh=UJb9uOq31XLmRSg9tviD5cak5LxhCjveAW2cCbEICCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jft772lZH9VqHbtrZ4NIbUzEh6ka2wUTzbXnJ96rluCxY7a27knzaovy4uxnJPV5k
	 re/5kk3RkzyRaeIv747z/XTspCKde1TyZDWd18fEprUymDuzDypBdUkJkZIk0HhvKU
	 oYuaWDWuK5pVxJz0+Axqj/V/olv1ctMrrSCb1R+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 111/515] tracefs: Add d_delete to remove negative dentries
Date: Mon, 18 Aug 2025 14:41:37 +0200
Message-ID: <20250818124502.629492095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit d9b13cdad80dc11d74408cf201939a946e9303a6 ]

If a lookup in tracefs is done on a file that does not exist, it leaves a
dentry hanging around until memory pressure removes it. But eventfs
dentries should hang around as when their ref count goes to zero, it
requires more work to recreate it. For the rest of the tracefs dentries,
they hang around as their dentry is used as a descriptor for the tracing
system. But if a file lookup happens for a file in tracefs that does not
exist, it should be deleted.

Add a .d_delete callback that checks if dentry->fsdata is set or not. Only
eventfs dentries set fsdata so if it has content it should not be deleted
and should hang around in the cache.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index cb1af30b49f5..2c4a0c0202f6 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -465,9 +465,20 @@ static int tracefs_d_revalidate(struct inode *inode, const struct qstr *name,
 	return !(ei && ei->is_freed);
 }
 
+static int tracefs_d_delete(const struct dentry *dentry)
+{
+	/*
+	 * We want to keep eventfs dentries around but not tracefs
+	 * ones. eventfs dentries have content in d_fsdata.
+	 * Use d_fsdata to determine if it's a eventfs dentry or not.
+	 */
+	return dentry->d_fsdata == NULL;
+}
+
 static const struct dentry_operations tracefs_dentry_operations = {
 	.d_revalidate = tracefs_d_revalidate,
 	.d_release = tracefs_d_release,
+	.d_delete = tracefs_d_delete,
 };
 
 static int tracefs_fill_super(struct super_block *sb, struct fs_context *fc)
-- 
2.39.5



