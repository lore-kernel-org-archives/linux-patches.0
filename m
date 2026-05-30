Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D29932B11D;
	Sat, 30 May 2026 17:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160692; cv=none; b=TmjTLReWjn9iq/DGGwg8DW0Qu/vALXUbhmgdSfQ7lr0LpB5wFqBPQCghsfft9h5yW33njW1xfbtlkJRRs2rkoUBV/+0PruExebEAV7GJvB0x6NFdzBX+eWO3Apcb+AWCuWpRz5uSvxhMMl+K0vpRNNTd4JYu8otZR4kPceMmJ0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160692; c=relaxed/simple;
	bh=Hvg3B9nu1qNIjgYDpn/g78U7IMkW9fhIrw6Gf5rdCqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgmfBsByee0qdWbwI+cYjg08ipo1BQH8PfV+4yELpCskJiiUu0c1o5PbLEGZQUOk1aKlsm+rVYx+mwW9ncfho+45vIwV4Rfmz8IdFWujeUniNzixs9Zm3c/jSE069Igf+z5iSgFChNJS4Fcqv80v27VehrAzXBFm/qwM9QNwPiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/tnHqpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/tnHqpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DB51F00893;
	Sat, 30 May 2026 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160691;
	bh=Qp8WZ4XUeri2DzNXQgV+LWHPmnige5Vh+cSCPk8tr30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/tnHqpV0orIARECpPEa+lO8VWtcG9liXztZqZTnpi6cjPhf5orlo0GxWqfZ4+y/E
	 KBXS1A+qOeBwRFgNX73I5/ZqVZQgcWITdgOO1OK/6enRRNu7YaYF7ubqc78Tn0hGSS
	 BtZ8cdWEaRAK/utOc/4rPUL1/wIHQ8k/MolWEUK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 377/969] f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()
Date: Sat, 30 May 2026 17:58:21 +0200
Message-ID: <20260530160310.714367343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1487,7 +1487,8 @@ static bool f2fs_map_blocks_cached(struc
 		f2fs_wait_on_block_writeback_range(inode,
 					map->m_pblk, map->m_len);
 
-	if (f2fs_allow_multi_device_dio(sbi, flag)) {
+	map->m_multidev_dio = f2fs_allow_multi_device_dio(sbi, flag);
+	if (map->m_multidev_dio) {
 		int bidx = f2fs_target_device_index(sbi, map->m_pblk);
 		struct f2fs_dev_info *dev = &sbi->devs[bidx];
 


