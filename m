Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE843D75C7;
	Wed, 20 May 2026 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298590; cv=none; b=Goi/cDyfIXgwZHbl+2/vVQwdlgDYk5Q+kkMqbiSSbYeo6CSnyrhd1UtPVOCFY6Tan+VXXFm1IrOJDoZjAL8B/eI9HtcIeMPxtqz+sjEjCim4q5Kz0WhwOWPqcLsijVAnj9/AgVqoe+U0k28dWnU/Mxs1ZXpFuOy7KBgvZeJA7Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298590; c=relaxed/simple;
	bh=pK/VjP0qrmOV1HQBvSOMwYRdTH/a8X/3bJBpqr9shl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfVnya4i15ZdKQK22PAx29YNfdtvrOmqGdVZyR4pgMF1jK/353OYcCrhQCoGNMcAyJKp17QdLb4zhUWzW+pEjFZI3LadY+cuDHTFyWwDGLDO/wSjku41UbBRa9Dtl0T0iOGrfRcBP7nerpW44eBAHcWz4qESkt+ZZetDGuQB9kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ7BNikb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ7BNikb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEA41F000E9;
	Wed, 20 May 2026 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298588;
	bh=YfHrCT4zrFeR7ZEzMk87L2kmsomqhW/4JNa+UQZoNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZ7BNikbW3tYDF56YMqM83Q6pYi9bkxZicixqG9MP/R+1UNbEmaP7Lk99N20unrIs
	 N10ShHGDx0VogTV5i+F0+pLQEp47V3sC3nCYvxk3j34z+h8bl+/VrZxKW+KAz8GAUO
	 VzYEvKK6ly8fFxk4UPAmkWaXIOA8gnmPEQ4vm5/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/957] firmware: arm_ffa: Use the correct buffer size during RXTX_MAP
Date: Wed, 20 May 2026 18:15:24 +0200
Message-ID: <20260520162144.084581056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ene <sebastianene@google.com>

[ Upstream commit 83210251fd70d5f96bcdc8911e15f7411a6b2463 ]

Don't use the discovered buffer size from an FFA_FEATURES call directly
since we can run on a system that has the PAGE_SIZE larger than the
returned size which makes the alloc_pages_exact for the buffer to be
rounded up.

Fixes: 61824feae5c0 ("firmware: arm_ffa: Fetch the Rx/Tx buffer size using ffa_features()")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Link: https://patch.msgid.link/20260402113939.930221-1-sebastianene@google.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f6ceae987acbc..d71a2ef335d1c 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2074,7 +2074,7 @@ static int __init ffa_init(void)
 
 	ret = ffa_rxtx_map(virt_to_phys(drv_info->tx_buffer),
 			   virt_to_phys(drv_info->rx_buffer),
-			   rxtx_bufsz / FFA_PAGE_SIZE);
+			   PAGE_ALIGN(rxtx_bufsz) / FFA_PAGE_SIZE);
 	if (ret) {
 		pr_err("failed to register FFA RxTx buffers\n");
 		goto free_pages;
-- 
2.53.0



