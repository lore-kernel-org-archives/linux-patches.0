Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D61DF751;
	Tue,  6 Jan 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721093; cv=none; b=nndRkNJzT5Xdb37ARrslXaQsvFPODeLKQpw2Stvl8V0o3Y3BC74DXAQA4Ot1rbkuDs/IDCjWMuTqiKt9UoSxBV331bPC+IBfmAsfEvV8RwSWMRsfW6IKBJfxXNF6fI1TQAN45MSCkubHtCD97PhCDKaQg5DoLRp5knDjgl/wLiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721093; c=relaxed/simple;
	bh=jthzbdAAY8gCNj5FigBEyWafYsDgI+EfBvU9ggJksko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OflqF82D9icOO/SbY66vEChN0jREY4mb3zcjxwjMq8VJKItbmJIkYKemXLVDbgJ5dV8SzCqotAe+4tu62kkkbvZFvw+93a4PIzYdV1NgIciH+gUxg/mSpzoDp9TdTpGiQvg2UWtWQr+cLopxEVi+wNRn6zDMt6dwUBRCDYFDNrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry+Oc6Zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry+Oc6Zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914C2C116C6;
	Tue,  6 Jan 2026 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721093;
	bh=jthzbdAAY8gCNj5FigBEyWafYsDgI+EfBvU9ggJksko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ry+Oc6ZozezqCtG0LWM4J5RIwGBsgADUDLEHtCwhnkf9tVlYiM7XFwVnsXUqQs/QC
	 j58XbVAjy58Emtst7SuTcjkD+fQvYFiyQxZCwRtadhC6vZEAuq8VBss8wE35QLmNeI
	 nar9+6PAZ+v6Fd5O7CM4ufDqGTKb2X2cf5l5kytA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 434/567] pmdomain: imx: Fix reference count leak in imx_gpc_probe()
Date: Tue,  6 Jan 2026 18:03:36 +0100
Message-ID: <20260106170507.407126503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,13 +403,12 @@ clk_err:
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


