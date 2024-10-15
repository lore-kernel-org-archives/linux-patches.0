Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9703F1C57B1;
	Tue, 15 Oct 2024 12:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993926; cv=none; b=u7ukoGzQaGOw/ZtP1fN4qhLYT5TEXv2g2FoaVmsCGBGsSgk85nTNUeqUUiyvyxgu5qHRPi6+xDOfySi1YjGi55R50qO/mqfUo15TkTmuSjbzxA1v8EAF03yOyqFgslFtOZ3HNC8np9Q9k2ydssSWBL3Er/X5t16WHAX5PZnxCtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993926; c=relaxed/simple;
	bh=PpOcdQ2DSIL6aYpScneYLTd2xyANtm06B73V6E7uXYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3gr3MfRxWKM7PDeJIHkyjSFE7JbpwmGpXZ2jR8icGTVISEThxOPPR7GD1ikF3jdv/cdZKm4G4Hwxy/vYOR5BdI3r/WU6UM83aTMfRdkb7rnRtbZQ7ZzePcRBhGUbhLmOpBUMoWV8N6tIIzNDGXSFfZEjOHDbhloaAMVO6fHLDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAbQtXJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAbQtXJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CD3C4CEC6;
	Tue, 15 Oct 2024 12:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993926;
	bh=PpOcdQ2DSIL6aYpScneYLTd2xyANtm06B73V6E7uXYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAbQtXJG3Xdq50UNf5SAXs6evAfs4TKyuk19F1Rr14692nQfQ57UNhQSuYhTVEjjn
	 BEvOeoI11LetRPHUhxN26aPr2jwYiE/8s1bhXjrVEg6IMfEroeNus2x/ihOX/DRruz
	 QXsFTRxTYXzwWxmiLHZJAClENLHH5u3rCYC/nJYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 524/691] clk: rockchip: fix error for unknown clocks
Date: Tue, 15 Oct 2024 13:27:52 +0200
Message-ID: <20241015112501.139533571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit 12fd64babaca4dc09d072f63eda76ba44119816a upstream.

There is a clk == NULL check after the switch to check for
unsupported clk types. Since clk is re-assigned in a loop,
this check is useless right now for anything but the first
round. Let's fix this up by assigning clk = NULL in the
loop before the switch statement.

Fixes: a245fecbb806 ("clk: rockchip: add basic infrastructure for clock branches")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[added fixes + stable-cc]
Link: https://lore.kernel.org/r/20240325193609.237182-6-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -434,12 +434,13 @@ void rockchip_clk_register_branches(stru
 				    struct rockchip_clk_branch *list,
 				    unsigned int nr_clk)
 {
-	struct clk *clk = NULL;
+	struct clk *clk;
 	unsigned int idx;
 	unsigned long flags;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
 		flags = list->flags;
+		clk = NULL;
 
 		/* catch simple muxes */
 		switch (list->branch_type) {


