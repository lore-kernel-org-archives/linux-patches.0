Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280A936C0D3;
	Tue,  6 Jan 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722285; cv=none; b=p9Ife9U/imy5X1cp2ZXsYa/xBR9hyjDZd1jyxO4VZIWqYOp/7RnZ9GOK4ow525hbzinjN5e+EP+b/k3tW2MVCpsFZAi9jQgiVLBueTDxdprQXKNITInDL25EsyZUtDj2iMDdYLly+AW962rJ7ZQZ7ZSKVZ9eI8jK0giKu/4Q31c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722285; c=relaxed/simple;
	bh=CZFv5R5AvSQ3KI19sl+5uMm333rVJO0ImOtALYryFto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg35YM7wkdia9eLilOMoygDTww5f+fXUJGT7C21B8qowldjb9zvfPbGy/eDCpBpRWgnwL1c0fFOL/wZZ14c4BVTwui6OvHBEGXJ/aouVOIQAe9XeTtul08RA1LZfzMn4uBJlNVRRrC1C7QMxVJlKBawGqKEWOtxnZD1abPjn1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f41PARhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f41PARhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3734AC116C6;
	Tue,  6 Jan 2026 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722284;
	bh=CZFv5R5AvSQ3KI19sl+5uMm333rVJO0ImOtALYryFto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f41PARhLFtb/WWWMVm7Fjqx9LaaE28ANmr3EkSgwUXj6Ige6tYnE02sIlqWiSq0+z
	 3hj13WUjtdsrMDniw1eWkVfGwlvOcYXMNs2UAV4zT9hlcVu+HtvMHz7VPsmDV1tbEj
	 pgNmGQiyZXVWHnoTUwCov4d5cCPOy3YHYH1UEs0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 218/312] pmdomain: imx: Fix reference count leak in imx_gpc_probe()
Date: Tue,  6 Jan 2026 18:04:52 +0100
Message-ID: <20260106170555.729447904@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 73cb5f6eafb0ac7aea8cdeb8ff12981aa741d8fb upstream.

of_get_child_by_name() returns a node pointer with refcount incremented.
Use the __free() attribute to manage the pgc_node reference, ensuring
automatic of_node_put() cleanup when pgc_node goes out of scope.

This eliminates the need for explicit error handling paths and avoids
reference count leaks.

Fixes: 721cabf6c660 ("soc: imx: move PGC handling to a new GPC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -402,13 +402,12 @@ clk_err:
 static int imx_gpc_probe(struct platform_device *pdev)
 {
 	const struct imx_gpc_dt_data *of_id_data = device_get_match_data(&pdev->dev);
-	struct device_node *pgc_node;
+	struct device_node *pgc_node __free(device_node)
+		= of_get_child_by_name(pdev->dev.of_node, "pgc");
 	struct regmap *regmap;
 	void __iomem *base;
 	int ret;
 
-	pgc_node = of_get_child_by_name(pdev->dev.of_node, "pgc");
-
 	/* bail out if DT too old and doesn't provide the necessary info */
 	if (!of_property_present(pdev->dev.of_node, "#power-domain-cells") &&
 	    !pgc_node)


