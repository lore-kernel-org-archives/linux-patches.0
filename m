Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450B52E7BB7;
	Tue, 15 Jul 2025 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587100; cv=none; b=YdMg4kAY9yOO5bYUeflpHYeLc1zIy33GemXNt6JK5/3/9hdVtoB+BM8/seP4xqJfbkQFvOmZyiLVZxV6rfURiEqmCv9BCUQk5WjaddNd2bmZ+1bSv+wNrf1mK6A/dLK9VNqHd4phxLp3eoapQbWFclSiBaJRz+JrcCbmIFNFLNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587100; c=relaxed/simple;
	bh=v+7uxXbHL+xp7cIlpBk8RKoGYgKWnenJCwCFgEXPau8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLHisZQXjZItY8RKVJfse8tRKvH2oe+JHyzEzf8trFIVkiYzIzx5iX76VyMfZYuTGta2fsiooguaKV3+TME7/4T14hf3+p+rhdFTE4BwFH5csj2pSnew3Gyya05SpLvfXd5QbKiYU4fOe7Mz84rJNiZYVsRcLkGFfLsxNY5Ki48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhedln2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhedln2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4E4C4CEF1;
	Tue, 15 Jul 2025 13:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587100;
	bh=v+7uxXbHL+xp7cIlpBk8RKoGYgKWnenJCwCFgEXPau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhedln2dYO7ChyA2QG9PMpahSNERwLrUlP6493a2r7w3UffyX4q1dZ63NLOjfphqD
	 uGcVt9S1i0iKE+o5I5En6YUMWYUIi8Vyoxzoh97mlrfrzeja9N+mya8ce09N1bDJP8
	 6RoJUZvI0M1MHTIRpTvKRopfI33YV7ojOO+AqLCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 167/192] ublk: sanity check add_dev input for underflow
Date: Tue, 15 Jul 2025 15:14:22 +0200
Message-ID: <20250715130821.614249613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronnie Sahlberg <rsahlberg@whamcloud.com>

[ Upstream commit 969127bf0783a4ac0c8a27e633a9e8ea1738583f ]

Add additional checks that queue depth and number of queues are
non-zero.

Signed-off-by: Ronnie Sahlberg <rsahlberg@whamcloud.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250626022046.235018-1-ronniesahlberg@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8a482853a75ed..0e017eae97fb1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2710,7 +2710,8 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
-	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues > UBLK_MAX_NR_QUEUES)
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || !info.queue_depth ||
+	    info.nr_hw_queues > UBLK_MAX_NR_QUEUES || !info.nr_hw_queues)
 		return -EINVAL;
 
 	if (capable(CAP_SYS_ADMIN))
-- 
2.39.5



