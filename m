Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A26A15B305;
	Mon, 29 Jan 2024 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548555; cv=none; b=PHSOPdCh3LxCXQdAWT3iPC9+DA9qX3Gdad5X9/KIc/URKBtK9BNaT87hn2OHlqhwGLp5qa/Ee6SdgG8+98xAbgkEPVCM0VW2Dl+DePf78HLLdjmeMjyCh1s+bb0AlQPgWmpONM7W3jfqy0lyXVrr2m5U7sekGkMWJoqZu0jSi1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548555; c=relaxed/simple;
	bh=CILSxdoAov4LB+Tu4wmgAcD0E9hu3Vv9KfZjNbFmuTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtjsPXIKJpUDxqcPyz01nW80DMj2Oxh9Lbg6z8yPGruRQcXAmqjHF9aKyxpNq7RD9ZGTX9WyxfMsk7C/c1q+or5z6jHhgdNP0xlbOGDQ+b2ZOfioNoqJbACHCkK6yLyvwbgNF8S2xmuzUq4OXY+UEttKMEAgqwNgpa93tdmEIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwVB3vql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwVB3vql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7052C433C7;
	Mon, 29 Jan 2024 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548554;
	bh=CILSxdoAov4LB+Tu4wmgAcD0E9hu3Vv9KfZjNbFmuTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwVB3vqlcZhfzYLP2+7ZpCRKjI6GnCV7lzr3+3dIVadiKZ7Ym3zj8q/Tf2HhiR7+x
	 1ffYE/g4vEoRMvIKkqdxrX6jBo5nK9u2OjAqoXuuiNmT0CvJm0nFRU5f/lbbAq8yE2
	 moCJaq42ehDcN37KF7zoSKQLTD5/fR5ywSItHp9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/331] net/mlx5e: Fix operation precedence bug in port timestamping napi_poll context
Date: Mon, 29 Jan 2024 09:04:16 -0800
Message-ID: <20240129170020.505309821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



