Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806E0355027;
	Tue, 16 Dec 2025 11:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885817; cv=none; b=EicusCb3GTwJH1Iy6H2qGsC3YGxykFihood7bsIxL9u+JuYtHv32CVun6GF1J1ZrGJAVfggYKqzxvbQz54EmzWn+WNK8DnVS7WpoMY+0wpNDx1XgcBN90VazR80saspkxbQYtpfz2/qWjHZRDA5URos7ALJWWhA5NWiSxypuBQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885817; c=relaxed/simple;
	bh=1VQ06xjwwAry9WcXytZsCir9no7i6osFXzGylA+hC0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flKgtEwtbfbGLLWKuCMIPfufmaqoN4RKpPCv5LHZRIvAaxV9zkleIMC17uqfPvpm8xQqOVu7sX5lFWYsZK23F9d1HSG1kDFcMs/AfqZ5lAvFZ65ey3XfCsiL3jYc+KjzGN0CzILTxYwPgnI29XlDSM+9iQY4phG/6S1yQlqkISY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHObZISX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHObZISX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C9CC4CEF1;
	Tue, 16 Dec 2025 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885817;
	bh=1VQ06xjwwAry9WcXytZsCir9no7i6osFXzGylA+hC0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHObZISXsHwSXrw6NJIs92e8hJE5dn8MXFeN0QNRYmV/JMQO0+eFcVjY38LuhZXem
	 KgKAMQB/D47FTygh+/ExVnMLXSBVJxfRVZTzsBltElG5YXm57wB3lY7UKJkRItm7o4
	 WQIlsr7vziYHjSHurFbkbAHKr39g2avl10ar77hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 254/507] tracefs: fix a leak in eventfs_create_events_dir()
Date: Tue, 16 Dec 2025 12:11:35 +0100
Message-ID: <20251216111354.693454579@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 798a401660a151633cb171738a72a8f1efb9b0b4 ]

If we have LOCKDOWN_TRACEFS, the function bails out - *after*
having locked the parent directory and without bothering to
undo that.  Just check it before tracefs_start_creating()...

Fixes: e24709454c45 "tracefs/eventfs: Add missing lockdown checks"
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 8705c77a9e75a..93c231601c8e2 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -757,7 +757,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 						const struct eventfs_entry *entries,
 						int size, void *data)
 {
-	struct dentry *dentry = tracefs_start_creating(name, parent);
+	struct dentry *dentry;
 	struct eventfs_root_inode *rei;
 	struct eventfs_inode *ei;
 	struct tracefs_inode *ti;
@@ -768,6 +768,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	if (security_locked_down(LOCKDOWN_TRACEFS))
 		return NULL;
 
+	dentry = tracefs_start_creating(name, parent);
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry);
 
-- 
2.51.0



