Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F5C30AD00;
	Tue, 31 Mar 2026 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976880; cv=none; b=jneE59i9VWtwg1SAyeRxRNa00Bcd6eeRBQx2n8IyZVSlbC4g/mvMSRu5IxkjDFkH0c50c9PoRKg7UjLwD5aOPOWSwu5qBdStFjyJubAqTFqED1PDzBRpz2ITLS1S72Ly2YfDlY1V0cTT5+XTn/WzHSOiHnLOcceRp6a95Fz/sd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976880; c=relaxed/simple;
	bh=d1NCKD4yRjTfbgndrYF7CfTALNgyjtUkaQvH0RvhANQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFQeeG226IkQ9qya2UBLECTysTXftZUwShvG2WuIVbEMicP7maC2xvmYjcWRXQU3z/oWt6pZvIFz2A7tTmUQuUDhiE8NCnIn/4NFkOB7s80dOAEj8YWShMJD8MtvkQj1tqQ2VxpLt+8YsRkU69Niq5pr/pNUKKHnnUmQMmGapXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1JX6Ke3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1JX6Ke3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87675C19423;
	Tue, 31 Mar 2026 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976879;
	bh=d1NCKD4yRjTfbgndrYF7CfTALNgyjtUkaQvH0RvhANQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1JX6Ke3G64LF5wJ3w0sK6bocjisSPl8cvNMQiCLM5sl7eY4J13yvEQpaeiVnhK95
	 mewayYrT0k00cJzlIAC5+0AQkbdR4OOWAkUxBrj3yK8ZPBv4kz0EMUONz5R4EkGgf4
	 DjaxdaPgH5pQyNXt9A6Dpgd6pgppFFZbqLp5MMYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com,
	Tejas Bharambe <tejas.bharambe@outlook.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 263/309] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Tue, 31 Mar 2026 18:22:46 +0200
Message-ID: <20260331161803.246778435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Tejas Bharambe <tejas.bharambe@outlook.com>

commit 2acb5c12ebd860f30e4faf67e6cc8c44ddfe5fe8 upstream.

ext4_ext_correct_indexes() walks up the extent tree correcting
index entries when the first extent in a leaf is modified. Before
accessing path[k].p_idx->ei_block, there is no validation that
p_idx falls within the valid range of index entries for that
level.

If the on-disk extent header contains a corrupted or crafted
eh_entries value, p_idx can point past the end of the allocated
buffer, causing a slab-out-of-bounds read.

Fix this by validating path[k].p_idx against EXT_LAST_INDEX() at
both access sites: before the while loop and inside it. Return
-EFSCORRUPTED if the index pointer is out of range, consistent
with how other bounds violations are handled in the ext4 extent
tree code.

Reported-by: syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=04c4e65cab786a2e5b7e
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
Link: https://patch.msgid.link/JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6632.apcprd06.prod.outlook.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1741,6 +1741,13 @@ static int ext4_ext_correct_indexes(hand
 	err = ext4_ext_get_access(handle, inode, path + k);
 	if (err)
 		return err;
+	if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+		EXT4_ERROR_INODE(inode,
+				 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+				 k, path[k].p_idx,
+				 EXT_LAST_INDEX(path[k].p_hdr));
+		return -EFSCORRUPTED;
+	}
 	path[k].p_idx->ei_block = border;
 	err = ext4_ext_dirty(handle, inode, path + k);
 	if (err)
@@ -1753,6 +1760,14 @@ static int ext4_ext_correct_indexes(hand
 		err = ext4_ext_get_access(handle, inode, path + k);
 		if (err)
 			goto clean;
+		if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+			EXT4_ERROR_INODE(inode,
+					 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+					 k, path[k].p_idx,
+					 EXT_LAST_INDEX(path[k].p_hdr));
+			err = -EFSCORRUPTED;
+			goto clean;
+		}
 		path[k].p_idx->ei_block = border;
 		err = ext4_ext_dirty(handle, inode, path + k);
 		if (err)


