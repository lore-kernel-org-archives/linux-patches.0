Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB32309B6;
	Mon, 10 Mar 2025 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626555; cv=none; b=frlfu0Hgo+e1ONGJTdFG7TvfHBHNhYsUveLdyRlVYGHQ7mj0gQfjSzdSVZ3SiRCOeIO8pRcTtEKgTdiTjDKPrWzEvSmQI2fgR0niI2p2WBePUe3Mcq8ajJf1AcdRCxBvNt+8iqmuUAq5Y2IJSnJpkXwbFZ5YaMNWcTGiOBARZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626555; c=relaxed/simple;
	bh=0w92nnXyiqeY03N+NV3oQfnGfuiPtmuLDluUnn76ZVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPq5QEh51eaM1q+MMctd4T13NQwBsD+3Rk8Owt9eiIthIsUKUJJFruJ3QyVt1HsKBlKqrKpTswL5a+rugMMOWh9Qs2UcSJgbrgyn/Y1ccAqRRc3fytAS/qHd9bRZXvKbDHK29iQniziP/0BOH5Xsk7C0MlzSKcHr7zCwd4ORQc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fh8l1oHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fh8l1oHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FDDC4CEE5;
	Mon, 10 Mar 2025 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626555;
	bh=0w92nnXyiqeY03N+NV3oQfnGfuiPtmuLDluUnn76ZVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fh8l1oHuqByu2oqDOyq+gl9R093r/h76KYEzETg3vBIO0WAfjIdz7IztrSwD9eekI
	 o83vMpwPticvRng1GtSecXW0r3PvdVTSPH404SUjeU8Ql10qUio0xPn84vrSL616RG
	 KNhmVA0Mm3y4hr5yD5pOxGJrdpPvIMr+4OaHlx38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 031/207] btrfs: fix a leaked chunk map issue in read_one_chunk()
Date: Mon, 10 Mar 2025 18:03:44 +0100
Message-ID: <20250310170449.010760907@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 35d99c68af40a8ca175babc5a89ef7e2226fb3ca upstream.

Add btrfs_free_chunk_map() to free the memory allocated
by btrfs_alloc_chunk_map() if btrfs_add_chunk_map() fails.

Fixes: 7dc66abb5a47 ("btrfs: use a dedicated data structure for chunk maps")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7076,6 +7076,7 @@ static int read_one_chunk(struct btrfs_k
 		btrfs_err(fs_info,
 			  "failed to add chunk map, start=%llu len=%llu: %d",
 			  map->start, map->chunk_len, ret);
+		btrfs_free_chunk_map(map);
 	}
 
 	return ret;


