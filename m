Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743B980029;
	Mon,  8 Apr 2024 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583160; cv=none; b=ZFJZltv1rs13vPwWCeVVLKnQceSrC7P/SVLYnWSqJIQs45UPNOCXgZChD4r/8LoEHFz5PHK9sw6M9PXjw2iptgmQe26yayvBgOtdNBo59+fssOUXc439TcmC4dLOlw6hve76A/gg99YOcVloECWnzWF/ytjN8SvpixpohLMJqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583160; c=relaxed/simple;
	bh=RozhS/fFB1GHbzp7pcw/3CnLTFvuJ1c6ePNewJ27+h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9Q5ts5kEmpJkE6QHWB1AbFdvkMRBqZu9LPjLD29EJmU9joKBye0rbQ8g/yqjARiY3cY9k0NYSOxUey01K5gH4mpNKICdn7/7AYR+6xzPxseAazvjJANLTaUbnEFc2Z/n26G/0KcaluclYUIDCYxQk8EK123bEbnn5ufIJo2rgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db8xkxSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db8xkxSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5F4C433F1;
	Mon,  8 Apr 2024 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583160;
	bh=RozhS/fFB1GHbzp7pcw/3CnLTFvuJ1c6ePNewJ27+h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=db8xkxSdMz6m02M1uIDe+xPspmrQZnaDCOUmyL8M5/NJdKo6GXCBag825oAqaYlY1
	 MKx9vsaZHXfZyUDm+nwKwqj+voZt1lNPrWVAc4BECDqmsSQF5vrzyesPMG/8nvcDEQ
	 9zfeXfa0v1l4WeCZrB22K20sMlp/p5NZmoxVVHJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 217/690] fanotify: use macros to get the offset to fanotify_info buffer
Date: Mon,  8 Apr 2024 14:51:23 +0200
Message-ID: <20240408125407.399451003@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 2d9374f095136206a02eb0b6cd9ef94632c1e9f7 ]

The fanotify_info buffer contains up to two file handles and a name.
Use macros to simplify the code that access the different items within
the buffer.

Add assertions to verify that stored fh len and name len do not overflow
the u8 stored value in fanotify_info header.

Remove the unused fanotify_info_len() helper.

Link: https://lore.kernel.org/r/20211129201537.1932819-6-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.c |  2 +-
 fs/notify/fanotify/fanotify.h | 41 +++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 85e542b164c8c..ffad224be0149 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -411,7 +411,7 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	 * be zero in that case if encoding fh len failed.
 	 */
 	err = -ENOENT;
-	if (fh_len < 4 || WARN_ON_ONCE(fh_len % 4))
+	if (fh_len < 4 || WARN_ON_ONCE(fh_len % 4) || fh_len > MAX_HANDLE_SZ)
 		goto out_err;
 
 	/* No external buffer in a variable size allocated fh */
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index d25f500bf7e79..dd23ba659e76b 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -49,6 +49,22 @@ struct fanotify_info {
 	 * (optional) file_fh starts at buf[dir_fh_totlen]
 	 * name starts at buf[dir_fh_totlen + file_fh_totlen]
 	 */
+#define FANOTIFY_DIR_FH_SIZE(info)	((info)->dir_fh_totlen)
+#define FANOTIFY_FILE_FH_SIZE(info)	((info)->file_fh_totlen)
+#define FANOTIFY_NAME_SIZE(info)	((info)->name_len + 1)
+
+#define FANOTIFY_DIR_FH_OFFSET(info)	0
+#define FANOTIFY_FILE_FH_OFFSET(info) \
+	(FANOTIFY_DIR_FH_OFFSET(info) + FANOTIFY_DIR_FH_SIZE(info))
+#define FANOTIFY_NAME_OFFSET(info) \
+	(FANOTIFY_FILE_FH_OFFSET(info) + FANOTIFY_FILE_FH_SIZE(info))
+
+#define FANOTIFY_DIR_FH_BUF(info) \
+	((info)->buf + FANOTIFY_DIR_FH_OFFSET(info))
+#define FANOTIFY_FILE_FH_BUF(info) \
+	((info)->buf + FANOTIFY_FILE_FH_OFFSET(info))
+#define FANOTIFY_NAME_BUF(info) \
+	((info)->buf + FANOTIFY_NAME_OFFSET(info))
 } __aligned(4);
 
 static inline bool fanotify_fh_has_ext_buf(struct fanotify_fh *fh)
@@ -87,7 +103,7 @@ static inline struct fanotify_fh *fanotify_info_dir_fh(struct fanotify_info *inf
 {
 	BUILD_BUG_ON(offsetof(struct fanotify_info, buf) % 4);
 
-	return (struct fanotify_fh *)info->buf;
+	return (struct fanotify_fh *)FANOTIFY_DIR_FH_BUF(info);
 }
 
 static inline int fanotify_info_file_fh_len(struct fanotify_info *info)
@@ -101,32 +117,35 @@ static inline int fanotify_info_file_fh_len(struct fanotify_info *info)
 
 static inline struct fanotify_fh *fanotify_info_file_fh(struct fanotify_info *info)
 {
-	return (struct fanotify_fh *)(info->buf + info->dir_fh_totlen);
+	return (struct fanotify_fh *)FANOTIFY_FILE_FH_BUF(info);
 }
 
-static inline const char *fanotify_info_name(struct fanotify_info *info)
+static inline char *fanotify_info_name(struct fanotify_info *info)
 {
-	return info->buf + info->dir_fh_totlen + info->file_fh_totlen;
+	if (!info->name_len)
+		return NULL;
+
+	return FANOTIFY_NAME_BUF(info);
 }
 
 static inline void fanotify_info_init(struct fanotify_info *info)
 {
+	BUILD_BUG_ON(FANOTIFY_FH_HDR_LEN + MAX_HANDLE_SZ > U8_MAX);
+	BUILD_BUG_ON(NAME_MAX > U8_MAX);
+
 	info->dir_fh_totlen = 0;
 	info->file_fh_totlen = 0;
 	info->name_len = 0;
 }
 
-static inline unsigned int fanotify_info_len(struct fanotify_info *info)
-{
-	return info->dir_fh_totlen + info->file_fh_totlen + info->name_len;
-}
-
 static inline void fanotify_info_copy_name(struct fanotify_info *info,
 					   const struct qstr *name)
 {
+	if (WARN_ON_ONCE(name->len > NAME_MAX))
+		return;
+
 	info->name_len = name->len;
-	strcpy(info->buf + info->dir_fh_totlen + info->file_fh_totlen,
-	       name->name);
+	strcpy(fanotify_info_name(info), name->name);
 }
 
 /*
-- 
2.43.0



