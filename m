Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EFB157053;
	Mon, 29 Jan 2024 17:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548149; cv=none; b=ZmmuT6FCLWDXQSJ3RW2+M3DfRgzC0soSmUeQIIxA5sgRybQqU+qQpdGU+z/im7mBfXOAsJFJG/HUB2rrReRza0OLUK0reh4eY7NexJ6/zAM5W3PyGrt95okLnDeI3M4SKioh8VJD/S6UM0UkhrxNPKdVBB2DJf22dg0YcHgoVjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548149; c=relaxed/simple;
	bh=QfVqtU5NIc2OIztSd7C52azHsXemTaUSo931SANF7EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iohctt1RNACQ4Tw79FjdyTcGtEED7/D3Cv/LXNmVICBgL5TP48zQmQguE6Iq1YM1lK9Yo6I5FNf0Zpjt6sPOlpLVfdB/ysn+s7G9JYRAa3KKKuB//6H83jRytzDSr23YTJxWgu78oiebyv5fYGqaiJTjbAkG996D/a0QNDxkZ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7J+p/ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7J+p/ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAB0C433F1;
	Mon, 29 Jan 2024 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548149;
	bh=QfVqtU5NIc2OIztSd7C52azHsXemTaUSo931SANF7EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7J+p/MEzjwNLck8srMFMgDAFQDvsRhrWaIun+KTuBuofJBvkrSwp1u8HaKQEtraT
	 j7OEQwc+LJdQq0b/1+92QqWJUDxJLeEn61jur6naUmpuxFK8a4LaOFP9WS1oKsi0lN
	 s76oWIUataqCbV/mQ0asbIIB4iMm7+CKAWb4XC2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 186/346] net/mlx5e: Fix operation precedence bug in port timestamping napi_poll context
Date: Mon, 29 Jan 2024 09:03:37 -0800
Message-ID: <20240129170021.866921782@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 3876638b2c7ebb2c9d181de1191db0de8cac143a ]

Indirection (*) is of lower precedence than postfix increment (++). Logic
in napi_poll context would cause an out-of-bound read by first increment
the pointer address by byte address space and then dereference the value.
Rather, the intended logic was to dereference first and then increment the
underlying value.

Fixes: 92214be5979c ("net/mlx5e: Update doorbell for port timestamping CQ before the software counter")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index af3928eddafd..803035d4e597 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -213,7 +213,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	mlx5e_ptpsq_mark_ts_cqes_undelivered(ptpsq, hwtstamp);
 out:
 	napi_consume_skb(skb, budget);
-	md_buff[*md_buff_sz++] = metadata_id;
+	md_buff[(*md_buff_sz)++] = metadata_id;
 	if (unlikely(mlx5e_ptp_metadata_map_unhealthy(&ptpsq->metadata_map)) &&
 	    !test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 		queue_work(ptpsq->txqsq.priv->wq, &ptpsq->report_unhealthy_work);
-- 
2.43.0



