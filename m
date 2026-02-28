Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE1135A3A0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300966; cv=none; b=oCp2H1A9GuDrQzhkV8Qlq5O6jXKItKL5qidnNioof+w7kPIPJENV1pojpc/0AT6wM9Vk5iLUhfQf10cYmf40yHP7dJk8b/AU5prKlby+kHIwB91lqSTRtXh8rbn9HetlS7IX15CuGNgqYu+X3AEtJstYN9RzeJXOkvb3pSiOkA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300966; c=relaxed/simple;
	bh=Q2P50G2oLMWLDkPOXKkRJJ/bx7ncv0t+7mU1ON33QU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6s/gXiWE3nwt+zOKp/NLHuspsyzj9/aJOzFPAvXxpF78Je6zJf2d97PLAIfFn0wUL2gcjX8sN/pGIiU93+RS7E4YAx00got6QBUe0wOhZW9h+IyKvAP4Fs3n4yEfxmO0lgRH1iehndMj4McRWUToiPtRWqEF+TOo4HMC9Udgsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trrotsaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trrotsaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20AAC19423;
	Sat, 28 Feb 2026 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300966;
	bh=Q2P50G2oLMWLDkPOXKkRJJ/bx7ncv0t+7mU1ON33QU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trrotsaQdZUjmtKRwlcI2OVP623kpw8JhmJeO/pYLlP/yLXaTnPrnyzgCLX1aBlxA
	 vbRqHmDLZqkrGu0T2grptaGF978OjIfq70mpDFyJeSgOUtcD1IYcaEiJDvoZWMS0Hs
	 fayKO37vE0k4ishXGaYR6Hiy+4dkwu72jxUX5VwBoCrqqikY4hPeJ0uMQal6W9wH+I
	 IVwV9c8lcvtJN9cOirAG6WH7Or5LG7/0KIE33v4hnbxdpljInJ4Beyl1a+K6NnUZqQ
	 /Xv6Qy/oDyUX+MaJbO6VqdCAktO1ZZZyBSAmsfZYERAbKtfk+VlsGRV9lgGlDcwvU9
	 dGenGiNu2+xbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/752] crypto: hisilicon/qm - move the barrier before writing to the mailbox register
Date: Sat, 28 Feb 2026 12:36:43 -0500
Message-ID: <20260228174750.1542406-92-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit ebf35d8f9368816c930f5d70783a72716fab5e19 ]

Before sending the data via the mailbox to the hardware, to ensure
that the data accessed by the hardware is the most up-to-date,
a write barrier should be added before writing to the mailbox register.
The current memory barrier is placed after writing to the register,
the barrier order should be modified to be before writing to the register.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a7c8839180ee7..b92ee2fcb18aa 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -609,9 +609,13 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 	}
 
 #if IS_ENABLED(CONFIG_ARM64)
+	/*
+	 * The dmb oshst instruction ensures that the data in the
+	 * mailbox is written before it is sent to the hardware.
+	 */
 	asm volatile("ldp %0, %1, %3\n"
-		     "stp %0, %1, %2\n"
 		     "dmb oshst\n"
+		     "stp %0, %1, %2\n"
 		     : "=&r" (tmp0),
 		       "=&r" (tmp1),
 		       "+Q" (*((char __iomem *)fun_base))
-- 
2.51.0

