Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878E35292A;
	Tue, 16 Jun 2026 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633950; cv=none; b=P1zY//f44EHJWs73x2pVDaMh+Sqb4GUplQ3sk5ZSB69lMuZhUy98gECqFjVmW3ExOK0t2te5x/vvC1MVu3U2rcitEPX5oeWDV7L26gsIAjDUnn0pl9D5dIqgrJPAJ3gRDw1xf1T02fiKCL8f3ov35QCkcA6bfwlwiGBMrgRX+OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633950; c=relaxed/simple;
	bh=5ZrAqZUIJ+VOp0Thdj1Yo8hYZDGMuNyZ9z9FA9bAcqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvNaMXNmGldxY6cecBQNdawSOVQLwYOGcmA/kV0JdSyxPsTJjwerCW8x6Hzm75kpM7yZT1bsl2ia2+loTmxZOJpxm6QKAVii/IWA9CG1g67crC9PipPb+gON0HlCNT0UVPMruauSCVxtTSwMdOdd3Bxx6sJPKX2qJUk0yiH2MSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnsK5mUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnsK5mUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000751F000E9;
	Tue, 16 Jun 2026 18:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633949;
	bh=IVVfQgzIL86T6cLt5ZlbUx4avH8RIvTJeVaHKNZNWRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnsK5mUmnpRhDDaC9xGZjRZtD8uzQJPev0bmsVYcwcphUzti28boSwcasElfrowuP
	 cbWFh7O2QkOJXA6UbRpLvse3keY7nqxQgPoJe0eSZH/cSzDhfZ6F7rSxYvmKo1Lcul
	 pnnAKAWaGXm+MKmvkBY/CuNnXdRoH97Rqyb3MPWM=
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
Subject: [PATCH 5.15 174/411] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Tue, 16 Jun 2026 20:26:52 +0530
Message-ID: <20260616145109.910023187@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
index 80b7783c65b41e..e6dbb2dfb3318f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1736,6 +1736,13 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
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
@@ -1748,6 +1755,14 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
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



