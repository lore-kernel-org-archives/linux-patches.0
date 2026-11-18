Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048457;
	b=HlmYzQoKBnGqytKlho1tBEZE9y9ic4Cd51LXQX5PB8wxse/tfdboknuSsnRl0qQwwbQR
	 PympG9HvcdqQyRWg3CWteGi54mpB1h/GOxxHUQzA590Onk5f1lCuzXYgCWV+6srzniTC6
	 6Zptui5GTfcLj8jCjaMYPzB+0tmnwkrYBWkj+syqW7v3GR22JJJ6ByH4SxZuazYC1bgt7
	 GoRdUDPgJuJKyE2YbGSF/nNs5vae6xyXVv6gXg6drIz/s5fJvuC398ufeR4JYjYZxPLS6
	 N16iKCluTvvPkw84MXesQI5TFyPKkltnIbSVmsh8owv58X6En32pavCuKI/sOpOyQYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SiC05LDzZ8NmHxpoxtka+gpqIC5EqFuWvEH8yOuwNEY=;
	b=CZWhaa8RCEqlPHF7+ieLeQsUN4R+YZQNvosk8TMIFBhYXVoppGsYs3TLembVPIY6l/Ss
	 nuaHKoaoPDOVnULHAVUnUvpNllqNSm5m2mOlY6E+gKVl6c3KFUjXu/35OxULV/Qk0cKu3
	 UPfvjAJX6S59KRubFgQwPUtn6cnqMf52up0abSxIH6Qfd5K5SKu0LGhyFm/DfNax2YPGv
	 FNJwGjal/KGdo/QJixsNP8upzuRvevhpfGATIRCLwI+AUUs5q/oRxlHDlD/iAcWR+eX+o
	 rWwNiMiAdzahQqA7XSYjVRjFDTKk4TnKT63XQR900t6t4Gf3Sxhr8v7qo9c6BPcYHZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Stm8Jw8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6360606A331;
	Thu, 19 Nov 2026 00:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Stm8Jw8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461961F000C4;
	Thu, 19 Nov 2026 00:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048456;
	bh=SiC05LDzZ8NmHxpoxtka+gpqIC5EqFuWvEH8yOuwNEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Stm8Jw8iU7LSjUvMQRkS5miZDKvDWSBUF90b/kffKLtJV6CjKdC2X1Ik3qH8lvGPm
	 rVt6A49KAVsTEesKFnevrS0GLXAKJQiG/nyD3Bfj8zKAacRPaoPKk8ms3VFHcP5Gew
	 qWGN2pmI3dXjezDdwh1NtN4CG6DEtGHqnmARQThU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2002/2857] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:50:36 +0100
Message-ID: <20261118150313.444456506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 5fb3051aa4611ae18e304814fb1b74a30065fd85 ]

If ip_dev_find() fails on the loopback path the code jumps to
free_dst without releasing the neighbour reference taken by
dst_neigh_lookup_skb(), leaking one neigh reference.

Release the neighbour before jumping to free_dst.

Fixes: ef42520240aa ("RDMA/cxgb4: add null-ptr-check after ip_dev_find()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183530.2092534-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8d753e6e0c719..07cf0026cf1e3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4156,6 +4156,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		if (!pdev) {
 			pr_err("%s - failed to find device!\n", __func__);
+			neigh_release(neigh);
 			goto free_dst;
 		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
-- 
2.53.0



