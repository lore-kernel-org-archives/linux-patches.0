Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D117551D503;
	Wed, 30 Sep 2026 18:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793342; cv=none; b=F1N7Nv5Zxa5QKY6KiMNlRYhf+pxk5VJd7gREABZ683S+O25PhHxTa2R867NKtTvvIf3cmy8Vc3FCrSdorzozJV0Wq7bg0EfIlYPOJaQT4ha+C4tAzc0CLqpV//EQphOIjKQXSQRkTYZ5E9/irvSXCqy4OY0/GnfXLTOap6yk2bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793342; c=relaxed/simple;
	bh=+GIKawiJovFfYIRHowCbKiKCy59ul9EuX8c/8yJ1pqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXSnEndcF0u0PvtN4okVFfX5PsHJRDX5hIVinQMIsPjX3Gxjkjsa3aYkAp2NFhJ0vx0P9aeQ9gt9p2gsj+DwdtxAJjeG4YM21HxkaJGEkZhHPsZC02R0rYHUz1cajh2h6vXKYolNnkt5B6tgOd/0XuV1cpBxZ+eXE8Dvj49VW7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nl0oHA/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nl0oHA/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373CF1F000FF;
	Wed, 30 Sep 2026 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793341;
	bh=u8jK0cFRBDY6Fc4vuoLzal4bIv47XdEUzZLlM1zH7k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nl0oHA/FG8afSq+SCrF3zleBr+RIZWcx1aitYq38w0gmrtZe3WshQw/MEDhRbxrPs
	 VXlAL0DFKemoP74kWL17yddwEPcxkbdKTNd9vWqAz5PDO46g/gazXN1HyPuQBinn3q
	 bLgSfuS62hR4YOTzyXDlKSSefmEWxqCfVxh4mfnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/395] net: dsa: mt7530: leave the MDIO IRQ mappings to regmap-irq
Date: Wed, 30 Sep 2026 17:27:18 +0200
Message-ID: <20260930152344.468066926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d7ebb7b8ee72c..4001779a91591 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3446,9 +3446,6 @@ EXPORT_SYMBOL_GPL(mt7530_probe_common);
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



