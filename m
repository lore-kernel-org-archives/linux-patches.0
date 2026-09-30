Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A5A3C3439;
	Wed, 30 Sep 2026 19:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796192; cv=none; b=LWMSC0vrPEzGK+mIhBEyOvnY/aoZ/0pM8lQR1BBpWDIdiQRYNzlAkmfvMg1ciGCp3JFNQ2/r2GIpfzUX5shC4CwY0iYrwrL94gDagn+f7cCgX7COHHRFA86a34BcunReYdIjL9rwOKqV0rPsGMtI41bbHKXfFYmlB3ltmvMVrtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796192; c=relaxed/simple;
	bh=K2t5PV81oXz7I5kWq9cl9sbfBteR1tC629Kz52NDIYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuazAcVgdxFfRWbY9oGHPy2eqmgh10mVbLzZIscN2NJd4aaK8ugDjNwpIqgVfGZ7KpmDRJFDdWn2korjN5F75grvjlKhysjT7m4dHDp9Py1GzgUbPKE3iewbZz1TfAYat0EpicI+QNBhLlKyWVCwEIMW41+9w8EyZiqGERD6zZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxNBzpGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxNBzpGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834F01F000FF;
	Wed, 30 Sep 2026 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796191;
	bh=bfx0OoPDEDvGr6k9lPlPPDjTFYS4K6Vu8SdV0bOskSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxNBzpGv+TFq7K3AMUn2W3ked9NDm8U/PR1sxYek1GEM3lS5o8wrBKTJ6UJjhpRdd
	 nWrmradn3ShJ2HFZiVxfSfOgFPNMF9WlwIdZT2epHsrrfJNckA/2OWv3Mf9+nLQBDj
	 g1NPbrqQVtHYMX8HCAJ2p7Rv2pBy1cIsXjSksb0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0826/1193] btrfs: abort transaction on failure to update inode for hole punching and reflinking
Date: Wed, 30 Sep 2026 17:25:10 +0200
Message-ID: <20260930152452.598084050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 97fcd34aa9fd73cefe3120ac9a82ca9d7763922f ]

If we fail to update the inode we error out without aborting the
transaction, which can result in a persistent inconsistency if after
the failure the transaction is committed, as we have dropped file
extent items from a range and either punched a hole or insert a new file
extent item for that range (for reflinks).

So add the missing transaction abort.

Fixes: 2aaa66558172 ("Btrfs: add hole punching")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c650d448737c8..7db2344a748cf 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2514,8 +2514,10 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 			inode->vfs_inode.i_mtime = inode_set_ctime_current(&inode->vfs_inode);
 
 		ret = btrfs_update_inode(trans, inode);
-		if (ret)
+		if (unlikely(ret)) {
+			btrfs_abort_transaction(trans, ret);
 			break;
+		}
 
 		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
-- 
2.53.0



