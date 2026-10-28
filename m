Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217277;
	b=dnM8ImMwrsgNzHzHcCTN/59jmdhIgYcS8RqWUpQTWOP0/YQXWR7veYFHchwzrbV2jPmI
	 SkKp8uhb3M0x9QeoaAaSfQdDqkN60KKfZbPAgHZz+ysYqfdz2EjaUXWz1zjzy6456tyGm
	 Uese5Y9UMrluszTkUk4N0l0QnK9csxQFWiPBNl3wfEbVwxi8OgleHWZN7+uWJVckmyBkR
	 DIHeHQd7QlZfs5/yuWMg3R8ezZkqJpR3JKHiYvlraYYaIboWJ83fYNR1iAgNdVKrkCaD+
	 agVHJ5mhVStMl0jaYUPFpFTCKXhfU+dKBAoddJJZsxggQKrsmBUQAl+03KQQrtyGZtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+3BWn8gUJbUXvaDAlgDeMs3+2xdreEobR+3OQeIppRg=;
	b=HeYwmIRk/p+cUrgxBwg3WiQKEniYJBBFgbvkRQ6yZ0oxUr+SSERwpRR/Q551S9enbg0P
	 ut3cMyQ197TxbDPbWGFQk5jm9/eAymery8Gemi82MQ8MCTVvzde4e/r/vXwZ/P6bqno3u
	 ccna/Frg7HqLS1O4p5+qTxXMMxd722TCJA4sGXJJhNDtE9Jtrwp7TOytvB+MKjgTZNEsi
	 GTgTV4THMb/6sXWA/hpgotg/pSBKxrI79pcBlRRB8Edh1bDR41EspNist8IIF/b0XqlqE
	 MG4MNp0tiVU9KyfLMYBMnrcBnfxl8262tMMd+epuD67V+hgMCe53ShfbI0HsZxR/YSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYhNvvBr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ACD606A31A;
	Wed, 28 Oct 2026 19:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYhNvvBr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D121F01825;
	Wed, 28 Oct 2026 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217277;
	bh=+3BWn8gUJbUXvaDAlgDeMs3+2xdreEobR+3OQeIppRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYhNvvBrIlEeJ69x6qpj7qJpqRebqSG8Q/RLWIlmq+zboGm8TAv0NWt1oiPPZysE5
	 SOkhlkarLB4POHu3p7nCjyMK0aoQ5aeMP87Qrc/OUo5fJ8l5LoxyfJyxzTK3Apdoh6
	 q89gPXXWcQBhBPJ0lD3igFawjFmc6Izw/VBW9R78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1849/1887] RDMA/mlx5: Follow rb_key.ats when creating new mkeys
Date: Wed, 28 Oct 2026 18:05:45 +0100
Message-ID: <20261028170541.526597837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f637040c3339a2ed8c12d65ad03f9552386e2fe7 ]

When a cache ent already exists but doesn't have any mkeys in it the cache
will automatically create a new one based on the specification in the
ent->rb_key.

ent->ats was missed when creating the new key and so ma_translation_mode
was not being set even though the ent requires it.

Cc: stable@vger.kernel.org
Fixes: 73d09b2fe833 ("RDMA/mlx5: Introduce mlx5r_cache_rb_key")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/7c5613458ecb89fbe5606b7aa4c8d990bdea5b9a.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6d0ef4a5406ba..dacda8d63c5a6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -295,6 +295,7 @@ static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 	MLX5_SET(mkc, mkc, access_mode_1_0, ent->rb_key.access_mode & 0x3);
 	MLX5_SET(mkc, mkc, access_mode_4_2,
 		(ent->rb_key.access_mode >> 2) & 0x7);
+	MLX5_SET(mkc, mkc, ma_translation_mode, !!ent->rb_key.ats);
 
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_mkc_octo_size(ent->rb_key.access_mode,
-- 
2.53.0



