Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2822C433D2;
	Wed, 28 Dec 2022 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242014;
	bh=S0YleyCtl8nxSbpHoRmYgzf0i+GtpfERISxg5tXcEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEALtw2KfZTL8YTATHT6C4/5W1DUk4L+Om14JSPUalFUeFPgEKk7uWSO3Za94dVfa
	 kzhADNxeptXfd3HnbU3kFWkLgZgtdHyWzNCXCGC7lX7NMYWtdXeuyHfje+1aXrUe4X
	 Z9St9Kfa/EEUGiyyfwWI+hlHEVBYrOVTwZ3c09Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/731] powerpc/52xx: Fix a resource leak in an error handling path
Date: Wed, 28 Dec 2022 15:41:00 +0100
Message-Id: <20221228144312.567216193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 5836947613ef33d311b4eff6a32d019580a214f5 ]

The error handling path of mpc52xx_lpbfifo_probe() has a request_irq()
that is not balanced by a corresponding free_irq().

Add the missing call, as already done in the remove function.

Fixes: 3c9059d79f5e ("powerpc/5200: add LocalPlus bus FIFO device driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/dec1496d46ccd5311d0f6e9f9ca4238be11bf6a6.1643440531.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index b91ebebd9ff2..e0049b7df212 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -530,6 +530,7 @@ static int mpc52xx_lpbfifo_probe(struct platform_device *op)
  err_bcom_rx_irq:
 	bcom_gen_bd_rx_release(lpbfifo.bcom_rx_task);
  err_bcom_rx:
+	free_irq(lpbfifo.irq, &lpbfifo);
  err_irq:
 	iounmap(lpbfifo.regs);
 	lpbfifo.regs = NULL;
-- 
2.35.1



