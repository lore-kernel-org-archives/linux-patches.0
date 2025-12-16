Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B52E340DB7;
	Tue, 16 Dec 2025 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884780; cv=none; b=WhzQHfFuud/khxiqPQZcWcwGavfeH9tTQ4EYg+xS6tM/BAMGIQ2oa0pedUe1p55HclXPpeTuJGoOQEAIZJ2Z5wxR1FP1qmJgdzWEoRJig4H0eFNO0YoWQBB//d3JHRZ2JPx9eoLZarIwXB72P4OoeeBMO+vZz0qRqVgwifR58yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884780; c=relaxed/simple;
	bh=YuAoCR/eSOhn8IVUYeVCzQ3hHLaU1Rj3XRpQje7f9BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usy9zvyuElyg5wlDH1iidwV58+os1CRnMg/SuEA4aJPGEdl+7VU5lwVVPRCGt1GRDhhudmEMPieasThYvCejLRxud+P7QaW+sXSRo125JtUifgLQyzOY998XAqPMSbOZPj63rWoec10DgrQbJ4Mv1Y7JJ6mufcAxpenqU2blXdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM7XIfno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM7XIfno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA054C4CEF1;
	Tue, 16 Dec 2025 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884780;
	bh=YuAoCR/eSOhn8IVUYeVCzQ3hHLaU1Rj3XRpQje7f9BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM7XIfnoYR9/lTwIAG3l4Sl6IMTygxkWnXDz4e2GSXgynlqZpMHwvcUAL+zk6loQ9
	 u74Ja08eNJFaGSQAVWVxipLUhBQ4OrCT//k3yOmAKYh1vjjuAKDaRBCUofECZOrhkl
	 gMDG06FygWXmS93cM3tBA20xtELHjiSz+1wrqXVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/354] f2fs: sysfs: add encoding_flags entry
Date: Tue, 16 Dec 2025 12:14:24 +0100
Message-ID: <20251216111331.671360478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 3fea0641b06ff4e53d95d07a96764d8951d4ced6 ]

This patch adds a new sysfs entry /sys/fs/f2fs/<disk>/encoding_flags,
it is a read-only entry to show the value of sb.s_encoding_flags, the
value is hexadecimal.

============================     ==========
Flag_Name                        Flag_Value
============================     ==========
SB_ENC_STRICT_MODE_FL            0x00000001
SB_ENC_NO_COMPAT_FALLBACK_FL     0x00000002
============================     ==========

case#1
mkfs.f2fs -f -O casefold -C utf8:strict /dev/vda
mount /dev/vda /mnt/f2fs
cat /sys/fs/f2fs/vda/encoding_flags
1

case#2
mkfs.f2fs -f -O casefold -C utf8 /dev/vda
fsck.f2fs --nolinear-lookup=1 /dev/vda
mount /dev/vda /mnt/f2fs
cat /sys/fs/f2fs/vda/encoding_flags
2

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e462fc48ceb8 ("f2fs: maintain one time GC mode is enabled during whole zoned GC cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 13 +++++++++++++
 fs/f2fs/sysfs.c                         |  9 +++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index c7ebda8c677e5..87b32ca7f3a46 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -845,3 +845,16 @@ Description:	For several zoned storage devices, vendors will provide extra space
 		reserved_blocks. However, it is not enough, since this extra space should
 		not be shown to users. So, with this new sysfs node, we can hide the space
 		by substracting reserved_blocks from total bytes.
+
+What:		/sys/fs/f2fs/<disk>/encoding_flags
+Date:		April 2025
+Contact:	"Chao Yu" <chao@kernel.org>
+Description:	This is a read-only entry to show the value of sb.s_encoding_flags, the
+		value is hexadecimal.
+
+		============================     ==========
+		Flag_Name                        Flag_Value
+		============================     ==========
+		SB_ENC_STRICT_MODE_FL            0x00000001
+		SB_ENC_NO_COMPAT_FALLBACK_FL     0x00000002
+		============================     ==========
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 9b4768b1efac5..309b73421dd92 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -274,6 +274,13 @@ static ssize_t encoding_show(struct f2fs_attr *a,
 	return sysfs_emit(buf, "(none)\n");
 }
 
+static ssize_t encoding_flags_show(struct f2fs_attr *a,
+		struct f2fs_sb_info *sbi, char *buf)
+{
+	return sysfs_emit(buf, "%x\n",
+		le16_to_cpu(F2FS_RAW_SUPER(sbi)->s_encoding_flags));
+}
+
 static ssize_t mounted_time_sec_show(struct f2fs_attr *a,
 		struct f2fs_sb_info *sbi, char *buf)
 {
@@ -1181,6 +1188,7 @@ F2FS_GENERAL_RO_ATTR(features);
 F2FS_GENERAL_RO_ATTR(current_reserved_blocks);
 F2FS_GENERAL_RO_ATTR(unusable);
 F2FS_GENERAL_RO_ATTR(encoding);
+F2FS_GENERAL_RO_ATTR(encoding_flags);
 F2FS_GENERAL_RO_ATTR(mounted_time_sec);
 F2FS_GENERAL_RO_ATTR(main_blkaddr);
 F2FS_GENERAL_RO_ATTR(pending_discard);
@@ -1293,6 +1301,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(reserved_blocks),
 	ATTR_LIST(current_reserved_blocks),
 	ATTR_LIST(encoding),
+	ATTR_LIST(encoding_flags),
 	ATTR_LIST(mounted_time_sec),
 #ifdef CONFIG_F2FS_STAT_FS
 	ATTR_LIST(cp_foreground_calls),
-- 
2.51.0



