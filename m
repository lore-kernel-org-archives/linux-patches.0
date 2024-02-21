Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA8D6996B;
	Wed, 21 Feb 2024 13:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522838; cv=none; b=Hd1h4w+Pq5z9JSGv02ZBdjJ4aShEKFEPjiEgvM0enJEYfpwLLNNYvpD+ltOeQgV9Zbg34Eefw2H8G1C5ztbNp8bkPxP4/VZOFF8U9EAT6wd68KpRDQp+F45GH+HMW1rn0bJ++DGSVYcjM6kgnEk3/vC1AtEYPTjsBk2wYRlj9YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522838; c=relaxed/simple;
	bh=RPA0KEmgnY+9d367Oy2oeNb+CgJoItXhCDC9ChBL2o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPowHfvX7HOB42c9I66LFG0PK1CF7tsgHto4ViLcf2G88a3rVlOKISZhOMMtlIpth6SWrVDFi3xu07YFsmXCaTOY31lZ3aVvhKU9iBd+P8jKTwUgSr+eoXrRtw3hrtPqBPY88tIkbbVpaRJKSDz1FQXWU2DGw9v5f1cSqM2R8T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2Mcf0gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2Mcf0gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5DEC433C7;
	Wed, 21 Feb 2024 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522838;
	bh=RPA0KEmgnY+9d367Oy2oeNb+CgJoItXhCDC9ChBL2o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2Mcf0gRrm5OURztkxYuVnCPgc/pvHZnLlEFWlzSL/ifQjIqsTr2E9w0JXbrM2DYk
	 p4w9VcexhBgD+TBaqrjrMWxzBKT/v8/nUz644pjLaPyBXd9md3W4zXnDy92w/X+Aon
	 bWx1rQEDxR7lJ49P4hobU+pZCnZx69tSQBOQpI68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/476] clk: imx: scu: Fix memory leak in __imx_clk_gpr_scu()
Date: Wed, 21 Feb 2024 14:04:46 +0100
Message-ID: <20240221130016.582057044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1cee88b073fa..89a914a15d62 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -841,8 +841,10 @@ struct clk_hw *__imx_clk_gpr_scu(const char *name, const char * const *parent_na
 	if (!clk_node)
 		return ERR_PTR(-ENOMEM);
 
-	if (!imx_scu_clk_is_valid(rsrc_id))
+	if (!imx_scu_clk_is_valid(rsrc_id)) {
+		kfree(clk_node);
 		return ERR_PTR(-EINVAL);
+	}
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
 	if (!clk) {
-- 
2.43.0



