Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773E15574C;
	Thu,  5 Sep 2024 09:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530281; cv=none; b=dBR34F4RY8jJ5QP+PLg2Sb8peKYi282+0QS8gURBw0C84IqNpEjbyK6BiyleD8Z+rw/Oxj/qMNpuApyHzGmF1F0W9Bnug4iaJ6K8te2AQMI8vA6w/1ZZeCP1/w3djNcRHwAKMJw8j51LXVNuqUGSuEyAsUYRV+9aLqVKABigvBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530281; c=relaxed/simple;
	bh=6lnyarCRg33jEk21jQ74+5wjwsQVFUhe3494swWA/UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9hO7QBbwPkw++sTMmO5+dRAFyggHyFmO/sNjHXOmBahl0h45fhijmeppebYOl98AKriOMoKLyv5MwXg7CLsHAZ87Yy/uJGGOMC7q1MR3lyrxLTx9SsoVkaQztztEiJdeflOCqRnt0rVQ4pimgm0HYIRZEv+PmXiFbtemjwj9/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwifyB+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwifyB+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF6DC4CEC3;
	Thu,  5 Sep 2024 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530281;
	bh=6lnyarCRg33jEk21jQ74+5wjwsQVFUhe3494swWA/UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwifyB+abPB2v1kWj+SQ/tyhf0veQNhlRP/UP7TCkoF0dbZbHM3E+DbLaHqQ21J6g
	 4RbqkxBZprQCkRCl538nDZcauXpiuySC31LTHkVPry1yWSlVmH6BqZCFMYty1raud0
	 9EU1LbUgNTRaI8X/GXQyqM8hsQq4+m0lhS/QsZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/132] crypto: stm32/cryp - call finalize with bh disabled
Date: Thu,  5 Sep 2024 11:41:37 +0200
Message-ID: <20240905093726.504900994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f095f0065428..2f1b82cf10b1 100644
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



