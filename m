Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D86FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588DEC433D2;
	Mon, 16 Jan 2023 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888118;
	bh=vqZxRn4hujHC9sVqnpir2AcfKo6w/7Wjnjtk6Z2mX6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyGds4TdX2KZmWdyX+tGRK/UQy14SAxrs+7wL8hTD+KXBde+/dbGYYAaj+8s3wNLW
	 KvhHuO+UlgTBA9gul3kw5gntsiD0VULrSYDyTnfX3upKI08MvBMGLec6lM7zMDWve0
	 +y5dz4glVLZ1TiJqZJ0WCU206TTwKDTyeaw9W6O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jason Yan <yanaijie@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 4.19 408/521] ext4: add helper to check quota inums
Date: Mon, 16 Jan 2023 16:51:10 +0100
Message-Id: <20230116154905.345693938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

commit 07342ec259df2a35d6a34aebce010567a80a0e15 upstream.

Before quota is enabled, a check on the preset quota inums in
ext4_super_block is added to prevent wrong quota inodes from being loaded.
In addition, when the quota fails to be enabled, the quota type and quota
inum are printed to facilitate fault locating.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221026042310.3839669-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5839,6 +5839,20 @@ static int ext4_quota_on(struct super_bl
 	return err;
 }
 
+static inline bool ext4_check_quota_inum(int type, unsigned long qf_inum)
+{
+	switch (type) {
+	case USRQUOTA:
+		return qf_inum == EXT4_USR_QUOTA_INO;
+	case GRPQUOTA:
+		return qf_inum == EXT4_GRP_QUOTA_INO;
+	case PRJQUOTA:
+		return qf_inum >= EXT4_GOOD_OLD_FIRST_INO;
+	default:
+		BUG();
+	}
+}
+
 static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 			     unsigned int flags)
 {
@@ -5855,9 +5869,16 @@ static int ext4_quota_enable(struct supe
 	if (!qf_inums[type])
 		return -EPERM;
 
+	if (!ext4_check_quota_inum(type, qf_inums[type])) {
+		ext4_error(sb, "Bad quota inum: %lu, type: %d",
+				qf_inums[type], type);
+		return -EUCLEAN;
+	}
+
 	qf_inode = ext4_iget(sb, qf_inums[type], EXT4_IGET_SPECIAL);
 	if (IS_ERR(qf_inode)) {
-		ext4_error(sb, "Bad quota inode # %lu", qf_inums[type]);
+		ext4_error(sb, "Bad quota inode: %lu, type: %d",
+				qf_inums[type], type);
 		return PTR_ERR(qf_inode);
 	}
 
@@ -5896,8 +5917,9 @@ static int ext4_enable_quotas(struct sup
 			if (err) {
 				ext4_warning(sb,
 					"Failed to enable quota tracking "
-					"(type=%d, err=%d). Please run "
-					"e2fsck to fix.", type, err);
+					"(type=%d, err=%d, ino=%lu). "
+					"Please run e2fsck to fix.", type,
+					err, qf_inums[type]);
 				for (type--; type >= 0; type--) {
 					struct inode *inode;
 


