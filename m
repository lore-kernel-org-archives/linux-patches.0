Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8638831A7EA;
	Fri,  9 Jan 2026 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959754; cv=none; b=U6t85a4gCjHMZd5vPCd29pp0YvD/hw2f0gZevdW1Xvymp48idzIK+UjQq0ULTMzLM9QvZqfvOO+73KLM500YyOseZGA8x/uvTsEZq22NZNwu27+t1EJ9CPIlxPZ/sa8f9ceKXhPFz3/CWtvC0Ei+I/3+3kvwj/Y11hQvvgRIrSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959754; c=relaxed/simple;
	bh=hxAr4HYFMeCuunCJwzig0AJNO6AH7LSCNACy909R+Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl4P2aitkMm5/RzwKVHqFfzwV/fV78eJmqEE2k7FCQvyCFSTq1wM5XddrozQjjlIk3VEj5Yi9XbP+YuEpP2I3kblyzb5gxS8+3H1oQ04jUlQ1y911V+I2geg6JiqWIwVqRVjtIeN/DC0xg89AdgwsF2RAnpT7+Ex84nNH9vXR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpr12PKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpr12PKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6A3C4CEF1;
	Fri,  9 Jan 2026 11:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959754;
	bh=hxAr4HYFMeCuunCJwzig0AJNO6AH7LSCNACy909R+Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpr12PKaK5A4Ak++cnmeJ0pRWsKOu6+nejBAEq1PcYx1fpNRYm8eapIfBNF6zr0Yn
	 JGY7RB5l948Vu3geCzA987rWn+I2lc4gfmo3bDBxUPJx7FqhmEUjIX7TGXSK2xJoyC
	 FFnn4cGmn9A4FmCBCxcsitWN8p/B/D25B0jzcy1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/737] tracefs: fix a leak in eventfs_create_events_dir()
Date: Fri,  9 Jan 2026 12:35:02 +0100
Message-ID: <20260109112140.125741643@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 73a08db3b7a85..4190e61550449 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -827,7 +827,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 						const struct eventfs_entry *entries,
 						int size, void *data)
 {
-	struct dentry *dentry = tracefs_start_creating(name, parent);
+	struct dentry *dentry;
 	struct eventfs_root_inode *rei;
 	struct eventfs_inode *ei;
 	struct tracefs_inode *ti;
@@ -838,6 +838,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	if (security_locked_down(LOCKDOWN_TRACEFS))
 		return NULL;
 
+	dentry = tracefs_start_creating(name, parent);
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry);
 
-- 
2.51.0



