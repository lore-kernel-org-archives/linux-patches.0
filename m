Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165A33FE15;
	Sat, 30 May 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161679; cv=none; b=bte/SXBWWNEnltpb4TVx4Pv1E1uuUJjeYoP6F+lumn0AQNW96WEFzkoXQq47bYzniY9VuulFMv7B5SHQT8ldkGn7u1aALnFiwD37uTdPg7Ka3fWZsfQ5iqudOMUO7Ny19yk7MD8v4zVGPDB+676afZQfrAdTBFjQ5cUfC+PiSUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161679; c=relaxed/simple;
	bh=vQ6EPHYnlWlGzM1vopqI0sc+lDzdYd6tthjzwa8pmtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMLR1BxHbNyaC5qAHMc1ST/2XVvSCMazD5+r0wzXQKCClqtJQDR9sQ31Betl1kzBoL+uskmLMrV75rT0PxBEwBl5b23IiKECkGrnMK3Ie1UXtWxT6Q9TZk3cpKX5Q17knkHbqww8SA8b5SCdwBvVyKpZhX6MEhilKLbNc/qdmA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le6a5I5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le6a5I5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60A61F00893;
	Sat, 30 May 2026 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161678;
	bh=OzNGU/v0NBRGc2Jpi7q17D6z3SMI2N/t9Yd890lQyLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le6a5I5CGsr0Cm2RdqIWma0HKWnOg5h0VzwY9CdGAY79AbSILZy14BtOHSV6T7WNg
	 zotPy5F1d/FTbBDqFS/+qd0Jgs7um/puchciIDaM83FkhxdaYTWGPED8NRzgXVPl5U
	 I7SFsA19x2WX3fBHuRNVCE/mPa4MXobkBVWlGRcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 667/969] f2fs: Use sysfs_emit_at() to simplify code
Date: Sat, 30 May 2026 18:03:11 +0200
Message-ID: <20260530160318.906306103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f7a678bbe5a8f22cfcef5369757cc9b95f73e027 ]

This file already uses sysfs_emit(). So be consistent and also use
sysfs_emit_at().

This slightly simplifies the code and makes it more readable.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5909bedbed38 ("f2fs: protect extension_list reading with sb_lock in f2fs_sbi_show()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 4e643abbd891a..aeb95c74710eb 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -150,50 +150,50 @@ static ssize_t features_show(struct f2fs_attr *a,
 	int len = 0;
 
 	if (f2fs_sb_has_encrypt(sbi))
-		len += scnprintf(buf, PAGE_SIZE - len, "%s",
+		len += sysfs_emit_at(buf, len, "%s",
 						"encryption");
 	if (f2fs_sb_has_blkzoned(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "blkzoned");
 	if (f2fs_sb_has_extra_attr(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "extra_attr");
 	if (f2fs_sb_has_project_quota(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "projquota");
 	if (f2fs_sb_has_inode_chksum(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "inode_checksum");
 	if (f2fs_sb_has_flexible_inline_xattr(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "flexible_inline_xattr");
 	if (f2fs_sb_has_quota_ino(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "quota_ino");
 	if (f2fs_sb_has_inode_crtime(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "inode_crtime");
 	if (f2fs_sb_has_lost_found(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "lost_found");
 	if (f2fs_sb_has_verity(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "verity");
 	if (f2fs_sb_has_sb_chksum(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "sb_checksum");
 	if (f2fs_sb_has_casefold(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "casefold");
 	if (f2fs_sb_has_readonly(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "readonly");
 	if (f2fs_sb_has_compression(sbi))
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+		len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "compression");
-	len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
+	len += sysfs_emit_at(buf, len, "%s%s",
 				len ? ", " : "", "pin_file");
-	len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 	return len;
 }
 
@@ -310,17 +310,14 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 		int hot_count = sbi->raw_super->hot_ext_count;
 		int len = 0, i;
 
-		len += scnprintf(buf + len, PAGE_SIZE - len,
-						"cold file extension:\n");
+		len += sysfs_emit_at(buf, len, "cold file extension:\n");
 		for (i = 0; i < cold_count; i++)
-			len += scnprintf(buf + len, PAGE_SIZE - len, "%s\n",
-								extlist[i]);
+			len += sysfs_emit_at(buf, len, "%s\n", extlist[i]);
 
-		len += scnprintf(buf + len, PAGE_SIZE - len,
-						"hot file extension:\n");
+		len += sysfs_emit_at(buf, len, "hot file extension:\n");
 		for (i = cold_count; i < cold_count + hot_count; i++)
-			len += scnprintf(buf + len, PAGE_SIZE - len, "%s\n",
-								extlist[i]);
+			len += sysfs_emit_at(buf, len, "%s\n", extlist[i]);
+
 		return len;
 	}
 
-- 
2.53.0



