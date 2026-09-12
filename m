Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D459242902E;
	Sat, 12 Sep 2026 10:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210022; cv=none; b=TxuNmCioteIfgq0jPtAVS33cOBnks+7hwMpqt/Pe1lz93ew6W7RQeqBLudXQJ4SE9KBrjIp/60UY10WjtOOed2lGJ0NqKgmNQLO5F3cNTVn7FjCZQovPihi21sehkoUyhq0E0qJCyX9FqNwFuF2FBIXilp+VeMl6CBffLXIEzvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210022; c=relaxed/simple;
	bh=+UtxuiZkT0AjDMJ4ElMqDsoQQueSYLq3TwSBVj4XIWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9kXTDJ+MS7lJzH8NsZdWZTiVmw3//4+3f05DJxGGvUaUUBoSOLOH0i/u1tGWWBHsD8pAvo6M0APkpUzERMX0RQ/W+6OoQtIJW2PoZLe/gcZwrQQAIk1ghTyE5wvLd49and9lVKCuCeSBqxVQQyGBVVivvkc+C0nFjWHJh62o8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAF2uejM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAF2uejM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8E01F000FF;
	Sat, 12 Sep 2026 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210020;
	bh=LDx2Q6JKkOpxv4UTAIVs5L80EUx1Qy7syNbmrGtsIxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAF2uejMjk9wWhMw63p/BJ0IBqzBgMrV++iWHB7eDXbJHHGCIOiMNVp8YRnxM675f
	 BvjmFlpoGdO2Lm7VIVnOQJeGiOH7yloUr8HScRSgMjb/12GTqOlHvCyxvF1t3S/XMv
	 8I4cjIC4NQ7JuFQt6WMQN1stS8uWxVnvqHgkLDX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Aivazian <aivazian.tigran@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0941/1518] ext4: fix spurious message about orphan cleanup on RO fs
Date: Sat, 12 Sep 2026 08:51:50 +0200
Message-ID: <20260912065644.740299178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5aa98f874c013bcce9bb84ffded2f0ef886e4e33 ]

When orphan_file feature is enabled, ext4_orphan_cleanup() was always
walking through the orphan file looking for orphan inodes. This is
mostly harmless but for read-only filesystem it results in spurious
"orphan cleanup on readonly fs" message and in other cornercases it
could result in similar somewhat misleading messages. Skip orphan
cleanup if the orphan file is empty to avoid confusing messages.

Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Reported-by: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260803160037.64285-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/orphan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 89c24c4f97846..47289d17152b8 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -388,7 +388,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 
-	if (!es->s_last_orphan && !oi->of_blocks) {
+	if (!es->s_last_orphan && ext4_orphan_file_empty(sb)) {
 		ext4_debug("no orphan inodes to clean up\n");
 		return;
 	}
-- 
2.53.0



