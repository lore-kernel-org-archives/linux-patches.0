Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B524D522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3173DC433C8;
	Sun,  9 Jul 2023 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902229;
	bh=bWAkDfDK2FZoit3t0CvM1Fh5j1tQCps5OwpjAk4ySL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVcGQnmlZoYYXXBeAmg7lufKc8qX0q/9HNwv2akrCMe0xudsDy5GBpvdpEw+hFKWc
	 8MqgpCfthJB8Ds4Xl4nzyFRzNcwltvrUmuPS4KAOJywSDZJ377EX21259XMusimiLQ
	 cITk8hJAiui5pVm6VgMN/EQvL6iURjGqBEKzBsXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Thierry Reding <treding@nvidia.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 301/431] clk: tegra: tegra124-emc: Fix potential memory leak
Date: Sun,  9 Jul 2023 13:14:09 +0200
Message-ID: <20230709111458.198315963@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 53a06e5924c0d43c11379a08c5a78529c3e61595 ]

The tegra and tegra needs to be freed in the error handling path, otherwise
it will be leaked.

Fixes: 2db04f16b589 ("clk: tegra: Add EMC clock driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221209094124.71043-1-yuancan@huawei.com
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index 219c80653dbdb..2a6db04342815 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -464,6 +464,7 @@ static int load_timings_from_dt(struct tegra_clk_emc *tegra,
 		err = load_one_timing_from_dt(tegra, timing, child);
 		if (err) {
 			of_node_put(child);
+			kfree(tegra->timings);
 			return err;
 		}
 
@@ -515,6 +516,7 @@ struct clk *tegra124_clk_register_emc(void __iomem *base, struct device_node *np
 		err = load_timings_from_dt(tegra, node, node_ram_code);
 		if (err) {
 			of_node_put(node);
+			kfree(tegra);
 			return ERR_PTR(err);
 		}
 	}
-- 
2.39.2



