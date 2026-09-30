Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2F8517BAF;
	Wed, 30 Sep 2026 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787503; cv=none; b=ozck73CytmcnLzjnMq9aOhRJ8S0QBnA6WFMTYqbd8NOIHIZLtJwh+psXID8KvNtrNuhgz6uWtaFhr3M8PI1P0EnTT6KmLJUTKkxnpsTCQsOsR+g+UYdujWa6kqwnz6cpunmR6yQiPnLKRf0VjMbr6ZoCxSzmhxlnyw3xABQJw94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787503; c=relaxed/simple;
	bh=5M1+g74vFGmX+8iis2yJEbfG5L5FfjDVS91/g7DpgVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/nFE+XUhMJ+EceW8wIJ6GcIy5xqAwr/+d2NVlP92R2pkLuFI7k8qgQeMreeyDasEVbC1+J8au70dtYNaAE7hHolwldOLFAwYdxxktCeBJL6mfadN2pDZWt8S29vn8AD6RgQWAMAFjtkpLH+NMALl8/aZLGMM5SFrOU2Dju1SwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Zl51kuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zl51kuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D311F000FF;
	Wed, 30 Sep 2026 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787502;
	bh=L+W8I2wLUwZTQ6GTnOMUNA8rWLJq5QuZOfcyMvcvgsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Zl51kuj56cRFNIQvyvcnjgzNFZcVvz52DWz/XOyNa2YAOuwpzl128cieUrtpKjS+
	 9ojkg/7e8oZ37GvhSQ1VEA1+L4sAapZ7GVYyoejuhoqVvCVvR1w40bKJBlALJJ9Rf3
	 EqEGFeBflRmc9hFeEac1j1IPQpnSZQqRlIr70kzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 208/457] net: dsa: mt7530: leave the MDIO IRQ mappings to regmap-irq
Date: Wed, 30 Sep 2026 17:25:13 +0200
Message-ID: <20260930152350.542075449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit 0d80ba0a204c6a16bd7778b50de578dff107c0fe ]

mt7530_remove_common() disposes the per-PHY interrupt mappings from
.remove, but the regmap-irq chip that owns the domain is devm-registered,
so its parent interrupt is only freed once .remove has returned. The
switch's own regmap-irq thread can therefore still dispatch on a mapping
that is already gone: irq_find_mapping() returns 0, irq_to_desc() returns
NULL and handle_nested_irq() locks desc->lock without checking it. The
attached PHYs have not given those interrupts back yet either, which the
kernel warns about a moment before the fault.

regmap_del_irq_chip() disposes the same mappings itself, after freeing the
parent interrupt and before removing the domain, so there is nothing left
for the driver to do here. Until it runs the descriptors stay alive, and a
late dispatch on one of them is harmless: dsa_unregister_switch() has freed
the PHY handlers by then, so handle_nested_irq() finds no action and
returns.

Fixes: 254f6b272e3b ("dsa: mt7530: Utilize REGMAP_IRQ for interrupt handling")
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260918015020.2518315-3-f@lex.la
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 56ee8dc34f518..93dba4498c420 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3539,9 +3539,6 @@ EXPORT_SYMBOL_GPL(mt7530_probe_common);
 void
 mt7530_remove_common(struct mt7530_priv *priv)
 {
-	if (priv->irq_domain)
-		mt7530_free_mdio_irq(priv);
-
 	dsa_unregister_switch(priv->ds);
 
 	mutex_destroy(&priv->reg_mutex);
-- 
2.53.0



