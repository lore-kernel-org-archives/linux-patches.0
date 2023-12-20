Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9244D48788;
	Wed, 20 Dec 2023 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INM6yPbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15690C433C7;
	Wed, 20 Dec 2023 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088842;
	bh=Tg0wCLeTTuFQ3DbjT3ddNQoG/9Vo7pRmwruY4N3P0ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INM6yPbhBjrgaHqyBlB/D08IyaMY7JrabIGiriFogROT+OH8xGaE7c7IlumY/hZkV
	 JvO9LxH9YKKxMXKJcaUlh5eqvfwAzxq9FmKhFed26j1akl3h2L3yfikvA/7hgmCTFW
	 gcJvDjsg1ANLqTBN1/vQnR5gk1ExNSPPKtNThtPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 061/159] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
Date: Wed, 20 Dec 2023 17:08:46 +0100
Message-ID: <20231220160934.195728280@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atte Heikkilä <atteh.mailbox@gmail.com>

[ Upstream commit dbab80e2071ad8c702e50dab43326608a127d27b ]

Case-insensitive file name lookups with __caseless_lookup() use
strncasecmp() for file name comparison. strncasecmp() assumes an
ISO8859-1-compatible encoding, which is not the case here as UTF-8
is always used. As such, use of strncasecmp() here produces correct
results only if both strings use characters in the ASCII range only.
Fix this by using utf8_strncasecmp() if CONFIG_UNICODE is set. On
failure or if CONFIG_UNICODE is not set, fallback to strncasecmp().
Also, as we are adding an include for `linux/unicode.h', include it
in `fs/ksmbd/connection.h' as well since it should be explicit there.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.h |    1 +
 fs/ksmbd/vfs.c        |   20 +++++++++++++++++---
 fs/ksmbd/vfs.h        |    2 ++
 3 files changed, 20 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -14,6 +14,7 @@
 #include <net/request_sock.h>
 #include <linux/kthread.h>
 #include <linux/nls.h>
+#include <linux/unicode.h>
 
 #include "smb_common.h"
 #include "ksmbd_work.h"
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1144,12 +1144,23 @@ static int __caseless_lookup(struct dir_
 			     unsigned int d_type)
 {
 	struct ksmbd_readdir_data *buf;
+	int cmp = -EINVAL;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
 
 	if (buf->used != namlen)
 		return 0;
-	if (!strncasecmp((char *)buf->private, name, namlen)) {
+	if (IS_ENABLED(CONFIG_UNICODE) && buf->um) {
+		const struct qstr q_buf = {.name = buf->private,
+					   .len = buf->used};
+		const struct qstr q_name = {.name = name,
+					    .len = namlen};
+
+		cmp = utf8_strncasecmp(buf->um, &q_buf, &q_name);
+	}
+	if (cmp < 0)
+		cmp = strncasecmp((char *)buf->private, name, namlen);
+	if (!cmp) {
 		memcpy((char *)buf->private, name, namlen);
 		buf->dirent_count = 1;
 		return -EEXIST;
@@ -1165,7 +1176,8 @@ static int __caseless_lookup(struct dir_
  *
  * Return:	0 on success, otherwise error
  */
-static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name, size_t namelen)
+static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
+				   size_t namelen, struct unicode_map *um)
 {
 	int ret;
 	struct file *dfilp;
@@ -1175,6 +1187,7 @@ static int ksmbd_vfs_lookup_in_dir(const
 		.private	= name,
 		.used		= namelen,
 		.dirent_count	= 0,
+		.um		= um,
 	};
 
 	dfilp = dentry_open(dir, flags, current_cred());
@@ -1237,7 +1250,8 @@ int ksmbd_vfs_kern_path(struct ksmbd_wor
 				break;
 
 			err = ksmbd_vfs_lookup_in_dir(&parent, filename,
-						      filename_len);
+						      filename_len,
+						      work->conn->um);
 			path_put(&parent);
 			if (err)
 				goto out;
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -12,6 +12,7 @@
 #include <linux/namei.h>
 #include <uapi/linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/unicode.h>
 
 #include "smbacl.h"
 #include "xattr.h"
@@ -99,6 +100,7 @@ struct ksmbd_readdir_data {
 	unsigned int		used;
 	unsigned int		dirent_count;
 	unsigned int		file_attr;
+	struct unicode_map	*um;
 };
 
 /* ksmbd kstat wrapper to get valid create time when reading dir entry */


