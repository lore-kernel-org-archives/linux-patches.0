Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA4A2D7D42;
	Wed, 25 Feb 2026 06:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002656; cv=none; b=TqbOMa79j7d6+Fstwq7WKb9VlSNZ24LUffY749OhnImMJAW9EEeGuc63Kz/fbbz5l9AI5/K9i6QD628Bqe06Op87CPiJwlRlMeKHYGlH8P1DkYjw7TZpv7NfZB3AXjBx1iMeJdEbT8FPj9OXvIbpHA6IdYzCEHV9yxvny4HXLfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002656; c=relaxed/simple;
	bh=Q2UL6blYJdZZuSzKbJM9Y+VShB8dDe1JwOV5yoN4tV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3UVKOp+uIVGgUki76NnvuotxyhVareh0ZOTTKxC8NAkD+xubxeLuF74N6bUcGBbFXkeh4UtZOPSmjEJATeo4E+8cXlmuAs/s9r8f7PmD+5Kqz2MVKcYrZKsfcC/fYUgpBZAjwrU8WCzYGTIri7d+V3s9DLoUDuDrALkoEdbjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJGYEpn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJGYEpn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C2DC116D0;
	Wed, 25 Feb 2026 06:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002656;
	bh=Q2UL6blYJdZZuSzKbJM9Y+VShB8dDe1JwOV5yoN4tV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJGYEpn+zMXdRPK9287C6cOjAfqMjjWZBFi1Np66T6/erU/xBRQtYGyk7nq4lsx55
	 k7gmMez/pT4WMOfk4RO0A4lLmQ2bUsEhlklWGrOP7VBhEJnB52SxBm1QdrE1bTdC6T
	 M3WeIqT2oTTwrwLJ1a1naHWKNImungRX2JuvnTOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 433/641] clk: hisilicon: clkdivider-hi6220: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:39 -0800
Message-ID: <20260225012359.031081557@linuxfoundation.org>
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

[ Upstream commit e3a5249c140a1ded55937ba04247d530a85f0edc ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 619a6210f398 ("clk: hisilicon: clkdivider-hi6220: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/clkdivider-hi6220.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/hisilicon/clkdivider-hi6220.c b/drivers/clk/hisilicon/clkdivider-hi6220.c
index 6bae18a84cb6c..fd7ceb92d6515 100644
--- a/drivers/clk/hisilicon/clkdivider-hi6220.c
+++ b/drivers/clk/hisilicon/clkdivider-hi6220.c
@@ -60,10 +60,8 @@ static int hi6220_clkdiv_determine_rate(struct clk_hw *hw,
 {
 	struct hi6220_clk_divider *dclk = to_hi6220_clk_divider(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate, dclk->table,
-				       dclk->width, CLK_DIVIDER_ROUND_CLOSEST);
-
-	return 0;
+	return divider_determine_rate(hw, req, dclk->table, dclk->width,
+				      CLK_DIVIDER_ROUND_CLOSEST);
 }
 
 static int hi6220_clkdiv_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



