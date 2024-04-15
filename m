Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92DD839E0;
	Mon, 15 Apr 2024 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191336; cv=none; b=b5qAKxAIqFb0tA6EHvTYebAZFko60XijOiYnQQrBL8WVuKaSx4Tz29tSzNrkRffaTcMIPXE/iWQEp8qlZIwf8NG7ABsyFnXo+Nf0cCqDWFChoEDp0IkPARlRlKSerVXqMfXhfVLeaU0HF6kTSvbnG5ZiPBJYP6k9vvDAqriWOP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191336; c=relaxed/simple;
	bh=NjdZACyeje+lhfCjXsFW9eFFrIANBuKSbezrdksuKPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJqMPLnfuI48ZXKGMNm8PkGwXq3EUx/KLm4Jfw+dI0w99XdHL1hXicqZcs60Z38kDQ9XEHEfjzQojPrVOM3sQerWwtMuNjk6OOGu9J0JWRgAWI7wUuLXTCLtScL3AvD3XtpB4l5VDZenWzC3FZ7sqFGgikwGjubpHaTUN98qReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqX3cRgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqX3cRgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583E2C113CC;
	Mon, 15 Apr 2024 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191336;
	bh=NjdZACyeje+lhfCjXsFW9eFFrIANBuKSbezrdksuKPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqX3cRgI44Rgbdq2CIymXoGAMwt3GkVDvuGdrMURQDYUJHQ146NxMAuCoDby87a1u
	 RJsgyL9Im1zhjRQEEMuNHbnioVro9ECDuZ1WmT4kmbwbxIIX7HpCNQVBqHcxiqYl5y
	 2fjB0pxH0rLEze3+IaXWhCXUC7efa2Xu6mZwii5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 110/172] btrfs: record delayed inode root in transaction
Date: Mon, 15 Apr 2024 16:20:09 +0200
Message-ID: <20240415142003.738674996@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 71537e35c324ea6fbd68377a4f26bb93a831ae35 upstream.

When running delayed inode updates, we do not record the inode's root in
the transaction, but we do allocate PREALLOC and thus converted PERTRANS
space for it. To be sure we free that PERTRANS meta rsv, we must ensure
that we record the root in the transaction.

Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1128,6 +1128,9 @@ __btrfs_commit_inode_delayed_items(struc
 	if (ret)
 		return ret;
 
+	ret = btrfs_record_root_in_trans(trans, node->root);
+	if (ret)
+		return ret;
 	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	return ret;
 }


