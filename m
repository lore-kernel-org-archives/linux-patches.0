Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF34E2FE587;
	Tue, 12 Aug 2025 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021728; cv=none; b=FcEdUj4TabdF495bVSuEmT46k0vs2fllBJ7eEG+CQjouoXl75GYS4g5274z73/NOK0lFxMD4vCDnI5dMbezfu4di38n1N0Eogwts7FkLQnMXR4I1COgFlLPLyyVYDNCj/R8+5VYoUueCtwpvcaIpS7c0l4dwDgF3wESH9veDfzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021728; c=relaxed/simple;
	bh=TRZ/k1mIHmo0HIvyAvh/H1EVwaqv5WReMng5VkqJMA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThoN1GX8fFVbPczhF6KICpfTM7D9D6WoMxZRgVgEh5f/5Zz2zbKnZ25nutlZEPMcJrjwdNc5FfTh8fwVIzeT8bqBzQ44H7VO5TQIZRZ925iNo2o2YWntS8YFGv30mVmSLGL48OeUep5B2+vI4WZjeDGAgtCSAs8w7YVfrqLhqxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06UeZ1I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06UeZ1I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFCCC4CEF0;
	Tue, 12 Aug 2025 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021727;
	bh=TRZ/k1mIHmo0HIvyAvh/H1EVwaqv5WReMng5VkqJMA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06UeZ1I6m+1eUWtAQtbashnjpOxgr6G2ph8ccxUD6dUyjgDAXsIvEiA7z27WgwQo6
	 lxENKzOE7nDnFpiZiA6FUaAsaW14WjAviZ1nO6VweVjvq4cHDnex4GefF2u0eKSXtH
	 eh1bvh5O8BXG62flTanAG8FE/FjwBl54jS8DpW98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Christoph Paasch <cpaasch@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/262] net/mlx5: Correctly set gso_segs when LRO is used
Date: Tue, 12 Aug 2025 19:29:56 +0200
Message-ID: <20250812173002.003865037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Christoph Paasch <cpaasch@openai.com>

[ Upstream commit 77bf1c55b2acc7fa3734b14f4561e3d75aea1a90 ]

When gso_segs is left at 0, a number of assumptions will end up being
incorrect throughout the stack.

For example, in the GRO-path, we set NAPI_GRO_CB()->count to gso_segs.
So, if a non-LRO'ed packet followed by an LRO'ed packet is being
processed in GRO, the first one will have NAPI_GRO_CB()->count set to 1 and
the next one to 0 (in dev_gro_receive()).
Since commit 531d0d32de3e
("net/mlx5: Correctly set gso_size when LRO is used")
these packets will get merged (as their gso_size now matches).
So, we end up in gro_complete() with NAPI_GRO_CB()->count == 1 and thus
don't call inet_gro_complete(). Meaning, checksum-validation in
tcp_checksum_complete() will fail with a "hw csum failure".

Even before the above mentioned commit, incorrect gso_segs means that other
things like TCP's accounting of incoming packets (tp->segs_in,
data_segs_in, rcv_ooopack) will be incorrect. Which means that if one
does bytes_received/data_segs_in, the result will be bigger than the
MTU.

Fix this by initializing gso_segs correctly when LRO is used.

Fixes: e586b3b0baee ("net/mlx5: Ethernet Datapath files")
Reported-by: Gal Pressman <gal@nvidia.com>
Closes: https://lore.kernel.org/netdev/6583783f-f0fb-4fb1-a415-feec8155bc69@nvidia.com/
Signed-off-by: Christoph Paasch <cpaasch@openai.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250729-mlx5_gso_segs-v1-1-b48c480c1c12@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d5731f7be04f..8278395ee20a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1573,6 +1573,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 		unsigned int hdrlen = mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt - hdrlen, lro_num_seg);
+		skb_shinfo(skb)->gso_segs = lro_num_seg;
 		/* Subtract one since we already counted this as one
 		 * "regular" packet in mlx5e_complete_rx_cqe()
 		 */
-- 
2.39.5



