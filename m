Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB871E48E;
	Thu, 11 Apr 2024 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832670; cv=none; b=lfw2FHHOxI/bQ7j8fy494zc2+ChsFUU8fM0LT0up/6tuOlMmaM0tWVxRELPyKMnLkXpukQK0AV6wlPY2gemgsL4oR5pQvP4rGPOoVzWFc8cotOu3vxrFDxLPSmSR4NfpEV6kxEjPG8vW2APFn4HvP27KqPNgoixDU8ja841wknM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832670; c=relaxed/simple;
	bh=4HuwDXwpHqrq/bxqbKJzHaJXnFiuPkQRQAKQWOTFgaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLyjYPrY5aZ4tmWeydCGyq+c58OykGGZ825eoPk8e+U2d3fZGECk6oPie8myow4IZt3RyCDxVgjfo68wTujSWCdDucAw7UOfQ+72ggEE4QXL9BK0HZeCsZZbGcEaZzOg+8ZIN4eOtSwQ7ror9/RPyPq0vz9fjUzX6BuuvH0Ci4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxSBhib3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxSBhib3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BC7C433C7;
	Thu, 11 Apr 2024 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832670;
	bh=4HuwDXwpHqrq/bxqbKJzHaJXnFiuPkQRQAKQWOTFgaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxSBhib3NFTDUifuLxR+z3DyIjhupZrU6ZlzVyfzb/UYcZd8izONer+mPY5wOcjQd
	 PiWNjYcWhDjvCgKmna7Ic+8i8iztROQdl9aE3p/Avjba1C8eWlVKqEKImMS83+R7Is
	 0mmK5gXDC4ct9oOlQ4dwShdR4TcN7e/cV/XxqvS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/57] btrfs: export: handle invalid inode or root reference in btrfs_get_parent()
Date: Thu, 11 Apr 2024 11:57:24 +0200
Message-ID: <20240411095408.486192422@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 26b66d1d366a375745755ca7365f67110bbf6bd5 ]

The get_parent handler looks up a parent of a given dentry, this can be
either a subvolume or a directory. The search is set up with offset -1
but it's never expected to find such item, as it would break allowed
range of inode number or a root id. This means it's a corruption (ext4
also returns this error code).

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/export.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index fab7eb76e53b2..58b0f04d7123f 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -161,8 +161,15 @@ struct dentry *btrfs_get_parent(struct dentry *child)
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto fail;
+	if (ret == 0) {
+		/*
+		 * Key with offset of -1 found, there would have to exist an
+		 * inode with such number or a root with such id.
+		 */
+		ret = -EUCLEAN;
+		goto fail;
+	}
 
-	BUG_ON(ret == 0); /* Key with offset of -1 found */
 	if (path->slots[0] == 0) {
 		ret = -ENOENT;
 		goto fail;
-- 
2.43.0



