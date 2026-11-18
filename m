Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028381;
	b=ZbEgGLLWHQIp8indvTLBGqMPfdLkCkK5RSZkxsWe+lPwtiSX754HxCszXSiquweQP7t0
	 c0QJ7dU0pXDiujZTv+I8jBY3BcokEts16N8MOWUCW8YGA2n4SAS1MZwWfsPqOkRQ0Ji9Y
	 9UBhNAGfZ9uEE4Fz2CdYWZZSieYpk0F75sSmbjPaQ/3LjduAcfpHlCDhWum23BJOEiHij
	 F1U53ai+BEWA3C/ATksBpRegQqNrH63NtOlR9S/0uOSJdgp/qxwxEK7VqkFjhVvxYHIMZ
	 5WA0zDS0WEe2sCTk+QC+ScjQzovT7TwZczk5t24YozhufmarxR6gZfbbUh830IMiNrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T9LfPRSxhkDS/W4227yFJWzQtHevxQnUDz248MrYsVQ=;
	b=ap+GWheveqfPdBcdo2ojWfS6Y0YQT+7hi5CpUKOTmvzG+/gyCidcm/BxP2pRfiTFlZtz
	 WpBCYK8JLt8Ulo05zp5N72HG4aUUg7gh4AHA1tMVC77X0D5xCWpnjteZsRe8U3U/e0qBT
	 8R7fNMroSW9NzvuEffELzgO1XD4zEDw69GUkGqw3+pWLdOOgVxauetI0+nMYYfr6YBMc5
	 esER80Zr+oCewhfskdEMlkQm5CpcunAliFjlWXTCdIz5VZ+s1/amluVqVUGARzpdrZDxl
	 bgx6g3mXRDkJLgeijbD/4lI6JQ4mvE30V81+zWsaJsm5803S5Zr+alF+Hs6wYj/Mepg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mwj1YHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646D9606A325;
	Wed, 18 Nov 2026 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1mwj1YHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F3F1F000C7;
	Wed, 18 Nov 2026 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028381;
	bh=T9LfPRSxhkDS/W4227yFJWzQtHevxQnUDz248MrYsVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mwj1YHAAvyrVPwDWL9WW1KMgrOyzvVvEHGddxu6TbDbCuzQ5TJRgc6OPvV2WG/tw
	 w4ag5emahoIcpC8Lf5ZLKhKrsCGyGHL4JHJxMXpxmIu4OjpHWoVtqOM9xVz4T1uOqG
	 7ea0uIHBDcyQp/hNdD71zsUaZLWZ8mGjSQzsTpFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2124/2151] Add error handling to minix filesystem for inode corruption detection
Date: Wed, 18 Nov 2026 16:04:19 +0100
Message-ID: <20261118150239.062247279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 21215ce7a95ae03891708028a8c805e5dc47395e ]

We would like to provide early and specific warnings of filesystem
corruption without running into generic WARN_ONs and BUG_ONs.
Towards this goal, ext4, e.g., has a EFSCORRUPTED errno and a
standardized inode corruption message format. This patch adds this
errno and message format to the minix filesystem.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20251104143005.3283980-2-jkoolstra@xs4all.nl
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: fc9577079df8 ("minix: reject rmdir of a directory with a corrupted link count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 16 ++++++++++++++++
 fs/minix/minix.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 5bfe42599a585..ed84279446267 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -26,6 +26,22 @@ static int minix_write_inode(struct inode *inode,
 		struct writeback_control *wbc);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
 
+void __minix_error_inode(struct inode *inode, const char *function,
+			 unsigned int line, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	printk(KERN_CRIT "minix-fs error (device %s): %s:%d: "
+	       "inode #%lu: comm %s: %pV\n",
+	       inode->i_sb->s_id, function, line, inode->i_ino,
+	       current->comm, &vaf);
+	va_end(args);
+}
+
 static void minix_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index c81e48badae93..73e1087502253 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -42,6 +42,9 @@ struct minix_sb_info {
 	unsigned short s_version;
 };
 
+void __minix_error_inode(struct inode *inode, const char *function,
+			 unsigned int line, const char *fmt, ...);
+
 struct inode *minix_iget(struct super_block *, unsigned long);
 struct minix_inode *minix_V1_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 struct minix2_inode *minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
@@ -168,4 +171,10 @@ static inline int minix_test_bit(int nr, const void *vaddr)
 
 #endif
 
+#define minix_error_inode(inode, fmt, ...)			\
+	__minix_error_inode((inode), __func__, __LINE__,	\
+			    (fmt), ##__VA_ARGS__)
+
+#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+
 #endif /* FS_MINIX_H */
-- 
2.53.0



