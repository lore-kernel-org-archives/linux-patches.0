Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063226;
	b=vt1uuI4+S+ZlACrSo/1u6xEySyiwVtP+vBr+Qjx48V27EfMO/AnKM3kY7ql2Kcn8fDcF
	 AEXyCe3i2nNCZkeybCfq6XodFK4EBMjotbdAnIGBMcUlp11gjWHRchBST0KJACNz6/q9C
	 wjPyIH84bk9QE+7aBvaDmjSur3aEYvIBNMwBilWhXY+KGD02scWY//osMaPZEUo9dfon/
	 g1uITSbiH3pnODjHTsEZQS2RCAnfe/4pQbYJ3yoPzKFwvByQtpMT69BfElqCte6CdbuRa
	 vo3qKT0ELfOfXW9xCZrSDJZeItT5if7AjJlwiNl+SlRQuYcpUqlZGBtUAR2b+j+lfzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ewRbzkuF9tPqHPfWAyDqroBCCLQtTbp8KvnQ0uuF3qM=;
	b=KbKMI8N2f2YDibeEHiGcj5CJ1vu4Kt4qR2FWNfaB73lexvIvUs8QcPqOWQy86tLWlTYv
	 vmvMyhSG6wtEurx/bGr4525R+j3bo1rYNaxkonSCv/XhVHWHnOag9oCm+XGUnHczwWTvB
	 C4nDv7GG5MDSPj6yT119uBTn1dk69jqoAwF2QNt70EigdpldGH4dgB5ooTpPsRvAOz3WP
	 8lplSSw7HsFnPV02S8Sj5kioXtLrFEoN7zklY2FmLQ8njJezi2vgak22PJv9WEk746CyP
	 tYYbmWCbS9j5GQFWmsHlmPm67jcEzJ11AzNKDc4xOY9KFe0oetJtwaeKrigsPvobkLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQQsYfUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C04F606A326;
	Sat,  7 Nov 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQQsYfUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1801F0089F;
	Sat,  7 Nov 2026 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063226;
	bh=ewRbzkuF9tPqHPfWAyDqroBCCLQtTbp8KvnQ0uuF3qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQQsYfUbpQAFI9e22x9iPRAjAJ1O+zoGgd95MJvF5xECkD8Gf3VXNCboaGXwQELmb
	 o7NyHoCJJASPEGKOmLX13rXsMGl0MvhtX07z0WRuIbcNvatUd/oVwhXFhZdGaTS+AG
	 d7fZH85CZlRanOpVJUyrBh/XUm3cN2AsntAmy7EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 432/869] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Sat,  7 Nov 2026 08:51:54 -0500
Message-ID: <20261107134908.462092034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 8e177ca735761a1f03e1dedffd7ab00d6d0540ae ]

imx_get_clk_hw_by_name() obtains a consumer clock with
of_clk_get_by_name(), extracts the hardware pointer with __clk_get_hw()
and returns it without ever calling clk_put(), leaking the consumer
reference on both return paths.

Extract the hardware pointer first and drop the clock reference with
clk_put() before returning.

Fixes: 3b315214e091 ("clk: imx: implement new clk_hw based APIs")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260915055515.1730145-1-vulab@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index df83bd939492e..542b58ccf120b 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -119,12 +119,16 @@ struct clk_hw *imx_obtain_fixed_of_clock(struct device_node *np,
 struct clk_hw *imx_get_clk_hw_by_name(struct device_node *np, const char *name)
 {
 	struct clk *clk;
+	struct clk_hw *hw;
 
 	clk = of_clk_get_by_name(np, name);
 	if (IS_ERR(clk))
 		return ERR_PTR(-ENOENT);
 
-	return __clk_get_hw(clk);
+	hw = __clk_get_hw(clk);
+	clk_put(clk);
+
+	return hw;
 }
 EXPORT_SYMBOL_GPL(imx_get_clk_hw_by_name);
 
-- 
2.53.0



