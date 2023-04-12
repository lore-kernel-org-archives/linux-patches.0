Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18732F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D2BC433D2;
	Wed, 12 Apr 2023 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289535;
	bh=e/Z5qEZh4IBJlMR5dxNup47f/gPo4jn7Mlhh01Ywrl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPkMGsP/RZYLHx2or8I/YZl0evlsvxNVKiZ3e+xYS5aycUWo+0K3vZCsYk4QzH4K8
	 ZDkjmHG4PETMNvDEYqQg1yVmjt5rzTt6SxyAIt3QUkJtwzZsMZpyqIbbQe/T2st8Y1
	 RJz8UjxTT4tOBiYMIKktOlj+9FvNK3vyP411Jx8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH 6.2 137/173] block: ublk: make sure that block size is set correctly
Date: Wed, 12 Apr 2023 10:34:23 +0200
Message-Id: <20230412082843.657965265@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 1d1665279a845d16c93687389e364386e3fe0f38 ]

block size is one very key setting for block layer, and bad block size
could panic kernel easily.

Make sure that block size is set correctly.

Meantime if ublk_validate_params() fails, clear ub->params so that disk
is prevented from being added.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reported-and-tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 22a790d512842..341f490fdbb02 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -233,7 +233,7 @@ static int ublk_validate_params(const struct ublk_device *ub)
 	if (ub->params.types & UBLK_PARAM_TYPE_BASIC) {
 		const struct ublk_param_basic *p = &ub->params.basic;
 
-		if (p->logical_bs_shift > PAGE_SHIFT)
+		if (p->logical_bs_shift > PAGE_SHIFT || p->logical_bs_shift < 9)
 			return -EINVAL;
 
 		if (p->logical_bs_shift > p->physical_bs_shift)
@@ -1886,6 +1886,8 @@ static int ublk_ctrl_set_params(struct io_uring_cmd *cmd)
 		/* clear all we don't support yet */
 		ub->params.types &= UBLK_PARAM_TYPE_ALL;
 		ret = ublk_validate_params(ub);
+		if (ret)
+			ub->params.types = 0;
 	}
 	mutex_unlock(&ub->mutex);
 	ublk_put_device(ub);
-- 
2.39.2



