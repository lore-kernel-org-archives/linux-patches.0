Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D446519923F;
	Thu,  5 Sep 2024 09:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529801; cv=none; b=fVWM6O5/xjJ/tVsJGeUAeUPudklpWxkVljyh/3ZgLmWXFE7AutIi7Q9c8GDk9sBXP5c1BC3/tnq+DO4idB1oVnb9e9Df2Y36WMFmwuM9ZzsF6pBCqoN8RufPib1Rc5KDyWFr6Fv8317OGRhjBujADHDVg+ygxap++MOMNLVvcyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529801; c=relaxed/simple;
	bh=psmMIe3NS37DNsRciBq4LZPGHEXNMqgmPC2FGh+Wqoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QhYEL1jrxpEztDomz0FwBVuplNm1VGTan082c+okJstVkEQ4GWTvH7/bNAcIv/hYH9+wNG9LoYWRsV1RDHm2o/UcyPJv8sGrIY+FF29MNUJ3mvXjrYJS73ZzZmXJRIKtj/tWWCRx84ab33IMfiaZecQUe6938uMiJ5AVBq1Yfs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0b6cH8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0b6cH8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ACDC4CEC9;
	Thu,  5 Sep 2024 09:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529801;
	bh=psmMIe3NS37DNsRciBq4LZPGHEXNMqgmPC2FGh+Wqoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0b6cH8tqkgAhKHQ9qK2kPNNrzpu3an9DfMPrX1x9MAG2CA3lQprC3AjuzcsEpDMt
	 yFgTHtkzgIBNdEU8nhIvgv8tWJrU7fg/+BjrFyFC61lD6qUu93qltlBoNTPQpF3YKB
	 K/BJYuuzn7qR/Sq+K8p2XLJjJr1cVo1vYOvp9HCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 146/184] crypto: stm32/cryp - call finalize with bh disabled
Date: Thu,  5 Sep 2024 11:40:59 +0200
Message-ID: <20240905093738.037572513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Méré <maxime.mere@foss.st.com>

[ Upstream commit 56ddb9aa3b324c2d9645b5a7343e46010cf3f6ce ]

The finalize operation in interrupt mode produce a produces a spinlock
recursion warning. The reason is the fact that BH must be disabled
during this process.

Signed-off-by: Maxime Méré <maxime.mere@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 11ad4ffdce0d..84f5f30d5ddd 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <linux/bottom_half.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/err.h>
@@ -1665,8 +1666,11 @@ static irqreturn_t stm32_cryp_irq_thread(int irq, void *arg)
 		it_mask &= ~IMSCR_OUT;
 	stm32_cryp_write(cryp, cryp->caps->imsc, it_mask);
 
-	if (!cryp->payload_in && !cryp->header_in && !cryp->payload_out)
+	if (!cryp->payload_in && !cryp->header_in && !cryp->payload_out) {
+		local_bh_disable();
 		stm32_cryp_finish_req(cryp, 0);
+		local_bh_enable();
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.43.0



