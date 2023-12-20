Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0698D482F6;
	Wed, 20 Dec 2023 16:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjco4r7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C14C433C8;
	Wed, 20 Dec 2023 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088771;
	bh=mF0QQ/Ws9CnsmV4rFgdjNKv+oAkKUZLDWORkwoju6qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjco4r7jo1BrwBrBBuOM+T6doZuHEB3dvSLVxAVg5zhYrvS0+XmHZScQ636o6x09A
	 fug7tHIxXkn8Gs0MBdX+1I+StULovMidCSH9eEm9kuxvgptAUOwehrwDJpmEG/RFEO
	 NmvDg3gUlVihnePSBCE8Z55fK9M7Avr0BUQMUliw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 052/159] ksmbd: casefold utf-8 share names and fix ascii lowercase conversion
Date: Wed, 20 Dec 2023 17:08:37 +0100
Message-ID: <20231220160933.756482176@linuxfoundation.org>
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

[ Upstream commit 16b5f54e30c1ddec36bdf946a299b3254aace477 ]

strtolower() corrupts all UTF-8 share names that have a byte in the C0
(À ISO8859-1) to DE (Þ ISO8859-1) range, since the non-ASCII part of
ISO8859-1 is incompatible with UTF-8. Prevent this by checking that a
byte is in the ASCII range with isascii(), before the conversion to
lowercase with tolower(). Properly handle case-insensitivity of UTF-8
share names by casefolding them, but fallback to ASCII lowercase
conversion on failure or if CONFIG_UNICODE is not set. Refactor to move
the share name casefolding immediately after the share name extraction.
Also, make the associated constness corrections.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c        |    8 +++++++
 fs/ksmbd/connection.h        |    1 
 fs/ksmbd/mgmt/share_config.c |   18 +++--------------
 fs/ksmbd/mgmt/share_config.h |    2 -
 fs/ksmbd/mgmt/tree_connect.c |    2 -
 fs/ksmbd/mgmt/tree_connect.h |    2 -
 fs/ksmbd/misc.c              |   44 +++++++++++++++++++++++++++++++++++--------
 fs/ksmbd/misc.h              |    2 -
 fs/ksmbd/smb2pdu.c           |    2 -
 fs/ksmbd/unicode.h           |    3 +-
 10 files changed, 56 insertions(+), 28 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -60,6 +60,12 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 	conn->local_nls = load_nls("utf8");
 	if (!conn->local_nls)
 		conn->local_nls = load_nls_default();
+	if (IS_ENABLED(CONFIG_UNICODE))
+		conn->um = utf8_load("12.1.0");
+	else
+		conn->um = ERR_PTR(-EOPNOTSUPP);
+	if (IS_ERR(conn->um))
+		conn->um = NULL;
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
@@ -361,6 +367,8 @@ out:
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
 
 
+	if (IS_ENABLED(CONFIG_UNICODE))
+		utf8_unload(conn->um);
 	unload_nls(conn->local_nls);
 	if (default_conn_ops.terminate_fn)
 		default_conn_ops.terminate_fn(conn);
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -46,6 +46,7 @@ struct ksmbd_conn {
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
+	struct unicode_map		*um;
 	struct list_head		conns_list;
 	/* smb session 1 per user */
 	struct xarray			sessions;
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -26,7 +26,7 @@ struct ksmbd_veto_pattern {
 	struct list_head	list;
 };
 
-static unsigned int share_name_hash(char *name)
+static unsigned int share_name_hash(const char *name)
 {
 	return jhash(name, strlen(name), 0);
 }
@@ -72,7 +72,7 @@ __get_share_config(struct ksmbd_share_co
 	return share;
 }
 
-static struct ksmbd_share_config *__share_lookup(char *name)
+static struct ksmbd_share_config *__share_lookup(const char *name)
 {
 	struct ksmbd_share_config *share;
 	unsigned int key = share_name_hash(name);
@@ -119,7 +119,7 @@ static int parse_veto_list(struct ksmbd_
 	return 0;
 }
 
-static struct ksmbd_share_config *share_config_request(char *name)
+static struct ksmbd_share_config *share_config_request(const char *name)
 {
 	struct ksmbd_share_config_response *resp;
 	struct ksmbd_share_config *share = NULL;
@@ -190,20 +190,10 @@ out:
 	return share;
 }
 
-static void strtolower(char *share_name)
-{
-	while (*share_name) {
-		*share_name = tolower(*share_name);
-		share_name++;
-	}
-}
-
-struct ksmbd_share_config *ksmbd_share_config_get(char *name)
+struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
 {
 	struct ksmbd_share_config *share;
 
-	strtolower(name);
-
 	down_read(&shares_table_lock);
 	share = __share_lookup(name);
 	if (share)
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -74,7 +74,7 @@ static inline void ksmbd_share_config_pu
 	__ksmbd_share_config_put(share);
 }
 
-struct ksmbd_share_config *ksmbd_share_config_get(char *name);
+struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -17,7 +17,7 @@
 
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			char *share_name)
+			const char *share_name)
 {
 	struct ksmbd_tree_conn_status status = {-ENOENT, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -42,7 +42,7 @@ struct ksmbd_session;
 
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			char *share_name);
+			const char *share_name);
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 			       struct ksmbd_tree_connect *tree_conn);
--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/xattr.h>
 #include <linux/fs.h>
