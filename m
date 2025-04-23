Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48819DF4C;
	Wed, 23 Apr 2025 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420197; cv=none; b=Hr371HeJ1JFg8xS+B8Vm72AHkCfXnPAdsVw+WWO8Zms7AGH/NGNp35LRDHBleJvFML1byR2PhRDf8gx/XYoOEY0Hh9k6PZ9NqjJMRHQLJDBpw0TYsR+OtSCcREcAFQF3J5I4oW+XBCRpVBGYbfvXPR05Wj4SShCK0zdQPYZH7DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420197; c=relaxed/simple;
	bh=72NMWS7FNd70dGYm+inwnKQvwfnQqOUOXjtHJEaqIDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGt/OXunQ+EumcYrL3anLXN3lgDaTd1dwUurCtQZw/yXtz9FQtECH2ceYtHMdEXvmzgfASc6LJmJWUcKCz7eJaniQ6vkpqjnCmDrCusx2b+Bu9u++a3NN6NggBhULK1SmckDwuaBvu5c9OxbNne2GkESkxWoaWeJNLt8bhMVlbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSmmlJ0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSmmlJ0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E40C4CEE2;
	Wed, 23 Apr 2025 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420197;
	bh=72NMWS7FNd70dGYm+inwnKQvwfnQqOUOXjtHJEaqIDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSmmlJ0PmKqhj3MpB5tJmyFpoejRO9LjDS8tpAm8JrQmYgxV6uChZNAeVAaknijk1
	 +DHBmJWc3+TifyHwbfkvbr+Cw3B/e6PsTX4WaxE0oYiG+NTfFWRd2uXteTuFIv7tyj
	 23OjTw3fJ9VOLVuveGWC4cA8R9S41E2abH2jBwp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 108/223] btrfs: correctly escape subvol in btrfs_show_options()
Date: Wed, 23 Apr 2025 16:43:00 +0200
Message-ID: <20250423142621.512668233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1140,8 +1140,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			btrfs_root_id(BTRFS_I(d_inode(dentry))->root));
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


