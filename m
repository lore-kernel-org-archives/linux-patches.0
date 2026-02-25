Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BA624A05D;
	Wed, 25 Feb 2026 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983419; cv=none; b=SyMnSVI38Enzw8i8qptrngPxwU0hV5LrVGZgHIPjUISLBNnfAZQAcZgjz2aEDu5PW0YAEfW1OH64DZ9wKh74YQOKi+UFPvAyWGlXAeux8eSU7Jmgd2YBnzDMzmB8UB/Fdz2vR9lzHV5+OV81rhVXL/lPiYFB4u7X9MLjN/IoFNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983419; c=relaxed/simple;
	bh=orRUKr+fDhpA78H+ArWorE2IIpQn48L/uhEroSC9AMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWi2jcPxoY25oJSn6budKj/KF6kSBPDAbk6V54ycUM/GDfJGfQovptDusxTWg6Pnvzag75zdMevMb2R+v067qC8t1En6oeHKNbGGbqEw5t557LSp3rWy31jUswtWJae999ioIyjHyvQ85xo5YggI/GeclH00l7LyZ6MDl/nUEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKJ95gcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKJ95gcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CFFC116D0;
	Wed, 25 Feb 2026 01:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983419;
	bh=orRUKr+fDhpA78H+ArWorE2IIpQn48L/uhEroSC9AMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKJ95gcfmqA9WLAnm0eQZoKs7CKnlFEqt3VLNqQapjyHrRPNjiErR/7vJApM7MvtK
	 Z4GUII/bQ92RxqAis/pVmyHnO/oRSQGx8KJ3z69W3pfK4ROrzNSd4uj+enq6JxxcTH
	 /sqj353JOCtEPKuMT74Ra0cWeSmXPUlFxP0lwdLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 540/781] clk: actions: owl-divider: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:49 -0800
Message-ID: <20260225012413.042046783@linuxfoundation.org>
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

[ Upstream commit 3ff3360440fa8cc7ef5a4da628d3b770b46a4f73 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed. Additionally, owl_divider_helper_round_rate() is no longer used,
so let's drop that from the header file as well.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 1b04e12a8bcc ("clk: actions: owl-divider: convert from round_rate() to determine_rate()")
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-divider.c | 17 ++---------------
 drivers/clk/actions/owl-divider.h |  5 -----
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/actions/owl-divider.c b/drivers/clk/actions/owl-divider.c
index 118f1393c6780..316ace80e87e3 100644
--- a/drivers/clk/actions/owl-divider.c
+++ b/drivers/clk/actions/owl-divider.c
@@ -13,26 +13,13 @@
 
 #include "owl-divider.h"
 
-long owl_divider_helper_round_rate(struct owl_clk_common *common,
-				const struct owl_divider_hw *div_hw,
-				unsigned long rate,
-				unsigned long *parent_rate)
-{
-	return divider_round_rate(&common->hw, rate, parent_rate,
-				  div_hw->table, div_hw->width,
-				  div_hw->div_flags);
-}
-
 static int owl_divider_determine_rate(struct clk_hw *hw,
 				      struct clk_rate_request *req)
 {
 	struct owl_divider *div = hw_to_owl_divider(hw);
 
-	req->rate = owl_divider_helper_round_rate(&div->common, &div->div_hw,
-						  req->rate,
-						  &req->best_parent_rate);
-
-	return 0;
+	return divider_determine_rate(hw, req, div->div_hw.table,
+				      div->div_hw.width, div->div_hw.div_flags);
 }
 
 unsigned long owl_divider_helper_recalc_rate(struct owl_clk_common *common,
diff --git a/drivers/clk/actions/owl-divider.h b/drivers/clk/actions/owl-divider.h
index d76f58782c528..1d3bb4e5898a3 100644
--- a/drivers/clk/actions/owl-divider.h
+++ b/drivers/clk/actions/owl-divider.h
@@ -56,11 +56,6 @@ static inline struct owl_divider *hw_to_owl_divider(struct clk_hw *hw)
 	return container_of(common, struct owl_divider, common);
 }
 
-long owl_divider_helper_round_rate(struct owl_clk_common *common,
-				const struct owl_divider_hw *div_hw,
-				unsigned long rate,
-				unsigned long *parent_rate);
-
 unsigned long owl_divider_helper_recalc_rate(struct owl_clk_common *common,
 					 const struct owl_divider_hw *div_hw,
 					 unsigned long parent_rate);
-- 
2.51.0



