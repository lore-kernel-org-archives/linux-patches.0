Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DB431B10B;
	Tue, 16 Dec 2025 11:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884523; cv=none; b=cSrwN44j+jMmFdk9tfFu78o+jHvLDGTCFACfUJ5ol8o2ntOMl7Fo9OnLbzLBsy9jWtL/T/PHTexq0cho7H9jrdOO2ltwhKiTZDKmXE0uVSVlg0/2BDfAulbkAaFXBz3Slw5R7m+qhROl+jvp7/Gic4X6zgcgghDa0smjPM9mlwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884523; c=relaxed/simple;
	bh=u/lkwx6QeH+y9seLWfic8c1kUFyWRjR6/fQrjhejFF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RliGehBk+KFAIsNbtFgbz6NMOmMza0kusCuPXXvs/SMKyY8xQw5rTJVvsdt5LwJ3S2bN/FlZ7qSprTNEhH0HLxcHAbgFPdIodfkfQTZiH7MTH15SdNjatw3oI4LMd0ISI7JLGKfP1/qRl+XnVnah4F2P8F4tI/md3HKhQlifU+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afpq0XTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afpq0XTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258FEC4CEF1;
	Tue, 16 Dec 2025 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884522;
	bh=u/lkwx6QeH+y9seLWfic8c1kUFyWRjR6/fQrjhejFF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afpq0XTQoZXKUgnPmcL4GYJDCmT7BLI8FsXlXFLo8HXUn4USrdq9RmNf8fEXVE1W3
	 XB4a8siso4SZBdpQ+ZtW+0eJLfnE4GiTwbEfs56wvpYA5gPjB0L+h94LvYM6vhhUos
	 Ul4H2q1a9hCSkcmPw1t70GRi5IlJvizFp2n0QI1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/354] btrfs: fix leaf leak in an error path in btrfs_del_items()
Date: Tue, 16 Dec 2025 12:13:07 +0100
Message-ID: <20251216111328.889272661@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

[ Upstream commit e7dd1182fcedee7c6097c9f49eba8de94a4364e3 ]

If the call to btrfs_del_leaf() fails we return without decrementing the
extra ref we took on the leaf, therefore leaking it. Fix this by ensuring
we drop the ref count before returning the error.

Fixes: 751a27615dda ("btrfs: do not BUG_ON() on tree mod log failures at btrfs_del_ptr()")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 81735d19feff5..362df6e96717c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4599,9 +4599,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			if (btrfs_header_nritems(leaf) == 0) {
 				path->slots[1] = slot;
 				ret = btrfs_del_leaf(trans, root, path, leaf);
+				free_extent_buffer(leaf);
 				if (ret < 0)
 					return ret;
-				free_extent_buffer(leaf);
 				ret = 0;
 			} else {
 				/* if we're still in the path, make sure
-- 
2.51.0



