Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AE9346796;
	Tue, 16 Dec 2025 12:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887669; cv=none; b=iIRCyYxx3oUeGsldHvUrLbc+DMS5gjCR+tz80oVG8Bd6DFY+CvUFDJpY+5zAHQJop9MkURx7hVBgknlEV9jJm4hjw6DjKNYvc+vfAkWeBcPadRtSgYKZPIMyS8rEyvi83sWEREkwyHt6no7E8Y/gi6g3vqEPFJcauZYQBeJvNGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887669; c=relaxed/simple;
	bh=23iTpyDcwykQ5XimzKapTmJi1iWAynlSd3dtrhcKwFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AruJmKXnR+aPlY6BMlBs1WFrV/YaQwnvW4m4FjmYkV/tN3ZHLID1WSsdtM1tooPWjKCFIWOzioFKBq6jPHUTfLFvktQxciEGJAr71oGU3mL8sf5zZ9nVYWADut2jZNx+RsZjA4KPThVvehSONqx26sYx2wz4PUJGLUZpda38+n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enCTc3Fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enCTc3Fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3448BC4CEF1;
	Tue, 16 Dec 2025 12:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887669;
	bh=23iTpyDcwykQ5XimzKapTmJi1iWAynlSd3dtrhcKwFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enCTc3FcUzuc8YQSpCfGY0WyAAKb2m7fI3C3Un/hY/Ti5h93G9G+PxelkEprbSEUN
	 w9C9/CfxoRQAFrl2uhITwypOeTkVJJybwGQCfgkrXpT03fn3oKRxNoqLXFULqrdnyg
	 l6W0sRYM1WCgDX652fALlPHauAS5QfwmRVwWueck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/614] tracefs: fix a leak in eventfs_create_events_dir()
Date: Tue, 16 Dec 2025 12:11:09 +0100
Message-ID: <20251216111412.311295317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



