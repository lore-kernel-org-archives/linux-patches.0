Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B6F383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302055; cv=none; b=VxiFBtFZIvqPtfOyvHupr6cqihuQR7bBELD+hi569bzUUhojKFd9YNjEubLAtwACOYvm5zDHqiZEz712JIeCXD4glt6lqtiKVKYRmfbfsdG9tk95mVLoEg1oAZLJgCCxaCSFt7bdJmSt+YmhMjt1NOTWabHroNg/vL3jgh9wn64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302055; c=relaxed/simple;
	bh=NypDcUL9HWIwOCdHMwd+i1rIJwJcKefRwq3MljzuQms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG6Rdfsn2HYybhQ1iKvtB0GNZic3MxhTmgev1ygKBk5/CeHj7duPyz3mRHD0m5csm3xA0h5fe+kNzQwm6PNoM/LRIdJpUtx1KCQyflM1INhgc00L1NY92zBKTwcNLk7cH7zthYSdWPjRYuSstp6v4uzI9AjAnOMTfitfP0lOymo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXgg2mFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXgg2mFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603E5C116D0;
	Sat, 28 Feb 2026 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302055;
	bh=NypDcUL9HWIwOCdHMwd+i1rIJwJcKefRwq3MljzuQms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXgg2mFPdulpqT92u6L6o1xxVHOKwFUKimrTTSAP21sNNweCV8XRY53WT++NgPLRf
	 hmVh3UT8FJnarYjf4Zz9SkU7sSNp1i5FB0gOfrYthDau3nUQNfGw31CUnopaYas91e
	 jEsPj62AXHIMg84jVyZM7Kn51DukKpnxr+ST7eOn9/YuPVrK41eJuyhuavivYy3l2L
	 WvWKTbc35zDysufE95wQOgAFICtkid6A9yiW5hqXM/tc9HG7U6T9YZTAzwQFXB9z81
	 sGnSiQWCWp2V2LPefQ20+fb6g7qmQuyufqxy68lUu/QZrC+75roHBlPZ6B3z6Pr9v4
	 sDVS6d2fBqlew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Govindarajulu Varadarajan <govind.varadar@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/283] ublk: Validate SQE128 flag before accessing the cmd
Date: Sat, 28 Feb 2026 13:02:52 -0500
Message-ID: <20260228180709.1583486-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Govindarajulu Varadarajan <govind.varadar@gmail.com>

[ Upstream commit da7e4b75e50c087d2031a92f6646eb90f7045a67 ]

ublk_ctrl_cmd_dump() accesses (header *)sqe->cmd before
IO_URING_F_SQE128 flag check. This could cause out of boundary memory
access.

Move the SQE128 flag check earlier in ublk_ctrl_uring_cmd() to return
-EINVAL immediately if the flag is not set.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 44f630a3f610b..89c1d6ec7adaa 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2908,10 +2908,10 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	ublk_ctrl_cmd_dump(cmd);
-
 	if (!(issue_flags & IO_URING_F_SQE128))
-		goto out;
+		return -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
 
 	ret = ublk_check_cmd_op(cmd_op);
 	if (ret)
-- 
2.51.0

