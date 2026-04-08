Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C543537EF;
	Wed,  8 Apr 2026 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672847; cv=none; b=O5RRc32ZLXW+Fs+beTV9ybeYzSQOe+ZORHXip+hAgNYek2xPws9nF9cUc6COee0vNHJPEgmLkMsRjvhuQu66w4ERIBgVc5bBRIZqt4fvn9CAUnqxQVhm9xYxiijw247Z0fdOrqSKyen82WkeJETWqzLAXHHLqhZtxJDzNPcFxkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672847; c=relaxed/simple;
	bh=U2A31IbOPW8OInylNJrBR78nMfiteBg6c4ZUk9JJE1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE/YQuulcCV1wUoM+GtJWnIst7RlecL6rGw7n/gyQ77oIfmh41cCBxeudH94/F7e2YsIDBhyMavaNJtU3K+cmxTg0yqFZQa4UVITOIdlCu7f3Rzwuy26P0Msat0g5SA+WW5YdcTBPANFLIxcqU9Hu4IEYNJZdmuze3WtIUdsRVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRjhYsi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRjhYsi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BA2C19421;
	Wed,  8 Apr 2026 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672847;
	bh=U2A31IbOPW8OInylNJrBR78nMfiteBg6c4ZUk9JJE1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRjhYsi3zXJtfk4z6deawsCiYqVTxOvSMKw7ZJreQmqeOp3/CTq/JjpTLJXB0MT3w
	 cB13/pf/qCIhM8ji0fYXEgnAjywSyNP52Xr9LkNX4AWzPwqGj+7PFVHJwcwuBY1Joy
	 v+UrAAUf26COaB1cRt7gdQtrf9P7jO6LI9yJGuUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/160] btrfs: do not free data reservation in fallback from inline due to -ENOSPC
Date: Wed,  8 Apr 2026 20:03:45 +0200
Message-ID: <20260408175918.339844807@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

[ Upstream commit f8da41de0bff9eb1d774a7253da0c9f637c4470a ]

If we fail to create an inline extent due to -ENOSPC, we will attempt to
go through the normal COW path, reserve an extent, create an ordered
extent, etc. However we were always freeing the reserved qgroup data,
which is wrong since we will use data. Fix this by freeing the reserved
qgroup data in __cow_file_range_inline() only if we are not doing the
fallback (ret is <= 0).

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 28625e504972e..46df425ab7bae 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -691,8 +691,12 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	 * it won't count as data extent, free them directly here.
 	 * And at reserve time, it's always aligned to page size, so
 	 * just free one page here.
+	 *
+	 * If we fallback to non-inline (ret == 1) due to -ENOSPC, then we need
+	 * to keep the data reservation.
 	 */
-	btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
+	if (ret <= 0)
+		btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
 	btrfs_free_path(path);
 	if (trans)
 		btrfs_end_transaction(trans);
-- 
2.53.0



