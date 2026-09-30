Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78E516157;
	Wed, 30 Sep 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788533; cv=none; b=tgPzeJ7ZqMlwlqFPP3wy4fpUse6neOjen2DPXAdmQfpdB+dc/50LlCmBeujBWEIjbGu17ERIi9vq3qCM8GxKEGnMRwhZbIRgWSyl15CfmWt7kEGpk3TCY1z8MF57BwfzFFikc3WVNMSgsZfeGWsEJeIXB3HPsvW/TLLHgdKT56k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788533; c=relaxed/simple;
	bh=eec4Lg/y/IPPqMqG2TbQCztbT6zceZi8nFdb7Km7WDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnD5DJKKZOnnpjz8eD3+vHiJfAO6Pc/u/30rVkU3ptj0Lr7xyawq3RyavcPe0n0bYdImEQbYQnSd8cLr93tq0yF7G1AnsSymsneTNwM+3Oy7Pazf70G/S6DM2hdvypSOjGxsQim5DUXiRQk7e0GtBy55/hJtUcSePJqyOKsp0is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4GHFwDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4GHFwDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69571F000FF;
	Wed, 30 Sep 2026 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788532;
	bh=dKaQ2wU5QF1y4epxdh1MXZa4my0BgO4vxv7D31kG7+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4GHFwDmlLNZ3fob80XSbHdKTFw4sBVtQ/UKGWvzuJNj76+GnbWVlQoW9XLSKJAKc
	 Qsfwg15BBpv4ZwCYJ2RfHKrUqzxpJdeF5/GsUrlPpniDzEoEEvdcmSXyVp+W90Ls4G
	 9E+vcAnlzqupohwm1+/s6l7jQ69pDWftAyOt9bD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/877] btrfs: abort transaction on failure to update inode for hole punching and reflinking
Date: Wed, 30 Sep 2026 17:17:47 +0200
Message-ID: <20260930152418.087782941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 9c3b5ecb0b01e..5627e2f7dd64a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2545,8 +2545,10 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 					      inode_set_ctime_current(&inode->vfs_inode));
 
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



