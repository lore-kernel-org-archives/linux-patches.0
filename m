Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492251012;
	Sat,  3 Feb 2024 04:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933888; cv=none; b=ofUHf46Are3W//TQ+PIrUlhyySr4/z/ytqtHktOtCiba/2ovYMNqcE4VJc9BMpkz7ewdh8YUlKaxB05/NLboXK2DnO9NJvnux9OzhAWrt6Y52auNuNIaqqHLM+rZ4sa+Na2vThlF35/hiDb2tiP5Uz63cnexRO4+a4wmGZChJls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933888; c=relaxed/simple;
	bh=kgmbrckL5nYu8Sa7GqMvQuy3ho6raDwPFRShrNLeo1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOzVncOBqvMwZGmbUdc7PnPXoYeP3oyOHfKFcndn7vZNgW70NW+PyfDc7qYk43JWTfqBlFcEFGBjdkLDJHTweGSDkPYSGoJ+zWztgTaCoLxz4mcMax41hfwWwUsH6ynY1w4OgccNNNbM+MIfO/aSRmRObGP45u/TYvPGGCBnRAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9Av7WaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9Av7WaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1422C433C7;
	Sat,  3 Feb 2024 04:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933888;
	bh=kgmbrckL5nYu8Sa7GqMvQuy3ho6raDwPFRShrNLeo1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9Av7WaIiyt/Lk+r7mdsF2P9tg+1IS8cNTibZtfF7mj00iPbdTlGHqAZiwuK++aSt
	 mw1XYd37CGqrq3WnMRy0A2ppTLDty68CNxRzmCDd72FKjM//qcPIVAvoQ8RAHZ60to
	 J2wFf5/vV5+3ETI7D7+4jnZJjSQmxa2QZbs49+fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 224/353] clk: imx: scu: Fix memory leak in __imx_clk_gpr_scu()
Date: Fri,  2 Feb 2024 20:05:42 -0800
Message-ID: <20240203035410.757839321@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 21c0efbcb45cf94724d17b040ebc03fcd4a81f22 ]

In cases where imx_clk_is_resource_owned() returns false, the code path
does not handle the failure gracefully, potentially leading to a memory
leak. This fix ensures proper cleanup by freeing the allocated memory
for 'clk_node' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/all/20231210171907.3410922-1-visitorckw@gmail.com/
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index be89180dd19c..e48a904c0013 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -886,8 +886,10 @@ struct clk_hw *__imx_clk_gpr_scu(const char *name, const char * const *parent_na
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (!imx_clk_is_resource_owned(rsrc_id))
+	if (!imx_clk_is_resource_owned(rsrc_id)) {
+		kfree(clk_node);
 		return NULL;
+	}
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
 	if (!clk) {
-- 
2.43.0



