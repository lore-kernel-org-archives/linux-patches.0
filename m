Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033287;
	b=V9li2uZLjzXJQa6PAG5bhueADOhCV8Z9PNTPq5ISNfTlJWx3Tf5ku+W5aYb0e90O0FNU
	 Xra8F1aviVIJl6k/xGRhDc18jwEzlL01yMK+rLxbpiwnE98fH2ABmXeyVsegm+xYtsrYk
	 Z9TC/tAQDN3OP91plYuR4ZVEHTgQEbKW4x5Cd4HioIekYAqjS2x/5e8HKwYZTkQsBl6Ga
	 607ZYjNjtsLQwe0ub+WO/165yurHI8hiYT1CGpXZOsoHdCjINTt7cOLUlEMyHYuoJ2HZT
	 U3Hn6u6fvwrlj6xVH0EqHaa3nNf4rQz2ZenMGomudC/lAEi1gCqxRlkRw0BcZFNjTTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1wPyczTQobGolSUblMuyKlCj+DzzfLI122Ofn/WbxoQ=;
	b=VMMDQaOds9OC89eo39ua02ehLmP5eOy/R6CxgQ319OLg2hgOIt8hhojy3MDw8yFuVFD7
	 jpYrdqVN2AqEAJ/9/+XlytAdsztKQegqaHqRN0WPpJ/QFcPg6bwOovU07IrjSErrM4VUQ
	 xtwmFSBWxxnBH1rjDPlAcYCgIHFhib+5NgfrYAgzKesOq69jniTfUDo7wUsKMmR+LXMew
	 JG++kuNyGT0lzX6HRj9dFpATUi6ZAoSmgAi6pePrkzA39Hq1FI3F/UTyS5CXAEsQ5i0wa
	 eTlujiHamVvks0ClO+MaEgIK0uzUKY5QYzU8gRayQ1mcoRR0GZVB+up0dGjcayEj+0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLlDBJnx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3C4606A31C;
	Wed, 18 Nov 2026 20:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLlDBJnx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857381F000C4;
	Wed, 18 Nov 2026 20:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033287;
	bh=1wPyczTQobGolSUblMuyKlCj+DzzfLI122Ofn/WbxoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLlDBJnx5hwccsN0FNT+0QIS7XqNBhRw3kWoVvq4cZrRXawfFtoFjjbhMwsm2bmvY
	 KBkqDcmOtgw0xdtm91F412T0k0b7RH+4xnxHZqZzF2PfS3g4YAlgfrAwAM+fEVaOTx
	 RFWbURq+0xLGVMUeBMH7cVTy7424K3p4/vLJlAxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1715/1756] Add error handling to minix filesystem for inode corruption detection
Date: Wed, 18 Nov 2026 16:04:02 +0100
Message-ID: <20261118150117.882404841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7084f41cefbcd..1bea63d71b806 100644
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



