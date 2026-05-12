Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED33EDE47;
	Tue, 12 May 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608817; cv=none; b=CItUkzpDQmStY9YQjdrTTsy1sgHIh+hpZ4YP91dDCyuHHX0KEyAsj6iQH9JzJXyF/ktEleXnbK4A/1P+RcbaGjbVT7ta3nNMy+E/RJahNXpXC25Nv9R3UC0Sksff0CYMQR9ihAhqv6DAIrb9aHvUq3retVjoys1IseUbVnqqV3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608817; c=relaxed/simple;
	bh=o9/Vc7NlUQeTkGKJL1Qn+lUTCPIhc8Pwh/lvbokEUoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHNgqY+ykmi1eaMmmM3AthFzM/GJfRRKzUOA2fxDd6hcmuuyD8Wiig9iyStyiTGqzBEY4TdEwxudGEC6asB1GnXIVO8OHEKemwSJAs32YDQ61OIueBODu4L3Jf0pOvPXTjz4qKGIea+Gf6bIWsDcEJyDBseIgufAIPw/MkXPXSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnv97arz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnv97arz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D590C2BCB0;
	Tue, 12 May 2026 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608817;
	bh=o9/Vc7NlUQeTkGKJL1Qn+lUTCPIhc8Pwh/lvbokEUoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnv97arzzLDYH/s9GQ6qC1K1kMRHcWQ1Ybo/g/6BYgOY8vlu/JXeqIF9LitCZYQu1
	 rs5fr+0WDzczpsFszLuqHxpAZyU0GVubsAsmVNyRQ0VKjs0QYeYxnNNXOyMw0mVqUb
	 mOTli7CvYIxfnIklmKRfvy7zZkOuqzoKEsTf1RhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 227/270] f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()
Date: Tue, 12 May 2026 19:40:28 +0200
Message-ID: <20260512173943.224883161@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit eb2ca3ca983551a80e16a4a25df5a4ce59df8484 upstream.

When f2fs_map_blocks()->f2fs_map_blocks_cached() hits the read extent
cache, map->m_multidev_dio is not updated, which leads to incorrect
multidevice information being reported by trace_f2fs_map_blocks().

This patch updates map->m_multidev_dio in f2fs_map_blocks_cached() when
the read extent cache is hit.

Cc: stable@kernel.org
Fixes: 0094e98bd147 ("f2fs: factor a f2fs_map_blocks_cached helper")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1508,7 +1508,8 @@ static bool f2fs_map_blocks_cached(struc
 		f2fs_wait_on_block_writeback_range(inode,
 					map->m_pblk, map->m_len);
 
-	if (f2fs_allow_multi_device_dio(sbi, flag)) {
+	map->m_multidev_dio = f2fs_allow_multi_device_dio(sbi, flag);
+	if (map->m_multidev_dio) {
 		int bidx = f2fs_target_device_index(sbi, map->m_pblk);
 		struct f2fs_dev_info *dev = &sbi->devs[bidx];
 


