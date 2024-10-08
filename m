Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40564183CB8;
	Tue,  8 Oct 2024 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391597; cv=none; b=S3LNUTyG/f9zr80B0osaZdE3zaXw/OqNOHXFk3Ddx2wR8/2k0sFKl7/8f5Bus28FXF8LTR1tvoTHlBboKpUtqLrRqKc8pbJQYf5USOAmtWwlufaXWypG+ZTfOz1gcNIeIX4gJ1qzRsIltE7+cBR2iLHewvY7F1IfsqLsgBJrhno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391597; c=relaxed/simple;
	bh=RnwKQLtHF0GCeIbHCvi5Bb7PdcxpzWloj8m0eReqDco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzBqxDrlK0QRDH0PEPmqHL4Bwnd9YGQ697sGYycYMU2VI2PxIpb4KhljpEMstaXhERzK38SiQO+bN6yRXViSWjlr7oQwt2qJnvlJ4VN7qwBJq+yiUhNpriNaw2gwVxLPkvMwVL8YiG5bnWcq+7LaY5WoW+8LEexwC4wC0Lnvx4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKuTcAW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKuTcAW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8471C4CEC7;
	Tue,  8 Oct 2024 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391597;
	bh=RnwKQLtHF0GCeIbHCvi5Bb7PdcxpzWloj8m0eReqDco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKuTcAW7y1CrNKXcw2sjzXtvRd14uUC12EF3/s/t+u8VbzY5+LOCEw9FCUKPsxFHp
	 ehRqui937piAQ+ij02gw9KXCco9+rJWTbtdYmY89MVC+aEx9CTEOpSIzxKz+ZmleFH
	 DlxO3fBJsWGilwk8H1l7Il8ssAAAnk7MEpskTrJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Peens <louis.peens@corigine.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 164/558] nfp: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  8 Oct 2024 14:03:14 +0200
Message-ID: <20241008115708.811638657@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 182ba0a8b095b..6e0929af0f725 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -821,14 +821,13 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 
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



