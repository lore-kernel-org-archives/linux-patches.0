Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F54356A2C
	for <patches@lists.linux.dev>; Fri, 23 Jan 2026 02:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769136083; cv=none; b=KEk0t3cCiq5Acb1MbNNlu1gsjWgiJlPgDWls2Zab3IlAqx28PklWXd/DvugnVCjkbSuJRt5MFt47OK6/Hs+9gY5UMPB/WwFES3sYc2w53+cEyzENI+WTFkaaoHq0T4m4X6sX6NfdRCuQ4Af+YdeaGl3RJAGpls76d++mMLecO5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769136083; c=relaxed/simple;
	bh=iP+Z1BSfQ34DlgbobzgZtwMFnl9QrexkVBD/N2NOYY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CODOC80AVfIP+/u6iaR/4/SIndrozg7f4PTQIYLZfN41cCKUa88KaoSWD7bmsKjCXzzlBNSk0impTRGYEDueROm5JYCLiUJA1Hs6tEw6DXcAktb4lKdvYH/EN/OUnzuu73yNu02ICxuZda1uGsF6ReYUuHZpRBBl+9U0DLV0YnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=cLOCS3AH; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="cLOCS3AH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=cLOCS3AHMRFgD7LSTgAC/VDoE7HKuWV30iTyOzqM6j519inAz1Jm2E10XiplbZYG3ecxm5Fi5pzS+
	 NHH8fzdJ/Q0BERZDemEBKr/bYubQc0x6LkTuqJiOYDfltE/UeY6YcRw/vJWBTF8EfrJ2aSqkIAyF1L
	 zWlVj8/FYX+YT5Rw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-21-12024 (RichMail) with SMTP id 2ef86972dee3c3f-04ca3;
	Fri, 23 Jan 2026 10:37:26 +0800 (CST)
X-RM-TRANSID:2ef86972dee3c3f-04ca3
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	sfual@cse.ust.hk
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yuezhang.Mo@sony.com,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	p22gone@gmail.com,
	kkamagui@gmail.com,
	jimmyxyz010315@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 6.12.y] exfat: fix refcount leak in exfat_find
Date: Fri, 23 Jan 2026 10:37:21 +0800
Message-Id: <20260123023721.3779125-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit 9aee8de970f18c2aaaa348e3de86c38e2d956c1d ]

Fix refcount leaks in `exfat_find` related to `exfat_get_dentry_set`.

Function `exfat_get_dentry_set` would increase the reference counter of
`es->bh` on success. Therefore, `exfat_put_dentry_set` must be called
after `exfat_get_dentry_set` to ensure refcount consistency. This patch
relocate two checks to avoid possible leaks.

Fixes: 82ebecdc74ff ("exfat: fix improper check of dentry.stream.valid_size")
Fixes: 13940cef9549 ("exfat: add a check for invalid data size")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/exfat/namei.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index f0fda3469404..44cce2544a74 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -638,16 +638,6 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
 
-	if (info->valid_size < 0) {
-		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
-		return -EIO;
-	}
-
-	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
-		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
-		return -EIO;
-	}
-
 	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
 	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
 		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
@@ -685,6 +675,16 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 			     0);
 	exfat_put_dentry_set(&es, false);
 
+	if (info->valid_size < 0) {
+		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
+		return -EIO;
+	}
+
+	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
+		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
+		return -EIO;
+	}
+
 	if (ei->start_clu == EXFAT_FREE_CLUSTER) {
 		exfat_fs_error(sb,
 			       "non-zero size file starts with zero cluster (size : %llu, p_dir : %u, entry : 0x%08x)",
-- 
2.34.1


