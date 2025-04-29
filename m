Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C71215060;
	Tue, 29 Apr 2025 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945398; cv=none; b=jtrWmY7NKLgvmaVIMYpnGeOmX8z17p+xK0Im41pfdDNLZxjchmvSkVbUF9xxu300hwdF7hRlbkjv4Oek63ENjjnGLW01j0xI025WfxOlCsaxM6Scz+ck5vu+p5jKrha1oz3c8hKrkHNu/Hows+bFX8WOJu5bGo4i0Z0E00Qe5Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945398; c=relaxed/simple;
	bh=bN5StPvi+KQxsEzJ+VrVYx76CbKjmLgIOwZ22V8S/78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmkiampAuS2jRfADeD2POsdXjH77J8gjz0dlUfwbrrbB/sBddrHSSIhxTOR11LSnrCXSCuxjfsksJvwRCFQm9FH7iQ6VBoB0JIB/8M5Ij/tw+ZCfM0YtjuqW4oUv7scTqswSTKM1vq6tjMMtJIjP5Jpgt+0Pmfolwlum/KBfy4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzJfZyZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzJfZyZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2566FC4CEE3;
	Tue, 29 Apr 2025 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945397;
	bh=bN5StPvi+KQxsEzJ+VrVYx76CbKjmLgIOwZ22V8S/78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzJfZyZ5igvSWPJEZj3r3s4pxNF1l/YMrQE1qA9cXHQPoq3wKZWkKbTtu3EKO9yRn
	 OqO0x/zatxJMNFALWHJVBQ4k2oRZLlc0Owj0pJmyDVgrZRGchUyD/P+gj6z/nDJDI4
	 w9N5XVyxh+MbMktLpR+4jYKdJOYLCVec0Qu2E/UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Walton <calvin.walton@kepstin.ca>,
	Johannes Kimmel <kernel@bareminimum.eu>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 099/179] btrfs: correctly escape subvol in btrfs_show_options()
Date: Tue, 29 Apr 2025 18:40:40 +0200
Message-ID: <20250429161053.404274738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1380,8 +1380,7 @@ static int btrfs_show_options(struct seq
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	if (!IS_ERR(subvol_name)) {
-		seq_puts(seq, ",subvol=");
-		seq_escape(seq, subvol_name, " \t\n\\");
+		seq_show_option(seq, "subvol", subvol_name);
 		kfree(subvol_name);
 	}
 	return 0;


