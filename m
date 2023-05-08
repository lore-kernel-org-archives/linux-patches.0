Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051371094C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772D4C4339B;
	Mon,  8 May 2023 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545066;
	bh=688oAdaoia6vhS8BOwDju/MvGwh4vRXuVLNxnNS7n5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlf4v9DbNh3vGNNw36JJT3iJOEeaqr3lnLv5/3OH4xF/bMK/0kwIFQDbIFcp4RHa5
	 NH+as03yuK+PCSvaSLAifjjgwMP3QPXtcZVmsnaDF5Z5sYWe2+hbT2eTStB4R/PkQs
	 5Q03hPtE7zSJcQNZLZxvwkaBcokBt/kQOvcwh8yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 582/694] clk: mediatek: clk-pllfh: fix missing of_node_put() in fhctl_parse_dt()
Date: Mon,  8 May 2023 11:46:57 +0200
Message-Id: <20230508094453.864254552@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f1d97a37f975ac615e4d6875c27516150642d499 ]

The device_node pointer returned by of_find_compatible_node() with
refcount incremented, when finish using it, the refcount need be
decreased.

Fixes: d7964de8a8ea ("clk: mediatek: Add new clock driver to handle FHCTL hardware")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221229092946.4162345-1-yangyingliang@huawei.com
[sboyd@kernel.org: Also unmap on error]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-pllfh.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mediatek/clk-pllfh.c b/drivers/clk/mediatek/clk-pllfh.c
index f48780bec5077..f135b32c6dbed 100644
--- a/drivers/clk/mediatek/clk-pllfh.c
+++ b/drivers/clk/mediatek/clk-pllfh.c
@@ -75,13 +75,13 @@ void fhctl_parse_dt(const u8 *compatible_node, struct mtk_pllfh_data *pllfhs,
 	base = of_iomap(node, 0);
 	if (!base) {
 		pr_err("%s(): ioremap failed\n", __func__);
-		return;
+		goto out_node_put;
 	}
 
 	num_clocks = of_clk_get_parent_count(node);
 	if (!num_clocks) {
 		pr_err("%s(): failed to get clocks property\n", __func__);
-		return;
+		goto err;
 	}
 
 	for (i = 0; i < num_clocks; i++) {
@@ -102,6 +102,13 @@ void fhctl_parse_dt(const u8 *compatible_node, struct mtk_pllfh_data *pllfhs,
 		pllfh->state.ssc_rate = ssc_rate;
 		pllfh->state.base = base;
 	}
+
+out_node_put:
+	of_node_put(node);
+	return;
+err:
+	iounmap(base);
+	goto out_node_put;
 }
 
 static void pllfh_init(struct mtk_fh *fh, struct mtk_pllfh_data *pllfh_data)
-- 
2.39.2



