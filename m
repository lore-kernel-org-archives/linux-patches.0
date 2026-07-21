Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2119049B;
	Tue, 21 Jul 2026 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654574; cv=none; b=XVe1xhUPWGmvwkEiBUJ5ThAzN95OCRbyNDP1JZZV3Xu6D+xXMTImgToDsKwewUvI4U1gfTTbmTH/wFuL/JWKHMcNF5OePbrXcJJrGD5TQCouS9myMAS4Z73yqzKTlVVVRm6Coq8UUzWVkNFVboRkmtz5t3AqKyfWkynPkOEKZPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654574; c=relaxed/simple;
	bh=6VWAnAnPgKU0bG+m4cfMU8Ov63S6+bxaMlV34Jmi4tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZDFfNDs0LXf59hgATAybrJ/RMkBrdXwJqsWBeba/sNX3clmBAww1OutkOGCs55EA9s7r8gme/kSDalu8C5IOAl8DhePT6wMOb5SaYRv7LN+KWbgrFwg/m2pB3MyqrH5qK22BhCFuDReyss8aHlzxjuDRKMK7t8vV6kG/BUEAh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjygZHvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjygZHvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2941F000E9;
	Tue, 21 Jul 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654572;
	bh=5djsT5iyPADZBGW5+S9ucNIi3wKfqRP4JiPrCR/0DYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjygZHvhLwE4LFdgx8rJZwKWxqZXPjBgibRYhYIqvCZAudLP3dcnibYXQT1F3KUgk
	 ytMn3dXGTNtC0A081vrmvUmfLhou7FF98UAd+Tvy6vkSvGQqg6U7VAEzX9sNbDaB8Z
	 fOrRCZj/20K82yIs/6dUFWVQ5lxz/WA7h/KNzqm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1713/2077] ntfs: fail attrlist updates when the superblock is inactive
Date: Tue, 21 Jul 2026 17:23:06 +0200
Message-ID: <20260721152633.160683147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit 0ebe8f625ab0520217a425d7cd366e4670484941 upstream.

generic_shutdown_super() clears SB_ACTIVE before evicting cached inodes.
If eviction selects the fake inode for a base inode's unnamed
$ATTRIBUTE_LIST attribute, ntfs_evict_big_inode() drops the fake inode's
reference on the base inode while the fake inode is still hashed and marked
I_FREEING.

That iput can synchronously write back the base inode. The writeback path
may update mapping pairs and call ntfs_attrlist_update(), which
unconditionally calls ntfs_attr_iget() for the same $ATTRIBUTE_LIST fake
inode. VFS then finds the I_FREEING inode and waits for eviction to finish,
but the current task is still inside that eviction path, causing a
self-deadlock in find_inode().

Fix this by mirroring the teardown guard used by __ntfs_write_inode():
once SB_ACTIVE has been cleared, do not try to iget the attribute-list
fake inode. Return -EIO so teardown aborts the update instead of waiting on
the inode it is evicting.

Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/AB8D5E603E6EA856+ae5f622a-dd3a-4e38-bdd2-42276ae0e1a8@smail.nju.edu.cn/
Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Assisted-by: Codex:gpt-5.5
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrlist.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ntfs/attrlist.c
+++ b/fs/ntfs/attrlist.c
@@ -57,6 +57,15 @@ int ntfs_attrlist_update(struct ntfs_ino
 	struct ntfs_inode *attr_ni;
 	int err;
 
+	/*
+	 * generic_shutdown_super() clears SB_ACTIVE before evicting cached
+	 * inodes. Do not look up the attribute-list inode after SB_ACTIVE has
+	 * been cleared; it may already be I_FREEING, and waiting on it can
+	 * self-deadlock.
+	 */
+	if (!(VFS_I(base_ni)->i_sb->s_flags & SB_ACTIVE))
+		return -EIO;
+
 	attr_vi = ntfs_attr_iget(VFS_I(base_ni), AT_ATTRIBUTE_LIST, AT_UNNAMED, 0);
 	if (IS_ERR(attr_vi)) {
 		err = PTR_ERR(attr_vi);


