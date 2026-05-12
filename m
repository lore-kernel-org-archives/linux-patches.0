Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A374A3C0A1A;
	Tue, 12 May 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608126; cv=none; b=lx0JAPESRRXRsWh8M8calOdxFF5y6O36nGIVcnfUf5NN4iKqfB8Xe7YoB7rtRMjNk/vPvgw9pud0O5r3HE0BlWKFl4rfAqa4HzxGogJsPvNCLHt29hZxkTsshx/vh/CEr+sCGD6ZUx+3VrJdRp7CHsG+9f2Odm2SwvriQvFLfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608126; c=relaxed/simple;
	bh=OTJgc0e0KQkPFuRmlGKfWda6Hlyql/jg4z7qHui1nTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWv5FbD9m1tC9ZJoSNIt7sUBcBul/pPhf9TfT76mY1GWgFx1+FZYtPv0qDuXXDiWXbIJv6ZQucZF8XzP32tjVYQ4QIOkRylyMlZ+N6lxfK9Q8jBqvWRhf7rMr1Dpgw1fsvbD8hbgiCtfZssGTNenXdxkgLD62LZWumc81+PhM2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1X04rFYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1X04rFYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ED7C2BCB0;
	Tue, 12 May 2026 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608126;
	bh=OTJgc0e0KQkPFuRmlGKfWda6Hlyql/jg4z7qHui1nTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1X04rFYq9dSzUUmD5S0/xq2qvSjUF1zjYCplByF4g9Rbiuu0u2LBy+KcnNAg647Vx
	 fE4uuz0Alypbq1GYkAKURRmKDnVI4ypaRcAo8aRD/JX9NtehqgEPNxaK9PeRzjyiPF
	 J4xVT7HQUXiablq/NG5rxfOGZFp9l/Zb9qEXGZL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 166/206] f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()
Date: Tue, 12 May 2026 19:40:18 +0200
Message-ID: <20260512173936.378584901@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -1509,7 +1509,8 @@ static bool f2fs_map_blocks_cached(struc
 		f2fs_wait_on_block_writeback_range(inode,
 					map->m_pblk, map->m_len);
 
-	if (f2fs_allow_multi_device_dio(sbi, flag)) {
+	map->m_multidev_dio = f2fs_allow_multi_device_dio(sbi, flag);
+	if (map->m_multidev_dio) {
 		int bidx = f2fs_target_device_index(sbi, map->m_pblk);
 		struct f2fs_dev_info *dev = &sbi->devs[bidx];
 


