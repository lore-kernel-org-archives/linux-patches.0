Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B66027CB04;
	Tue, 27 May 2025 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364620; cv=none; b=iyVpmEotC+B8AFmBBhncePz0BizpKNjk7/4xXFG4ko9cyMysVvGIfD6uDUx2/5DacAlj9J9fEHE81UncDcYzTPqHBoeUUrdgDllLKkXBk3PB58w5g+NLcuQZE7OcdqXiI6cLzSX1/5iWy/eBtftqMQX/En70BX5FbR9duxPK5Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364620; c=relaxed/simple;
	bh=iihuf5P2rX0vrhdXVwHIK9yWdnyaeZeWSF2xUi1xoGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ft2NICWOUhz/3yeEy+Hu0D2JwyqLuvYPv5W20/1V4SseCUcoPD0jvMeZI/460CNKT8BX0/SCGTdbYtGm1drn7p0dk8+fjzpM+3d3TnywMBuK/VpV1VvgcXzXd1SBROVojLfESNOsUEihSlNwGkgDmC9dAY6JlbnmtzxquQVbRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkSiON2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkSiON2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E7FC4CEEB;
	Tue, 27 May 2025 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364619;
	bh=iihuf5P2rX0vrhdXVwHIK9yWdnyaeZeWSF2xUi1xoGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkSiON2/3rTk4VdsyysBLRoi4s0p5VFOgqS/mPvtBKK3ocmsXR3HpV/8Z/NCctZ/f
	 xAOQpCpEAZPkM6MucAgDmPbTnUJ+gBn3BdehOAL5HmftVQNFAHm3WC4xX+4d7SMG1r
	 PvcaiIKKDkj4375cJOL5os2pD7bINb0CZPGapBr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tsai <pedro.tsai@mediatek.com>,
	Felix Freimann <felix.freimann@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/626] Bluetooth: btmtksdio: Prevent enabling interrupts after IRQ handler removal
Date: Tue, 27 May 2025 18:19:35 +0200
Message-ID: <20250527162448.381455778@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 6ac4233afb9a389a7629b7f812395d1d1eca5a83 ]

Ensure interrupts are not re-enabled when the IRQ handler has already been
removed. This prevents unexpected IRQ handler execution due to stale or
unhandled interrupts.

Modify btmtksdio_txrx_work to check if bdev->func->irq_handler exists
before calling sdio_writel to enable interrupts.

Co-developed-by: Pedro Tsai <pedro.tsai@mediatek.com>
Signed-off-by: Pedro Tsai <pedro.tsai@mediatek.com>
Co-developed-by: Felix Freimann <felix.freimann@mediatek.com>
Signed-off-by: Felix Freimann <felix.freimann@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 11d33cd7b08fc..d4ea1ff07b3e7 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -610,7 +610,8 @@ static void btmtksdio_txrx_work(struct work_struct *work)
 	} while (int_status || time_is_before_jiffies(txrx_timeout));
 
 	/* Enable interrupt */
-	sdio_writel(bdev->func, C_INT_EN_SET, MTK_REG_CHLPCR, NULL);
+	if (bdev->func->irq_handler)
+		sdio_writel(bdev->func, C_INT_EN_SET, MTK_REG_CHLPCR, NULL);
 
 	sdio_release_host(bdev->func);
 
-- 
2.39.5



