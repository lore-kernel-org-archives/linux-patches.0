Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE27464;
	Tue, 30 Apr 2024 10:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474774; cv=none; b=RlRPTRzB7D0gkv7GpIiwGZPcKt9RwfOoAuXFhOH4QPlB94Qj/RrrYWsdOlaREW7CvfOKIGZiN/S/9AItIQwebbPeaziFgtL3ssh+hAEM6BRoKqkfCk+SgEz4uJkqDSqU3W+fFArikhuXlzTcZSRvamNnj6wqEBOIl0jWElvkrEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474774; c=relaxed/simple;
	bh=uRem7jWQvSFSxhkK2BLVocUdC0lVLrBM24f7Qj6Zq44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmnG3Wxisfioxgkaf3jZ9BUUCspDTjeRCCUofF/k0TphlOy2Nm5iADZY4uS44LDjGPSj6HH/CLre5XpMxydpEwm/1946sgZkBFvbB4b7LS95RyWv2p7UIt/UbciwWktHHFVhx1YnAYQS076qh1sEPs3nlM6pMxO3tCg0Upjai3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRINQWkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRINQWkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58682C2BBFC;
	Tue, 30 Apr 2024 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474773;
	bh=uRem7jWQvSFSxhkK2BLVocUdC0lVLrBM24f7Qj6Zq44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRINQWkQkePKz1RuRie2oszOLVH9xjCiR1ZUsRnfd1MCmHoAcK+Qhqf35h/6Lj7NM
	 acC/ntdCws1To1RaFAtmT4C2InX/+vZk5WMYsWW5VHAr3OevwNsW4GCZJDxBVpwNHV
	 0Q/O15Ng9syxsFQmIufBMBCQ/W/QuezNmtgo1rqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/138] btrfs: record delayed inode root in transaction
Date: Tue, 30 Apr 2024 12:38:35 +0200
Message-ID: <20240430103050.317035159@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 71537e35c324ea6fbd68377a4f26bb93a831ae35 ]

When running delayed inode updates, we do not record the inode's root in
the transaction, but we do allocate PREALLOC and thus converted PERTRANS
space for it. To be sure we free that PERTRANS meta rsv, we must ensure
that we record the root in the transaction.

Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bcffe7886530a..cdfc791b3c405 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1135,6 +1135,9 @@ __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
+	ret = btrfs_record_root_in_trans(trans, node->root);
+	if (ret)
+		return ret;
 	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	return ret;
 }
-- 
2.43.0



