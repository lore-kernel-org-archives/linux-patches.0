Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D208913DBA5;
	Tue, 27 Feb 2024 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041983; cv=none; b=SJnlULws41qwEi2XH/l1PXZQT2V+Is9QWm+YsZY9qd54+zlGFVi2MJnHXY/VuHXgt64FfMWehkS6Bgs+y9ttNVAqv3LvBQqFud8YOqNVI+Clt4USYRJQ2MJ5ln++lF3MGvY+4TnHyWaAgEAuWUY2OjaDCkK/LDv9u2dkZd9OHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041983; c=relaxed/simple;
	bh=qggbTdxWtxrX1iP+Xs2iMwXzyyB2AeoUKJjYMh5ettM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0pywQkGSxH/072nGCkHTVT6ZoljpjMUnlgPyrs9jk+ynOeTBa4qTZ9uCH2RlMM7fh+LpQ8v9cuGiPzLyx7+Kfc8tP/wfC9GhtWDgTIL7tnB9bvgFDjarCJAlPCQV+jFZpmNpJp58M0G/1Mk2fn8SzSRC2YdzJabLpqGFqjBpWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upt3kSbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upt3kSbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3DAC433F1;
	Tue, 27 Feb 2024 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041983;
	bh=qggbTdxWtxrX1iP+Xs2iMwXzyyB2AeoUKJjYMh5ettM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upt3kSbnoga+l/Mq2nmHbFyzWUgTZjEEU/guGIMvh3VDP3hBSDU+l0FKjIhNs8FgI
	 Ppo0U1j2sMBxMXfuydDarbdl69ahlKBoYY4SCAgbNTxhdTEONhVrtIHNl5gIhuLw17
	 zgfJputZKkwhvxGpvsD2rD61GL8kNlbdxejZ4duU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 139/299] btrfs: defrag: avoid unnecessary defrag caused by incorrect extent size
Date: Tue, 27 Feb 2024 14:24:10 +0100
Message-ID: <20240227131630.329797566@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qu Wenruo <wqu@suse.com>

commit e42b9d8b9ea2672811285e6a7654887ff64d23f3 upstream.

[BUG]
With the following file extent layout, defrag would do unnecessary IO
and result more on-disk space usage.

  # mkfs.btrfs -f $dev
  # mount $dev $mnt
  # xfs_io -f -c "pwrite 0 40m" $mnt/foobar
  # sync
  # xfs_io -f -c "pwrite 40m 16k" $mnt/foobar
  # sync

Above command would lead to the following file extent layout:

        item 6 key (257 EXTENT_DATA 0) itemoff 15816 itemsize 53
                generation 7 type 1 (regular)
                extent data disk byte 298844160 nr 41943040
                extent data offset 0 nr 41943040 ram 41943040
                extent compression 0 (none)
        item 7 key (257 EXTENT_DATA 41943040) itemoff 15763 itemsize 53
                generation 8 type 1 (regular)
                extent data disk byte 13631488 nr 16384
                extent data offset 0 nr 16384 ram 16384
                extent compression 0 (none)

Which is mostly fine. We can allow the final 16K to be merged with the
previous 40M, but it's upon the end users' preference.

But if we defrag the file using the default parameters, it would result
worse file layout:

 # btrfs filesystem defrag $mnt/foobar
 # sync

        item 6 key (257 EXTENT_DATA 0) itemoff 15816 itemsize 53
                generation 7 type 1 (regular)
                extent data disk byte 298844160 nr 41943040
                extent data offset 0 nr 8650752 ram 41943040
                extent compression 0 (none)
        item 7 key (257 EXTENT_DATA 8650752) itemoff 15763 itemsize 53
                generation 9 type 1 (regular)
                extent data disk byte 340787200 nr 33292288
                extent data offset 0 nr 33292288 ram 33292288
                extent compression 0 (none)
        item 8 key (257 EXTENT_DATA 41943040) itemoff 15710 itemsize 53
                generation 8 type 1 (regular)
                extent data disk byte 13631488 nr 16384
                extent data offset 0 nr 16384 ram 16384
                extent compression 0 (none)

Note the original 40M extent is still there, but a new 32M extent is
created for no benefit at all.

[CAUSE]
There is an existing check to make sure we won't defrag a large enough
extent (the threshold is by default 32M).

But the check is using the length to the end of the extent:

	range_len = em->len - (cur - em->start);

	/* Skip too large extent */
	if (range_len >= extent_thresh)
		goto next;

This means, for the first 8MiB of the extent, the range_len is always
smaller than the default threshold, and would not be defragged.
But after the first 8MiB, the remaining part would fit the requirement,
and be defragged.

Such different behavior inside the same extent caused the above problem,
and we should avoid different defrag decision inside the same extent.

[FIX]
Instead of using @range_len, just use @em->len, so that we have a
consistent decision among the same file extent.

Now with this fix, we won't touch the extent, thus not making it any
worse.

Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: 0cb5950f3f3b ("btrfs: fix deadlock when reserving space during defrag")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/defrag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -903,7 +903,7 @@ static int defrag_collect_targets(struct
 			goto add;
 
 		/* Skip too large extent */
-		if (range_len >= extent_thresh)
+		if (em->len >= extent_thresh)
 			goto next;
 
 		/*


