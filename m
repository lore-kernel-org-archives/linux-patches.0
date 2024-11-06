Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478171E0B84;
	Wed,  6 Nov 2024 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898545; cv=none; b=qQNwbF4MzfnwyTwJm4HI1G606su/Xo2DoT6nGNVeqiVax2e5ZWiA18Q50n07wEjCwsBCgD2OFphhY9ee/sSwKcVDRMX4XqDiLJKhrTtYbvXtaDGo+QlV3Gywsl8e+fwnFON+4J35HjxYvbHsgatwMmNPcrc4UlgkjjCQ/CTmyco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898545; c=relaxed/simple;
	bh=vP7m7r8GDsf3ow4zzV9kVLvMg6EmeiLY7jtlKxtMH8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAKZlhHibc0bMbcmoN4+uNuGvpS7nTTljge9j6gG96rq22JFEyLLDJcz0wET5NuWc696gEh/hKf/i/p6peW38TCmlnbXbfP9tKrJkgNr/J2RJgX1wbgcV+3NgQnuKHk/zm7XTwoxfq0RiGo5BdFwJZ1fsIXNkatZC8dp1PNNdIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUy7ZUoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUy7ZUoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA07FC4CED3;
	Wed,  6 Nov 2024 13:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898545;
	bh=vP7m7r8GDsf3ow4zzV9kVLvMg6EmeiLY7jtlKxtMH8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUy7ZUohYsAaPNjBy1PwiE+0RpX9/PwIf1FgXC9h7SUOwXjrOTZVKk6p0zzrgshWN
	 fTVl5py005K43f5escxhMlQOWVQQmuvA6ZMQ8+fFH7yFziJtdlesGNr6lezRcF8ihT
	 oBIMaAwQndaTHb67APDFuJecUFEQorPZQzObToiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.4 267/462] clk: rockchip: fix error for unknown clocks
Date: Wed,  6 Nov 2024 13:02:40 +0100
Message-ID: <20241106120338.124086372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -439,12 +439,13 @@ void __init rockchip_clk_register_branch
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


