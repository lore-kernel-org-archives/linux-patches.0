Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0B28B517;
	Sat, 12 Sep 2026 08:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200071; cv=none; b=tYVVs/VWEJUrWi0GGz2ZLbIogI4AEyszbWVSaAfJAV3a8ktAI8ZWQg5sf0wKFVetE9rSyNjWir6gr2vbIkOadCtqmGoDl83pbk9aSgaBsJMdfYEjll6t7pWF/T4KWIe9tqBl4wEu959+J9Y1+nCsvFZ/rGNjQU4DB29EiRiPiaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200071; c=relaxed/simple;
	bh=6uFYE/lIL5apwU+LEMva5lTJSLHxN2U3ywLwM8vOJXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiTA+uQxWYQuDF7ofWp+z8ZHQIhp33MYYzbm+PSTwHWxWZITI1xJNyohIK5OgIVwqz+gBDsFpk2WK838WWG6rrBryUESX03dqaQSMGeJx34Ts3T7CmZ9/YYqPrZrBKz7DNQRjhwjla5CJYXVBc5BDygGim/AixCB9hAyrSTGkqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGiTvm/i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGiTvm/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB971F000FF;
	Sat, 12 Sep 2026 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200070;
	bh=iaWzszh1iHfolScTMH7rUAKgbWapNdjAvJ5eSalT+0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGiTvm/i9gORUxtHAlTT91BIjPguvsm24IDxpfh2HXA/B6o2Z6+S0ceKuRCZUBIwa
	 FVMqhka3LOTJg1MfWW6X/7YhwJ6TqpqQ498VpfnL2OrhNhxrT6Jqrh9ju0F5bKvvMw
	 Dl1fVj1rHRY5oqe9qVCQjIfPfdBV6X+mWq8kRF28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0714/1815] clk: tegra: tegra124-emc: put EMC node on register failure
Date: Sat, 12 Sep 2026 08:41:04 +0200
Message-ID: <20260912065705.659346860@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f726279f5eab813f9a8b6f38ddf2a4b062d038ff ]

tegra124_clk_register_emc() stores a device node reference returned by
of_parse_phandle() in tegra->emc_node.

If clk_register() fails, the function returns an error before that
reference can be consumed and released by the normal runtime path. The
tegra_clk_emc object is freed on this failure path, but freeing the
object does not drop the OF node reference stored in it.

Drop the EMC node reference before freeing the tegra_clk_emc object.
of_node_put() is safe for a NULL node, so this also covers the case where
the phandle is absent.

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index f3b2c96fdcfc2..94ac24ea1e6ad 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -537,6 +537,7 @@ struct clk *tegra124_clk_register_emc(void __iomem *base, struct device_node *np
 
 	clk = clk_register(NULL, &tegra->hw);
 	if (IS_ERR(clk)) {
+		of_node_put(tegra->emc_node);
 		kfree(tegra);
 		return clk;
 	}
-- 
2.53.0



