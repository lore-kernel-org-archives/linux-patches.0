Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EE030E85C;
	Wed, 25 Feb 2026 06:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002663; cv=none; b=TM1DHSOyOyFreU50bMh3ZGOlUJ7OlVQb/2j1VpbJDN71J+s318fXRJYnyyhzfgEcwyEufMUjSe4HGaYzTzN5t864ZnbxSgpP2PK3szxmnp8oYoxOSXUI80GXcteCeXONXIcWdsP2m+bpZds9eSyZ8GBo+DAQr8dwaZurelUCd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002663; c=relaxed/simple;
	bh=3azyQwgygXlD/U+XDCmgt7RRnR39XUGr9q4PFEq0O/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCWyTfLvYCdhu2py2VCHJXLLZx621yIdsyOFS2u+138lWAIv4ezZW+qmu1XklwDv737rsljsBhUf2qzkYnMTpcq364OoyuBkLX1s9yCdgw5XFIK9tbVUJuim1Al6S5qT8rnJKSN37Srf6wVGP+Vyqkisf8+YKdYqyKx3UkfvjWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLCP1ZMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLCP1ZMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910C7C116D0;
	Wed, 25 Feb 2026 06:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002663;
	bh=3azyQwgygXlD/U+XDCmgt7RRnR39XUGr9q4PFEq0O/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLCP1ZMf4g8xLA3mKXgj90675R9FYHXgAa3jLNDsqBbd4iO5XFJEq+BarKY4BwFR1
	 hSxKIb5r5fmqIoHeDU2b4sdOkEZjP8E88NDqDJWDQtC/02LGIqKpCgc5n7OCwaLaUm
	 23PSsi85TF37TF6HUySNsAQwGUkpKz8E6844lbBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 443/641] clk: x86: cgu: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:49 -0800
Message-ID: <20260225012359.261395706@linuxfoundation.org>
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

[ Upstream commit bb1b0e63dbbd7150324cb4d6aef7854dbe26a617 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: f7a6bed91a19 ("clk: x86: cgu: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index d099667355f8d..92ee05d75af2b 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -137,10 +137,8 @@ static int lgm_clk_divider_determine_rate(struct clk_hw *hw,
 {
 	struct lgm_clk_divider *divider = to_lgm_clk_divider(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate, divider->table,
-				       divider->width, divider->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width,
+				      divider->flags);
 }
 
 static int
-- 
2.51.0



