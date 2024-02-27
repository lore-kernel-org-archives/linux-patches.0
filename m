Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB21F13B2A2;
	Tue, 27 Feb 2024 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042773; cv=none; b=fGxKiFsvVCVoCbOPhdC1d73X+aOBHcnbiA9iQgrG7dAoOcLVE+9HwsVe6KspWYS4gGuqrADKAGkLtcU51fo1QkIdfzs7F1s4lJ2arKjriMJ211cY8pUAjJ0kEzwDf+loMgi2O0TNuLbBZbmM8kncIfS46jmi9Tluy/xGo/Bbdj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042773; c=relaxed/simple;
	bh=PqKOiQ7hcWhubAmY1ogWMqlniibgTMh3Bf+Zou9ygyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdheBFULOvkiQzoaPtUUZmKgnf1q73d6G3Es8Ne4449NZfnt9fbk0P+zLs8Le/8UweKewqTPFu1NUywJtBcdG1teqBhN6uWpzrfdTTiUx7Mt56HewrZ5sEaR5ISuC+MuWtoTezg7rgW12HZR3JIqar6+rHC3Fgq588viB/lxWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVMyYqAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVMyYqAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA4EC43394;
	Tue, 27 Feb 2024 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042773;
	bh=PqKOiQ7hcWhubAmY1ogWMqlniibgTMh3Bf+Zou9ygyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVMyYqAlgi76hvi1qL9+Gtunh2e9p7t7V+3c4GF57TDXrv9W5r5Jo9bM4P8lK3keC
	 xzFXqVNN/V/WyHH0ylX1jXLnXMzdwrYqCE0fIHGB3ZwpbDg74ILsE+nFeYvYZB0XFq
	 Rg7wLH/+ZwhVuY9tNPq/CXUOk2BsXAREaWLUC+SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/245] clk: renesas: cpg-mssr: Remove superfluous check in resume code
Date: Tue, 27 Feb 2024 14:25:03 +0100
Message-ID: <20240227131618.973468929@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1c052043c79af5f70e80e2acd4dd70904ae08666 ]

When the code flow arrives at printing the error message in
cpg_mssr_resume_noirq(), we know for sure that we are not running on an
RZ/A Soc, as the code checked for that before.

Fixes: ace342097768e35f ("clk: renesas: cpg-mssr: Fix STBCR suspend/resume handling")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/144a3e66d748c0c17f3524ac8fa6ece5bf5b6f1e.1673425314.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index ed67b90fc1b0c..54c5d35fe2ae3 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -911,9 +911,8 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		}
 
 		if (!i)
-			dev_warn(dev, "Failed to enable %s%u[0x%x]\n",
-				 priv->reg_layout == CLK_REG_LAYOUT_RZ_A ?
-				 "STB" : "SMSTP", reg, oldval & mask);
+			dev_warn(dev, "Failed to enable SMSTP%u[0x%x]\n", reg,
+				 oldval & mask);
 	}
 
 	return 0;
-- 
2.43.0



