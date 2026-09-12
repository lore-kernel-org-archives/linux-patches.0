Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC54340D9D;
	Sat, 12 Sep 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223337; cv=none; b=ExNjby80ZfBlIWxFVwy/TzEVL0yLkKV7qihG+TkJqWMPVwMT7cbVOMGKKu7BWUMih2jjw5i5GU/kIl/tThjWVF/Krp476hi8Q4rPEup9AdzetTaOm3ea6d1+8DFVLmFiWbiq51/qPob7IdZFyH7zaUsTuSR9JF4L+GrhwP0nv5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223337; c=relaxed/simple;
	bh=FNknQCm94ME9B+3l3TeVSNWzvnBXBhpcPQokM00aZwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJqJCV87V3p+Mz333gW3W2dQ6dOFWs7lM/x+AquSnCV5LQ7Z6KXkUZFgHQO33dOFLJUWCB2ZBmSJD2SP1OSiAI5zKfHi/FwPy6r1Idge/ca43IjCUeko2dWWrktDWH0qCtpKOAlTozis81D2eUmgFhSEAh9McpRmRbcjbC2l4AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyK07QG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyK07QG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395171F000FF;
	Sat, 12 Sep 2026 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223336;
	bh=l7ZA/T8NBwLgOBpyhUzQEwYejL0zHSacfbei1qzo6k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyK07QG6k4qCLT3X7SgD6UyCUvCOEZJvZ2Vwi3UC3zr+zkt65OtgUMfWQh7vxUoQ1
	 FDMnTXjQ9YhhAn1QXTAp4qdrGyjRnPSRUvxGkUuMcYPXorvPnDYuQSGDXRxTfbD8FS
	 CJhj3YOdDdenkiI2G5iKwPCPGUXqwMYnoE/ShUHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0726/1424] pmdomain: bcm: bcm2835: handle genpd provider registration errors
Date: Sat, 12 Sep 2026 08:52:38 +0200
Message-ID: <20260912065623.548881163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20130549a7a53..85406b4a99b06 100644
--- a/drivers/pmdomain/bcm/bcm2835-power.c
+++ b/drivers/pmdomain/bcm/bcm2835-power.c
@@ -682,7 +682,12 @@ static int bcm2835_power_probe(struct platform_device *pdev)
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



