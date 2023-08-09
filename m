Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC89D14A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AED7C433C7;
	Wed,  9 Aug 2023 10:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578259;
	bh=yjb+DL6XkIoN0iV3XWxSpWjgrrfESiZWTyArR9z9F0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfVs74VhURYe9Q/X2AyXaJ0/5t4d1yA2Ellmsmvzil3BmzSr/gP/Lg+ftheAabJt7
	 zsx8PtWiFU9U1Ef9oEf7/+yToi/IRrAHsndXU4y7ulTGzv08oxegYtBMYKD+aX96pO
	 tlTWrMc7CPFTR0nqgv8IJQQbRd7f+3l7Ge+lDIFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Peng Fan <peng.fan@nxp.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.4 133/165] clk: imx93: Propagate correct error in imx93_clocks_probe()
Date: Wed,  9 Aug 2023 12:41:04 +0200
Message-ID: <20230809103647.167080790@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit a29b2fccf5f2689a9637be85ff1f51c834c6fb33 upstream.

smatch reports:

    drivers/clk/imx/clk-imx93.c:294 imx93_clocks_probe() error: uninitialized symbol 'base'.

Indeed, in case of an error, the wrong (yet uninitialized) variable is
converted to an error code and returned.
Fix this by propagating the error code in the correct variable.

Fixes: e02ba11b45764705 ("clk: imx93: fix memory leak and missing unwind goto in imx93_clocks_probe")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/9c2acd81-3ad8-485d-819e-9e4201277831@kadam.mountain
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202306161533.4YDmL22b-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230711150812.3562221-1-geert+renesas@glider.be
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-imx93.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -291,7 +291,7 @@ static int imx93_clocks_probe(struct pla
 	anatop_base = devm_of_iomap(dev, np, 0, NULL);
 	of_node_put(np);
 	if (WARN_ON(IS_ERR(anatop_base))) {
-		ret = PTR_ERR(base);
+		ret = PTR_ERR(anatop_base);
 		goto unregister_hws;
 	}
 


