Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB382EBBB2;
	Tue, 15 Jul 2025 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587642; cv=none; b=AYfzwpyYtDeYlXWO5TWR5EjiaHq2y4YITgM7OWOm2nnxlQvLLQfkGlDLnJag7i6hmfHy+5bJXZSNQm6GfoHsAa8qIfB80/k0lh7qWo4i9ckA3liISob5tIhV+YlB9R/Cq8lbTz3RRFOwgwJnxc0SF05U0G4+QEzTuFLutHHuE6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587642; c=relaxed/simple;
	bh=pP2i/GAj0zxr4l5HysPMqbrDQLhMTvU0cVmBnK1Dmb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATMPQxcPB8BUFTDgfg8fD4raOhHjulctoz695EIazWZXkqyPPKtYxhj2NctEgfPtgCRDfMwiiRSooDGuWEh2T5It4ZMLne1+RjT2WYQJi7WrAVc0bQtxVumWENWnfKezBid4yHNmeTyzEzOb8Ev7eQ+W4fyEqZXZAWxJOeCWB6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYZ9U/DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYZ9U/DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A071AC4CEE3;
	Tue, 15 Jul 2025 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587642;
	bh=pP2i/GAj0zxr4l5HysPMqbrDQLhMTvU0cVmBnK1Dmb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYZ9U/DN1uz3jHBSCTCpeKubeTTzrM2CDbt2ADxfc0QtiWsJBHDYTrpJaEsur/K2e
	 hdQII45DMqMcBRBqSA1mam5XiK0jLkTlb8je99jM06xKbfigZzgWFUpOkkPZn3EeLu
	 H4AQkGz9HAbP8oaAaSGIQ66lbpEwy3INQpZbK9bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/208] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue, 15 Jul 2025 15:13:17 +0200
Message-ID: <20250715130814.466088892@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit acd245b1e33fc4b9d0f2e3372021d632f7ee0652 ]

In case, CC counters are querying for the second port use the correct
core device for the query instead of always using the master core device.

Fixes: aac4492ef23a ("IB/mlx5: Update counter implementation for dual port RoCE")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9cace74dcf106116118bebfa9146d40d4166c6b0.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index f6bae1f7545b5..33636268d43d9 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -279,7 +279,7 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 			 */
 			goto done;
 		}
-		ret = mlx5_lag_query_cong_counters(dev->mdev,
+		ret = mlx5_lag_query_cong_counters(mdev,
 						   stats->value +
 						   cnts->num_q_counters,
 						   cnts->num_cong_counters,
-- 
2.39.5



