Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7491D0799;
	Wed,  2 Oct 2024 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876331; cv=none; b=g8qbnvturgtWuqkHyyvm5Ikt5q2wwOdHGYH2vee2MsOGMC7tSZlf9YY6QudZpsFta+Qa7vXOLNqYKWskTKjEKEOUa+gubjP3WSDUcMTUOHzS8MOkFPIgvWrd95k57SQ4zm8w3cNet5XQCGn84Rq28laaq+l6rlig+Zni5v5NmnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876331; c=relaxed/simple;
	bh=xeyIzIsIqcvdtfqLz5BNDWh4ca8RjEMGn3t/12FTwuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB9UC3aX1p9UpLj95b6q09yIG8BMw1+XVAG/NYyh0ESclgOZopWeeOqqurzL1lLDtbQz1cj0qK4mfj6VX8TkDVCzvA2nsBJ25bM7MlpF/5ZMIpcQ6x/7ALyLBna+izMhnp71+ARUY8F0YkoJoDE7FN0crEVdzjHq/NEjS4yl/1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g39w95E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g39w95E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627CDC4CEC5;
	Wed,  2 Oct 2024 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876330;
	bh=xeyIzIsIqcvdtfqLz5BNDWh4ca8RjEMGn3t/12FTwuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g39w95E3gmSF3dx6Q0b/PK6OBDnHq1Bi/iFdmiUlZbsc2XqDyIOnmOLFCoRR7jJa1
	 VqzaJ9oVRZtRSdEEN4rS0JFiE/jfV24SmbcoEFfzp1OM6Zfu7QNtXHqiQJqnFidQAB
	 oNmuaxvwNEMt+IeWwVdpdtyQ4ma/fPbv+xuP3DZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 407/695] RDMA/mlx5: Drop redundant work canceling from clean_keys()
Date: Wed,  2 Oct 2024 14:56:45 +0200
Message-ID: <20241002125838.700091447@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 30e6bd8d3b5639f8f4261e5e6c0917ce264b8dc2 ]

The canceling of dealyed work in clean_keys() is a leftover from years
back and was added to prevent races in the cleanup process of MR cache.
The cleanup process was rewritten a few years ago and the canceling of
delayed work and flushing of workqueue was added before the call to
clean_keys().

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/943d21f5a9dba7b98a3e1d531e3561ffe9745d71.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 7ebb00cea49d ("RDMA/mlx5: Fix MR cache temp entries cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ffe1b95ca6853..19f5e5957e180 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -779,7 +779,6 @@ static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
 {
 	u32 mkey;
 
-	cancel_delayed_work(&ent->dwork);
 	spin_lock_irq(&ent->mkeys_queue.lock);
 	while (ent->mkeys_queue.ci) {
 		mkey = pop_mkey_locked(ent);
-- 
2.43.0



