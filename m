Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DF4215F4A;
	Wed, 17 Sep 2025 12:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113591; cv=none; b=DCBnE+z3uRp4c4roQZozU0aQ1WsXf6MPRuC2U/aTTzXO63foZ9/wQfB+dUejLi1dhpCjM51psOPZ8KnNMhn4JVtU0Y0DY5H+juz/EZqq1p7XSZ4dxfzZCbTxw+zsN6QHY+u2fE+05m4uytqyLhPZo48G8mgTNo4ol3PXE8laQFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113591; c=relaxed/simple;
	bh=FmVT2uXXNHYIML7JIf+ngogvSdZFtnW6cxUMcNpLd28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6XKVa4qDGC0qm/upNOE4+tmz601QfpRktUNlCOoiOlzmQT4PhM7saGVezEzVYNoi9N4oju8eSVvxCRAY47QurJmxad2M06wZogtwJT6jTESBB9dYCQazQBPrZGr15VfhuAwFPfnIjI+JDOb2sIm5ZiuJ8OZOJaDjwLvSgfd0PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VV4BpC6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VV4BpC6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1CBC4CEF0;
	Wed, 17 Sep 2025 12:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113591;
	bh=FmVT2uXXNHYIML7JIf+ngogvSdZFtnW6cxUMcNpLd28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VV4BpC6VvOMQAqcGcF1m9EcGli2HzT7Tt8b2vX/KOq4bMgwiHIOqS+wjhbUccyBga
	 OQCgMSFdlVOuUWiVh66Z8hQD1D9E5hi9ZaZrAX8MODaSMI2z/y6rrS6kBGc83tFUJT
	 yEsXBk95WU289j2w8ji5DLARSJCJ3nFwcc/Ak/tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JC Kuo <jckuo@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 134/140] phy: tegra: xusb: fix device and OF node leak at probe
Date: Wed, 17 Sep 2025 14:35:06 +0200
Message-ID: <20250917123347.595665133@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit bca065733afd1e3a89a02f05ffe14e966cd5f78e upstream.

Make sure to drop the references taken to the PMC OF node and device by
of_parse_phandle() and of_find_device_by_node() during probe.

Note the holding a reference to the PMC device does not prevent the
PMC regmap from going away (e.g. if the PMC driver is unbound) so there
is no need to keep the reference.

Fixes: 2d1021487273 ("phy: tegra: xusb: Add wake/sleepwalk for Tegra210")
Cc: stable@vger.kernel.org	# 5.14
Cc: JC Kuo <jckuo@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250724131206.2211-2-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra210.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/phy/tegra/xusb-tegra210.c
+++ b/drivers/phy/tegra/xusb-tegra210.c
@@ -3164,18 +3164,22 @@ tegra210_xusb_padctl_probe(struct device
 	}
 
 	pdev = of_find_device_by_node(np);
+	of_node_put(np);
 	if (!pdev) {
 		dev_warn(dev, "PMC device is not available\n");
 		goto out;
 	}
 
-	if (!platform_get_drvdata(pdev))
+	if (!platform_get_drvdata(pdev)) {
+		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
+	}
 
 	padctl->regmap = dev_get_regmap(&pdev->dev, "usb_sleepwalk");
 	if (!padctl->regmap)
 		dev_info(dev, "failed to find PMC regmap\n");
 
+	put_device(&pdev->dev);
 out:
 	return &padctl->base;
 }


