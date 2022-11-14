Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CB04C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5702CC433D7;
	Mon, 14 Nov 2022 12:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430511;
	bh=sp+gBnK1+NEnweJEGrxConGz44K1rSTcau4w/OVgd+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFpz286518WyTSCqmBmbTHCtpXvAg9JWd5roov9Rwz2VzK/2SK4c/ydiPvpWb30Fp
	 cgehfjk8FhOfWULlmu9cixjo+kQ4QnTaTeao/fMA6XMmGQxNVX0UMlNmmYvMPX5/lu
	 oO8lqyCUz1PgHD6tcP9NvTnuTR55Rri5V6tqgEIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/131] dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()
Date: Mon, 14 Nov 2022 13:45:18 +0100
Message-Id: <20221114124450.811761511@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 081195d17a0c4c636da2b869bd5809d42e8cbb13 ]

A clk_prepare_enable() call in the probe is not balanced by a corresponding
clk_disable_unprepare() in the remove function.

Add the missing call.

Fixes: 3cd2c313f1d6 ("dmaengine: mv_xor_v2: Fix clock resource by adding a register clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e9e3837a680c9bd2438e4db2b83270c6c052d005.1666640987.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index 9b0d463f89bb..4800c596433a 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -899,6 +899,7 @@ static int mv_xor_v2_remove(struct platform_device *pdev)
 	tasklet_kill(&xor_dev->irq_tasklet);
 
 	clk_disable_unprepare(xor_dev->clk);
+	clk_disable_unprepare(xor_dev->reg_clk);
 
 	return 0;
 }
-- 
2.35.1



