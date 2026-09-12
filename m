Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF8C38F259;
	Sat, 12 Sep 2026 08:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201360; cv=none; b=JOEnq/6cpIIe50EHev/IUpRrfvToLRanTfXki7xLXrbi3NVZ6zRSvVYRTdjufBtsfUKnitw3vto2YqydKoJQTE1ZF4nQfATUxuH6AVHjlLcQnnML50B0tERrzBOfDrCZnDeDDJuLlHw8g1Y0FwcPCM2BJSUE/RSWC/Dqp8//x8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201360; c=relaxed/simple;
	bh=+2PCVvMvm72rEgX67j/XPKpLde4z3Io8LkWxmz+cr2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qD4nC7PFkzlwlRdrqSRrxupg7s/H5gN7Yc28loaFeWwq+DrHLg1ZAFA9QfhYbm8GC9G7HebCyfG/eUQhjwjD0+XU/puppvatAKhL8GCptxSC0+GzqA3aOOsqHl74ryqxiwq2U1K1MbykdhnzBj19VNLfQp8PmYomyCSR1FAoXVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJAbyL5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJAbyL5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649791F000FF;
	Sat, 12 Sep 2026 08:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201358;
	bh=zrIJsiwBjXsccBRpsgXQGZ+i8NF68+eYYaopSoJ7j3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJAbyL5VcoAWnVcdVkpeLtATiWKjbArd6ClgB1AdWvNYOApazi2GfSPTiGdMci086
	 wFzX4/9cF7hmzZFkwKopxMtoPWogmI5VSPHFvlCVb2X1KJg4eLt98DhxbuKvQvqDeR
	 0at0STcOzeFSDWqVlZZjUVPDhon6pCAHAzR2sui8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surendra Singh Chouhan <kr494167@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0980/1815] pinctrl: generic: free maps on pinctrl_generic_to_map() failure
Date: Sat, 12 Sep 2026 08:45:30 +0200
Message-ID: <20260912065711.997622378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surendra Singh Chouhan <kr494167@gmail.com>

[ Upstream commit 17007cd700601777d9ee203a13d97e64ece3a10f ]

pinctrl_generic_to_map() parses DT configuration and allocates pinctrl
maps via pinctrl_utils_reserve_map().

If subsequent steps (such as pinctrl_utils_add_map_mux(),
pinctrl_generic_add_group(), pinconf_generic_parse_dt_config(), or
pinctrl_utils_add_map_configs()) return an error, *maps may contain
partially allocated map entries. Returning the error directly without
freeing *maps leaks the allocated mapping memory across all drivers
that rely on pinctrl_generic_to_map().

Fix this by calling pinctrl_utils_free_map() and resetting *maps,
*num_maps, and *num_reserved_maps in the error path of
pinctrl_generic_to_map().

Fixes: aaaf31be0426 ("pinctrl: extract pinctrl_generic_to_map() from pinctrl_generic_pins_function_dt_node_to_map()")
Signed-off-by: Surendra Singh Chouhan <kr494167@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-generic.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-generic.c b/drivers/pinctrl/pinctrl-generic.c
index 9759b0186bcc2..fd6bdb74028aa 100644
--- a/drivers/pinctrl/pinctrl-generic.c
+++ b/drivers/pinctrl/pinctrl-generic.c
@@ -42,33 +42,44 @@ int pinctrl_generic_to_map(struct pinctrl_dev *pctldev, struct device_node *pare
 	ret = pinctrl_utils_add_map_mux(pctldev, maps, num_reserved_maps, num_maps, group_name,
 					parent->name);
 	if (ret < 0)
-		return ret;
+		goto err_free_map;
 
 	ret = pinctrl_generic_add_group(pctldev, group_name, pins, npins, data);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "failed to add group %s: %d\n",
+	if (ret < 0) {
+		dev_err_probe(dev, ret, "failed to add group %s: %d\n",
 				     group_name, ret);
+		goto err_free_map;
+	}
 
 	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs, &num_configs);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to parse pin config of group %s\n",
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to parse pin config of group %s\n",
 			group_name);
+		goto err_free_map;
+	}
 
 	if (num_configs == 0)
 		return 0;
 
 	ret = pinctrl_utils_reserve_map(pctldev, maps, num_reserved_maps, num_maps, reserve);
 	if (ret)
-		return ret;
+		goto err_free_map;
 
 	ret = pinctrl_utils_add_map_configs(pctldev, maps, num_reserved_maps, num_maps, group_name,
 					    configs,
 			num_configs, PIN_MAP_TYPE_CONFIGS_GROUP);
 	kfree(configs);
 	if (ret)
-		return ret;
+		goto err_free_map;
 
 	return 0;
+
+err_free_map:
+	pinctrl_utils_free_map(pctldev, *maps, *num_maps);
+	*maps = NULL;
+	*num_maps = 0;
+	*num_reserved_maps = 0;
+	return ret;
 };
 EXPORT_SYMBOL_GPL(pinctrl_generic_to_map);
 
-- 
2.53.0



