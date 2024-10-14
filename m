Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770FE1BF804;
	Mon, 14 Oct 2024 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918894; cv=none; b=XTQVpG7IyZpHDcBBIdFRWqdkxvX/IsDIys63vdCXS2HquGNg65xjdIUa8WC2l9/x/9X8R3mW79vCqRaVuxeJhS0UXNUH8MuqmPviElko0EvCcgU34sRO9y7GM/PfEcgiNm7olScYvHjmpuD+kxIuWmDEWa0rtf2TgCaFbydh6hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918894; c=relaxed/simple;
	bh=HsYsYHt2o2vvF8oBS8nAAigY+XFth6/KC4k26JY8/mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1cNr2mZhcO5DvcOqTghr1p66u6js9Wv4s/4GQhzPhBFYZeOraawlRQL3tCucmvnegmwxWq2QY6KyJuy6V6rRBujEXXfvaaXPOfghT8VDWii5bOP78VL2TL3v9V0a6Pc5zQ11SAlLuSxwjKYgQVduIp9fqHB/WORA5Nyfx1IodU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5oVXu3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5oVXu3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA861C4CEC3;
	Mon, 14 Oct 2024 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918894;
	bh=HsYsYHt2o2vvF8oBS8nAAigY+XFth6/KC4k26JY8/mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5oVXu3MIZplLEzmYHLOJgJtdxV6M4AaN3vXY43ud7KT/E02UwVdica7elkaOGffU
	 RX+4C95wlu9Q9Y8de4ojrHv2+LQvVZbveH3oGIaHHDfRjICIBiiqlG5EIaV7+q5Gvy
	 SL9G0kxF+40E8W21rC1MXdK1Rkw9ijok6+UwQm74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Peens <louis.peens@corigine.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/798] nfp: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Mon, 14 Oct 2024 16:16:47 +0200
Message-ID: <20241014141235.769479209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 27f4786ace4fb..4fbf2d6129ffb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -818,14 +818,13 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 
 	snprintf(r_vec->name, sizeof(r_vec->name),
 		 "%s-rxtx-%d", nfp_net_name(nn), idx);
-	err = request_irq(r_vec->irq_vector, r_vec->handler, 0, r_vec->name,
-			  r_vec);
+	err = request_irq(r_vec->irq_vector, r_vec->handler, IRQF_NO_AUTOEN,
+			  r_vec->name, r_vec);
 	if (err) {
 		nfp_net_napi_del(&nn->dp, r_vec);
 		nn_err(nn, "Error requesting IRQ %d\n", r_vec->irq_vector);
 		return err;
 	}
-	disable_irq(r_vec->irq_vector);
 
 	irq_set_affinity_hint(r_vec->irq_vector, &r_vec->affinity_mask);
 
-- 
2.43.0



