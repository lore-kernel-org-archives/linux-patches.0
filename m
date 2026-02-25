Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAE3081C2;
	Wed, 25 Feb 2026 06:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002661; cv=none; b=CrN6WJ1IBH/2FSPwPzqFdyCXQRkIK8GkobYTu9MjEq+7i1cwgVZRbC7JEbhwmaDIvpsy1pR096WmUI29gr6UjplwEgnVsCf7mOoZwdCV6r8FjfC6qrS4WqMTMqLQcIYqLPIww+i6FX7HCnDTS0gz8VpSazb8MGgyaDZj/4NNLJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002661; c=relaxed/simple;
	bh=j483y+6UaDDOHUT9A7QrWwXm5f/oC2XCKQ1rCeYHOLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKNkrgaI+N7ckM2o/ZnCGNDKNE1tWogCwDZWylEO3IRiAAK4WyXDgAPV/jMXk/Vyb3LCB4uyVEs8MR9FHHX5ezC+dRfa+M78q24NyQqo/7s07OFkry50A4wVFr1uHVa3lYKjd/PT/L4WbZfiXAe/nGL8U093gNgtxjo4zrA14G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGDGPvfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGDGPvfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC454C19425;
	Wed, 25 Feb 2026 06:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002661;
	bh=j483y+6UaDDOHUT9A7QrWwXm5f/oC2XCKQ1rCeYHOLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGDGPvfL/MvKGgk/ZFF3kR4lj6aGLQ9ycmy+MAMtb0wFL49iS7gbusULtJHkM6x4s
	 ckNoe3XZyPDptqu/q2ftJqU3UyNCqvmCdwGBxVYx+y8Gt+AuKrCLCjXpf1MBitBUeC
	 xh7s0ovsspUVa1kKW+kU9zGXhNu6UxltMBO5WJZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/641] clk: sprd: div: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:45 -0800
Message-ID: <20260225012359.170158624@linuxfoundation.org>
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

[ Upstream commit f78fb9422980ceeb340fa3a2e370ae8845798ec7 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: deb4740a5ff8 ("clk: sprd: div: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/div.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clk/sprd/div.c b/drivers/clk/sprd/div.c
index 0134238819680..cd57163a7204c 100644
--- a/drivers/clk/sprd/div.c
+++ b/drivers/clk/sprd/div.c
@@ -14,11 +14,7 @@ static int sprd_div_determine_rate(struct clk_hw *hw,
 {
 	struct sprd_div *cd = hw_to_sprd_div(hw);
 
-	req->rate = divider_round_rate(&cd->common.hw, req->rate,
-				       &req->best_parent_rate,
-				       NULL, cd->div.width, 0);
-
-	return 0;
+	return divider_determine_rate(&cd->common.hw, req, NULL, cd->div.width, 0);
 }
 
 unsigned long sprd_div_helper_recalc_rate(struct sprd_clk_common *common,
-- 
2.51.0



