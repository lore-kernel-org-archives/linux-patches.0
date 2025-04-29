Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53DC24EABF;
	Tue, 29 Apr 2025 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946966; cv=none; b=sJNWuw9/jKGJOVkGk82SnSvlbhqCT4Zr6YhTaRWfJLwINMUaslBHBKuVZQ0AFBHqmlrItHfPlKpLCFrCWqrghbjslY0OIOI8vJFHeWm75OccN0YMO9Nqmo9RZ0lwxbgDLmDkmEmOl1Vx+Hnx/740t25kYp8tJDAgLM5ThI+TSNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946966; c=relaxed/simple;
	bh=0lxJKx5KSleLUXdczo4l1TKJHTRf0e9u8Q3w4PRsZ9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xbd3YE9xTwnUzQPkSzS+dE4sfoYpuopBlLT6T7iGxPysqZSkmnoGdcuiaxFJ0mNqiQde0I39BkfrzuiTzRUXvpYxSPekJTgsLyDnZaA+bdhNxZ7ANIIj6GwxsnSJW9v7EWmv2ytnufYYmA57DHztcn/gWcwsK+YRfZCeDK2asg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW8z8iOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW8z8iOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2030DC4CEE3;
	Tue, 29 Apr 2025 17:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946966;
	bh=0lxJKx5KSleLUXdczo4l1TKJHTRf0e9u8Q3w4PRsZ9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW8z8iOxpFTl18dg0kutLCmp/uDmSxFLtL9jvAXX8T1wCqWDsOfHJmMlOH8sVXxZG
	 cv1QN3dNGqghx3vz6PF2Z4k3RXq/76UhFQGZunTC/9VjEA1Np+iJGDmxi8NDR7lzLk
	 7EXiLuY2+t8OtOU8S/KWHbNVq+OLGFdwyf2rmUio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 126/286] btrfs: correctly escape subvol in btrfs_show_options()
Date: Tue, 29 Apr 2025 18:40:30 +0200
Message-ID: <20250429161113.042373752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1502,8 +1502,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


