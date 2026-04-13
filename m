Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8702E11B9;
	Mon, 13 Apr 2026 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097553; cv=none; b=tQTywl3Es54V7UtwUBeHmEImy/cotb4YBLY64cFhuHht2Y72E6/GMjlbutBNgtk6cZPW0kC96e10+/hW/dfKALm4H0gAbK+KskB6qIVgI5j27G3z6Wxr6OEIvQ7Zlyz7A0BM2c59Ts80RgiTXqPdmkCpNgaEd/zNKsZ2IE9rGdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097553; c=relaxed/simple;
	bh=HSiWHBHhvQN+sLuLdVVRZG2SXZtlqxb33y+/FKS3EWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwHMnndyoge8n7mM8AJccmKvBytoaTLlZmI7OZ2JA6jcB7bwQvhCUoFdtjOSSWPXk1CowgfEgeJQ/H5XpsiMvdZSj46xvv4hyxj9dE6ZUy3oT1El4KZoHr8FGdtlZbgq+1CmiKZoBenfCb4GQ+KSJ5UdpDiertQciho/yH5Pya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjmcUBET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjmcUBET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D83C2BCB0;
	Mon, 13 Apr 2026 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097553;
	bh=HSiWHBHhvQN+sLuLdVVRZG2SXZtlqxb33y+/FKS3EWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjmcUBETiUtuwlfU4YalGPVwhOLoKOg/VJwoTHRh7aH+HMxrV9UY/0/Ueyibpeo2c
	 cipW0pfH6gW8xrrlQ3diRpJAuLysZoMp+tUIKCr0D4uFPmwj+tY2mp28qFqORUmhE+
	 cFva+tSlmM7WP6dqGI566kml6SfvboNHiMDoZ7uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 181/570] btrfs: abort transaction on failure to update root in the received subvol ioctl
Date: Mon, 13 Apr 2026 17:55:12 +0200
Message-ID: <20260413155837.236397479@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 0f475ee0ebce5c9492b260027cd95270191675fa upstream.

If we failed to update the root we don't abort the transaction, which is
wrong since we already used the transaction to remove an item from the
uuid tree.

Fixes: dd5f9615fc5c ("Btrfs: maintain subvolume items in the UUID tree")
CC: stable@vger.kernel.org # 3.12+
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4545,7 +4545,8 @@ static long _btrfs_ioctl_set_received_su
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		goto out;
 	}


