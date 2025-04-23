Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED46269B07;
	Wed, 23 Apr 2025 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421963; cv=none; b=T1jDPcbMtyv6D56kDLZ+T8I89ezEpYn61/D+ykxdUc3iz+Qf9Ng+m9n9F+zAk2d4a9+CmbK8A6B9HhtqJ3rH8sMflvxOCew2KjBB17UsQzhDcL2FXx+uZYnqHOlLno9EV1Vi0xzqUmvbdL0l6EcsQ2eycqk0itLqHo5ACTBZRP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421963; c=relaxed/simple;
	bh=yyJQ0IuBWIPlVWmG+AXJUHI/ffC/rqZy/9F+LgLeHkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6iMB6XE7J2mSMUVLIgzrKfL03ikjr9td90kWGCuWPMd2I41+UFCC+BQDbdaVFpD1+0xjZtXAeiq5C4crApKsMlsq+3CFWUikhVhW1SMgyyqlxgVW+owUuhjMAoiBh5soZwoRuAlQ+A93fsFqj1UUX3CCPjZ3JM4nBWH2q0fPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KapWIVDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KapWIVDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A998C4CEE2;
	Wed, 23 Apr 2025 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421963;
	bh=yyJQ0IuBWIPlVWmG+AXJUHI/ffC/rqZy/9F+LgLeHkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KapWIVDJomk0JkMVMAdUEhlq+pF/yIneMR7o2YzI3HhIHfcenIVM/LoWvMAgWPmX5
	 yOmnuGIsjlVF4JnGpCcIYvsN6Sqi4JThoDOU4F3H9OStMM0RdGpUo/2Dz1TTOUba3E
	 f2Uvf60qNyBz+HuYhBr3DLSZ/43VIMaI5nsLztQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 206/291] btrfs: correctly escape subvol in btrfs_show_options()
Date: Wed, 23 Apr 2025 16:43:15 +0200
Message-ID: <20250423142632.800120912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1640,8 +1640,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


