Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2FA30E84D;
	Mon, 23 Jun 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685616; cv=none; b=SyjtP06mFXyI4sK1hxdComF4zF2tW5HdKyIDU5fE3sMHn0nO/ldUDMxSXfxtQDB1leSExSbAgk7ihNYh+2UlR+tENy5s91pOGRiOXcnBPS630Yr8QGKvnPrl9TXtfQbPWdsgVvjiSoFNq3rA36H7KrKWkWwWnuA9DKINnHaykAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685616; c=relaxed/simple;
	bh=XZawhtgnRnd/GUfk4v+NsxTkf5Pr5KlSgLuH5ZKAOcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smbXl9qDk9wGT7Kz7VaucOPzNzalX6X0ikKvzGnmpdIM9PjlgolQdOcyKzYoEUQIQ5Ze+iW1cRX8pXCKFQvDZSXlWdRfUjN3bBfHYNkoNK09h0oKEn5Akg163OPpGecQMtYfjjtQvUe2oLdhSdPE9JnM1EnAZDXix3Qm5v4z0E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukYQ2Prj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukYQ2Prj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3808C4CEEA;
	Mon, 23 Jun 2025 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685616;
	bh=XZawhtgnRnd/GUfk4v+NsxTkf5Pr5KlSgLuH5ZKAOcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukYQ2PrjcfI4zRsgrSy0FzNHO9kW9JctagHthaJ+QIVE5LUFD9ZvGpnaqt3NyasQC
	 EI77hQrWatP+MERfcFwPZ2oHlu6M7Bui4P/jHiDf8IF+H8A8/i2oWFclHg2QQ2sxfi
	 6K3HFR7mcJc75tDgxHdfC5exIZdBy1UWII4Se7Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+65761fc25a137b9c8c6e@syzkaller.appspotmail.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/355] Squashfs: check return result of sb_min_blocksize
Date: Mon, 23 Jun 2025 15:04:24 +0200
Message-ID: <20250623130628.724441648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 734aa85390ea693bb7eaf2240623d41b03705c84 ]

Syzkaller reports an "UBSAN: shift-out-of-bounds in squashfs_bio_read" bug.

Syzkaller forks multiple processes which after mounting the Squashfs
filesystem, issues an ioctl("/dev/loop0", LOOP_SET_BLOCK_SIZE, 0x8000).
Now if this ioctl occurs at the same time another process is in the
process of mounting a Squashfs filesystem on /dev/loop0, the failure
occurs.  When this happens the following code in squashfs_fill_super()
fails.

----
msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
msblk->devblksize_log2 = ffz(~msblk->devblksize);
----

sb_min_blocksize() returns 0, which means msblk->devblksize is set to 0.

As a result, ffz(~msblk->devblksize) returns 64, and msblk->devblksize_log2
is set to 64.

This subsequently causes the

UBSAN: shift-out-of-bounds in fs/squashfs/block.c:195:36
shift exponent 64 is too large for 64-bit type 'u64' (aka
'unsigned long long')

This commit adds a check for a 0 return by sb_min_blocksize().

Link: https://lkml.kernel.org/r/20250409024747.876480-1-phillip@squashfs.org.uk
Fixes: 0aa666190509 ("Squashfs: super block operations")
Reported-by: syzbot+65761fc25a137b9c8c6e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67f0dd7a.050a0220.0a13.0230.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 88cc94be10765..5a47b5c2fdc00 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -86,6 +86,11 @@ static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	msblk = sb->s_fs_info;
 
 	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
+	if (!msblk->devblksize) {
+		errorf(fc, "squashfs: unable to set blocksize\n");
+		return -EINVAL;
+	}
+
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->meta_index_mutex);
-- 
2.39.5



