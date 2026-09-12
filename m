Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A82365A0B;
	Sat, 12 Sep 2026 09:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204188; cv=none; b=jz7uIfXW6C+6+giOfxwvYnPapFcrRYe9RY5RfAyJMEvjuHKt+aV3x7wFPInLfZ1T2RzRwVB4P26dKq59DOROa5Qycb69McgEaWNWQCO5YmuzLcBS1H+fsYb4yxDSKJwyCZlzFRtOnAZQlxJ8U/CnTf0edZI7cFEsLdOOgJ4N6nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204188; c=relaxed/simple;
	bh=X40qk/ddFowRz+xyv1U3iKAfNijfVtw9pp+SvEagcSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p2ClwOYoRqEx7kVEyYn6JqHmVL6lO8i2ei1A/TkTY0FPLhdn/SrmDlV215R0kPGDD8Kx0m66igGG5gBH0dcn90upEDN9/NPrMf4C4a3Zoy+8jnzolKfrPH21GtwsRP1LEQVbci7FChqTosmYBDpATPDLZZLNmWfrSngHsh3aQn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ike2bBQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ike2bBQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688251F000FF;
	Sat, 12 Sep 2026 09:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204187;
	bh=0KK78DtxUEqbMPMW0JV+fxBElY2vug3plH+C46CuS9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ike2bBQi2qp7zZ4Q3nrF2i8uofFZOS9ZMsYo54nKIDSmIF+KYD+Cxm8CmTGRG9ZNE
	 OuX81IdGvh0sD2StDAm3wgLOSvaBVRd6ttdDJS/0zH5gbxh9oGTF3zX45c5XsASPVI
	 q7yzqRbh5rUG7ABu53SSKmPrKeJMW3xhthVSDXI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1554/1815] clk: devres: fix cleanup in devm_clk_get_optional_enabled_with_rate()
Date: Sat, 12 Sep 2026 08:55:04 +0200
Message-ID: <20260912065725.479032971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Onur Özkan <work@onurozkan.dev>

[ Upstream commit 0d4d262c1664365e17e0a5ba2ab79f4db484b44e ]

devm_clk_get_optional_enabled_with_rate() registers its cleanup action
before setting the clock rate. If setting the rate fails, it attempts to
disable and unprepare a clock that was never enabled. This issue was
spotted while reviewing "rust: clk: add devres-managed clks" [1].

Register the cleanup action only after successfully preparing and enabling
the clock.

[1]: https://lore.kernel.org/rust-for-linux/20260706-clk-type-state-v5-3-67c5f326a16c@collabora.com

Fixes: 9934a1bd45b2 ("clk: provide devm_clk_get_optional_enabled_with_rate()")
Signed-off-by: Onur Özkan <work@onurozkan.dev>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-devres.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 994d5bc5168be..697d102449c10 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -99,6 +99,11 @@ struct clk *devm_clk_get_optional_enabled(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(devm_clk_get_optional_enabled);
 
+static void devm_clk_disable_unprepare(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
 struct clk *devm_clk_get_optional_enabled_with_rate(struct device *dev,
 						    const char *id,
 						    unsigned long rate)
@@ -106,8 +111,7 @@ struct clk *devm_clk_get_optional_enabled_with_rate(struct device *dev,
 	struct clk *clk;
 	int ret;
 
-	clk = __devm_clk_get(dev, id, clk_get_optional, NULL,
-			     clk_disable_unprepare);
+	clk = devm_clk_get_optional(dev, id);
 	if (IS_ERR(clk))
 		return ERR_CAST(clk);
 
@@ -119,6 +123,10 @@ struct clk *devm_clk_get_optional_enabled_with_rate(struct device *dev,
 	if (ret)
 		goto out_put_clk;
 
+	ret = devm_add_action_or_reset(dev, devm_clk_disable_unprepare, clk);
+	if (ret)
+		goto out_put_clk;
+
 	return clk;
 
 out_put_clk:
-- 
2.53.0



