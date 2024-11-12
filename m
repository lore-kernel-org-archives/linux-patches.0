Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4661A76C7;
	Tue, 12 Nov 2024 10:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407651; cv=none; b=tgho7PA671PxOnXiMCJHusINeDK4eg36ZYTtHi58n+W0RFUVUSdxTCCNxQkCjgwsEQkRu2BaLX3U8sgimCZuMOsWb05pZRdLWZ3VfMF78ZB6bURTA9Z/Rj1fuG6OmGhXfopC8/TMN0r18xIXuQ17FdMbKWDTz43o/D/THxvKSbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407651; c=relaxed/simple;
	bh=i00dunWrbFm20pdalcHe4iLBDuHnRBxTCbgD1SXCFnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+xHja6HIpeozEIK2fhfy43Nhs7sFfqvX8q8o/fPfkggR/1rjCV4XFxQbTv3hYsyXeLvrhdBPz9w8WRnNe9r4t12shrOa2i2Mo6IYo27ffYJ5waUjaOt0wYRCKX8Zrf9L3n8KSxipduEO9uae2E9vl/++gfpMtq+y88ByDoCL18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1j883fBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1j883fBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9695DC4CECD;
	Tue, 12 Nov 2024 10:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407651;
	bh=i00dunWrbFm20pdalcHe4iLBDuHnRBxTCbgD1SXCFnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1j883fBDthtWjzy1eWr2b/pGfAo7MmwhBOyre8kx7NkV/kRuxjGX0b++ax9SveeXy
	 yCYSu6PV1Q6XIKHh2zZZFGdLziDX4UYkZHt1RxTT+DFdvHmOJOtQvJGPXVWBCNPj3o
	 Tt2WdFotCzwrJ9KRbaLTfAq2cR6Rx2s0OUT+638E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/119] net: stmmac: Fix unbalanced IRQ wake disable warning on single irq case
Date: Tue, 12 Nov 2024 11:20:49 +0100
Message-ID: <20241112101850.288081415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 25d70702142ac2115e75e01a0a985c6ea1d78033 ]

Commit a23aa0404218 ("net: stmmac: ethtool: Fixed calltrace caused by
unbalanced disable_irq_wake calls") introduced checks to prevent
unbalanced enable and disable IRQ wake calls. However it only
initialized the auxiliary variable on one of the paths,
stmmac_request_irq_multi_msi(), missing the other,
stmmac_request_irq_single().

Add the same initialization on stmmac_request_irq_single() to prevent
"Unbalanced IRQ <x> wake disable" warnings from being printed the first
time disable_irq_wake() is called on platforms that run on that code
path.

Fixes: a23aa0404218 ("net: stmmac: ethtool: Fixed calltrace caused by unbalanced disable_irq_wake calls")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241101-stmmac-unbalanced-wake-single-fix-v1-1-5952524c97f0@collabora.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a116423adb30a..853851d5f3620 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3678,6 +3678,7 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	/* Request the Wake IRQ in case of another line
 	 * is used for WoL
 	 */
+	priv->wol_irq_disabled = true;
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
 		ret = request_irq(priv->wol_irq, stmmac_interrupt,
 				  IRQF_SHARED, dev->name, dev);
-- 
2.43.0



