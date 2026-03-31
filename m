Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAC94266AE;
	Tue, 31 Mar 2026 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976052; cv=none; b=nC0VVZTZMTv88ykBki2nXATCeMk8pl+HVBCu909olTRUazMnGymgSbsy5qgQEKYsaLcOweG+z/ORGmjL110ouDSyBYrKIMPKVfdW3coVmnmmeZg3EyG+KUJ8kEJEQx4gluxmNKpPdd1ZZrpM43CLXVLItMtHUXTuDAVg2YzcU98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976052; c=relaxed/simple;
	bh=Ww2SI/DaN1rnysx0J+bB1VTjwjOZK3oQ2C6Vp9nBoL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxNM+/6uCf38UBvXy0Qa8kAyn79iK7kY+sNr6T2QVmOqfszlbfKCaH2hBff2WBnFC/qek8Zy22n/jjUkWhx2yZSG5DuxAvwwwBnWvyWmWQhKZPxM0S9G+UiFrU42FunWPxAzelO8bhIjvGJUcVO5ypfIKDy40NezRgEyjBRPk1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQXxIfMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQXxIfMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EF2C19423;
	Tue, 31 Mar 2026 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976052;
	bh=Ww2SI/DaN1rnysx0J+bB1VTjwjOZK3oQ2C6Vp9nBoL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQXxIfMJLYgyzT+8XDtOZGGR8LQTef+jfypwIRDGsRvrVUju1hDeFGJVUDAxnAhyZ
	 IJRCi6RHha9Epq6TCMXL6Cc//ILlugYiXrh+D7XrsqXwy0wJMFRKwZ6vP+MkAFZFxk
	 Au2sZLaVdI2d4vGvWBMOm2V86J4kBybMTaD8thdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com,
	Tejas Bharambe <tejas.bharambe@outlook.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 189/244] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Tue, 31 Mar 2026 18:22:19 +0200
Message-ID: <20260331161748.735786831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1739,6 +1739,13 @@ static int ext4_ext_correct_indexes(hand
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
@@ -1751,6 +1758,14 @@ static int ext4_ext_correct_indexes(hand
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


