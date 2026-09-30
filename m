Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1A3B52EF;
	Wed, 30 Sep 2026 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783573; cv=none; b=p0A64tCuBlGRgmAHWB6FIcKIZBnTPepWJAwKKpfjMz57vhMopDsH4dzMagNfDpTGPiXoUNFIPf48U5NOs5P2hbvZgyLhdXzvz4IU3D5vHcnKoyRhqn+56qpDnV7QNFgSZUBfjoWSzJbknvNkzaDqYILhiZOL2ZxoRzcfIgkKMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783573; c=relaxed/simple;
	bh=sBR1Kb0zOG7h/gZ70pCzzRC0zd5QONIN2gZp7SprdQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBUVLwgPMBrH5Ku9zWfA9mjyl+EHuGyuZLVOXcT9hUr4MYQADvR184tgM/GaztDHi0fDzZKprUnvsHXDvK51hUJF9ZoWwNHuaznFpJhPNnmqxq3wSBHu1x7VS4zXAPS9LO3DSbIOqJH3g4S6x/dtBxfTelhg/YuFQMUsbRAZRgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSTb9w2P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSTb9w2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D911F00898;
	Wed, 30 Sep 2026 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783568;
	bh=i3OUXbac3qESsgBPqDQ0RoS2dxccwL9jvsV1vcBceBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSTb9w2PvZ+DqMY+UNBjPEybVeckhzlqmxB/HsoRrtP2+X1USuh4RgZ+X8e0TlVyc
	 AxAsVjzOKO1r/3Lo3lygoMov3+gby3cHjZ9VcyFQToJpYEKuAE+XK+Ldos7oDlhb8z
	 4z0ftZRIS4w5KjIRQ2YA8A7XnvXbkMqSppNqPZUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 443/595] mmc: sdhci-of-aspeed: Remove children before releasing SDC resources
Date: Wed, 30 Sep 2026 17:25:36 +0200
Message-ID: <20260930152357.210390946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 4396d70bb7fec531bcf934fed016b2f3300c670b upstream.

Probe failure and removal leave SDHCI child devices registered after the
parent clock and managed resources are released.

Unregister the OF children in reverse order before disabling the parent
clock on both paths. Use of_platform_device_destroy() because manual
child creation does not set the flag required by of_platform_depopulate().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: bb7b8ec62dfb ("mmc: sdhci-of-aspeed: Add support for the ASPEED SD controller")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-aspeed.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-aspeed.c
+++ b/drivers/mmc/host/sdhci-of-aspeed.c
@@ -288,12 +288,14 @@ static int aspeed_sdc_probe(struct platf
 		if (!cpdev) {
 			of_node_put(child);
 			ret = -ENODEV;
-			goto err_clk;
+			goto err_children;
 		}
 	}
 
 	return 0;
 
+err_children:
+	device_for_each_child_reverse(&pdev->dev, NULL, of_platform_device_destroy);
 err_clk:
 	clk_disable_unprepare(sdc->clk);
 	return ret;
@@ -303,6 +305,7 @@ static int aspeed_sdc_remove(struct plat
 {
 	struct aspeed_sdc *sdc = dev_get_drvdata(&pdev->dev);
 
+	device_for_each_child_reverse(&pdev->dev, NULL, of_platform_device_destroy);
 	clk_disable_unprepare(sdc->clk);
 
 	return 0;


