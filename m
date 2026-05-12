Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2169365A19;
	Tue, 12 May 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609636; cv=none; b=I5/GJAUlCh6OowigEh+P26dpUCOhEdhsWs8KuhZpM6gMCcZ9rYZyTcX8zE43sBm2ZeZSge5egIrRUzaiD6s1fdskIqdEX/77ZxLyi0Er3HVDcH7vuBo7+md2BM6sFyee/3kmzHyW9qC+JnPXff1+b3U3JPpPjJHbyEnpDYPHqsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609636; c=relaxed/simple;
	bh=ljmI4hy7PmrmgatJ3pa0AWO+W/9QFxrfNchbGf/HtWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qvx2p+VxoO5E+E4RjcDOM5sPuZeyXZlcpcV7hmr3GpeQhHj0h7Oe2Vt6IHvOZQDKPMjEs5+qtxYLmQOt5v5PWZG10shj5aehROmcMzX9yFDq0KurhklK1WAneM9lN+LMmN70azavwzU10E0cmsxw14Qq9aizQDOUM8kMaJjvQUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UEZMA1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UEZMA1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B41C2BCB0;
	Tue, 12 May 2026 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609635;
	bh=ljmI4hy7PmrmgatJ3pa0AWO+W/9QFxrfNchbGf/HtWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UEZMA1KRn4DC37c6ROfLjvkGi27VG3dqQdY3H5hu1QI1JKlUfzW/npEtZye2OEap
	 G9JYGue3/51HHa+zEkMyMadi1bids+UO/DBTXpoTjgpgF/6P0fH9seMCGuSGH6vRMf
	 u213d9l+E+4FMETFtcreVBdvrSmeNYPe1r7nNeWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 272/307] f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()
Date: Tue, 12 May 2026 19:41:07 +0200
Message-ID: <20260512173945.866464625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1576,7 +1576,8 @@ static bool f2fs_map_blocks_cached(struc
 		f2fs_wait_on_block_writeback_range(inode,
 					map->m_pblk, map->m_len);
 
-	if (f2fs_allow_multi_device_dio(sbi, flag)) {
+	map->m_multidev_dio = f2fs_allow_multi_device_dio(sbi, flag);
+	if (map->m_multidev_dio) {
 		int bidx = f2fs_target_device_index(sbi, map->m_pblk);
 		struct f2fs_dev_info *dev = &sbi->devs[bidx];
 


