Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A7F2FC21;
	Fri, 24 Nov 2023 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+wJRCX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BA3C433C8;
	Fri, 24 Nov 2023 18:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851194;
	bh=fL87N7klrL5e9eCb5eGvQbK4iUiaCq3Sdzd6h0KGjrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+wJRCX2s1bnNTBoo14DTJD8CefK3surgQrXh6dl6PNi/qxZCSfAL3cDgSRNIgQhH
	 ASWcm0aDG7ai97iIJlN11nktmA0DQ+pHLeqEv23CakGQmx6CcQ44T3srrbDzxWEiL6
	 FA4ZMoXAAePUuFhPOc1p07xIiqYehv4Gpvg1SkjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Raul E Rangel <rrangel@chromium.org>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.5 326/491] ima: detect changes to the backing overlay file
Date: Fri, 24 Nov 2023 17:49:22 +0000
Message-ID: <20231124172034.364655065@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.ibm.com>

commit b836c4d29f2744200b2af41e14bf50758dddc818 upstream.

Commit 18b44bc5a672 ("ovl: Always reevaluate the file signature for
IMA") forced signature re-evaulation on every file access.

Instead of always re-evaluating the file's integrity, detect a change
to the backing file, by comparing the cached file metadata with the
backing file's metadata.  Verifying just the i_version has not changed
is insufficient.  In addition save and compare the i_ino and s_dev
as well.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Eric Snowberg <eric.snowberg@oracle.com>
Tested-by: Raul E Rangel <rrangel@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c              |    2 +-
 security/integrity/ima/ima_api.c  |    5 +++++
 security/integrity/ima/ima_main.c |   16 +++++++++++++++-
 security/integrity/integrity.h    |    2 ++
 4 files changed, 23 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1467,7 +1467,7 @@ int ovl_fill_super(struct super_block *s
 		ovl_trusted_xattr_handlers;
 	sb->s_fs_info = ofs;
 	sb->s_flags |= SB_POSIXACL;
-	sb->s_iflags |= SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATURE;
+	sb->s_iflags |= SB_I_SKIP_SYNC;
 
 	err = -ENOMEM;
 	root_dentry = ovl_get_root(sb, ctx->upper.dentry, oe);
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -243,6 +243,7 @@ int ima_collect_measurement(struct integ
 {
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
+	struct inode *real_inode = d_real_inode(file_dentry(file));
 	const char *filename = file->f_path.dentry->d_name.name;
 	struct ima_max_digest_data hash;
 	struct kstat stat;
@@ -302,6 +303,10 @@ int ima_collect_measurement(struct integ
 	iint->ima_hash = tmpbuf;
 	memcpy(iint->ima_hash, &hash, length);
 	iint->version = i_version;
+	if (real_inode != inode) {
+		iint->real_ino = real_inode->i_ino;
+		iint->real_dev = real_inode->i_sb->s_dev;
+	}
 
 	/* Possibly temporary failure due to type of read (eg. O_DIRECT) */
 	if (!result)
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -25,6 +25,7 @@
 #include <linux/xattr.h>
 #include <linux/ima.h>
 #include <linux/fs.h>
+#include <linux/iversion.h>
 
 #include "ima.h"
 
@@ -207,7 +208,7 @@ static int process_measurement(struct fi
 			       u32 secid, char *buf, loff_t size, int mask,
 			       enum ima_hooks func)
 {
-	struct inode *inode = file_inode(file);
+	struct inode *backing_inode, *inode = file_inode(file);
 	struct integrity_iint_cache *iint = NULL;
 	struct ima_template_desc *template_desc = NULL;
 	char *pathbuf = NULL;
@@ -284,6 +285,19 @@ static int process_measurement(struct fi
 		iint->measured_pcrs = 0;
 	}
 
+	/* Detect and re-evaluate changes made to the backing file. */
+	backing_inode = d_real_inode(file_dentry(file));
+	if (backing_inode != inode &&
+	    (action & IMA_DO_MASK) && (iint->flags & IMA_DONE_MASK)) {
+		if (!IS_I_VERSION(backing_inode) ||
+		    backing_inode->i_sb->s_dev != iint->real_dev ||
+		    backing_inode->i_ino != iint->real_ino ||
+		    !inode_eq_iversion(backing_inode, iint->version)) {
+			iint->flags &= ~IMA_DONE_MASK;
+			iint->measured_pcrs = 0;
+		}
+	}
+
 	/* Determine if already appraised/measured based on bitmask
 	 * (IMA_MEASURE, IMA_MEASURED, IMA_XXXX_APPRAISE, IMA_XXXX_APPRAISED,
 	 *  IMA_AUDIT, IMA_AUDITED)
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -164,6 +164,8 @@ struct integrity_iint_cache {
 	unsigned long flags;
 	unsigned long measured_pcrs;
 	unsigned long atomic_flags;
+	unsigned long real_ino;
+	dev_t real_dev;
 	enum integrity_status ima_file_status:4;
 	enum integrity_status ima_mmap_status:4;
 	enum integrity_status ima_bprm_status:4;


