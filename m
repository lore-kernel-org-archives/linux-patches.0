Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB3C37D130;
	Sat, 12 Sep 2026 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238423; cv=none; b=VoHgqL72m835RwdM00X+1ZhF3U0uYavKE5Nkcxvjq8YKW5W1O2LbY+4YkTohqNdYuhLRhanv5dgHsSF6uDugDu754LccuqPQblG7sZRle/0E4V1jFkzvsdyDPsMiFLytek6nqQUaIR9pMu12/o1Ufq6+NBo9HGGfE5ZdEqYYABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238423; c=relaxed/simple;
	bh=6pdl6vYT5jbq+Yo1FJZ3GG90SNKhNbd7TINjbfLvJYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWgb9abngZ57j5Vsjy8ub/wLS4vH976B+OTQtXb8mPZh/Dt+7uOE2uSHdmTJqk7hA7WTywjnTT3Y2MtdBnK+VM3X71CxCikehGbFVbmkgbq396ik1T8aBx4GpljmTKL3c5NmXTtRTy3yBr7KTl548ng4CkhHayd6XFUHsmAEZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrznHod+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrznHod+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12FC1F000FF;
	Sat, 12 Sep 2026 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238419;
	bh=BpUJZ+fz8GGal8TH50mVl+I6uiKJHfZsLbQ9zkeK6Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrznHod+YcaR5OkbKahzpl4ZxacvUeBKMiUxIOOqZDybsfIUuB9AIAvJEfwbY0uVd
	 fFAy1GtyqFmY1snKDzrC77SMixCqgyitrQVVkUp/g5DqIqE8jTrYNiBPyq3zwCZEtQ
	 jVre1n2stF+AbpHn5E9dZKl2HnMcAsed59E+d3Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 459/935] staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:58:09 +0200
Message-ID: <20260912065537.352659755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Mukkanwar <ayushmukkanwar@gmail.com>

[ Upstream commit c0a9a8586a63fda49e61a6b83360feac2a60d898 ]

cvm_oct_rx_shutdown calls free_irq and netif_napi_del without
disabling the napi instance first. As the free_irq only waits
for completion of hard interrupt handlers, the napi poll
function could still be active. If cvm_oct_remove proceeds to
free the plat structure (which holds the NAPI instances), the
active poll function will access freed memory, resulting in a
use-after-free crash.

Fixes: 3368c784bcf7 ("Staging: Octeon Ethernet: Convert to NAPI.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260511150931.93382-1-ayushmukkanwar%40gmail.com
Signed-off-by: Ayush Mukkanwar <ayushmukkanwar@gmail.com>
Link: https://patch.msgid.link/20260615172734.42038-2-ayushmukkanwar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index cd36b5ba6f6c2..3e9d58d321560 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,6 +535,8 @@ void cvm_oct_rx_shutdown(struct platform_device *pdev)
 		else
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
+		napi_disable(&plat->rx_group[i].napi);
+
 		/* Free the interrupt handler */
 		free_irq(plat->rx_group[i].irq, &plat->rx_group[i].napi);
 
-- 
2.53.0



