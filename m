Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2175D342CB3;
	Wed, 20 May 2026 18:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302242; cv=none; b=f8YzqNr7Co9y89fuzDq2IxBdgn3dHkKUs5RSop3ss35hj/gDCt6cup+pxfWBCH72Lk5zv+Z61hd3R4QGVKh5uhSOaqPoELMnrokXZhf+IJmeBd9RU+NZMngpP/4i98YqYx5aKuzpQzdKyLfM+bu44BJgDou73FVtt5c2uAHQu5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302242; c=relaxed/simple;
	bh=6MO6VTzrWHH5SFYhjug5WNfOKi1D/HvkoOaGw8xWB1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI2cPSrOHuYjO8rYSHKzKlvJzqTnajCyidLGUqD91JYljsZJdaDZHm398fltNoXudPmbJxAhcLE4uWPKoprfMh7Lgbl/qGciQFK29Vj28ZbD/OAEC38ZNeRZ7dHIGNRM3tw+P7R3X+386MVowr4MgzH4w8LKTTyCOj8x2v2ce3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJxh30Ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJxh30Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBA61F000E9;
	Wed, 20 May 2026 18:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302240;
	bh=21fW8T2q63p49/t+YNnTmj0Z3Wp2cR/sw7wGwNlkiIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJxh30UlgKK7BIu0V2+TQoCc/i3WRZU/7LS6YN7DrYd8JLdk/slw8UA/MYLjOM4lh
	 1IaOsdpqAA3VaesSlP4TGA6zQCn34+en1qJLdPw23L1DorCjDHUhvc5rEdFBvONxFX
	 6QhE4Qv0Q9qGZkyLljWQmFAEK1t1I175GBv1s5jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/508] soc: qcom: ocmem: use scoped device node handling to simplify error paths
Date: Wed, 20 May 2026 18:20:15 +0200
Message-ID: <20260520162102.795431071@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f4c1c19f5c0e5cf2870df91dedc6b40400fd9c8a ]

Obtain the device node reference with scoped/cleanup.h to reduce error
handling and make the code a bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240813-b4-cleanup-h-of-node-put-other-v1-4-cfb67323a95c@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 9dfd69cd89cd ("soc: qcom: ocmem: register reasons for probe deferrals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index c5fc6db9870a2..697c8a6a400b1 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -185,23 +185,20 @@ static void update_range(struct ocmem *ocmem, struct ocmem_buf *buf,
 struct ocmem *of_get_ocmem(struct device *dev)
 {
 	struct platform_device *pdev;
-	struct device_node *devnode;
 	struct ocmem *ocmem;
 
-	devnode = of_parse_phandle(dev->of_node, "sram", 0);
+	struct device_node *devnode __free(device_node) = of_parse_phandle(dev->of_node,
+									   "sram", 0);
 	if (!devnode || !devnode->parent) {
 		dev_err(dev, "Cannot look up sram phandle\n");
-		of_node_put(devnode);
 		return ERR_PTR(-ENODEV);
 	}
 
 	pdev = of_find_device_by_node(devnode->parent);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", devnode->name);
-		of_node_put(devnode);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
-	of_node_put(devnode);
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-- 
2.53.0