+#include <linux/unicode.h>
 
 #include "misc.h"
 #include "smb_common.h"
@@ -226,26 +227,53 @@ void ksmbd_conv_path_to_windows(char *pa
 	strreplace(path, '/', '\\');
 }
 
+static char *casefold_sharename(struct unicode_map *um, const char *name)
+{
+	char *cf_name;
+	int cf_len;
+
+	cf_name = kzalloc(KSMBD_REQ_MAX_SHARE_NAME, GFP_KERNEL);
+	if (!cf_name)
+		return ERR_PTR(-ENOMEM);
+
+	if (IS_ENABLED(CONFIG_UNICODE) && um) {
+		const struct qstr q_name = {.name = name, .len = strlen(name)};
+
+		cf_len = utf8_casefold(um, &q_name, cf_name,
+				       KSMBD_REQ_MAX_SHARE_NAME);
+		if (cf_len < 0)
+			goto out_ascii;
+
+		return cf_name;
+	}
+
+out_ascii:
+	cf_len = strscpy(cf_name, name, KSMBD_REQ_MAX_SHARE_NAME);
+	if (cf_len < 0) {
+		kfree(cf_name);
+		return ERR_PTR(-E2BIG);
+	}
+
+	for (; *cf_name; ++cf_name)
+		*cf_name = isascii(*cf_name) ? tolower(*cf_name) : *cf_name;
+	return cf_name - cf_len;
+}
+
 /**
  * ksmbd_extract_sharename() - get share name from tree connect request
  * @treename:	buffer containing tree name and share name
  *
  * Return:      share name on success, otherwise error
  */
-char *ksmbd_extract_sharename(char *treename)
+char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
 {
-	char *name = treename;
-	char *dst;
-	char *pos = strrchr(name, '\\');
+	const char *name = treename, *pos = strrchr(name, '\\');
 
 	if (pos)
 		name = (pos + 1);
 
 	/* caller has to free the memory */
-	dst = kstrdup(name, GFP_KERNEL);
-	if (!dst)
-		return ERR_PTR(-ENOMEM);
-	return dst;
+	return casefold_sharename(um, name);
 }
 
 /**
--- a/fs/ksmbd/misc.h
+++ b/fs/ksmbd/misc.h
@@ -20,7 +20,7 @@ int get_nlink(struct kstat *st);
 void ksmbd_conv_path_to_unix(char *path);
 void ksmbd_strip_last_slash(char *path);
 void ksmbd_conv_path_to_windows(char *path);
-char *ksmbd_extract_sharename(char *treename);
+char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
 char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
 
 #define KSMBD_DIR_INFO_ALIGNMENT	8
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1924,7 +1924,7 @@ int smb2_tree_connect(struct ksmbd_work
 		goto out_err1;
 	}
 
-	name = ksmbd_extract_sharename(treename);
+	name = ksmbd_extract_sharename(conn->um, treename);
 	if (IS_ERR(name)) {
 		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
 		goto out_err1;
--- a/fs/ksmbd/unicode.h
+++ b/fs/ksmbd/unicode.h
@@ -24,6 +24,7 @@
 #include <asm/byteorder.h>
 #include <linux/types.h>
 #include <linux/nls.h>
+#include <linux/unicode.h>
 
 #define  UNIUPR_NOLOWER		/* Example to not expand lower case tables */
 
@@ -69,7 +70,7 @@ char *smb_strndup_from_utf16(const char
 			     const struct nls_table *codepage);
 int smbConvertToUTF16(__le16 *target, const char *source, int srclen,
 		      const struct nls_table *cp, int mapchars);
-char *ksmbd_extract_sharename(char *treename);
+char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
 #endif
 
 /*


