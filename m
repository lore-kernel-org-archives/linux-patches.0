Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF133CC303;
	Tue, 16 Jun 2026 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635991; cv=none; b=C03AAC77kwCnyuF/VH4cUU/Q8U1nSnnY3Mc1IZdwGmdMj7cXm2Nb8KfhycWSVpUXCUonwcSa9Nj9VY1/++p9xiFqsThtAiVQWJQ+Nz2NojK70B9RilBWiX+w8VIIS5TmbKxkToNmK8GntrdfKvGBqdIfSa4KPk5gqaMMjxCvaAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635991; c=relaxed/simple;
	bh=fqsfryQRLY6Ga9ue1hwFbicBZ1IuCjnv25rpHFharVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb5KwqmWxNXirYXhw9EzHT5vJfMO84kV4q3/lEGT+SKb/s6NNgSxRUJW6Wg4TrLtc4N/JEz5UCH1Nr1Czj7BF5Xq6UF+qlw2tq/Vcd0AQ9yeTJNxwf45Cib3/DhdAK3drEKYSpnkEPlHcmUtiJVxLotzNXf78ha/NATxT8OQVmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hygqoNgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hygqoNgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7A91F000E9;
	Tue, 16 Jun 2026 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635990;
	bh=HUYU8s2K+psNSOT71bDGBpLI3jB+IVf0Qxsll3NND54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hygqoNgt4lqA8yHBMNz/PASibaC73/aOgnxlG49YjXEkRvrtyVQS9hkS6qdnsyDTk
	 rC9+pdvj3qDNjOkrpqTeAdY2E+vjTwwlBoEkoOcmfDcl9l0U3oLzAR5JEpG0LYmZy6
	 oeuHperN4dSp/FBB1NUQr40faDJB8tHBkB9yz58Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com,
	Tejas Bharambe <tejas.bharambe@outlook.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Alexey Panov <apanov@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/342] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Tue, 16 Jun 2026 20:27:29 +0530
Message-ID: <20260616145055.288443840@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Alexey: Adapt goto clean to break because the clean error path is not
  present in linux-5.10.y and linux-5.15.y. ]
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6d37805d315507..388e47dfb7aa18 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1731,6 +1731,13 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
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
@@ -1743,6 +1750,14 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 		err = ext4_ext_get_access(handle, inode, path + k);
 		if (err)
 			break;
+		if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
+			EXT4_ERROR_INODE(inode,
+					 "path[%d].p_idx %p > EXT_LAST_INDEX %p",
+					 k, path[k].p_idx,
+					 EXT_LAST_INDEX(path[k].p_hdr));
+			err = -EFSCORRUPTED;
+			break;
+		}
 		path[k].p_idx->ei_block = border;
 		err = ext4_ext_dirty(handle, inode, path + k);
 		if (err)
-- 
2.53.0



