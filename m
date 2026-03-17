Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C62DF132;
	Tue, 17 Mar 2026 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767980; cv=none; b=UtbTnizJZMA4CZRtpAlLfxcw+pVWQCwT1zMM76hArOYld8qTsf1Ka8JKCgH+3Kgu2sFGuzrdjDpo0IDIhzPluaMXyXIunoD/Va5UhmTlAlRBvrLYiwkxsYHO2L/ozWr3L+xKglABNJoHeU0wXYfGEaP3VGlhqwdWNjs+esvwn6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767980; c=relaxed/simple;
	bh=HoQeP54Aq+Oqnpp49JodQlWj5cWrG4q8UocxXFJUWsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM4Lpvddaq5wxZa+xAqoU3zZxF1IM/86pc0rBiTqjyne/hFtpAF9Wao1p3ueagZuWUOy5Pd5/mBNd+1I1nmjruqdwj3JS6cF4drJZd1tmxhUcFuLCaugb6DL4ZiK/tHLPQWYz/vw1ws8HsyhPLLQnXs6iOrxVLBdnk/5M+aGEjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euLPIkza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euLPIkza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E71C4CEF7;
	Tue, 17 Mar 2026 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767979;
	bh=HoQeP54Aq+Oqnpp49JodQlWj5cWrG4q8UocxXFJUWsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euLPIkzaYg/YIJ2kIea2TztH6wXu24NBRXyc3PtZ/0Q2AZW5GdxeqvqrRz2LsdTnv
	 6KS+P/F6rDHEwm2Xb0HiQFoYp/6Mqu4X4tnXHfp0YknSvB1HnCttnOxxbS4eaMJnnX
	 qGKws8d99pG87BrzUqgd2aNmvXI7kLxTV9LZqahc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 203/333] btrfs: fix chunk map leak in btrfs_map_block() after btrfs_chunk_map_num_copies()
Date: Tue, 17 Mar 2026 17:33:52 +0100
Message-ID: <20260317163006.883543310@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6759,8 +6759,10 @@ int btrfs_map_block(struct btrfs_fs_info
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


