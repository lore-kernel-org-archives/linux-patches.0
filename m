Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5149D3D8914;
	Wed, 20 May 2026 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296077; cv=none; b=XlWEAYtBA0KVYckgXMdSu6P5iLzPr4g94V/qz25tbWAwvblVisTFfg+7u225FBxS7lLk21dla/qOzFLd9dwa2Fqa4UH0/EMDEMzUkery/jTtkvcIj7fpefqB4r6xnBEK/0gq90u1Bfvj7XMOmM0dLKhLAJgYXGe4f4AXslJsmlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296077; c=relaxed/simple;
	bh=lxSfV2QjgngY0mzVwwrf9Q1VNBFN+ukZ6aHlOr7TNSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsoPV+CYrVOltKduqImmsYmYDkdj/2b196x1QjTJxJGUPZQQzpr84ey+8IxJEi5J9a0gJXmuSjnqSXkaRcRYh/SLsY3XprSGm2eU4FUtuBurtF/k4EUOayRz2ZUTMCjEVgqzb6X3MExwUTj7d2AWa53wRx/ghBzKRPH1VonWRYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkmAQElh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkmAQElh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C2A1F000E9;
	Wed, 20 May 2026 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296076;
	bh=CCWfoPBT2K9kh38f4f7nPJPi6hKyHXIDlDwwn9jRePU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkmAQElhmfcnQH9VkIbmVs5tjWfh3CZyXx+0m4lgtpFS8lk2TKuAtHCAiP1Ps2kGR
	 GRPqOtCdn5W9BBDgKYaFWFASc9rMpv2xgJjkGySJ6jAG+lUoZMM+5UhtS24/yYS3H7
	 jqOc6hvzvcHUb6GutI7sa8Wuy9NCcCLIrH9TThxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7be88937363ac7ab7bb0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0663/1146] fs/ntfs3: prevent uninitialized lcn caused by zero len
Date: Wed, 20 May 2026 18:15:13 +0200
Message-ID: <20260520162203.188129188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit e98266e823a1fa06fe6499df61aeaac2fd6f7a49 ]

syzbot reported a uninit-value in ntfs_iomap_begin [1].

Since runs was not touched yet, run_lookup_entry() immediately fails
and returns false, which makes the value of "*len" 0.
Simultaneously, the new value and err value are also 0, causing the
logic in attr_data_get_block_locked() to jump directly to ok, ultimately
resulting in *lcn being triggered before it is set [1].

In ntfs_iomap_begin(), the check for a 0 value in clen is moved forward
to before updating lcn to avoid this [1].

[1]
BUG: KMSAN: uninit-value in ntfs_iomap_begin+0x8c0/0x1460 fs/ntfs3/inode.c:825
 ntfs_iomap_begin+0x8c0/0x1460 fs/ntfs3/inode.c:825
 iomap_iter+0x9b7/0x1540 fs/iomap/iter.c:110

Local variable lcn created at:
 ntfs_iomap_begin+0x15d/0x1460 fs/ntfs3/inode.c:786

Fixes: 10d7c95af043 ("fs/ntfs3: add delayed-allocation (delalloc) support")
Reported-by: syzbot+7be88937363ac7ab7bb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7be88937363ac7ab7bb0
Tested-by: syzbot+7be88937363ac7ab7bb0@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6e65066ebcc1a..eac421cf98a87 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -822,6 +822,11 @@ static int ntfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return err;
 	}
 
+	if (!clen) {
+		/* broken file? */
+		return -EINVAL;
+	}
+
 	if (lcn == EOF_LCN) {
 		/* request out of file. */
 		if (flags & IOMAP_REPORT) {
@@ -855,11 +860,6 @@ static int ntfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		return 0;
 	}
 
-	if (!clen) {
-		/* broken file? */
-		return -EINVAL;
-	}
-
 	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = offset;
 	iomap->length = ((loff_t)clen << cluster_bits) - off;
-- 
2.53.0



