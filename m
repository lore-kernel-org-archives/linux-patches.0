Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2045C6FB0;
	Tue,  5 Dec 2023 03:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN8eFlB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C18C433C8;
	Tue,  5 Dec 2023 03:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748019;
	bh=826GaVaP7pk/OUogj7AFHZxdGzsS9bSSg+7q8f0cr0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN8eFlB/Juaod3njpg8fs1zjzv7vlUWl26fZBn5kugkuWN6pmhwnQ/5y4NhhrcQtf
	 ZTz7HBrGRiSe/wu0wMm7nxndhr39Z15POVLgOA8VU9KMH3OvCtF3nZT3NVBzEgJshX
	 vDrFubUP5D3UQQhRjFUoeMaegwqPokPQuo0YdsII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Raul E Rangel <rrangel@chromium.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 83/94] ima: detect changes to the backing overlay file
Date: Tue,  5 Dec 2023 12:17:51 +0900
Message-ID: <20231205031527.437612919@linuxfoundation.org>
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

From: Mimi Zohar <zohar@linux.ibm.com>

[ Upstream commit b836c4d29f2744200b2af41e14bf50758dddc818 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_api.c  |  5 +++++
 security/integrity/ima/ima_main.c | 16 +++++++++++++++-
 security/integrity/integrity.h    |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 610759fe63b8a..364979233a174 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -209,6 +209,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 {
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
+	struct inode *real_inode = d_real_inode(file_dentry(file));
 	const char *filename = file->f_path.dentry->d_name.name;
 	int result = 0;
 	int length;
@@ -259,6 +260,10 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	iint->ima_hash = tmpbuf;
 	memcpy(iint->ima_hash, &hash, length);
 	iint->version = i_version;
+	if (real_inode != inode) {
+		iint->real_ino = real_inode->i_ino;
+		iint->real_dev = real_inode->i_sb->s_dev;
+	}
 
 	/* Possibly temporary failure due to type of read (eg. O_DIRECT) */
 	if (!result)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 6a2377eee03d8..09b9c2b252944 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -27,6 +27,7 @@
 #include <linux/ima.h>
 #include <linux/iversion.h>
 #include <linux/fs.h>
+#include <linux/iversion.h>
 
 #include "ima.h"
 
@@ -193,7 +194,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 			       u32 secid, char *buf, loff_t size, int mask,
 			       enum ima_hooks func)
 {
-	struct inode *inode = file_inode(file);
+	struct inode *backing_inode, *inode = file_inode(file);
 	struct integrity_iint_cache *iint = NULL;
 	struct ima_template_desc *template_desc = NULL;
 	char *pathbuf = NULL;
@@ -267,6 +268,19 @@ static int process_measurement(struct file *file, const struct cred *cred,
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
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d9323d31a3a83..f63516ebec5db 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -124,6 +124,8 @@ struct integrity_iint_cache {
 	unsigned long flags;
 	unsigned long measured_pcrs;
 	unsigned long atomic_flags;
+	unsigned long real_ino;
+	dev_t real_dev;
 	enum integrity_status ima_file_status:4;
 	enum integrity_status ima_mmap_status:4;
 	enum integrity_status ima_bprm_status:4;
-- 
2.42.0



