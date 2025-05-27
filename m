Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453512CCC0;
	Tue, 27 May 2025 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364558; cv=none; b=Uh3SS5dOlh4X6Fv7udZLIZEtnXrgucGbtDBstoqTlVbSxoMrig1KAiQ2uCXbqujN33/5ucOp6SuwDsA8h53NWZEJ2lZfNt8UlHmo5YSX7cdmySvGw+t36bPcfnZh4IA++LJJe4JhYJJqquZi+d2f40M3iJnNHb7cec48I3gxaxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364558; c=relaxed/simple;
	bh=mfbL/3ujACFDIZFhLQuZURa4TxNZ97GfyhI/K4jN9H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0JXYSOWEbCU8TntWy/yA0ZQkMQb/UyMPhyfo+wiUKxj8ptls/tXsG4GYyyA3D0AxBTDapHsVE1t4yocQPirBhoE2wGUd14eZADqv2LhmWuv06BvwgNOz0HeMXXow1kG/3c3WGCPZbMP4MTjgOZkLuG18CZ2CF9nnz5cAFP6Vfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfHNdIzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfHNdIzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FA8C4CEE9;
	Tue, 27 May 2025 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364558;
	bh=mfbL/3ujACFDIZFhLQuZURa4TxNZ97GfyhI/K4jN9H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfHNdIzJnLrqE4aCYoEEjeQETCdVktd8xe+yRF5h+IVRSjWEeYsIDSa3HT+KhIHZv
	 N4axaDCoExwrX9SnHiMD3VjeJpeFTdXYlKOKPhkRy2C94cp/++M43qR8voHM1ZGIxu
	 13QQb3E63z6FXk115r/L9xp1V88tMF4mJT1jJ5R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bretz <bretznic@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/626] ext4: on a remount, only log the ro or r/w state when it has changed
Date: Tue, 27 May 2025 18:19:48 +0200
Message-ID: <20250527162448.906849437@linuxfoundation.org>
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

From: Nicolas Bretz <bretznic@gmail.com>

[ Upstream commit d7b0befd09320e3356a75cb96541c030515e7f5f ]

A user complained that a message such as:

EXT4-fs (nvme0n1p3): re-mounted UUID ro. Quota mode: none.

implied that the file system was previously mounted read/write and was
now remounted read-only, when it could have been some other mount
state that had changed by the "mount -o remount" operation.  Fix this
by only logging "ro"or "r/w" when it has changed.

https://bugzilla.kernel.org/show_bug.cgi?id=219132

Signed-off-by: Nicolas Bretz <bretznic@gmail.com>
Link: https://patch.msgid.link/20250319171011.8372-1-bretznic@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4291ab3c20be6..473909c4a3784 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6744,6 +6744,7 @@ static int ext4_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
 	int ret;
+	bool old_ro = sb_rdonly(sb);
 
 	fc->s_fs_info = EXT4_SB(sb);
 
@@ -6755,9 +6756,9 @@ static int ext4_reconfigure(struct fs_context *fc)
 	if (ret < 0)
 		return ret;
 
-	ext4_msg(sb, KERN_INFO, "re-mounted %pU %s. Quota mode: %s.",
-		 &sb->s_uuid, sb_rdonly(sb) ? "ro" : "r/w",
-		 ext4_quota_mode(sb));
+	ext4_msg(sb, KERN_INFO, "re-mounted %pU%s.",
+		 &sb->s_uuid,
+		 (old_ro != sb_rdonly(sb)) ? (sb_rdonly(sb) ? " ro" : " r/w") : "");
 
 	return 0;
 }
-- 
2.39.5



