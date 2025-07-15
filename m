Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E282E1734;
	Tue, 15 Jul 2025 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585698; cv=none; b=qnL3O8irEq+bOBkLTYqJgGtXT9TV5tz/FHeGNqtUV4ytHCGsuv6nhfvBW/REiYU4UyO4e5jNU0FNUDb2/VntSKRweHd7oK174cguBSypWHeKERpnBeQYkbEriNGkpqe/JMEt3kCWu4zwtnshrLc6RukxXuAxiUH86qN7PFf2/gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585698; c=relaxed/simple;
	bh=t4JDGQ68DZHnWI8sFE+qmhaQqTSMk7avaCw++X2Ib/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxIqZmQpjZCmWctB+MVmvXSpJEHhpcTmjq95HFYq4pWwYQjsNEkNahpg7yHGiQ7R6AEcuUDqqoOheZF2f7WV8wS/3s4BDun17v1J9PVJiu6RqjvHDXOrKRQGWCjjAxCUym248i9wGUoJLEpdLEz2yJ9zaAvslaqurMOJJH6ZHHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPivBydS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPivBydS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0ABC4CEE3;
	Tue, 15 Jul 2025 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585698;
	bh=t4JDGQ68DZHnWI8sFE+qmhaQqTSMk7avaCw++X2Ib/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPivBydSxwbxhlkiBFgboCDMoGFJMDPrZGWhoxSMGB9bdaxofRjocp3g8zgv6ox8z
	 6tDC7O5sTjxcKFkMokx3dtljGWcl1dpTo4f9QYYU/DFiAMdy335sMHaNgkZder9Ea2
	 QsaZUSjuESs+4HfBHKtoqagrsqHgHq+rF/Tq7QVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <rsahlberg@whamcloud.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/163] ublk: sanity check add_dev input for underflow
Date: Tue, 15 Jul 2025 15:13:26 +0200
Message-ID: <20250715130814.373544901@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 746ef36e58df2..3b1a5cdd63116 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2457,7 +2457,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
-	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || info.nr_hw_queues > UBLK_MAX_NR_QUEUES)
+	if (info.queue_depth > UBLK_MAX_QUEUE_DEPTH || !info.queue_depth ||
+	    info.nr_hw_queues > UBLK_MAX_NR_QUEUES || !info.nr_hw_queues)
 		return -EINVAL;
 
 	if (capable(CAP_SYS_ADMIN))
-- 
2.39.5



