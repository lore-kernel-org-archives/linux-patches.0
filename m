Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2428313A26F;
	Tue, 27 Feb 2024 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042765; cv=none; b=fcu86uSlGEMmGQJyT54EesVmrdbvdD1Q0sdB2N9MxfF0iiuZkXAvWpvvMxEWam8VjznJBcHBcRIt8AXf7ejIFKL6Cy/O5zZXcyrhKLan9ROXSv1KftNEsTk6OHeecIUWeqdusoN2ug8pIYKvezCMoyB9RD6SDwrp1lu4BbOr3Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042765; c=relaxed/simple;
	bh=mgDt8jCkKkaFZVH2MEjokqy4xq8v63WmBB0T46Yp5Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm2zdVCg8vnm4oHJdzB5ad2mG9Kjc08Vb0G6T2xJqD5IFZTwrp6SFYByiF38U1IeYlLiwrpXOJDP8ONfVpDyVU6JFv3am+9tzTWGY4xNim1DKh/Y/IakFqErysu87DhKjWw6FmvKgvyzLEdkngAAot3A7+qHHpEHzckhsYlnnr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHx2XyAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHx2XyAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75ADC433C7;
	Tue, 27 Feb 2024 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042765;
	bh=mgDt8jCkKkaFZVH2MEjokqy4xq8v63WmBB0T46Yp5Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHx2XyAt+8RnDUaFAGAkKCbr3KQlzSPr4RBvc0ICFDFMRVYmhmliCEXEldLqs9WUo
	 gr3vuphRlhmQu2RyJPqPOFB5BAFTvn8GkxJ6eVcD5t0BMxDpZB9+DWANwipAuVOUdZ
	 4dxu9TkQX6qzECAt2CB1d8TYZ1w77y1W6lEBZS9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/245] Input: iqs269a - increase interrupt handler return delay
Date: Tue, 27 Feb 2024 14:25:00 +0100
Message-ID: <20240227131618.860252178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit e023cc4abde3c01b895660b0e5a8488deb36b8c1 ]

The time the device takes to deassert its RDY output following an
I2C stop condition scales with the core clock frequency.

To prevent level-triggered interrupts from being reasserted after
the interrupt handler returns, increase the time before returning
to account for the worst-case delay (~140 us) plus margin.

Fixes: 04e49867fad1 ("Input: add support for Azoteq IQS269A")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/Y7Rs484ypy4dab5G@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs269a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index 2124d08c55b79..1530efd301c24 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -151,7 +151,7 @@
 #define IQS269_PWR_MODE_POLL_SLEEP_US		IQS269_ATI_POLL_SLEEP_US
 #define IQS269_PWR_MODE_POLL_TIMEOUT_US		IQS269_ATI_POLL_TIMEOUT_US
 
-#define iqs269_irq_wait()			usleep_range(100, 150)
+#define iqs269_irq_wait()			usleep_range(200, 250)
 
 enum iqs269_local_cap_size {
 	IQS269_LOCAL_CAP_SIZE_0,
-- 
2.43.0



