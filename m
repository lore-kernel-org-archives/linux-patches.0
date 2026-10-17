Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E03AA4E8;
	Sat, 17 Oct 2026 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257162; cv=none; b=HEFlOzU4o/IooOWc1EuDIyGYJSEUZatXzVLT9SHNWw3hYMYvTY3obVrcQF9/cljHgaudTiMmGSayjZUA05cU4+MUqTlfXVrBUdpq8NL3lmWV3G3qeu4sH/KGeoA5QYtcysDrp/qYFF11yL5Nk6Khk9lB1b8KsrZBeiWMB9wBPKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257162; c=relaxed/simple;
	bh=eVS6cgAH8X+WL81d+Ux6BdSHqWVpgIoXKZeahE9laEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0M/qSMn8o6UTNI/pMvhwVKjtdRfbFDngTjdJr1CR441DHUO+K9e1wl1vkGFX13SPWNfphHh2FynJ+VQfzV0pyZ70GxuNEBLE5yWQD2tAc7PZoI5ZoUzS6MomPxBinWQZoC+n/v8CkSRIPpxgHDmUvrs1hEPGFql4jTHG7d7vEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bN4vnj35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bN4vnj35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036AC1F000C4;
	Sat, 17 Oct 2026 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257161;
	bh=aU23fymiX1cI18pdLvdONVbTekLo+3S/aChKrLJQ7oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bN4vnj35810+HCKGEULnthMy+Ji1BCKIDAKSJ25dcjsyR5xW4MhI46thCn3Y1pV0p
	 qThEI6bFcS/rTZKakueAWdJ1D06KfvyZCP7qxCZe1LcQjAxbNeRNxElPFPYqTPQUyW
	 kgunVkDumYtT77MrCuEoA3/4MuYaW4dSfLRpUIjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 0470/1674] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Sat, 17 Oct 2026 17:45:42 +0200
Message-ID: <20261017160443.179714350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1fd742c7479961da6d0bb794ef8ac6b7b9442847 upstream.

When paths_from_inode() fails, scrub_print_warning_inode() jumps to err
without dropping the reference taken by btrfs_get_fs_root(), leaking a
reference to the root every time path resolution fails while printing
scrub warnings.  Every other error and success path of the function
drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -446,8 +446,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


