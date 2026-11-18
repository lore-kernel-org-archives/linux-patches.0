Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028150;
	b=zuhyDCCyqK2GX54SyEuBlq3M1KL2d7QMlCLdNpmmcdJkzB91kOzuzJpaGQ0CubMfI4ax
	 bjm3ftLhB7QhTNboxqrx93XQRnG1dTVJQPhaURym8Y8+QR/QFL3wKs47cJd+7zsNt+0vu
	 oq5IYCgSWJYaZtromTf5SKHmJLBQ8pBN3mPnVwKUbXXkXS9IGooSK6aq5tUgriqztf5IU
	 l1UCFkzufeTaGMuQiuOLHl5o5vNUpK+SPQEHXCcCATNZLeKK5lflwCiGWmEhAgGJ18nNs
	 51BIYg237AlsfvNo9qiMkY6S7Pm4NiO2LZzjL4Ql3nhr2A5EVh3WntCIdXUyZy5c0vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6UFWD74jldaNt/5Ss8i+/STu8nY/gnwTDcgkYDmRchQ=;
	b=RCiueEvqb3N04rnhx5a3JIO/rts2Ey51FU1VxXXzHvFeKL2oY6uBBGuEvRBMhzfyYVdo
	 YTiGRndPNLPYmjEsOL9YRrFmMeTNMm13GepVFs1t8/L0mPjbGZX6q3rp/39HUyf83CgV6
	 2EveJnol8Qgm+bgKQOT+e3q3mY3e2NNE1/OwD9WqoC4k7DeScXg7/jypRAT3fzZs7WZ/O
	 QNiZ+PE4FSPNAFnaEMPMGzSDcXF6HFS3ejOirINsi5quASF34tM389Ci0Zku5R1vsLVZS
	 waW9zKZU2VJAhJ7+vCe1PpLDO27uNi2tTxN7+M4WcJTM/g7UD5xZ3GIGFZSdJZPoTTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISd7QDmg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB47606A31C;
	Wed, 18 Nov 2026 18:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISd7QDmg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0011C1F000C4;
	Wed, 18 Nov 2026 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028150;
	bh=6UFWD74jldaNt/5Ss8i+/STu8nY/gnwTDcgkYDmRchQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISd7QDmgLvuiI5zqfmkwmycjVda2Q8kbzVjoVrUKgytwuPYLEiybWOLtW4gbu0zFU
	 YvsbxPR1tuHkYuy67WpYZM4+VSQkLPXPxzIxasBJ0MNRJENuvlkcv4XJBNTDOC6dBL
	 weRwrSaUeoER+XFMhWZgswhmmbvtUCR79dwffJWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2041/2151] blk-iolatency: flush enable_work after going offline
Date: Wed, 18 Nov 2026 16:02:56 +0100
Message-ID: <20261118150236.077247701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 020f61242d6ebeba5f8f2ef6e429aeffdd63f1c1 ]

blkcg_iolatency_exit() flushes enable_work before it deactivates the
policy, but iolatency_pd_offline() schedules it again for the last group
with a target, so the blk_iolatency is freed with the work queued. Flush
it after the deactivation.

Fixes: 8a177a36da6c ("blk-iolatency: Fix inflight count imbalances and IO hangs on offline")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-24-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 17e530b93c48c..741c804c217bf 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -637,8 +637,9 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 
 	timer_shutdown_sync(&blkiolat->timer);
-	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iolatency);
+	/* iolatency_pd_offline() schedules it for the last group with a target */
+	flush_work(&blkiolat->enable_work);
 	kfree(blkiolat);
 }
 
-- 
2.53.0



