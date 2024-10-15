Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3742F1C07FF;
	Tue, 15 Oct 2024 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997889; cv=none; b=b0/eslH1tI+wFFpaIln1UNr+i0VzBL0JzqgN0qmstMwRsbi80M2oPj7JZEgLDDsK7uYqtZ68GwSAJencENRu39FH256qZyU1sX1ZX4xIu+z/iDeG+tEGUAwhzLMOvwhd06HlP+zSkZSd99wOywwq7qXrmVFIjhrkGljkfdywTA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997889; c=relaxed/simple;
	bh=8bZ4W20o7qqiR+iXDWS6NIAWhQ5OEirbsjaSbliqTOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGHOKBamoF+WsfR98Oaq7LZ39LW+yCAougW8MN7fQZ42tPoRIGQiKhUZor2PQRysBavs7NJYUlN0SzHklN0FAEAagQR98VjuPdS7KZvFvrqJjKV5l+gtNK3d/qCko08ROkMNjVY2e7+el6KNmSe8Imd+eTN3OZ2Mony/Tbj60no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7w3WY6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7w3WY6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE1AC4CEC6;
	Tue, 15 Oct 2024 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997889;
	bh=8bZ4W20o7qqiR+iXDWS6NIAWhQ5OEirbsjaSbliqTOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7w3WY6ZFRlWIAgB1dzcrCu03TjVs82DTw5SfXfF/Ey8rNXJ6daC16oJ5N/RT+aaz
	 ECkQZ/Q3g6cgIheQQUmlYPEXqYbFik1Ri2HJaB+2Aak7TrY/Gu7WrKdp03faKoXe52
	 6+1j5g84gwFu1/n8ZBWWOUVn9ZfSn0kXzfTyLbjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Peens <louis.peens@corigine.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/518] nfp: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue, 15 Oct 2024 14:43:42 +0200
Message-ID: <20241015123929.255758974@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5ab230aab2cd8..4a4d171e4f5b1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2631,8 +2631,8 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 
 	snprintf(r_vec->name, sizeof(r_vec->name),
 		 "%s-rxtx-%d", nfp_net_name(nn), idx);
-	err = request_irq(r_vec->irq_vector, r_vec->handler, 0, r_vec->name,
-			  r_vec);
+	err = request_irq(r_vec->irq_vector, r_vec->handler, IRQF_NO_AUTOEN,
+			  r_vec->name, r_vec);
 	if (err) {
 		if (nn->dp.netdev)
 			netif_napi_del(&r_vec->napi);
@@ -2642,7 +2642,6 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		nn_err(nn, "Error requesting IRQ %d\n", r_vec->irq_vector);
 		return err;
 	}
-	disable_irq(r_vec->irq_vector);
 
 	irq_set_affinity_hint(r_vec->irq_vector, &r_vec->affinity_mask);
 
-- 
2.43.0



