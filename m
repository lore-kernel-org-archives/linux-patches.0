Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040391;
	b=TnqA2MpxRZPx4jGeHTpXDm4pZMkxk5Smv1yg6qjIlXw17qHnSexAsYhwUBfniZujj2H0
	 UhoXIwELwkc4fhTzxUhvu/tCaeq/BXJDyiX/ZKRY1KT4QU+0vQaySkI0AvFoDTysuZ2I6
	 jQMZ8P1ZluQvwoyABGBJu5xPYTiXbkv47IueLm+YPLtWJ2jcB0vnrhl4w8FxcGbRI3qZ3
	 /jNpkN6kXzQe/qfQsk3MveguS8lv6SQd9TdkL3JzbpszF1iJl6J9JlEJXl1r20sMYtRM7
	 PlDyhPY5d5rlA/e9avEEIQa1jGT+lVP+xPibSv9zdLFcUOoK8IdbjCiSWblT9+Fa/zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xwZxIHRsTsf8H90TS3gGph3svyHP89GKff3hFEM2h+w=;
	b=LVi0EkzL0voCS/uAccJsW7WVUijgSfuz53eEXvpRN8PEW5/tHNVT0Z8B/P5rCHqg9gsC
	 bqkESBK4d+io95U2PXKf3WZgoUPgHUgTdHNOaBKR763iyZ35QNzdic7s5Pj/Mqx/BbtPS
	 1Vsc40h1KpFsouJ8twGaeSa7GtWIQeFGY+v1nBz4P/+fWtwvBL+NXAw42+l7P0V9oPlh4
	 WcXjyaA0Ujly5/UqV4AjE6nYkkTwpyryroxBIs07JaHnxjydP8+xijQG65FrJ6f9e36bE
	 IjFL1gQ7d5Y0IaI9xC/cUnkWDjWEnVZSclfm9aY6YXphJeI5lTcWQttEQfHq9dF/pdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4nKUxzp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B79606A31C;
	Wed, 18 Nov 2026 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4nKUxzp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9DD1F000C4;
	Wed, 18 Nov 2026 22:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040391;
	bh=xwZxIHRsTsf8H90TS3gGph3svyHP89GKff3hFEM2h+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4nKUxzp93GWLYm01wylLyTIr9umBSYG2Sxl+viZ64PDkja//AIc9TbxvJq5Ameof
	 iYVXc8PPBo9F+0gdl1T/wmng108CHe/N8MRHJRgKJJDvWxj06aEGRIZTxCqHplDC6u
	 HCIpN9n/TA+nAdVVsn3QjcCPs6mXS6WOnzRSO6y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2439/3318] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150434.620936522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9728effe43d8fc4d58e12b697d0d6127355abdd5 ]

In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
so set_pi_umr_wr can read it during this call. The pointer is never
restored, so after the function returns mr->pi_mr dangles at a freed stack
frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
remapping reads the stale pointer and dereferences it.

Save the original pi_mr (captured at function entry) and restore it on
the out path.

Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260919100848.2442-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/wr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 9947feb7fb8a0..1748c633213ed 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -925,6 +925,7 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.53.0



