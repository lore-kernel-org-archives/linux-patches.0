Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9B279345;
	Wed, 23 Apr 2025 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422278; cv=none; b=d9tyk9u7PF+l2oNgvHdG50KSyxQ9L9dYU8CebVCk3uix+kh8apLYNmHXeqhx4SpaW6zCFYU16L5cg2n31pX97qLI2myijSdp8r14z8WrZby/FWTx4Y/0idtUxwQsn9rrEiLmuN7yeLZZBUZUuYJLKksItpFZsTvhtEkeYXkQCYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422278; c=relaxed/simple;
	bh=BwhxDdKebDzI4zqT1zOL0ubjsbZsz0ttEaof8Cq3q1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbaXkVR/6QnpTU9eR7zIc3l2zuf4fxk9nPhSCNNMgU/2xhDN6BVaXcZXiF2xTujFSXWH2g/uEI2jRdkdyJQg7TiNbr/mtDdFckXNfnoIIz9RE2/wW7fiySJ0Vy/EP5FZlB5BLJma313tztZMMhCURUg/nLjIr3t0kSKxKQfYlCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxC/btoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxC/btoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991DBC4CEE2;
	Wed, 23 Apr 2025 15:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422278;
	bh=BwhxDdKebDzI4zqT1zOL0ubjsbZsz0ttEaof8Cq3q1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxC/btoLW4YVeS/By4HKWOy/9+6a5J2bDVeiuR3nlt8HE064QIk90PuV0az8h07tB
	 VNjT2azzBBfmwpwCVitV6Wi0Xm6shEPmMns+NqwyyR+Kr8gfVSuV0REhRK+yjhkJBx
	 T4GwJF0MH7LuC8gBpbJu7iSGL3MHy/zHjGrYDYjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 312/393] btrfs: correctly escape subvol in btrfs_show_options()
Date: Wed, 23 Apr 2025 16:43:28 +0200
Message-ID: <20250423142656.214891247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Kimmel <kernel@bareminimum.eu>

commit dc08c58696f8555e4a802f1f23c894a330d80ab7 upstream.

Currently, displaying the btrfs subvol mount option doesn't escape ','.
This makes parsing /proc/self/mounts and /proc/self/mountinfo
ambiguous for subvolume names that contain commas. The text after the
comma could be mistaken for another option (think "subvol=foo,ro", where
ro is actually part of the subvolumes name).

Replace the manual escape characters list with a call to
seq_show_option(). Thanks to Calvin Walton for suggesting this approach.

Fixes: c8d3fe028f64 ("Btrfs: show subvol= and subvolid= in /proc/mounts")
CC: stable@vger.kernel.org # 5.4+
Suggested-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Johannes Kimmel <kernel@bareminimum.eu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1336,8 +1336,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


