Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B319E7F9;
	Tue, 27 May 2025 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365640; cv=none; b=g2EFANM3jdMHSpeZnM8WQKDcIYPW1UsIQXUf8Rrzl64tKN4LUEc7MYJ915OOIk9S/prOSAMah5LbMzOZ9QMGOG3rVnt9RJzqtzxvkSA7gDUdeFDUZaERA1rkv6OKaVOijK4WOM0k5KFu6Z27dIn86dQI9vjF1Z6CHD7SxLRUSMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365640; c=relaxed/simple;
	bh=qYNondvNp9RH+6KYepvnCdOSGa5malrZqStZGFVDKuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmH5gkpPOIg1wkTLU1/RBtolnwQYLbmYH+dZQmjnYzyoDqXmF64SHr5dHx4bbRkUenpo8CsuNerM+Zv+Cqay3XYwm6QXt2JVTq/di45A/5WxpS9F1YfqNWBxUhA8ltyK9sKloE26JLapAkqC7nZSS8CT/3pf89dVblTFHQ4ffj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBza9Qhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBza9Qhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59996C4CEE9;
	Tue, 27 May 2025 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365639;
	bh=qYNondvNp9RH+6KYepvnCdOSGa5malrZqStZGFVDKuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBza9Qhpq6vVOOEa1ND2sa8D7YSKoJUoajAr+VoOoTm4zi5hK2cXN3+Maq5SDcouK
	 VjnfmigdMZWmuJwjHk9jtEuYJDtv87F32FTLjuMMQuAJtbt9Xyu0ug5Q6iEHuHfmKp
	 RPZhXm8/khz9oZModroMpcj3pqczEt4dP/q9LGoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 440/626] f2fs: introduce f2fs_base_attr for global sysfs entries
Date: Tue, 27 May 2025 18:25:33 +0200
Message-ID: <20250527162502.879454769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 21925ede449e038ed6f9efdfe0e79f15bddc34bc ]

In /sys/fs/f2fs/features, there's no f2fs_sb_info, so let's avoid to get
the pointer.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 74 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 22 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index d9a44f03e558b..7df638f901a1f 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -61,6 +61,12 @@ struct f2fs_attr {
 	int id;
 };
 
+struct f2fs_base_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct f2fs_base_attr *a, char *buf);
+	ssize_t (*store)(struct f2fs_base_attr *a, const char *buf, size_t len);
+};
+
 static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 			     struct f2fs_sb_info *sbi, char *buf);
 
@@ -864,6 +870,25 @@ static void f2fs_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static ssize_t f2fs_base_attr_show(struct kobject *kobj,
+				struct attribute *attr, char *buf)
+{
+	struct f2fs_base_attr *a = container_of(attr,
+				struct f2fs_base_attr, attr);
+
+	return a->show ? a->show(a, buf) : 0;
+}
+
+static ssize_t f2fs_base_attr_store(struct kobject *kobj,
+				struct attribute *attr,
+				const char *buf, size_t len)
+{
+	struct f2fs_base_attr *a = container_of(attr,
+				struct f2fs_base_attr, attr);
+
+	return a->store ? a->store(a, buf, len) : 0;
+}
+
 /*
  * Note that there are three feature list entries:
  * 1) /sys/fs/f2fs/features
@@ -882,14 +907,13 @@ static void f2fs_sb_release(struct kobject *kobj)
  *     please add new on-disk feature in this list only.
  *     - ref. F2FS_SB_FEATURE_RO_ATTR()
  */
-static ssize_t f2fs_feature_show(struct f2fs_attr *a,
-		struct f2fs_sb_info *sbi, char *buf)
+static ssize_t f2fs_feature_show(struct f2fs_base_attr *a, char *buf)
 {
 	return sysfs_emit(buf, "supported\n");
 }
 
 #define F2FS_FEATURE_RO_ATTR(_name)				\
-static struct f2fs_attr f2fs_attr_##_name = {			\
+static struct f2fs_base_attr f2fs_base_attr_##_name = {		\
 	.attr = {.name = __stringify(_name), .mode = 0444 },	\
 	.show	= f2fs_feature_show,				\
 }
@@ -1258,37 +1282,38 @@ static struct attribute *f2fs_attrs[] = {
 };
 ATTRIBUTE_GROUPS(f2fs);
 
+#define BASE_ATTR_LIST(name) (&f2fs_base_attr_##name.attr)
 static struct attribute *f2fs_feat_attrs[] = {
 #ifdef CONFIG_FS_ENCRYPTION
-	ATTR_LIST(encryption),
-	ATTR_LIST(test_dummy_encryption_v2),
+	BASE_ATTR_LIST(encryption),
+	BASE_ATTR_LIST(test_dummy_encryption_v2),
 #if IS_ENABLED(CONFIG_UNICODE)
-	ATTR_LIST(encrypted_casefold),
+	BASE_ATTR_LIST(encrypted_casefold),
 #endif
 #endif /* CONFIG_FS_ENCRYPTION */
 #ifdef CONFIG_BLK_DEV_ZONED
-	ATTR_LIST(block_zoned),
+	BASE_ATTR_LIST(block_zoned),
 #endif
-	ATTR_LIST(atomic_write),
-	ATTR_LIST(extra_attr),
-	ATTR_LIST(project_quota),
-	ATTR_LIST(inode_checksum),
-	ATTR_LIST(flexible_inline_xattr),
-	ATTR_LIST(quota_ino),
-	ATTR_LIST(inode_crtime),
-	ATTR_LIST(lost_found),
+	BASE_ATTR_LIST(atomic_write),
+	BASE_ATTR_LIST(extra_attr),
+	BASE_ATTR_LIST(project_quota),
+	BASE_ATTR_LIST(inode_checksum),
+	BASE_ATTR_LIST(flexible_inline_xattr),
+	BASE_ATTR_LIST(quota_ino),
+	BASE_ATTR_LIST(inode_crtime),
+	BASE_ATTR_LIST(lost_found),
 #ifdef CONFIG_FS_VERITY
-	ATTR_LIST(verity),
+	BASE_ATTR_LIST(verity),
 #endif
-	ATTR_LIST(sb_checksum),
+	BASE_ATTR_LIST(sb_checksum),
 #if IS_ENABLED(CONFIG_UNICODE)
-	ATTR_LIST(casefold),
+	BASE_ATTR_LIST(casefold),
 #endif
-	ATTR_LIST(readonly),
+	BASE_ATTR_LIST(readonly),
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-	ATTR_LIST(compression),
+	BASE_ATTR_LIST(compression),
 #endif
-	ATTR_LIST(pin_file),
+	BASE_ATTR_LIST(pin_file),
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs_feat);
@@ -1362,9 +1387,14 @@ static struct kset f2fs_kset = {
 	.kobj	= {.ktype = &f2fs_ktype},
 };
 
+static const struct sysfs_ops f2fs_feat_attr_ops = {
+	.show	= f2fs_base_attr_show,
+	.store	= f2fs_base_attr_store,
+};
+
 static const struct kobj_type f2fs_feat_ktype = {
 	.default_groups = f2fs_feat_groups,
-	.sysfs_ops	= &f2fs_attr_ops,
+	.sysfs_ops	= &f2fs_feat_attr_ops,
 };
 
 static struct kobject f2fs_feat = {
-- 
2.39.5



