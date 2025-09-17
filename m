Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241832F260C;
	Wed, 17 Sep 2025 12:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113153; cv=none; b=O76B/lLFytx0FBS2bTsEZ0IJqmoPKZvBE9/lxhsrVeNhypCFYdoEC+VSHclr7d7I79l3Cu24Uxb6HYvCjq5nTj0/97N8hRfGFHeb13ejCJZWoAHaFXIVEgvZ1ry9N1tkHgKrX/Uvqxu55/KGeZbM3xkgySQawb9+mPEHcudVp2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113153; c=relaxed/simple;
	bh=s2iJ7Gn65jBcJCp5K9xcgwRk6xnRZXSlQ0CcqRkfeqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmTuaIzry1e8GT4dS3Owwy07Msyo9QFPAOZO+Iz6Zy70sSugRqRz28UXPXCh1+9nA7COFoSy9QS4BPmyd+NZsL34duqEsFz4d3Rica7onB8eEU/ue+UYfAFO/FsEQ2N444fZgzFnYK/aRfsN3KohbAtvfa+V6i5UDLWWOP/tZYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pivlFraP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pivlFraP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D819C4CEF0;
	Wed, 17 Sep 2025 12:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113153;
	bh=s2iJ7Gn65jBcJCp5K9xcgwRk6xnRZXSlQ0CcqRkfeqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pivlFraP8QmHHH3M/kavroSbYyyb+Woj7It5NqnZOcVYAQzALNaLPLNZKkuiWR5Zo
	 Lr7lWGwIAk7ITrbc0OCJpT1+OWMRnhefgm50xyebUyimncW0vXC2IAvqnGw7m2WtdK
	 9kA075F2nPVPpznhBmA4+0c/eS+LRvngj2zKN6Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JC Kuo <jckuo@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.16 187/189] phy: tegra: xusb: fix device and OF node leak at probe
Date: Wed, 17 Sep 2025 14:34:57 +0200
Message-ID: <20250917123356.459501901@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


