Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829705;
	b=2fg0NXo8WRLVUVnDaBEK9hAXtDIUPYC8SMtXkwxyMvGTTj9dTVZqjY6mIdnXGZjYR346
	 WnO5TFj5+ca8nRIEaADBhaS8/ie4zathyZzy9Rp5VAaM9CzM2nJZgJRDxszSGTMCmg6VA
	 RX9w9uTM/S6Rvq5uhas4KewciXx51R/L1ojtsHoaPEGWFATKGaZSzRs5yPDkIOL29h8dy
	 bMoNfcrgexxBnaaoqJFx6legtdz6baCORdnPSklQBMTKN7jhET/BjvMmtfkRZ6Im5UDwe
	 iCUUIhsVjbZnkaARCLXCF1xeitM3WcfsbmXgApOAc7BtaFbn8CmDfrq3SRR48b9CWnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9CyUKegCiQdsdxu/BA31qdLPo73w2RspGf4dKVPs1ow=;
	b=UJboG5fb2QIt/do8XiETqh+MFwHexGbJ8QHIZWy3B4yK3WTSdolzjqxJ20MdW6zrHpLm
	 LcR8aF8/UoZZDpJ/dOwKzpz5pLtm/LHZQk2shHKZJfWpUPbcRp056hZvFQTe7roXsUDyU
	 5ajmbNhgJXMdU8sCf7EJAk1v5j5KpYJVxUVHJ++41GgsSSPlW0qfic5JfKCSKMY93Npiy
	 0WBeOsfQ4WOVrigMArH3L7kUo3ZgSeuu8Hd9azcAcgcHw/u4Y+Op4wavacU81CO9DGLho
	 engKXz6blS1fE9Bja3sJ2cQPCqnf/t+Bv3P7A6YozBNSttqQ78bDC423YGQrR7X9TxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QhwLAy0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCF7606BA3C;
	Wed,  4 Nov 2026 22:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QhwLAy0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A549C1F00A18;
	Wed,  4 Nov 2026 22:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829704;
	bh=9CyUKegCiQdsdxu/BA31qdLPo73w2RspGf4dKVPs1ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhwLAy0rKnLNvFboS/hXnP8DNJhqZSQNNDyQ+gHA6rwUZVXG51iGbonUn5OdCM1zG
	 8E0wKyZ77tq/Fz2aS5NU0tb/8BMUCAux//Sr1J/Qr1NZ67tuFldU1M5cT5w56GKffV
	 YG/Ee75TopaEVgPhJPKy1uyiO21ODtKYKUnVq3x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0290/1005] md/raid5: complete discard bios while reshape is active
Date: Wed,  4 Nov 2026 16:00:23 -0500
Message-ID: <20261104211052.033336350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Genjian Zhang <zhanggenjian@kylinos.cn>

[ Upstream commit 85764f475f3b3abd956bf8eaeaa643b367676cf4 ]

make_discard_request() returns without completing the bio when reshape
is in progress. Discard callers block in submit_bio_wait()
waiting for a completion that never arrives.  The caller hangs in
uninterruptible sleep, and this does not resolve when reshape finishes.

Complete the bio with BLK_STS_AGAIN so userspace can retry after reshape,
consistent with the existing policy of not processing discard during
reshape.

Tested on a loop-backed RAID5 array during mdadm --grow: without this
patch, blkdiscard hangs in bio_await() and remains in uninterruptible
sleep after md reports "reshape done"; with this patch it returns
-EAGAIN instead.

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260711161326.962336-1-zhanggenjian@126.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2817cd7d197e9..b7da2b83e1938 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5707,8 +5707,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	int stripe_sectors;
 
 	if (mddev->reshape_position != MaxSector)
-		/* Skip discard while reshape is happening */
-		return;
+		goto complete_again;
 
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
@@ -5786,6 +5785,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 
 	bio_endio(bi);
+	return;
+
+complete_again:
+	/* Skip discard while reshape is happening */
+	bio_endio_status(bi, BLK_STS_AGAIN);
 }
 
 static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
-- 
2.53.0



