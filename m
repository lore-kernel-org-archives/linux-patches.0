Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F9212D37;
	Tue, 12 Nov 2024 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408081; cv=none; b=VJfd4IifOoz7U4fXbsoFBV2B3RWklskYyZfPus6ycV+hVaXk+o8itwy7MAS4Ea4ekd+ca5jD1RO6QKA1llbmm3BK2CBLy/wKgx0m6gb7s+yXgVm6w5bRsUGXx7z/rhJ12TGphrupfi7eroCb8AeFGT73J0sBK/n2CBcMEn1ZXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408081; c=relaxed/simple;
	bh=udkpATHTkMz2xYYVwyQIMJcorZtu5yUOmyoT1oyGnSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bM1D/MPqUHGDVygJN8TFnsLAng8itglFWi9xRUPILIY3bIjc2MbCYBYnHkGoE1KENG7v6F71MsIbS08hHyv1kZfeNnN/QX42/2L3W0eXz/pyHiKlYVq5UlKzeXfcGpBmDyxx/ldVDmdxyqaeId4Lk8StDXseD5BeNWek10iebvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ado0Rf+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ado0Rf+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160C7C4CECD;
	Tue, 12 Nov 2024 10:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408081;
	bh=udkpATHTkMz2xYYVwyQIMJcorZtu5yUOmyoT1oyGnSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ado0Rf+h60v7Vm8KiH7cgQsE5GYOhBAo2ryb8YWipJvcEAZgMCZh8zmISvlfTeKUd
	 GSUq1iKkcSLv+565nm2ixXHAelqL3+MtJvJeCaVdcst50lz9iCSsbUPmQBLygrZil1
	 XSfn2aZLaulCEydbeK/2fa2YkzB18LH0JY6XkXqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 053/184] net: stmmac: Fix unbalanced IRQ wake disable warning on single irq case
Date: Tue, 12 Nov 2024 11:20:11 +0100
Message-ID: <20241112101902.895919935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 02368917efb4a..afb8a5a079fa0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3794,6 +3794,7 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	/* Request the Wake IRQ in case of another line
 	 * is used for WoL
 	 */
+	priv->wol_irq_disabled = true;
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
 		ret = request_irq(priv->wol_irq, stmmac_interrupt,
 				  IRQF_SHARED, dev->name, dev);
-- 
2.43.0



