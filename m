Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734B2A59;
	Mon, 23 Mar 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275711; cv=none; b=HYj8lT4MdP+z0ICATW0IYQD7BaeWIgE8Kud61U1+dB1gYM/Gg4RyPORlbsvIsK1oLNR1zfLva6kmeMSv+8eg+VIL2/emOWMHPQyScY+enkxkAwK7gSZePpi6Jjj/lcvcj/LmAthcIx3jQEU8t6nEV+j4zwjBeFX03lHgkrfvBmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275711; c=relaxed/simple;
	bh=5j0QSoNQmDKd43upchVV46hKDaiZNTWwQyM8uSVOp4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9LRekpsUToC7sYjmRj4W4z3xs20/u3k+/hORcUoRe8gDCRFAmykhrZ4gheWu/eobl5r2CKdPOd7D+9wTE38fGcoDtjkA+xc5HDVAeIerL4asX96GNCJinO6KxpFzDXqJ1SQn4NWBgaXWTTmB3MhDwNzsIu8JW7LapCsz1jypec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsnlT76x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsnlT76x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025C5C4CEF7;
	Mon, 23 Mar 2026 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275711;
	bh=5j0QSoNQmDKd43upchVV46hKDaiZNTWwQyM8uSVOp4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsnlT76xNugc/6tdcQotz2Qg+wwPJvs6gtl8kH1eIgpjO1/XqwdFGOWmV9domELND
	 bU+TWa6hhv9Yvw8kvbgWVI5qZ52LvGb46NtFsJeSOkER/H/46BT0VCtjluEIf87pJ8
	 zv6uOFCSLuJQvRcUBZFgi2BTgd/iQNbEw9228E4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 149/460] btrfs: fix chunk map leak in btrfs_map_block() after btrfs_chunk_map_num_copies()
Date: Mon, 23 Mar 2026 14:42:25 +0100
Message-ID: <20260323134530.237909050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

commit f15fb3d41543244d1179f423da4a4832a55bc050 upstream.

Fix a chunk map leak in btrfs_map_block(): if we return early with -EINVAL,
we're not freeing the chunk map that we've just looked up.

Fixes: 0ae653fbec2b ("btrfs: reduce chunk_map lookups in btrfs_map_block()")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6522,8 +6522,10 @@ int btrfs_map_block(struct btrfs_fs_info
 		return PTR_ERR(map);
 
 	num_copies = btrfs_chunk_map_num_copies(map);
-	if (io_geom.mirror_num > num_copies)
-		return -EINVAL;
+	if (io_geom.mirror_num > num_copies) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	map_offset = logical - map->start;
 	io_geom.raid56_full_stripe_start = (u64)-1;


