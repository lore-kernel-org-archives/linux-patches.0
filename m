Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CEA2E5B06;
	Tue, 15 Jul 2025 13:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586009; cv=none; b=MYzu36HuDwPC7PJYGAhkvrE9SnVtmj6CxSnw9HgrPiq+0mCvtJeZRJS5dWe7IIgRynPCExPAd5k09eH6c2B5EuKM2MmX2Wee22ktdrIbw5javCjTVrByf4Ld3xUnRPJt6bLf08j0DkzsgrYrh+Db315Yj5y4DqWw1YEXVcVSVC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586009; c=relaxed/simple;
	bh=jh/orqlR8jBFKHkMvVQe7AK/oDwNFTAd8mReIagmPUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUaum1Kwz4K7fs0VfvTE9Ls8aU9UJ88U1KxMN7UY1pMAb4WLsqDPu/EHv4aM1P4+uXpx3GJnUTqUaunW8ftgsdFWKDSkN4T+3afdj2SwxkZ9wNmzuPevlMxPQmeK+4CGN/Mk0bqt0yJw3kAEfQhiDyg0Gbk3oaTC8nNX6XcXGuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VujME70P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VujME70P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465FFC4CEE3;
	Tue, 15 Jul 2025 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586009;
	bh=jh/orqlR8jBFKHkMvVQe7AK/oDwNFTAd8mReIagmPUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VujME70PThl22gyyeuSQ2qFTOhwxK8cCNvUWpqG8yvMT0LGUBzdcCZN2TERufMD8C
	 R6tRlDlaQUpaFabWsIgBFcihUewHhebyIr/KDP/mzA9qgwNJc6LJpWEFOwbeE5lXtG
	 bi020jUs1FuPY44XnkrlHpeFz3/ymWhBMcv6W2Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/109] ublk: sanity check add_dev input for underflow
Date: Tue, 15 Jul 2025 15:13:47 +0200
Message-ID: <20250715130802.527910129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df3e5aab4b5ac..8c873a8e39cd9 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2323,7 +2323,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
-	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues > UBLK_MAX_NR_QUEUES)
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || !info.queue_depth ||
+	    info.nr_hw_queues > UBLK_MAX_NR_QUEUES || !info.nr_hw_queues)
 		return -EINVAL;
 
 	if (capable(CAP_SYS_ADMIN))
-- 
2.39.5



