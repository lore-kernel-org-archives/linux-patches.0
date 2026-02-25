Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CA3309EF2;
	Wed, 25 Feb 2026 06:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002660; cv=none; b=fkfKsJSSAXHBROCnFWCRM/RFccDov7USVdCGHxQl902o0YHqqEWUmUcXg68Vr2SB/QTERvaNz3WL/55TWlxaMCfOA48b09ibU5kH7mzzJ05O/aFgdRCv7BOc1JCzTD7QnmnSReGGbFY0Ztkj1FI/ixLROnGfbiyX50Rxz0MGsTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002660; c=relaxed/simple;
	bh=n4vdjzT5NuWeUnqKtc0883EjwIFpcQ4+1lUh4+iYqaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpZFa21cbOmJMPhSci4KqSQngzv6nSgIW7j0FYMUjdDApQEp74NGUCk6Sxs/IwkBE7hkIgtneImpnbX7FuuXIhk/JYwvnu3BwLoXEKbiFfLunYt7hszsnF2lgdunr5SLCNivDxlaflEGmjNiIKdiKd0v2R0Y5OGAfIZKEG69glU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFJArp8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFJArp8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5DAC116D0;
	Wed, 25 Feb 2026 06:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002660;
	bh=n4vdjzT5NuWeUnqKtc0883EjwIFpcQ4+1lUh4+iYqaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFJArp8MyTMK+yU022o61mjvnYdZWIWbTIgC4iraWvLql25olFm5tTUYfvkZlYZqq
	 H8C/omlwSK9715DbLQ7M6BavS+f9cGZVSNOQ9roOR1nHruu0UPfwhPMyl0dMw7ptvT
	 kLXB2/cm01MuKWlPcPiJFpvEFH/flabAYaSmXjGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Wang <unicorn_wang@outlook.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 438/641] clk: sophgo: sg2042-clkgen: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:44 -0800
Message-ID: <20260225012359.146868496@linuxfoundation.org>
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

[ Upstream commit 77b04dc19693510ce8ed1c6eda5f5b833e208816 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Note that this commit also removes a debugging message that's not really
needed.

Fixes: 9a3b6993613d ("clk: sophgo: sg2042-clkgen: convert from round_rate() to determine_rate()")
Tested-by: Chen Wang <unicorn_wang@outlook.com>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sophgo/clk-sg2042-clkgen.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/sophgo/clk-sg2042-clkgen.c b/drivers/clk/sophgo/clk-sg2042-clkgen.c
index 683661b71787c..9725ac4e050a4 100644
--- a/drivers/clk/sophgo/clk-sg2042-clkgen.c
+++ b/drivers/clk/sophgo/clk-sg2042-clkgen.c
@@ -180,7 +180,6 @@ static int sg2042_clk_divider_determine_rate(struct clk_hw *hw,
 					     struct clk_rate_request *req)
 {
 	struct sg2042_divider_clock *divider = to_sg2042_clk_divider(hw);
-	unsigned long ret_rate;
 	u32 bestdiv;
 
 	/* if read only, just return current value */
@@ -191,17 +190,13 @@ static int sg2042_clk_divider_determine_rate(struct clk_hw *hw,
 			bestdiv = readl(divider->reg) >> divider->shift;
 			bestdiv &= clk_div_mask(divider->width);
 		}
-		ret_rate = DIV_ROUND_UP_ULL((u64)req->best_parent_rate, bestdiv);
-	} else {
-		ret_rate = divider_round_rate(hw, req->rate, &req->best_parent_rate, NULL,
-					      divider->width, divider->div_flags);
-	}
+		req->rate = DIV_ROUND_UP_ULL((u64)req->best_parent_rate, bestdiv);
 
-	pr_debug("--> %s: divider_round_rate: val = %ld\n",
-		 clk_hw_get_name(hw), ret_rate);
-	req->rate = ret_rate;
+		return 0;
+	}
 
-	return 0;
+	return divider_determine_rate(hw, req, NULL, divider->width,
+				      divider->div_flags);
 }
 
 static int sg2042_clk_divider_set_rate(struct clk_hw *hw,
-- 
2.51.0



