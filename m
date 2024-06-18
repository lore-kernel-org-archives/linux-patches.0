Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105C718E749;
	Tue, 18 Jun 2024 13:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715740; cv=none; b=ZxfoMwc+zbAIci6S2SZQSHbCxliBRjiw9b29PiwytBAHbgCfoDc8irMa84jX18/G6osN2o6n2MXpjngYKwXRS0Ojuc8L0HCFr8lsh55b9y+2xWPbRbldQ2/O/vZOW7BljZ4Nf438g4k0b5QrXK20laNkmfMQlaKljw9qL3eIlYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715740; c=relaxed/simple;
	bh=FpVOSupl9V81AOWVJieCi0HmfJu3k7eupidplDPMWEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H90s1RvT7dMjeysdgpWY/A8YlpH9EIrqiWxc1kIhpFnawdBrsUF4fNdkbm8Lr+dz09tARj1g0D53b8W6s8q9ejggtCqnkG7TFSVP+/bKzhcjAgxLQaVByGRVlOtN97OCRJWmOKYmHxokEYv6UG/+ZX58AwfDr3aEYVo3m7uagGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsQbu3w/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsQbu3w/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACE2C3277B;
	Tue, 18 Jun 2024 13:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715739;
	bh=FpVOSupl9V81AOWVJieCi0HmfJu3k7eupidplDPMWEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsQbu3w/2+CgFDXh2SY1ZdtV15QSQ4ilQaWAes6Q30UvTGSsj9Ppw/WJnY9TjTNvJ
	 d6/YCbIYyPWsKrLO+KRvqT4zb3MmdhvBkIoxpIzHY1YJ3lNQVIAARkl0gjXrF+OAhp
	 mJKguJAmLd749zGpPMsW5VPEYSJ8yaVXS8UusOfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/770] fanotify: use macros to get the offset to fanotify_info buffer
Date: Tue, 18 Jun 2024 14:34:22 +0200
Message-ID: <20240618123423.073956010@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



