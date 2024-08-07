Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2006F2F7;
	Wed,  7 Aug 2024 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042954; cv=none; b=ggur2j59SzZpF/pxSd4zfKgSVzTB40eeysxWs4ZZrBs8bzgT7FO9z+iM/vhyGpE7KxN9pWq/H6f6kh5E3nbmDPFAGRmN0Ldt68YmcRB5CTMnKy+uDhFDAmfxFy1yaMoxYGCrzshyIjJtujR+gygK6SJrwgdhj/tEmipn2xmcmeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042954; c=relaxed/simple;
	bh=lJzdWj7ZrB4/hDIUFv2Zo2w8/ezu7BzauUTZjAIrlK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqdQbe0UZ5wBcmTHcdu5HIAQ10De2vEcxXU1tLaMCsLjELLXLhZTKel8Z1kiAr/LQeem8j/odvwllieuuTkv424aAmZlq5X+E/Emt6xyADRzpyVDwN3FoSft1dE2y9Gsl+2GPet5BpxAx2ENlG7t9HnmXnVwbY9ryNRcvjXtwGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdA/I4lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdA/I4lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAF1C32781;
	Wed,  7 Aug 2024 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042954;
	bh=lJzdWj7ZrB4/hDIUFv2Zo2w8/ezu7BzauUTZjAIrlK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdA/I4lhKl86YiKm4gdJ/Jr7h7e5rYD6LPs1tlJAtE8BVEdGqj3K6TW4o2v1bnne1
	 42TvNriElS/wewVB/kQizLw+KmrLd/ZMKrmUdL3fECoLiW5kl265PH+O/Tqq36JuOy
	 LMkwCICt5QAB+ASiFfLO7ZpcsvwiGUNNBVNBVw6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/123] f2fs: fix to avoid use SSR allocate when do defragment
Date: Wed,  7 Aug 2024 16:58:47 +0200
Message-ID: <20240807150021.085535568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 21327a042dd94bc73181d7300e688699cb1f467e ]

SSR allocate mode will be used when doing file defragment
if ATGC is working at the same time, that is because
set_page_private_gcing may make CURSEG_ALL_DATA_ATGC segment
type got in f2fs_allocate_data_block when defragment page
is writeback, which may cause file fragmentation is worse.

A file with 2 fragmentations is changed as following after defragment:

----------------file info-------------------
sensorsdata :
--------------------------------------------
dev       [254:48]
ino       [0x    3029 : 12329]
mode      [0x    81b0 : 33200]
nlink     [0x       1 : 1]
uid       [0x    27e6 : 10214]
gid       [0x    27e6 : 10214]
size      [0x  242000 : 2367488]
blksize   [0x    1000 : 4096]
blocks    [0x    1210 : 4624]
--------------------------------------------

file_pos   start_blk     end_blk        blks
       0    11361121    11361207          87
  356352    11361215    11361216           2
  364544    11361218    11361218           1
  368640    11361220    11361221           2
  376832    11361224    11361225           2
  385024    11361227    11361238          12
  434176    11361240    11361252          13
  487424    11361254    11361254           1
  491520    11361271    11361279           9
  528384     3681794     3681795           2
  536576     3681797     3681797           1
  540672     3681799     3681799           1
  544768     3681803     3681803           1
  548864     3681805     3681805           1
  552960     3681807     3681807           1
  557056     3681809     3681809           1

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 8cb1f4080dd9 ("f2fs: assign CURSEG_ALL_DATA_ATGC if blkaddr is valid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 259e235becc59..92331f8dbe4e3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3483,7 +3483,8 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 		if (page_private_gcing(fio->page)) {
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type == FS_DATA_IO) &&
-				(fio->sbi->gc_mode != GC_URGENT_HIGH))
+				(fio->sbi->gc_mode != GC_URGENT_HIGH) &&
+				!is_inode_flag_set(inode, FI_OPU_WRITE))
 				return CURSEG_ALL_DATA_ATGC;
 			else
 				return CURSEG_COLD_DATA;
-- 
2.43.0



