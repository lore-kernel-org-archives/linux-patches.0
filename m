Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C262E36E8;
	Tue, 22 Jul 2025 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192990; cv=none; b=nsPg87Dw0ptReSvuV5yS07sgrAyvlLfSU+QRX21N4YyQguN7K4YAoKZBa/8kAy1rq7xYJVEpHuHSuTmSZfbwh1zI7LmQ4n7jfjyVmGUDIt1w6SxN8ZF+VuFtKoeLJXnPd4oVeVcpraWE4Pg+bwN+hLoJmMXdSCipC15BgZce2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192990; c=relaxed/simple;
	bh=36IAOEwbkAiMe+MY3bN7le6V08GlGgABma6UUQcoq5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9KsmgAwUqCa8ObnSvcuPTtI3wb11EEFWtqxR9Ud499nU/g3hafAbET2mGTtLjhULEjel+2Htph/ih1Y8ACvp98ZwdIJRmSrlQvoLI2/Wq6d2Msd8avH5qFvJS7gWrjKEU1rE8A+DwgLXERSmCIB0ixIPYinLGCgxp4/x6gzjSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IghIuTln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IghIuTln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7141C4CEEB;
	Tue, 22 Jul 2025 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192990;
	bh=36IAOEwbkAiMe+MY3bN7le6V08GlGgABma6UUQcoq5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IghIuTlnMyvAaLSJ5eszlGz8Kr9FTglBUUQK4FDdB7zU4wCsViKcA9AEgFHqtc6VI
	 jitqLyS56jDrvRzTgVAEuuH0zAnMYBjREk3dQZxw81ekghEfWL2vx1KWrdI8+c5VR2
	 JHnS0RFzIgZp+2eZzesp+DnuioyCNe4yHk/cAi/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@openai.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/158] net/mlx5: Correctly set gso_size when LRO is used
Date: Tue, 22 Jul 2025 15:45:03 +0200
Message-ID: <20250722134345.184095166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

[ Upstream commit 531d0d32de3e1b6b77a87bd37de0c2c6e17b496a ]

gso_size is expected by the networking stack to be the size of the
payload (thus, not including ethernet/IP/TCP-headers). However, cqe_bcnt
is the full sized frame (including the headers). Dividing cqe_bcnt by
lro_num_seg will then give incorrect results.

For example, running a bpftrace higher up in the TCP-stack
(tcp_event_data_recv), we commonly have gso_size set to 1450 or 1451 even
though in reality the payload was only 1448 bytes.

This can have unintended consequences:
- In tcp_measure_rcv_mss() len will be for example 1450, but. rcv_mss
will be 1448 (because tp->advmss is 1448). Thus, we will always
recompute scaling_ratio each time an LRO-packet is received.
- In tcp_gro_receive(), it will interfere with the decision whether or
not to flush and thus potentially result in less gro'ed packets.

So, we need to discount the protocol headers from cqe_bcnt so we can
actually divide the payload by lro_num_seg to get the real gso_size.

v2:
 - Use "(unsigned char *)tcp + tcp->doff * 4 - skb->data)" to compute header-len
   (Tariq Toukan <tariqt@nvidia.com>)
 - Improve commit-message (Gal Pressman <gal@nvidia.com>)

Fixes: e586b3b0baee ("net/mlx5: Ethernet Datapath files")
Signed-off-by: Christoph Paasch <cpaasch@openai.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20250715-cpaasch-pf-925-investigate-incorrect-gso_size-on-cx-7-nic-v2-1-e06c3475f3ac@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8e24ba96c779a..8ed47e7a7515b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1156,8 +1156,9 @@ static void mlx5e_lro_update_tcp_hdr(struct mlx5_cqe64 *cqe, struct tcphdr *tcp)
 	}
 }
 
-static void mlx5e_lro_update_hdr(struct sk_buff *skb, struct mlx5_cqe64 *cqe,
-				 u32 cqe_bcnt)
+static unsigned int mlx5e_lro_update_hdr(struct sk_buff *skb,
+					 struct mlx5_cqe64 *cqe,
+					 u32 cqe_bcnt)
 {
 	struct ethhdr	*eth = (struct ethhdr *)(skb->data);
 	struct tcphdr	*tcp;
@@ -1207,6 +1208,8 @@ static void mlx5e_lro_update_hdr(struct sk_buff *skb, struct mlx5_cqe64 *cqe,
 		tcp->check = tcp_v6_check(payload_len, &ipv6->saddr,
 					  &ipv6->daddr, check);
 	}
+
+	return (unsigned int)((unsigned char *)tcp + tcp->doff * 4 - skb->data);
 }
 
 static void *mlx5e_shampo_get_packet_hd(struct mlx5e_rq *rq, u16 header_index)
@@ -1563,8 +1566,9 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 		mlx5e_macsec_offload_handle_rx_skb(netdev, skb, cqe);
 
 	if (lro_num_seg > 1) {
-		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
-		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt, lro_num_seg);
+		unsigned int hdrlen = mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
+
+		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt - hdrlen, lro_num_seg);
 		/* Subtract one since we already counted this as one
 		 * "regular" packet in mlx5e_complete_rx_cqe()
 		 */
-- 
2.39.5



