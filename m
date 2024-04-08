Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600287C092;
	Mon,  8 Apr 2024 13:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584177; cv=none; b=Q+wM/RIySVh1CMVlM8g1oyI0ZNic5tMaQ6jhGNr73gYKYUThO7eiyblf74X4+lMBTUE4JPopy1TPdLioFOmJZT4vJnSS2H8SYywsmWmY7ZYEXD2lBOL6iMRYgCO+AXolylrYmWqtZNZk+77lE6inQj55F2xRh9Jmwe+kVCkF2KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584177; c=relaxed/simple;
	bh=C9uNpwT6j98kbrbIYRHc0+quXDJqfZ6r3WrmMsM6xL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZWRoo9Yy/JDsyDuhY+kBt0yjUoHYLLLREKwKFKSiZa0z+KBgNfpoDJlFsZtKOA6y8KTXrcFZpUjI7HIo07dnQHnU9LGgVHILKuMxk7J4JIJe82CUe/YjD+32NKASRFQ9Sbm0pwwI5aKQUnMwI+GM7PaBjfoZJdC1sFNyceA/e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rx13ya2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rx13ya2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3B8C433C7;
	Mon,  8 Apr 2024 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584177;
	bh=C9uNpwT6j98kbrbIYRHc0+quXDJqfZ6r3WrmMsM6xL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rx13ya2hYqP134v35xpxdOhb2IdaldkxSMm7qdpQ2QWIdeo81hZBJC6ThxdqpSouW
	 rQTnzwHFLFvRwxZxvrZ4A8ZPdg6hScvYVcaBaX+/215QNtqEyxnTdIL3hGALcVg4k8
	 S6qH1cxXEGBYpZN5Bc0QZW3zaAoTTzVWbVqrQjUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 247/273] smb: client: serialise cifs_construct_tcon() with cifs_mount_mutex
Date: Mon,  8 Apr 2024 14:58:42 +0200
Message-ID: <20240408125317.122571678@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 93cee45ccfebc62a3bb4cd622b89e00c8c7d8493 upstream.

Serialise cifs_construct_tcon() with cifs_mount_mutex to handle
parallel mounts that may end up reusing the session and tcon created
by it.

Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c    |   13 ++++++++++++-
 fs/smb/client/fs_context.c |    6 +++---
 fs/smb/client/fs_context.h |   12 ++++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3989,7 +3989,7 @@ cifs_set_vol_auth(struct smb3_fs_context
 }
 
 static struct cifs_tcon *
-cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
+__cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 {
 	int rc;
 	struct cifs_tcon *master_tcon = cifs_sb_master_tcon(cifs_sb);
@@ -4087,6 +4087,17 @@ out:
 	return tcon;
 }
 
+static struct cifs_tcon *
+cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
+{
+	struct cifs_tcon *ret;
+
+	cifs_mount_lock();
+	ret = __cifs_construct_tcon(cifs_sb, fsuid);
+	cifs_mount_unlock();
+	return ret;
+}
+
 struct cifs_tcon *
 cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
 {
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -37,7 +37,7 @@
 #include "rfc1002pdu.h"
 #include "fs_context.h"
 
-static DEFINE_MUTEX(cifs_mount_mutex);
+DEFINE_MUTEX(cifs_mount_mutex);
 
 static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_1, SMB1_VERSION_STRING },
@@ -753,9 +753,9 @@ static int smb3_get_tree(struct fs_conte
 
 	if (err)
 		return err;
-	mutex_lock(&cifs_mount_mutex);
+	cifs_mount_lock();
 	ret = smb3_get_tree_common(fc);
-	mutex_unlock(&cifs_mount_mutex);
+	cifs_mount_unlock();
 	return ret;
 }
 
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -295,4 +295,16 @@ extern void smb3_update_mnt_flags(struct
 #define MAX_CACHED_FIDS 16
 extern char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
 
+extern struct mutex cifs_mount_mutex;
+
+static inline void cifs_mount_lock(void)
+{
+	mutex_lock(&cifs_mount_mutex);
+}
+
+static inline void cifs_mount_unlock(void)
+{
+	mutex_unlock(&cifs_mount_mutex);
+}
+
 #endif


