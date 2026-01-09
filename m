Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1412737EE;
	Fri,  9 Jan 2026 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961171; cv=none; b=oiHD+a3diGRRNyahoh2Qw/4V9zvgMYYN4+ByvYoAE3dqSy/bKp4AF5puAOSkOwattsLfX7F1oxUyzNWqUT9/BitmK810DMnTnHQBElu3fo440gl6eAuveI0MTqTYUUj8qY20AM7nHGgXhsrTm7JxJqVuykemToneRwljrnu6UI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961171; c=relaxed/simple;
	bh=RAWy9v56+CLMnQj5VxMFd9gCp8lW6pwCRfqpIVJNib8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+T+LAiesLFaGjrvXg16o93c+3uA69KDFsYL14LICuZvWqf77woYO7fYPUIonL7AWmZyr3nEG++76CzJZthmMst39xoSnDFqq+28AnKdCzQlXaOnXmYEEjX9RqPSNdDb+uHUVRX4DsudC4mMyXtNVDA4RQ5i4yHHqm4jbyPPUNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrYD/8DX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrYD/8DX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A43C4CEF1;
	Fri,  9 Jan 2026 12:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961171;
	bh=RAWy9v56+CLMnQj5VxMFd9gCp8lW6pwCRfqpIVJNib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrYD/8DXfBZGjOwFvBfaDx4+zE+yRf6O3ZGis1RoMdZWwVdqqWl2NydU5k4x4qEYV
	 eoMNwkCFezrCcOGnXDABt6csHuCIK4932Q9ZTwqChwI2yb2o7DtCuQnfKwA4uzXQDU
	 id4t4m405mhTOhLA4/p0GcYbEK+JCjE85HBh6t+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 659/737] pmdomain: imx: Fix reference count leak in imx_gpc_probe()
Date: Fri,  9 Jan 2026 12:43:18 +0100
Message-ID: <20260109112158.818690970@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 73cb5f6eafb0ac7aea8cdeb8ff12981aa741d8fb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -405,13 +405,12 @@ clk_err:
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
 	if (!of_property_read_bool(pdev->dev.of_node, "#power-domain-cells") &&
 	    !pgc_node)


