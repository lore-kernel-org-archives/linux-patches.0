Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F972F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77024C433D2;
	Wed, 12 Apr 2023 08:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289026;
	bh=/Lkjj21dBq8914eNUWLWnY1eEDNO/XOF2Zyk0uMpW7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbO9FGqRjuqDfA+OEjZ6AjQ2R7MhUUGjz28mF+O38yVqc5QMPOLOQ/swrcrTc5Zz8
	 7ns41fcMmJLOZb3Z1f4u1J9IYKmNLGqSDw67rpYWbs9eidHn+NEohA3RUlulU8tYDY
	 oVI8C1g7W4iCA79/HqcISo4xgRMywmAa8SHar7cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Thiago Rafael Becker <tbecker@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/164] cifs: sanitize paths in cifs_update_super_prepath.
Date: Wed, 12 Apr 2023 10:33:49 +0200
Message-Id: <20230412082841.172523209@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thiago Rafael Becker <tbecker@redhat.com>

[ Upstream commit d19342c6609b67f2ba83b9eccca2777e3687f625 ]

After a server reboot, clients are failing to move files with ENOENT.
This is caused by DFS referrals containing multiple separators, which
the server move call doesn't recognize.

v1: Initial patch.
v2: Move prototype to header.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2182472
Fixes: a31080899d5f ("cifs: sanitize multiple delimiters in prepath")
Actually-Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Thiago Rafael Becker <tbecker@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.c | 13 +++++++------
 fs/cifs/fs_context.h |  3 +++
 fs/cifs/misc.c       |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 45119597c7655..89e810b27a4bf 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -441,13 +441,14 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
  * but there are some bugs that prevent rename from working if there are
  * multiple delimiters.
  *
- * Returns a sanitized duplicate of @path. The caller is responsible for
- * cleaning up the original.
+ * Returns a sanitized duplicate of @path. @gfp indicates the GFP_* flags
+ * for kstrdup.
+ * The caller is responsible for freeing the original.
  */
 #define IS_DELIM(c) ((c) == '/' || (c) == '\\')
-static char *sanitize_path(char *path)
+char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
 {
-	char *cursor1 = path, *cursor2 = path;
+	char *cursor1 = prepath, *cursor2 = prepath;
 
 	/* skip all prepended delimiters */
 	while (IS_DELIM(*cursor1))
@@ -469,7 +470,7 @@ static char *sanitize_path(char *path)
 		cursor2--;
 
 	*(cursor2) = '\0';
-	return kstrdup(path, GFP_KERNEL);
+	return kstrdup(prepath, gfp);
 }
 
 /*
@@ -531,7 +532,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	if (!*pos)
 		return 0;
 
-	ctx->prepath = sanitize_path(pos);
+	ctx->prepath = cifs_sanitize_prepath(pos, GFP_KERNEL);
 	if (!ctx->prepath)
 		return -ENOMEM;
 
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index a268896d05d57..26093f54d3e65 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -287,4 +287,7 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
  */
 #define SMB3_MAX_DCLOSETIMEO (1 << 30)
 #define SMB3_DEF_DCLOSETIMEO (1 * HZ) /* even 1 sec enough to help eg open/write/close/open/read */
+
+extern char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
+
 #endif
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 832856aef4b7a..cf19e6a81ed99 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1304,7 +1304,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 	kfree(cifs_sb->prepath);
 
 	if (prefix && *prefix) {
-		cifs_sb->prepath = kstrdup(prefix, GFP_ATOMIC);
+		cifs_sb->prepath = cifs_sanitize_prepath(prefix, GFP_ATOMIC);
 		if (!cifs_sb->prepath)
 			return -ENOMEM;
 
-- 
2.39.2



