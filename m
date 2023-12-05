Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941876FB0;
	Tue,  5 Dec 2023 03:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jibMkaNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12736C433C8;
	Tue,  5 Dec 2023 03:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748013;
	bh=PTYrBH26WmS4RHxmSi9jEBvmMWR4MD5ghVdt4aVgPwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jibMkaNabT1m/dfLEA8B8/YMR4+0QX2Hmc8T80BZw40rjNs1Leq4sm4mrIah741Vr
	 i4pXkVA7X2bnhwInN6b7osnmwrwKGikCW4qLPyiEmBT7tNbUwHAS5lGcQ8ZBljqDuj
	 w9e1CA4M4wtNOsd1HoQZS6/+UTumpOIb001RDwds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com
Subject: [PATCH 5.4 81/94] ima: annotate iint mutex to avoid lockdep false positive warnings
Date: Tue,  5 Dec 2023 12:17:49 +0900
Message-ID: <20231205031527.319281277@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ff37143000b4c..ffdc3ca1e9c16 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -66,9 +66,32 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode)
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
@@ -80,6 +103,14 @@ static void iint_free(struct integrity_iint_cache *iint)
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
 
@@ -112,6 +143,8 @@ struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 	if (!iint)
 		return NULL;
 
+	iint_init_always(iint, inode);
+
 	write_lock(&integrity_iint_lock);
 
 	p = &integrity_iint_tree.rb_node;
@@ -161,25 +194,18 @@ void integrity_inode_free(struct inode *inode)
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
 DEFINE_LSM(integrity) = {
-- 
2.42.0



