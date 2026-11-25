Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622713;
	b=oTGxa6yf56A75cgwHZnVfX4d8fUj35sz4fw0ErvHONu5PgU2ymTAcrUg3MLRb12prgfd
	 9oPvMUYesxC69HVDMZrbnf969hwIHzR99sOjZ6Q5y+KljdYTmZgOKsI4NXLSpfuMCMcof
	 IP8ssnbjeySRXsv1C0O7GKarOPq8jL7a8ZS4V5G3bZb0FH1vFMmBjzgyiA+Y6s+9q5BFL
	 eJH2EQeqHmdpaagUWAZiwt7cxM6kVAZ+HrRV6nK1f7v8aZvC5kwXyymmzYXts49zOZJoH
	 8glwUtHitEwrEeqAhcOQ9kwWrzQfYRZH9bBvGCA8oBiImMxQcYb2sF5LBWS/L9XQi6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bvxxFiVi1oxoYMDhXnYy8UEFl8a7D7Tie4SsfjDC4/I=;
	b=I6/jCzHZoonK1Vwj3jkWefmW1kZLzgVomM2zbERv2maXtSCbjFBAn1GChP6AShWIF6SC
	 0Fv8tRBivt+p1kGjcZokxRZA+eMb4wU/aDfQwYfm8k7kUgnisiVofyidVIDopy5/Rfygh
	 dzusG39TNsmZXLIRVDwhkB39XcJ1E2mU7KnqrtvYgmsEpM4RsPFoMqTW9ZkrForUqQyY9
	 hLgs6CwRbKR6+zsCjdQ0hjAmrT3b2IsRlycilhztLMvSGj1f0FZXVvjgUD4sx0b1OBUPw
	 O2vtGQFg4T5w7W/0mtKoOfmzBDEnvrJqgPkAmskElEJAXkoGVrRjsw/sWKeNB9mhyrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoLbZX55;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A610606A31E;
	Wed, 25 Nov 2026 16:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoLbZX55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F52D1F000D2;
	Wed, 25 Nov 2026 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622713;
	bh=bvxxFiVi1oxoYMDhXnYy8UEFl8a7D7Tie4SsfjDC4/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoLbZX55D/kNINQzRqlQ5zko8DpQV+fD8H3NWR/xrQpFjxwKB/bWvfr9wUrXxDREw
	 hrpQo7zoxG9Xq9877IVHxVWiCTYlQiCI7K+dp9oAuMwt8w2pdFMfKdJCtLNtU3qU5K
	 KXK4jDnQS+fmd17C+1pLKtPYv07ByNZx/FetHQvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 623/990] ksmbd: cache the resolved share path for durable reconnects
Date: Wed, 25 Nov 2026 15:33:10 +0100
Message-ID: <20261125143836.694761588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 2a90ba573d41efa82e075ba9ac532bb3ec0519c4 ]

A share configured as /a/link/b, with /a/link pointing to /real, is
opened relative to share->vfs_path at /real/b. However,
ksmbd_validate_name_reconnect() compares the file's d_path() result
against the original /a/link/b string and rejects a valid reconnect.

Render share->vfs_path with d_path() after the existing kern_path()
lookup and cache a copy in real_path along with its length. Use the
resolved string for durable reconnect name validation. Keep path and
path_sz as the configured spelling for existing consumers, including
the volume serial calculation and path lookups.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Dropped the scoped_with_init_fs() wrapper around the share_config_resolve_path() call and the fs_struct.h include, since this tree has neither and calls the helper directly. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 43 +++++++++++++++++++++++++++++--
 fs/smb/server/mgmt/share_config.h |  2 ++
 fs/smb/server/vfs_cache.c         | 12 +++++----
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 8813a81ca6629..5fbc2235ab8d3 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/rwsem.h>
 #include <linux/parser.h>
+#include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -50,6 +51,7 @@ static void kill_share(struct ksmbd_share_config *share)
 		path_put(&share->vfs_path);
 	kfree(share->name);
 	kfree(share->path);
+	kfree(share->real_path);
 	kfree(share);
 }
 
@@ -124,6 +126,43 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	return 0;
 }
 
+static int share_config_resolve_path(struct ksmbd_share_config *share)
+{
+	char *buf, *path;
+	int ret;
+
+	ret = kern_path(share->path, 0, &share->vfs_path);
+	if (ret)
+		return ret;
+
+	buf = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	path = d_path(&share->vfs_path, buf, PATH_MAX);
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		goto out_buf;
+	}
+
+	path = kstrdup(path, KSMBD_DEFAULT_GFP);
+	if (!path) {
+		ret = -ENOMEM;
+		goto out_buf;
+	}
+
+	share->real_path = path;
+	share->real_path_sz = strlen(path);
+out_buf:
+	kfree(buf);
+out:
+	if (ret)
+		path_put(&share->vfs_path);
+	return ret;
+}
+
 static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 						       const char *name)
 {
@@ -212,12 +251,12 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 				goto out;
 			}
 
-			ret = kern_path(share->path, 0, &share->vfs_path);
+			ret = share_config_resolve_path(share);
 			ksmbd_revert_fsids(work);
 			if (ret) {
 				ksmbd_debug(SMB, "failed to access '%s'\n",
 					    share->path);
-				/* Avoid put_path() */
+				/* No path reference is retained on failure. */
 				kfree(share->path);
 				share->path = NULL;
 			}
diff --git a/fs/smb/server/mgmt/share_config.h b/fs/smb/server/mgmt/share_config.h
index d4ac2dd4de204..baa9f9ed91cde 100644
--- a/fs/smb/server/mgmt/share_config.h
+++ b/fs/smb/server/mgmt/share_config.h
@@ -16,8 +16,10 @@ struct ksmbd_work;
 struct ksmbd_share_config {
 	char			*name;
 	char			*path;
+	char			*real_path;
 
 	unsigned int		path_sz;
+	unsigned int		real_path_sz;
 	unsigned int		flags;
 	struct list_head	veto_list;
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 2621d2cffe619..b1ee76949a2ea 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1355,6 +1355,8 @@ void ksmbd_free_global_file_table(void)
 int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 				  struct ksmbd_file *fp, char *name)
 {
+	const char *share_path = share->real_path;
+	size_t share_path_sz = share->real_path_sz;
 	char *pathname, *ab_pathname;
 	int ret = 0;
 
@@ -1371,14 +1373,14 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 	if (name) {
 		size_t len = strlen(ab_pathname);
 
-		if (len == share->path_sz && !strncmp(ab_pathname, share->path, len)) {
+		if (len == share_path_sz && !strncmp(ab_pathname, share_path, len)) {
 			/* the durable fp is the share root itself */
 			if (name[0])
 				ret = -EINVAL;
-		} else if (len <= share->path_sz ||
-			   strncmp(ab_pathname, share->path, share->path_sz) ||
-			   ab_pathname[share->path_sz] != '/' ||
-			   strcmp(&ab_pathname[share->path_sz + 1], name)) {
+		} else if (len <= share_path_sz ||
+			   strncmp(ab_pathname, share_path, share_path_sz) ||
+			   ab_pathname[share_path_sz] != '/' ||
+			   strcmp(&ab_pathname[share_path_sz + 1], name)) {
 			ret = -EINVAL;
 		}
 		if (ret)
-- 
2.53.0



