Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD738656D;
	Sat, 12 Sep 2026 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239268; cv=none; b=f4cX/pgJ5jEYOWM2+wAqvTUAyF7vFOLsciJqdAwok8zzSDiJPEybAWxC4Xh2DIL7ThDSONVcEm3hD3MsQih7WKPvqP4og5dYImUMFLlj0C8ZpoZ0zAkvSmdz1v8a4VYXoydBJCGgrMGh0EQLS4ji9Ax5LCd4ktDqyOZ3dd2bocY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239268; c=relaxed/simple;
	bh=vQFN86TF1o3++9hPlf1RcD/KswA9nST9pee3bgqJU3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1P9/i7bVkepG1wNLmiaD0C419d5mvmH5ODIH9HP+XM0rDW1yxr2CcVBQyscAriUuGKhJEn9Mb1zVscJGsqBbiRinLxFsRnMI5EgqngzeaeIY/Mjce3GZlVRfPKM5tbv967Zfos0XwVMlqyd5YlC2jM5EbSF+gWTNNdRpUHDT6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PB5gl3Gc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PB5gl3Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F341F000FF;
	Sat, 12 Sep 2026 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239267;
	bh=cWT6PFfuUbS0KEJf3ysnDhDMfOicRsjzYtYe6irWmr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB5gl3Gc/5Vrq7WphqEZNWdKHZZOeOziyJCPi5SvLCkzSLpYrW7gEtIuumZu7QFLn
	 EqTnItqxOta9JR/C1zW1IgrtAXPfYQhQk1h88+3rr0NZSdVYPQKRzvcwQGhgFaDT8Z
	 7gqUxB2hRgGNY4gxx0+mtzQv21CK/H34txw4KdmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 587/935] ext4: fix buffer_head leak in ext4_init_orphan_info
Date: Sat, 12 Sep 2026 09:00:17 +0200
Message-ID: <20260912065540.300918500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit 05704335803b69c1bfa8637b7ada942bf2ee8a41 ]

ext4_init_orphan_info() reads orphan file blocks with ext4_bread()
and stores the returned buffer_head in oi->of_binfo[i].ob_bh.

If ext4_bread() succeeds but the orphan block magic or checksum
validation fails, the function jumps to out_free. However, the old
out_free loop starts releasing buffers from i - 1, so the current
buffer_head at index i is skipped.

This leaks the buffer_head reference obtained by ext4_bread() on the
bad magic and bad checksum error paths.

Fix this by tracking the number of successfully read buffer_heads and
releasing exactly those buffer_heads on the error path.

Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/tencent_B38798612A159E21450ECF959016371B0807@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/orphan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index a196910635094..48c0d323ff8f8 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -573,6 +573,7 @@ int ext4_init_orphan_info(struct super_block *sb)
 	int i, j;
 	int ret;
 	int free;
+	int loaded = 0;
 	__le32 *bdata;
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 	struct ext4_orphan_block_tail *ot;
@@ -616,6 +617,7 @@ int ext4_init_orphan_info(struct super_block *sb)
 			ret = -EIO;
 			goto out_free;
 		}
+		loaded++;
 		ot = ext4_orphan_block_tail(sb, oi->of_binfo[i].ob_bh);
 		if (le32_to_cpu(ot->ob_magic) != EXT4_ORPHAN_BLOCK_MAGIC) {
 			ext4_error(sb, "orphan file block %d: bad magic", i);
@@ -638,8 +640,10 @@ int ext4_init_orphan_info(struct super_block *sb)
 	iput(inode);
 	return 0;
 out_free:
-	for (i--; i >= 0; i--)
-		brelse(oi->of_binfo[i].ob_bh);
+	while (loaded > 0) {
+		loaded--;
+		brelse(oi->of_binfo[loaded].ob_bh);
+	}
 	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
-- 
2.53.0



