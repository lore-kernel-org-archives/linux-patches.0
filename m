Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029884;
	b=CSlrvTFmzNlsgsv5vnq9ewFhJh991H1tsI8NE0ZYli/j6x3SeFjxqg+GdYkDDK4QQQyo
	 6SLqq0+s2cZRG9AUTzFx1jIg2a37dcd1yEXuDQxvqOkmnoCZnVGJ+Sol0gkflqplOF8Mt
	 oRHZ1iSdmmydYtATJRDSY3Ur9wqy0/+iWEMKWuDKRv7ZEMC4aO+CQIABmShsxVcOlDfSc
	 YIHsHGocxDYt9s/0eeyhFWbG4jOh9Lzq3XT32Dn+MO4Oh09dC29G2s9rM22G7QTCUtZkr
	 JhFm1qrLNX+QFci3KkY26cp1u8eM0/P6jQHxChxyYNEPfhnHFYfDh4BpoRD1IHyJmyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xzEloIYAPUX1akio9blu17Y4WTOe86JFRWLXdZ9V5Vc=;
	b=pW540vbrhgA4RSFkyCQ06LV+oeGAe5jpKy4z2jH525dboL+Rx2GmnrG8uxaadZJFPxd6
	 gt5bZwv9bqfxTI3a+zp1WhwKUTozQYHzejlLmmc5ndQ+j7bq4euJ3ua5uO7iiPqvHDeGj
	 C7bNBgFCoE8w7hYKR00a7DL9oqGUiXrnbHxwE+86scEB9vdfteOhzbF+yeR5ei6SkWNT1
	 Oa0Kiv5k+JyyiLNPv/xy5sb2nWBhOjsv+qzPN6jIAQhXap2yqKAkQFHiBU44SlHheMAAu
	 4tv/Ya7vRm/yuLbwOy5PkyiL7fZM6RLQjrNRjqnw3KhH4nDHSjaHuYA7b3aOMzcIWpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riifrd7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC40760A2614;
	Wed, 18 Nov 2026 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riifrd7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EF31F000C5;
	Wed, 18 Nov 2026 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029883;
	bh=xzEloIYAPUX1akio9blu17Y4WTOe86JFRWLXdZ9V5Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riifrd7iG232Ea19v2QLTqSYxYJRzB3YzeKv1fQVkqPJjtFgV+oGrUSom82hN2RY7
	 sFM4KrCZbkSYDJ3xGMFRNlcS5GztT539brYbisYpmbiLQHILE/bLAYQcEtNdVU+cBn
	 q+TfoWwGBMvTbhQGCl+ruIXOJUQz2sgBWyx0CY1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0506/1756] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:43:53 +0100
Message-ID: <20261118150029.274718547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



