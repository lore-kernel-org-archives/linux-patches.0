Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC852E659;
	Tue,  8 Jul 2025 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992085; cv=none; b=OFhGKmeJpNpPaKTqn8EBOXkx6DqDw1vM2/VBHDy+IaCxOICECxVVDiA0voQCCfwqNSSuHcckYqjN7TpBVt+zv2LBHyw0ktqdsK+fE0iIG4td2T5zsX/aOyhFRcshTLJkc6jjfV2tGTtfEF+pXyvCrAzuLNh4GnJXxFCJtnhrCi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992085; c=relaxed/simple;
	bh=WloMT+3vwc0QVvMuNk/PtuBOUjGSXGiAQVUt1CJ4DUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRX9KgoYuQk3CgRKPfZfyzbpnczfHFztHE+7tRnM7ZUFvjR0GfSNGfWkqN/vgzG9tCj7GX0QZAj+oH1tQJOYRRQMRyEzojT4EHAVSqPnCi0ARy9hzwYNZrTVRgfUi9kJLc43hlSx87E8TsTRPfXQagLuXGFuLM8czXjKsxradMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDwiVN8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDwiVN8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFABC4CEED;
	Tue,  8 Jul 2025 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992084;
	bh=WloMT+3vwc0QVvMuNk/PtuBOUjGSXGiAQVUt1CJ4DUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDwiVN8rHxMU34v8PFyRkwKzxCpsS3sejrrJ3RPaii9LS3KnqpINwyc6w6nK+3O4q
	 EKoBA+32xOFfSRn0Y1c2Jp3XkMubQ1mRYQT8PIPlv9iHoFfl1Bgiu0R/2c8C2Tj/Sn
	 wf/gsPr3RHqaz5gPNgzKQ6yS109fgoiCLjcy3Res=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/81] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue,  8 Jul 2025 18:23:15 +0200
Message-ID: <20250708162225.667092900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9915504ad1e18..39f71312e57a2 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -308,7 +308,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
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



