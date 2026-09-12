Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9574078E8;
	Sat, 12 Sep 2026 09:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207142; cv=none; b=ncNMmyio5sNeywk/s7LFfuLr8/U2KQ/viCpzJt8E/tR4hOZkdKs+0W2JlM2WhJbPv8cffqiiMJXgmiOoVmcd+PovH1iL5oeIs0oybA21yBc1PnsMB2jr4c8T6rTTp17hzLDpMU9MKudAjQn2Ii2OcBs4LDY99njPbHkpbE1arP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207142; c=relaxed/simple;
	bh=j8fIcRtCLWKPeCJF3+qjblPTxHZxYnJaXYcOoFdNe/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1qh3vgBIH4g34zFFy77Qi8obRWgzv86/STQeJUBNihTwL7BWBb+04x2ZwQHZu6YoH6uhR6J+LZM/f9+T2aQ4O0eP4UA1RzVQ33RLYOGvm9RBC6h7+u3018c5p1dxhpELvJQSVus3x/dJ2Z7HkR8R9eexe4YVdLiPRkNbrpjptY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeBX+7BE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeBX+7BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A05F1F000FF;
	Sat, 12 Sep 2026 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207141;
	bh=rbCt5QBu18j8uRGa7BrBbeoNZfo+OjR/lhUbGZU1myo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeBX+7BEiCllzN18LZUwRuKmPn4RGGbsl2hxLp/S5S0rijbbniY6pNNdlKUEN0rgV
	 6qi96pgwKhlDsEWiCcr51eoKjs05JJtUZe4nhAA021XvXat7hhc5xXf5wlRIQWmt9P
	 E5bwcDaLdB52785Ac7IfdG/fpkC2Phv1Lq2KVtNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0351/1518] pmdomain: bcm: bcm2835: handle genpd provider registration errors
Date: Sat, 12 Sep 2026 08:42:00 +0200
Message-ID: <20260912065631.414880128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a1d9d3b958d69a13783613304f524f489fecdd1f ]

bcm2835_power_probe() initializes all power domains and then registers
the onecell genpd provider, but ignores of_genpd_add_provider_onecell()
failures. Probe can therefore return success even though no provider was
published.

Check the provider registration return value and jump to the existing
cleanup path on failure.

Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/bcm/bcm2835-power.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pmdomain/bcm/bcm2835-power.c b/drivers/pmdomain/bcm/bcm2835-power.c
index f2472f1e17521..f3df1198ec7e2 100644
--- a/drivers/pmdomain/bcm/bcm2835-power.c
+++ b/drivers/pmdomain/bcm/bcm2835-power.c
@@ -675,7 +675,12 @@ static int bcm2835_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto fail;
 
-	of_genpd_add_provider_onecell(dev->parent->of_node, &power->pd_xlate);
+	ret = of_genpd_add_provider_onecell(dev->parent->of_node,
+					    &power->pd_xlate);
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to add genpd provider\n");
+		goto fail;
+	}
 
 	dev_info(dev, "Broadcom BCM2835 power domains driver");
 	return 0;
-- 
2.53.0



