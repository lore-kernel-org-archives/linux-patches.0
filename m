Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2A013B2BA;
	Tue, 27 Feb 2024 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042638; cv=none; b=T/ddy7IEf3F+x4yaKbmzNJY2ttqfKcA2Cbgkcqhonk55IQB0GUe0Q05V7dfRsqjWbBMnog3mkFY2cQwDPI7E0IR3iXckPtPXeHWhZl3hJHG0cD8xuT5EMR44h7F0HDmdUbpCw4J2J/dRkvFrDot+MaMQSDH6ctxMbuF1OMEHXlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042638; c=relaxed/simple;
	bh=zDPJtK7XQ06purNhRUeri9d2GjbjTP9UEo4OVKMNu+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTIt4cipMQ0Gy7/an57CA+9QAN6QJA773dMfuOPjZu4vpBL3M7I8RQEr4LrMM3HrkAUYn925Hi4P4NfqYSelu+O86xMwTtBoi0cioA4UdGpTQ78EqIKrMYV021HRzyhkvxohF5aL2VAvFMpeQnD5IT1GIgy0vEa9rylIKfLa1Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVtmN7Ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVtmN7Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA72C433F1;
	Tue, 27 Feb 2024 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042638;
	bh=zDPJtK7XQ06purNhRUeri9d2GjbjTP9UEo4OVKMNu+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVtmN7Kyxx0MIt5VcSZ356pIm2BQV+HqeWsIKGhlzKmigemILsW5QKjZHM3iXNmej
	 7d95hmxbhwhVWhEv9oCfwYU8CkvZRZMDgGva6knTMd9hzasG6SSFOIHyJV0Uqm8iid
	 VsjfSAUTM+PKXADw+7KXQciOaHaJi+OEQdJjEU+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ism Hong <ism.hong@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/245] fs/ntfs3: use non-movable memory for ntfs3 MFT buffer cache
Date: Tue, 27 Feb 2024 14:24:07 +0100
Message-ID: <20240227131617.161390971@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ism Hong <ism.hong@gmail.com>

[ Upstream commit d6d33f03baa43d763fe094ca926eeae7d3421d07 ]

Since the buffer cache for ntfs3 metadata is not released until the file
system is unmounted, allocating from the movable zone may result in cma
allocation failures. This is due to the page still being used by ntfs3,
leading to migration failures.

To address this, this commit use sb_bread_umovable() instead of
sb_bread(). This change prevents allocation from the movable zone,
ensuring compatibility with scenarios where the buffer head is not
released until unmount. This patch is inspired by commit
a8ac900b8163("ext4: use non-movable memory for the ext4 superblock").

The issue is found when playing video files stored in NTFS on the
Android TV platform. During this process, the media parser reads the
video file, causing ntfs3 to allocate buffer cache from the CMA area.
Subsequently, the hardware decoder attempts to allocate memory from the
same CMA area. However, the page is still in use by ntfs3, resulting in
a migrate failure in alloc_contig_range().

The pinned page and allocating stacktrace reported by page owner shows
below:

page:ffffffff00b68880 refcount:3 mapcount:0 mapping:ffffff80046aa828
        index:0xc0040 pfn:0x20fa4
    aops:def_blk_aops ino:0
    flags: 0x2020(active|private)
    page dumped because: migration failure
    page last allocated via order 0, migratetype Movable,
        gfp_mask 0x108c48
        (GFP_NOFS|__GFP_NOFAIL|__GFP_HARDWALL|__GFP_MOVABLE),
    page_owner tracks the page as allocated
     prep_new_page
     get_page_from_freelist
     __alloc_pages_nodemask
     pagecache_get_page
     __getblk_gfp
     __bread_gfp
     ntfs_read_run_nb
     ntfs_read_bh
     mi_read
     ntfs_iget5
     dir_search_u
     ntfs_lookup
     __lookup_slow
     lookup_slow
     walk_component
     path_lookupat

Signed-off-by: Ism Hong <ism.hong@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 9812765000439..ffc8dfbb310ff 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -1014,7 +1014,7 @@ static inline u64 bytes_to_block(const struct super_block *sb, u64 size)
 static inline struct buffer_head *ntfs_bread(struct super_block *sb,
 					     sector_t block)
 {
-	struct buffer_head *bh = sb_bread(sb, block);
+	struct buffer_head *bh = sb_bread_unmovable(sb, block);
 
 	if (bh)
 		return bh;
-- 
2.43.0



