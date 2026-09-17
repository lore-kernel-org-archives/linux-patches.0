Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38835C680;
	Thu, 17 Sep 2026 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659994; cv=none; b=T2/IACh27n9jODKLtH/stY76p//QAAUB4ME7S2Mz7HRCac/MOO1m4QH/NKR3JSTvW5fvkTJpfs8Bal0DYouTaOInfE5ycM0COu9U6HsL5ofriNxSwbHWjOGI2CiwmmYgF0orCJsVYC9UU1eT5miHZhR5m2Gk0WckgEKV3TZ3JEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659994; c=relaxed/simple;
	bh=NlA339dEud3B0H8A+Yi8aRkuXE++a1WVzxD4KfpNI8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY4D6KBfj1LOTMCWzdGW41SbF4F9KdSvbXOT7h0w56alF2KT+oPZZGcFKBTh3iGD+7+wJoOoWosWLf+83SUpsqaFNGt/QKyHjfNTb8itKF1Kq7rluBg7V6frW6+g6u9eC/+NKdhtloKV3/2YGI4KYb5dgwDCuyuwEBBhwjuuXjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr5npsgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr5npsgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4831F00899;
	Thu, 17 Sep 2026 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659988;
	bh=EsTjoXnmYHWOnpkl0UB0lP1ndmHNA1qyBblR/6XnnY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qr5npsgygSbvE4fjoQCto4yWTb0zLo6bVfEzoYAYCyMcH8GzpyVAPEzeUgSgEXUfs
	 Ajl/TIGj80koD5ddUdTttLs2U+u8OVlj/VYoe7HJgUxY6JM+8V3QluETGDCzeZss5S
	 v7LXmY3MB6Itr6PmuqV6y1d1nE1XEs0O2g3bgAWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 440/733] ublk: clear force_abort in ublk_queue_reset_io_flags()
Date: Thu, 17 Sep 2026 16:12:28 +0100
Message-ID: <20260917151402.832865580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 8a14be55bdc6d5a25cd7b0ac5d4d884fcc727b49 ]

Quiesce sets ubq->force_abort for batch I/O. Recovery never clears
it, so batch fetch keeps failing with -ENODEV and the device stays
QUIESCED.

Fixes: a4d883755399 ("ublk: add UBLK_U_IO_FETCH_IO_CMDS for batch I/O processing")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260821103047.369522-2-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index b71283588ea77..d879e8492d59c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3040,6 +3040,7 @@ static void ublk_queue_reset_io_flags(struct ublk_queue *ubq)
 	ubq->canceling = false;
 	spin_unlock(&ubq->cancel_lock);
 	ubq->fail_io = false;
+	ubq->force_abort = false;
 }
 
 /* device can only be started after all IOs are ready */
-- 
2.53.0



