Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714B71DF726;
	Wed,  6 Nov 2024 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896194; cv=none; b=laaTtC68pHXlcaVKjT4gcQI7FsZ3pIzAdRT54156eYlBFuN5+6H9usukMQvhxu50jGbIeT2EMv0Tgu2HccV33Cz07uYBIo4aqz10onPKjs0KLzjdcGpVyUqYBOzUdzVWUXTYI/M6JuskJvkIxBDHtrAq+7r6EZYUKZtKGO2u4uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896194; c=relaxed/simple;
	bh=3aXg0tvF3C0VJ6IGHr1wv4p/RYBFgBm4FOUloIXb50o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9hxPxKe0t8XRfpH65yTczLscfny/ukyzInwa/L09FyfLr2ihFaCQ5epEOiRCgfS1ybfECqL6pYHg8o04Klj/TSYkLPshfEOuJDCXcM3bfVO7ikchL3RfPIMGvongSPcujYvCRZED3l6GyLFFCPg1o9F7PKuRrvfNznWLWY9IUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnY47MHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnY47MHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE80CC4CED4;
	Wed,  6 Nov 2024 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896194;
	bh=3aXg0tvF3C0VJ6IGHr1wv4p/RYBFgBm4FOUloIXb50o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnY47MHZqbY+whQwFQ4vdEVGNCWeIVumUrP9PIMSO4iAVGs4HUHBptlNnNJ621zjI
	 clmn0B8xREUkdIy/LZiLrXi6+cg4Hn9NMFLQI+ooSJ8vW7HX66TFFSrB/ycLMlbWtu
	 xishdQte6aX/1c7KsNKbOXaugCmboYkrAo0b9P4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 085/245] fs/ntfs3: Stale inode instead of bad
Date: Wed,  6 Nov 2024 13:02:18 +0100
Message-ID: <20241106120321.298756961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1fd21919de6de245b63066b8ee3cfba92e36f0e9 ]

Fixed the logic of processing inode with wrong sequence number.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6b0bdc474e763..56b6c4c6f528f 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -536,11 +536,15 @@ struct inode *ntfs_iget5(struct super_block *sb, const struct MFT_REF *ref,
 	if (inode->i_state & I_NEW)
 		inode = ntfs_read_mft(inode, name, ref);
 	else if (ref->seq != ntfs_i(inode)->mi.mrec->seq) {
-		/* Inode overlaps? */
-		_ntfs_bad_inode(inode);
+		/*
+		 * Sequence number is not expected.
+		 * Looks like inode was reused but caller uses the old reference
+		 */
+		iput(inode);
+		inode = ERR_PTR(-ESTALE);
 	}
 
-	if (IS_ERR(inode) && name)
+	if (IS_ERR(inode))
 		ntfs_set_state(sb->s_fs_info, NTFS_DIRTY_ERROR);
 
 	return inode;
-- 
2.43.0



