Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2C33C00A1;
	Thu, 15 Jan 2026 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498563; cv=none; b=jGSwMCb07Nu7CEW9hxBCuZzyp1wf8g1JWOmHxLpH4yR1PbKip5AiKNadrlub1bDswJVRVVGYUk/gZuMXSwYQIFHcYQEiGjYwHftAf/Xg9RqMBrRiTairsDfrN7wMwStz9UQTUfbsaSnQDK4cXKT6V6gWjRJfP5mqekdq8kKOXR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498563; c=relaxed/simple;
	bh=noGglZ+36gQWGoCDQadFAMgjApsqqjxoswZJ7e34dkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjt/ehbGAdkuiobEmo5ALhb0ZJvfjkyHWpiAphWldRrgndh0/iEjqz+AdaCJAW56LNxHp7ISjClKS0qDuo/POHChUNvjWRUyGu5FofoeV4oO2D8PrgaXD8XxGDAZLbU6m7POF9wesRC0lpTpiBrARR5+mkMbMqoZEjUo4t/NYIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g86Izy94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g86Izy94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1C2C116D0;
	Thu, 15 Jan 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498562;
	bh=noGglZ+36gQWGoCDQadFAMgjApsqqjxoswZJ7e34dkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g86Izy94yk4x+c9XDp1hHWc4cjkZAAv+u2RVbk1iSHpWUl5GyIUXvOYkzr6tek3tm
	 MAX6wh4StkP72jSjqlz032I8vSc/lr+wlK9imiT07W13MBX/4JFBxlHZR3ku01NalR
	 egjtoWAbk17bSSSOQLWiKjBGq3XoVzj4gucKZEPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/554] pmdomain: imx: Fix reference count leak in imx_gpc_probe()
Date: Thu, 15 Jan 2026 17:49:01 +0100
Message-ID: <20260115164303.494416876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/imx/gpc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
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


