Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A173033CB;
	Wed, 25 Feb 2026 06:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002662; cv=none; b=sm/w84jYjyftrCaJlaZF6dCshLbV8KskYGL5uqyjpozKLff2kykbzlYNi48G4pp7TlX3StDb8K14kRugEr/yIwxoI07DjXxvBdcNccHPk11iwquMErPWT26U/8P+K9xpa6nnbe4CWVNVHn84BF4Lcrt7vpcpO9IT5Bq4tab89uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002662; c=relaxed/simple;
	bh=Dr2pkKmvCzGcMz3r+ZxTJvcbsVaCB1QxLAmDO7CaZbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGbeHk2z98RbY7GvORMLmwqIk1D00qrucDbgIa85AgARD9RV814ITw7FYJemHdqDwSMKpCHjxMHWlGz75TSzMCUwX4MC2FG2RUCuDz6IUzwOqXwIYMuO7iwVgckm0vhkOQpxwo17GxLA2hl8XcSFmfNlt5oBWy38h04/VCOdu44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0Gspu8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0Gspu8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6F7C116D0;
	Wed, 25 Feb 2026 06:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002662;
	bh=Dr2pkKmvCzGcMz3r+ZxTJvcbsVaCB1QxLAmDO7CaZbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0Gspu8hm24Dc0/GPUZQCRrNbZk5KmssU6gfAWcOfKngZ0wWDOZyJxH4+rj05jB1E
	 pm28+2DmN2p8a7l4FlJELG77Jk/Bi8vRcrgmEIzMntVIXxQX6E9LQSzxAakXDG95mV
	 25Qm7n91mj3aQkIS5ufU/EduDdOVx96hYtZUa3CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/641] clk: stm32: stm32-core: convert from divider_round_rate_parent() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:47 -0800
Message-ID: <20260225012359.214459259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 2532795a6d6bb9791d713ffa9d9433f293b45b14 ]

The divider_round_rate_parent() function is now deprecated, so let's
migrate to divider_determine_rate() instead so that this deprecated API
can be removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: cd1cb38836c0 ("clk: stm32: stm32-core: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/stm32/clk-stm32-core.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/stm32/clk-stm32-core.c b/drivers/clk/stm32/clk-stm32-core.c
index b95b9c591fda7..e921c25a929c3 100644
--- a/drivers/clk/stm32/clk-stm32-core.c
+++ b/drivers/clk/stm32/clk-stm32-core.c
@@ -375,13 +375,8 @@ static int clk_stm32_divider_determine_rate(struct clk_hw *hw,
 						 divider->flags, val);
 	}
 
-	req->rate = divider_round_rate_parent(hw, clk_hw_get_parent(hw),
-					      req->rate,
-					      &req->best_parent_rate,
-					      divider->table,
-					      divider->width, divider->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width,
+				      divider->flags);
 }
 
 static unsigned long clk_stm32_divider_recalc_rate(struct clk_hw *hw,
@@ -438,7 +433,6 @@ static int clk_stm32_composite_determine_rate(struct clk_hw *hw,
 {
 	struct clk_stm32_composite *composite = to_clk_stm32_composite(hw);
 	const struct stm32_div_cfg *divider;
-	long rate;
 
 	if (composite->div_id == NO_STM32_DIV)
 		return 0;
@@ -457,14 +451,8 @@ static int clk_stm32_composite_determine_rate(struct clk_hw *hw,
 						 val);
 	}
 
-	rate = divider_round_rate_parent(hw, clk_hw_get_parent(hw),
-					 req->rate, &req->best_parent_rate,
-					 divider->table, divider->width, divider->flags);
-	if (rate < 0)
-		return rate;
-
-	req->rate = rate;
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width,
+				      divider->flags);
 }
 
 static u8 clk_stm32_composite_get_parent(struct clk_hw *hw)
-- 
2.51.0



