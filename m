Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3BA679E5;
	Mon, 15 Apr 2024 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192030; cv=none; b=PWfjuJpMgwxouazSxhoLYn1SnYpKRNw1//aM7245hFMAPnoH4zrA7cEqnvSOmh2ZvDSLtg7pc3N+u/kS6BUV1bsFmCx831iI1zaC4BzSjoFRnc0CkVFGbredJan9pogth9iPRm5k5ThsZZpslNvZv6zKZWee9+YJW+vZGAZBZx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192030; c=relaxed/simple;
	bh=CDtfkSJGr3InB8D2Oj7Rhrpfk8SKl0ozLYHDNDfoj8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBvBelm3DEZj+ekNZXgExZPmOIZanQJVindliOpIHu1aLBXyUzVq1AwnGEk3ktxqKdmtqKcOmE96j0nBcuM3KDpJqJC4YNy2xnoHtO/NPWb1qHYRxTqGOI4pJ2T/uM/PKxG8JeoEuWq+sVKRM2ypetjZSecJTaGX/U3cRUGbsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtdY09Og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtdY09Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533C3C113CC;
	Mon, 15 Apr 2024 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192030;
	bh=CDtfkSJGr3InB8D2Oj7Rhrpfk8SKl0ozLYHDNDfoj8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtdY09OgJ6q6rL/V7uh7yN/ey1Uq2eBD0WPCciGZ2TeGG7u+WiotYNw007YH5JVkk
	 MELqXH0zTktc/aKDv0MgoLwZ3x9ppeNsVLK0MToPOn80FOqg+sD7Lnbo/FPoz/3PRq
	 COpbRmaiaOChu8thpQnxdXfAqxNlZENzbcJR1WfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 42/69] btrfs: record delayed inode root in transaction
Date: Mon, 15 Apr 2024 16:21:13 +0200
Message-ID: <20240415141947.431994503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1115,6 +1115,9 @@ __btrfs_commit_inode_delayed_items(struc
 	if (ret)
 		return ret;
 
+	ret = btrfs_record_root_in_trans(trans, node->root);
+	if (ret)
+		return ret;
 	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	return ret;
 }


