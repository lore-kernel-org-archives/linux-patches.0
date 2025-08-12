Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43612FDC59;
	Tue, 12 Aug 2025 18:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025078; cv=none; b=gu9f9TAWIvg/nTaOtPB9v8ZMGUpzadc2PjLFoDTeWK5/JjVc1nKTiGA1xK3vT1BfGNxXgZz+/BoJdDXNXB8F6G5Nak19hGN7Ew0///arNriGBEsIpnLtbIiXepTfrn5i9YplufzQNDsAhRDOxuQ73LjAn/LCy9R8fqU5blhFvFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025078; c=relaxed/simple;
	bh=sy6QiIrG1P7haNGGLyiPK19LyH9FYgzQ39SmXEx2ItY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erl4CGZGm+ogSrS7JCVoTRzIEO0mICEmJf7QQKosp7aqClnJYqShqS/tbiOGY+MXcOvekshtFMLZdr22sDK2pZKjcpytYTvwYN29BN6yRd1BOsa6SqCsquWZmYl8FbgAAAzcv4hnZi1cHvUWmiUKgXxlWuH7l2mHFWw1oS/uaGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABeqDaNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABeqDaNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D0AC4CEF0;
	Tue, 12 Aug 2025 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025078;
	bh=sy6QiIrG1P7haNGGLyiPK19LyH9FYgzQ39SmXEx2ItY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABeqDaNKHPatTikhoYnFR1opREjcLBCodgwjzpKoVrE8VkK7WKJvbHnNLCyv1+0Q+
	 FtFJ8JmidRAM68CqxQHyHui+t5/XT0cSTESdTVNTV7JeNas5XA1EnV4VAMn4BKkjlg
	 62Omen8LM8ZLKjfi9YZRCGzG78xlLxWITzPVymh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Christoph Paasch <cpaasch@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 530/627] net/mlx5: Correctly set gso_segs when LRO is used
Date: Tue, 12 Aug 2025 19:33:45 +0200
Message-ID: <20250812173452.066902754@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 7462514c7f3d..da3e340c99b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1567,6 +1567,7 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 		unsigned int hdrlen = mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt - hdrlen, lro_num_seg);
+		skb_shinfo(skb)->gso_segs = lro_num_seg;
 		/* Subtract one since we already counted this as one
 		 * "regular" packet in mlx5e_complete_rx_cqe()
 		 */
-- 
2.39.5



