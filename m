Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8367A12C47F;
	Tue, 30 Apr 2024 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473710; cv=none; b=bwFv/BLyDimt7V+PoqvUR0+M0IKWcLyZol7AfdwlWABVKjJtkO+Cp/jWzJuKEU54hlSQADp6oGmUsDH3j+YoAgZFl2uUJsTFFf+DYSD8gcoZy/rXw0agbogXIn57fAGUh7Z2+w664WLdHxj+Df0PFqyKjoda+H12UeQZ1B6QHrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473710; c=relaxed/simple;
	bh=qvl4q71NxBmznRRcgjBzkcuWg2HaN/RbXs4ERXWOkGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmPuTDzRCanVQTLCe0cab2Gyfm0Le0I0/4zp8xXBm7Gds1u07EF2ucEoD/Tx4CHhfqEGvzYV4DOwtBHFGSRVxW/T0LgZOty25diyp4KTEjTX1EgjmuzqJWKgZhTQFdn1mnDKj6y7gN7hPLNBQBCpwYHQ9nSLNxdXFkrU/ao+5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3YlpQ5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3YlpQ5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE65C2BBFC;
	Tue, 30 Apr 2024 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473710;
	bh=qvl4q71NxBmznRRcgjBzkcuWg2HaN/RbXs4ERXWOkGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3YlpQ5/7hLi1zv9rKX2muU8fpzuVkihOq15kzatZxqhGv1IZGBuaj7i1lRXtiN24
	 iBHq2R7BokW5/P1l2FRHxjrfdYtg8YYQ1vm6bilQVo/BkciaqX3/XB7QHD3wAvoN+B
	 pL1IJFnWqhgPhmZA2lgk7aQDnfWuGKuRokNDdL/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/77] btrfs: record delayed inode root in transaction
Date: Tue, 30 Apr 2024 12:38:52 +0200
Message-ID: <20240430103041.515285767@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/delayed-inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1133,6 +1133,9 @@ __btrfs_commit_inode_delayed_items(struc
 	if (ret)
 		return ret;
 
+	ret = btrfs_record_root_in_trans(trans, node->root);
+	if (ret)
+		return ret;
 	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	return ret;
 }


