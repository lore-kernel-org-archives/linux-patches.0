Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75603256C8B;
	Wed, 25 Feb 2026 01:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983430; cv=none; b=jrdAjTlqX103QIkcjJL6/H6Ph7Fd8QuYNG+Nzz/rbifh4c/0YFuE1WtW/m3X+SxdqiLamo5EgC8ljrTwT2AigfccleD+YEGM7S9NZ21o+5/eOCiUqC90rrr3sL2VoxZ0pyYWQ2RAHZBeMxx8oI4qpJCIVDiyxwnyi1AdrirZMpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983430; c=relaxed/simple;
	bh=rjw9fA4Hm0yiZxPo6F5CU/vDo3QuhH7VGCLHUV7JIck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUZjVGjAKSXu3ungKs87LeEGrbDiNoBJG6M+3fcUlkFN/aSYbysX86j9wd4D//jIaG+mWt0ElN7UvEr3uINOy0+WaerxCor1ETL2vLf92i2R9Lbbg8wZCLnBMdqu1OevX6ksoFx9dLTqXRnMqNK22gYtNO1cxh78crNWafsplxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3eid5Pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3eid5Pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8A9C116D0;
	Wed, 25 Feb 2026 01:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983430;
	bh=rjw9fA4Hm0yiZxPo6F5CU/vDo3QuhH7VGCLHUV7JIck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3eid5PkAmh4v4vKZBwAjz/6gTg+jm7vlx6JEuCw9kAzsKvWxacHg6EsI8y2ldljX
	 4eXZuu7lmYxA96Jl64AMo3R8mSb5pnoImtrdOJbM26t7a4SksQqBH5FItTkprDxswn
	 U4Puu1rtBLiGLBUBt8KtaUw2uZv/6Gv6KDvidoAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 549/781] clk: stm32: stm32-core: convert from divider_ro_round_rate() to divider_ro_determine_rate()
Date: Tue, 24 Feb 2026 17:20:58 -0800
Message-ID: <20260225012413.268351412@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 6587c9dacc89ad7014bf601fe851955429f13230 ]

The divider_ro_round_rate() function is now deprecated, so let's migrate
to divider_ro_determine_rate() instead so that this deprecated API can
be removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: cd1cb38836c0 ("clk: stm32: stm32-core: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/stm32/clk-stm32-core.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/stm32/clk-stm32-core.c b/drivers/clk/stm32/clk-stm32-core.c
index 72825b9c36a4d..b95b9c591fda7 100644
--- a/drivers/clk/stm32/clk-stm32-core.c
+++ b/drivers/clk/stm32/clk-stm32-core.c
@@ -369,13 +369,10 @@ static int clk_stm32_divider_determine_rate(struct clk_hw *hw,
 		val =  readl(div->base + divider->offset) >> divider->shift;
 		val &= clk_div_mask(divider->width);
 
-		req->rate = divider_ro_round_rate(hw, req->rate,
-						  &req->best_parent_rate,
-						  divider->table,
-						  divider->width,
-						  divider->flags, val);
-
-		return 0;
+		return divider_ro_determine_rate(hw, req,
+						 divider->table,
+						 divider->width,
+						 divider->flags, val);
 	}
 
 	req->rate = divider_round_rate_parent(hw, clk_hw_get_parent(hw),
@@ -455,14 +452,9 @@ static int clk_stm32_composite_determine_rate(struct clk_hw *hw,
 		val =  readl(composite->base + divider->offset) >> divider->shift;
 		val &= clk_div_mask(divider->width);
 
-		rate = divider_ro_round_rate(hw, req->rate, &req->best_parent_rate,
-					     divider->table, divider->width, divider->flags,
-					     val);
-		if (rate < 0)
-			return rate;
-
-		req->rate = rate;
-		return 0;
+		return divider_ro_determine_rate(hw, req, divider->table,
+						 divider->width, divider->flags,
+						 val);
 	}
 
 	rate = divider_round_rate_parent(hw, clk_hw_get_parent(hw),
-- 
2.51.0



