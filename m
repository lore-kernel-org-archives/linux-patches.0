Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0A2FDC55;
	Tue, 12 Aug 2025 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022916; cv=none; b=LQcLHz0D5r7jBQ4E7Sfap7DTj4L1kRiTswVmMxpxJ/LXPZTmhKyfmkqUAmY0D3vKYvK/watlOY2E35YGC5SwlT4oKL48cusAD260HumnLXnSU/Rj6jMvvzmEyPNudyAHt5AzgDNxT1L3Lib6gQuAOpbIE3YFS/Y4Ix318Ak2HUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022916; c=relaxed/simple;
	bh=cYdCNHoZkth8cT1ZDXrj5LssL7COAob4GL1U8HfO3kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+L6CAwqVT443mI7aet/k7i8sGXicAvWCajAN896kCUeplf7MLcITdDiEFWXmKhCClun4u3UaV0VAj5Xs1aaRWgt2iPtk2cpdG05CyA/AhWI7F3Pek5E/9A1BiLIakOuao89CGax9oySxSkt01ePeZXRyj2hrSIE5yQZDQC1N0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqpRd7UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqpRd7UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF0DC4CEF6;
	Tue, 12 Aug 2025 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022916;
	bh=cYdCNHoZkth8cT1ZDXrj5LssL7COAob4GL1U8HfO3kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqpRd7UNpto3ZYElVjdNeWry3fKQjo4NWFTJPzJ27FBtrNHPyE6ZworXCqabG1dMg
	 EP82NblL19+Lv98qxnaP72GTE7Degcqdr/uVsq8uw4F5M+9mMgp6dLpGQq50peSeJu
	 Ev9MBp0yzaTDq6v0d8KAT8VnqujmcFIzDcNt23cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Christoph Paasch <cpaasch@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/369] net/mlx5: Correctly set gso_segs when LRO is used
Date: Tue, 12 Aug 2025 19:29:55 +0200
Message-ID: <20250812173027.938240319@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 8ed47e7a7515..673043d9ed11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1569,6 +1569,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 		unsigned int hdrlen = mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt - hdrlen, lro_num_seg);
+		skb_shinfo(skb)->gso_segs = lro_num_seg;
 		/* Subtract one since we already counted this as one
 		 * "regular" packet in mlx5e_complete_rx_cqe()
 		 */
-- 
2.39.5



