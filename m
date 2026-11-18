Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022033;
	b=n8KBmr6z15HPzeWB4mwZB2ti4mrpfJ8M2jEPOZAj5mpQyYER5WChImq8tsnNJoJrKVMk
	 x+VkevKxdPKWCwy5MHsSxBl83C82F1GOScAZbKsIqP2ziL63Wqg+uwaO2Ds0TlcQ4/cik
	 Z1cDRnb/zw1swjdJ4/53kDwqyrk25QgKG7fz/jMLrwbUoNYLdx3kYgHs1RLijo8dj9Yej
	 bJMQVO5NA//DI60JBXSeO4BvjNzmqyblX5DI4uCEXvZViISLQpmNKJDmMM/f9nCkPl8fu
	 ZIEkzUWFPwWG2s9KWWgeJdno6kURsphQs0enhu9ZqJIMajiJkjj96xlV6Whho6EG2nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FiLuGxAkGP1KEAfqVeiwDdbqCjf8AnGDNZo/Dtj+/k4=;
	b=beisQgvaDOD9fvIEhqKhc5ghBFNeLP/X39fxMbsJy0n9CmAsC62+T2VCxtb8NEMqzlX4
	 Il6VSdj9nwuW6EufO3gl2R+BuLnwVJOVvvAOZbycmwpU/nGWc0LaiVqgNwAv/bU0AzzMK
	 55GCTA8crbp7PMSg2EqFeozqqhBfySMQgobg7jzzQdhc3Gs0sFWeAe/8A1aYC/38+ap0J
	 ohsHJ7krNFf7c6XEQ9y4ky52p+ioWsNF6/dcVInIy5vr0X1K7WyKsQHvtMWbqHLUJG7P9
	 zuUkf2ErY+obXc/SI7CjpaP2ECVQkHmqxZJNeV/wmjMrNTVBY2GbzHWGg+J4PZnNYgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gy+aDJbV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC65B606A33F;
	Wed, 18 Nov 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gy+aDJbV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E841F000C8;
	Wed, 18 Nov 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022033;
	bh=FiLuGxAkGP1KEAfqVeiwDdbqCjf8AnGDNZo/Dtj+/k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gy+aDJbVD+RHP/D5swMd3fphstzhBFgoHHdiYXsj6SJ2yYCWMBl8p4SuDCrQ+TVmz
	 0nU/h2+zM+ZxzfazFUqjh0cfChhNUIb3srdeRn2dSklPHth/dUKe9wt6IW9thc59ZQ
	 yGxkV3FDllXUmfeIVjskGWRWX/o+9weTgnnYZPh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7736960b837908f3a81d@syzkaller.appspotmail.com,
	syzbot+262a71e9d2faf8747085@syzkaller.appspotmail.com,
	syzbot+cfc6e8106bec1c524f7d@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2518/2651] ntfs3: release ni_lock before dir_emit in ntfs_readdir to fix deadlocks
Date: Wed, 18 Nov 2026 16:02:38 +0100
Message-ID: <20261118150415.348745190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 7a5aa6c45072b54c8d97c5d54bbdf18aabf0ee6d ]

ntfs_readdir() holds ni_lock while calling ntfs_read_hdr(), which calls
dir_emit() to copy directory entries to userspace.  If the user buffer
triggers a page fault, the fault handler may need mmap_lock or
mapping->invalidate_lock, creating lock-order inversions with paths
that acquire those locks before ni_lock (e.g. ntfs_fallocate, mmap).

Fix by releasing ni_lock before calling ntfs_read_hdr():

- For non-root index nodes, indx_read_ra() returns data in a kmalloc'd
  buffer (node->index) that remains valid after ni_unlock.

- For the root index header, the data lives in the main MFT record
  whose lifetime is bound to the inode.  i_rwsem shared prevents
  concurrent directory modifications, so it is safe to access after
  ni_unlock.

Reported-by: syzbot+7736960b837908f3a81d@syzkaller.appspotmail.com
Reported-by: syzbot+262a71e9d2faf8747085@syzkaller.appspotmail.com
Reported-by: syzbot+cfc6e8106bec1c524f7d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
Closes: https://syzkaller.appspot.com/bug?extid=262a71e9d2faf8747085
Closes: https://syzkaller.appspot.com/bug?extid=cfc6e8106bec1c524f7d
Fixes: d62cf685d12e ("fs/ntfs3: hold ni_lock across readdir metadata walk")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 58dc1ae34d412..c82f3222bf350 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -553,12 +553,22 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	if (pos >= sbi->record_size) {
 		bit = (pos - sbi->record_size) >> index_bits;
 	} else {
+		/*
+		 * Release ni_lock before dir_emit (which may fault into
+		 * user pages).  root->ihdr lives in the main MFT record
+		 * whose lifetime is bound to the inode, and i_rwsem shared
+		 * prevents concurrent directory modifications.
+		 */
+		ni_unlock(ni);
+
 		/*
 		 * Add each name from root in 'ctx'.
 		 */
 		err = ntfs_read_hdr(sbi, ni, &root->ihdr, 0, pos, name, ctx);
 		if (err)
 			goto out;
+
+		ni_lock(ni);
 		bit = 0;
 	}
 
@@ -587,6 +597,12 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			goto out;
 
+		/*
+		 * node->index is a kmalloc'd buffer, safe after ni_unlock.
+		 * Release lock before dir_emit to avoid lock-order issues.
+		 */
+		ni_unlock(ni);
+
 		/*
 		 * Add each name from index in 'ctx'.
 		 */
@@ -595,6 +611,8 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 				    pos, name, ctx);
 		if (err)
 			goto out;
+
+		ni_lock(ni);
 	}
 
 out:
-- 
2.53.0



