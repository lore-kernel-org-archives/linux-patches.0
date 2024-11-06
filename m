Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C611E1A25;
	Wed,  6 Nov 2024 13:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898367; cv=none; b=ax+JRfXi3SmPAbmdQ6xVcy1Um6/cHxxwOg+ozNbphDmAZ0a9EaQlCSkmU/Dti+/Sao/vjQ49DnpN4vh2klIQFCRavizEhPl401sKO/1fQ7rtTJBbVfj9BCET73IvkiZC6tY4arpCe6niCZisDxPhynSEZ94OG0mAXqUjMrYzisI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898367; c=relaxed/simple;
	bh=P8s0QR5OWZYb1oDW9pJhLyAVS5QV1DzwMjzji0Q4eg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mA5VADkgUGHDMWoNi/M8g/nkP+CiqocBxGAAqHY4oi69gKz//DE08ISkG8zUKj9mh+n8bNqL7dwG3B4zJjv+ldFKbHWTCpIfdo5L46FmTphHT8nulrdEyCOqwZNSYell5ujRW1tgSQMZu4FvxcthQzh85aqOYQL15mvy2tCdGUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKLbNcrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKLbNcrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE10C4CECD;
	Wed,  6 Nov 2024 13:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898367;
	bh=P8s0QR5OWZYb1oDW9pJhLyAVS5QV1DzwMjzji0Q4eg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKLbNcrBPVQc48zK9rt+IpPeJ+5+zvox2+xVH+ZkRYQ7rJiIqI/C9rZTAJkq5kjQ5
	 TXEgf01jDKRsbjdbG7tuyPBS45PuUhW/9hUi9liu5nyqbBF+lxpT/SroPEucj2zXWS
	 eaIVsELNs2r6huXH87GHsS3MLz2adJ2VZJrJ0vJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Peens <louis.peens@corigine.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/462] nfp: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Wed,  6 Nov 2024 13:01:47 +0100
Message-ID: <20241106120336.807055165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit daaba19d357f0900b303a530ced96c78086267ea ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240911094445.1922476-4-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 61aabffc8888d..7cbce8f51f069 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2626,8 +2626,8 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 
 	snprintf(r_vec->name, sizeof(r_vec->name),
 		 "%s-rxtx-%d", nfp_net_name(nn), idx);
-	err = request_irq(r_vec->irq_vector, r_vec->handler, 0, r_vec->name,
-			  r_vec);
+	err = request_irq(r_vec->irq_vector, r_vec->handler, IRQF_NO_AUTOEN,
+			  r_vec->name, r_vec);
 	if (err) {
 		if (nn->dp.netdev)
 			netif_napi_del(&r_vec->napi);
@@ -2637,7 +2637,6 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		nn_err(nn, "Error requesting IRQ %d\n", r_vec->irq_vector);
 		return err;
 	}
-	disable_irq(r_vec->irq_vector);
 
 	irq_set_affinity_hint(r_vec->irq_vector, &r_vec->affinity_mask);
 
-- 
2.43.0



