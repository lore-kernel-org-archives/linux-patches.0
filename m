Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC929BD87;
	Mon, 13 Apr 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098094; cv=none; b=AHVXUHSXZ8RU3w5VNPeByzRJ62SZMRiToSR4U2jUMG+d/DSCllsIeMtHdbYW8ii1pDJ91OVoM4dRfjnxIRO1E33SWwTaX7R2g43TGf1e1rC/XcL6OYQSSEbzg30h5MDLc2YP7qIQAOFFFUKkPURNfsK9yY8iATAAVxVf+K2OJDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098094; c=relaxed/simple;
	bh=Yblj4HUek6e1N5xE8lyMcj3CAbWQfFeITNY1lhUYs3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HucmXwqeyOwpfhANCOkrTVtGuOhOmz2hkLc79Y0ojkXYZesns8vDK42SQFkM4YpiSd9NwYf/rPNjI1NMJs9/nZu9O30wDgXYWduTG6cvAUqztBWi3vZJKBEaSb77Zi/TqT3q/aLLUDpX7I65art+XayixTU5xVkiOKmrQDR8Ohs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6/1FW4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6/1FW4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16342C2BCAF;
	Mon, 13 Apr 2026 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098094;
	bh=Yblj4HUek6e1N5xE8lyMcj3CAbWQfFeITNY1lhUYs3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6/1FW4fNJUh5nNWT/P6AVT3HJSoHMf1IxdFmXRtk//DcuW5kjGDv5Db+tGkZqNbT
	 wVEDBm3WElEuIKxhqflRGACrjFgs6BtQTnbQ3FGVhp2Eg+J2ffupyStCDN9chedJB0
	 sL0wBNuoFjcWLcHgiffiXoe7mq55L3Tiu0+0TvA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/570] btrfs: fix super block offset in error message in btrfs_validate_super()
Date: Mon, 13 Apr 2026 17:58:42 +0200
Message-ID: <20260413155845.120820202@linuxfoundation.org>
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

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit b52fe51f724385b3ed81e37e510a4a33107e8161 ]

Fix the superblock offset mismatch error message in
btrfs_validate_super(): we changed it so that it considers all the
superblocks, but the message still assumes we're only looking at the
first one.

The change from %u to %llu is because we're changing from a constant to
a u64.

Fixes: 069ec957c35e ("btrfs: Refactor btrfs_check_super_valid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 136902f27e441..41cc27ba4355a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2657,8 +2657,8 @@ int btrfs_validate_super(struct btrfs_fs_info *fs_info,
 
 	if (mirror_num >= 0 &&
 	    btrfs_super_bytenr(sb) != btrfs_sb_offset(mirror_num)) {
-		btrfs_err(fs_info, "super offset mismatch %llu != %u",
-			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
+		btrfs_err(fs_info, "super offset mismatch %llu != %llu",
+			  btrfs_super_bytenr(sb), btrfs_sb_offset(mirror_num));
 		ret = -EINVAL;
 	}
 
-- 
2.53.0



