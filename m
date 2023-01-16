Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19FD46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53538C433EF;
	Mon, 16 Jan 2023 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886419;
	bh=YRB7LULLjg1RZAf4ZJkr7VcQB7304qoXiHfCRF+n0jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMgim9duSxs7itgoAjd4jxbkYIjzwOprYIilYM7QoMQyrs0gfZc9SOGSNAhd7Q8hI
	 ULMsS2kE26U1dsnRiiXZyfGWPO+U7jSMpp51ViV+78LQ5lAqlW+HdQx0BMkaPjyZsO
	 h4Nd5YTRDB1RGeHPA0LfS7eP36c4itelx+kc/lrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 424/658] clk: st: Fix memory leak in st_of_quadfs_setup()
Date: Mon, 16 Jan 2023 16:48:32 +0100
Message-Id: <20230116154928.989913269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit cfd3ffb36f0d566846163118651d868e607300ba ]

If st_clk_register_quadfs_pll() fails, @lock should be freed before goto
@err_exit, otherwise will cause meory leak issue, fix it.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221122133614.184910-1-xiujianfeng@huawei.com
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/st/clkgen-fsyn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index a156bd0c6af7..9eff05386ef9 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -943,9 +943,10 @@ static void __init st_of_quadfs_setup(struct device_node *np,
 
 	clk = st_clk_register_quadfs_pll(pll_name, clk_parent_name, data,
 			reg, lock);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		kfree(lock);
 		goto err_exit;
-	else
+	} else
 		pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
 			__clk_get_name(clk_get_parent(clk)),
-- 
2.35.1



