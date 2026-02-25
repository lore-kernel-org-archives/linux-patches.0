Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEEA30E855;
	Wed, 25 Feb 2026 06:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002663; cv=none; b=TCXKqmwNGNhYRyRN5e1CoS1S9i2oQlkOJaXE7reOInm+DkfoVSlEL5x8HZPJD6vRGQifqN0hnNsTz/IqyRSxKaIJB1AzqADuqCkwM2AYYLXuYBIg4uZ0gjC87fNCMWYiPDaZcgisKkCugXlqaDjnlUXazys4aHOJ6zSNDMxJR0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002663; c=relaxed/simple;
	bh=/I0SmMYjMia/YyDU9UIG5avovrarEiAAuioDaM9obVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw1/up0g8B9solh1W92D6BD6qu+OoiVKNnntfp5l9IgLK9B4WkVzN2xFlh3LWmxkcax1+KIFVGKgA547IBMDL/n8GMc49h3UZlR9gWhKFx4HP6TbUzTwrVqbVcdzsi3HQ8N/bkg8PtJJvYhW9lajeum+C/iNDDJXwFs7PsXdv4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg8m1fwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg8m1fwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE03C4AF09;
	Wed, 25 Feb 2026 06:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002663;
	bh=/I0SmMYjMia/YyDU9UIG5avovrarEiAAuioDaM9obVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg8m1fwIRB3dQHO20J9uqXWq3AV1YvbSK6cbKH5XfcwgqUyDEthokcIp9SAhlcf5O
	 kpSMIL01exFSYLk4/pXkGKb1Lp7q+5YUgNMBSrg2SYdCJhIuVrR5SxEIEtD1DEnXYa
	 8RODzc9HVCytbvlx5KyMUTJ9RADGemxZGnPfeRfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/641] clk: versaclock3: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:48 -0800
Message-ID: <20260225012359.238535382@linuxfoundation.org>
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

[ Upstream commit 56c1cfb488cc17944c200edad96191a70a3783ba ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 9e3372b2ebac ("clk: versaclock3: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock3.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-versaclock3.c b/drivers/clk/clk-versaclock3.c
index 1849863dbd673..27b6cf70f3ae1 100644
--- a/drivers/clk/clk-versaclock3.c
+++ b/drivers/clk/clk-versaclock3.c
@@ -523,11 +523,8 @@ static int vc3_div_determine_rate(struct clk_hw *hw,
 		return 0;
 	}
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       div_data->table,
-				       div_data->width, div_data->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, div_data->table, div_data->width,
+				      div_data->flags);
 }
 
 static int vc3_div_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



