Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CA23DAAD8;
	Wed, 30 Sep 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793945; cv=none; b=EL344LRGXOw9Kad/sobQyVywJ86VhOBX3afdI/cqkJyOEB0ZBiv2YuaoaZuTglnUtvpnF2nWDyG/97FFx6IIBvE8Nt5CATh/vQ5Nn0SGUl1EBObHNvktxO8ejJBFWf5EOs9vKIWtpoexMgagXil0UNzSaLerebe3IdYQsit/dG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793945; c=relaxed/simple;
	bh=NiLzp6tHZ0RX96eWbz7M1vb34hcGQx4cNB05MvmSHg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeg/Eg1k5X5mR78e0JiKYnkv8VkrWsDuGwDTWNrc5BSUN1+oN2GB478UFpgYn2BA3qk9wVSl/Pp8w0th95vznIOFjupm3jiJ9a+r6xkqx7hMucJMwyTcNt75Fy/Cpgm3h97gbXyHP6suP8IKDQJtYtS9Md7xCjDhoH2e+PMxzus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcoGY8Wf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcoGY8Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987981F00898;
	Wed, 30 Sep 2026 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793944;
	bh=zH6MpSKOrizdiveKUxTxfYNiiKD18sEpP3UKQqE74Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcoGY8WfSDJOmPWrX9p1QKHJUpKYlFj4NgxxReO4gJrGs9pdoKJJsiu8dA/ni3e8Y
	 gsOebsQ1ce0xAjV2iWsaqK2/v/ZmMAabhX+wuF78/kR9xTQH2dIe068hGPaBrmiqqi
	 wad//R6JeDDZ9yxBlso1YfFM0iNtgozq9iE9H0Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0036/1193] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Wed, 30 Sep 2026 17:12:00 +0200
Message-ID: <20260930152435.087707403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7f0c422c7fbfd9294ff9321ada0c63561e5c6ea0 ]

The number of clock cells is not validated in the clock provider's
clk_src_get() callback.  Add the missing check.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/46e010659ffdffd5e3541369f3b65d43ebe236ec.1777562043.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 0f558d94750f1..9f29c49b6b056 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -278,6 +278,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
 	struct clk *clk;
 	int range_check;
 
+	if (clkspec->args_count != 2)
+		return ERR_PTR(-EINVAL);
+
 	switch (clkspec->args[0]) {
 	case CPG_CORE:
 		type = "core";
-- 
2.53.0



