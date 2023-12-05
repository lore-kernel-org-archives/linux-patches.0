Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1F86FAF;
	Tue,  5 Dec 2023 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG6xR6Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E31EC433C8;
	Tue,  5 Dec 2023 03:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746907;
	bh=VNIF8IvsapDcMcGBOLoQzBaKutUaJwaQU+WheKfZn8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KG6xR6MsFW/IUV5Bh6NS0i/Ton7l3h9wgjU+WDxlkUDDhBl4V+Zb2MQPfjSdRTOfY
	 w0tjMAtJE3b/i6s8YqWciI+1ILHMdmlV0GLrAh3nUcvuYqb1ovIFatKh/TR5EcWeFz
	 9x9jcVN5kMnMtd3+3iUEbdONhhirKa0BJ900Slnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com
Subject: [PATCH 4.19 62/71] ima: annotate iint mutex to avoid lockdep false positive warnings
Date: Tue,  5 Dec 2023 12:17:00 +0900
Message-ID: <20231205031521.477996507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit e044374a8a0a99e46f4e6d6751d3042b6d9cc12e ]

It is not clear that IMA should be nested at all, but as long is it
measures files both on overlayfs and on underlying fs, we need to
annotate the iint mutex to avoid lockdep false positives related to
IMA + overlayfs, same as overlayfs annotates the inode mutex.

Reported-and-tested-by: syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/iint.c | 48 ++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index d5b9253ebd12b..7c751c23e7e63 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -69,9 +69,32 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode)
 	return iint;
 }
 
-static void iint_free(struct integrity_iint_cache *iint)
+#define IMA_MAX_NESTING (FILESYSTEM_MAX_STACK_DEPTH+1)
+
+/*
+ * It is not clear that IMA should be nested at all, but as long is it measures
+ * files both on overlayfs and on underlying fs, we need to annotate the iint
+ * mutex to avoid lockdep false positives related to IMA + overlayfs.
+ * See ovl_lockdep_annotate_inode_mutex_key() for more details.
+ */
+static inline void iint_lockdep_annotate(struct integrity_iint_cache *iint,
+					 struct inode *inode)
+{
+#ifdef CONFIG_LOCKDEP
+	static struct lock_class_key iint_mutex_key[IMA_MAX_NESTING];
+
+	int depth = inode->i_sb->s_stack_depth;
+
+	if (WARN_ON_ONCE(depth < 0 || depth >= IMA_MAX_NESTING))
+		depth = 0;
+
+	lockdep_set_class(&iint->mutex, &iint_mutex_key[depth]);
+#endif
+}
+
+static void iint_init_always(struct integrity_iint_cache *iint,
+			     struct inode *inode)
 {
-	kfree(iint->ima_hash);
 	iint->ima_hash = NULL;
 	iint->version = 0;
 	iint->flags = 0UL;
@@ -83,6 +106,14 @@ static void iint_free(struct integrity_iint_cache *iint)
 	iint->ima_creds_status = INTEGRITY_UNKNOWN;
 	iint->evm_status = INTEGRITY_UNKNOWN;
 	iint->measured_pcrs = 0;
+	mutex_init(&iint->mutex);
+	iint_lockdep_annotate(iint, inode);
+}
+
+static void iint_free(struct integrity_iint_cache *iint)
+{
+	kfree(iint->ima_hash);
+	mutex_destroy(&iint->mutex);
 	kmem_cache_free(iint_cache, iint);
 }
 
@@ -107,6 +138,8 @@ struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 	if (!iint)
 		return NULL;
 
+	iint_init_always(iint, inode);
+
 	write_lock(&integrity_iint_lock);
 
 	p = &integrity_iint_tree.rb_node;
@@ -156,25 +189,18 @@ void integrity_inode_free(struct inode *inode)
 	iint_free(iint);
 }
 
-static void init_once(void *foo)
+static void iint_init_once(void *foo)
 {
 	struct integrity_iint_cache *iint = foo;
 
 	memset(iint, 0, sizeof(*iint));
-	iint->ima_file_status = INTEGRITY_UNKNOWN;
-	iint->ima_mmap_status = INTEGRITY_UNKNOWN;
-	iint->ima_bprm_status = INTEGRITY_UNKNOWN;
-	iint->ima_read_status = INTEGRITY_UNKNOWN;
-	iint->ima_creds_status = INTEGRITY_UNKNOWN;
-	iint->evm_status = INTEGRITY_UNKNOWN;
-	mutex_init(&iint->mutex);
 }
 
 static int __init integrity_iintcache_init(void)
 {
 	iint_cache =
 	    kmem_cache_create("iint_cache", sizeof(struct integrity_iint_cache),
-			      0, SLAB_PANIC, init_once);
+			      0, SLAB_PANIC, iint_init_once);
 	return 0;
 }
 security_initcall(integrity_iintcache_init);
-- 
2.42.0



