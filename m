Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CFD230BED;
	Mon, 10 Mar 2025 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627329; cv=none; b=I9zv2tT9+3Svj32UF90PMk5Wx4k/x7szVOs4GZelUDuEueKm+8+agBnktN6bUz/3v/jZUVM0yuMx/h5nPexVzaDAPvcvPoUiFuYU+mxaiHVf7PRPelLX5f1QsJ8OUqCHMvCzjtDxvSzs49a7bxXCG3FWDPUpSh/RTAOd7H3RugQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627329; c=relaxed/simple;
	bh=imxFXcC169K/zP6QKaVG07ZbpQ0/61HOjGA0Cn+FPCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUzpklEXV8GZ3QZWYxnPOz7XNmbi3YXEj01VOTFzM3AznJQF6GVZjTjV09Rj+iU+SaMo44GFq2Lfme46i+Etw/RlleJKV+/faudQhkm84330GRsxjcLjTEL78p3xQ18A+JU7FHb48EqITiThgLRpyke/d43rC9ESS3VniWV8sJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7Kt+faA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7Kt+faA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12848C4CEE5;
	Mon, 10 Mar 2025 17:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627329;
	bh=imxFXcC169K/zP6QKaVG07ZbpQ0/61HOjGA0Cn+FPCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7Kt+faAxN9XagUd2TbQriOKN1HqDPyLx4iBf4Ts1cK19m+pOE0q+EOj1gd+xWNnf
	 BBINu9UCHZfr0ibmnBkr4EiiR3z374RgoUzFuGjMLhj7Dpsq7u3Qs+KLiue7qZIKC4
	 0D50nRrg/QUPgNItr6wDkY5XKXJobOMpS22Tfn9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 093/269] btrfs: fix a leaked chunk map issue in read_one_chunk()
Date: Mon, 10 Mar 2025 18:04:06 +0100
Message-ID: <20250310170501.418917235@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
@@ -7094,6 +7094,7 @@ static int read_one_chunk(struct btrfs_k
 		btrfs_err(fs_info,
 			  "failed to add chunk map, start=%llu len=%llu: %d",
 			  map->start, map->chunk_len, ret);
+		btrfs_free_chunk_map(map);
 	}
 
 	return ret;


