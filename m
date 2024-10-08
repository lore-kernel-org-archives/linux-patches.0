Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F5B1DFE01;
	Tue,  8 Oct 2024 13:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393877; cv=none; b=Kxy7+6xndl5R5Tpy8c1XW7xourMRlwpKjETUUnKPRNwLeSrABfCDMecu3ulCsgCSIR1l98W3nFWAKnn7CdLexAwQs5V4dSdmizbg8nwZ/xC7N2F5IKW1gQS/LbusJy0mSM2Njx6B99wCucLoLQmybzP3f9n9w+46DdqvCwoepjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393877; c=relaxed/simple;
	bh=vFpRdhPWz+UX7g83evXPOlWA7FTeuj2cXlPf3CCgenA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRsNf70GjAynQ6acR3OISq4fBwAfMHvp0AlDpm76DNjWI1B4zEWX7WERCQTxudvZt1vJvp2z813sYpC1RkscKp+FfhPuqozoELusvuX2mrYJa2b9n24h+kmbVlIlVy76lnDLooKuIGOqnB7n1YyAo/Mlgmn+FOUYt9khdZv2u6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6BK+slV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6BK+slV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB17C4CECC;
	Tue,  8 Oct 2024 13:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393877;
	bh=vFpRdhPWz+UX7g83evXPOlWA7FTeuj2cXlPf3CCgenA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6BK+slViAA46l4ecvTkxrnKmz2ebYdjIh1UJMLqlxk7Mjm0snus75AeXhPpoSZq9
	 dyRRttPgmpnoe16Fh+g1DvCFiYt+k0Cht+7pIYedz0E7+yLoQsnJ2OnwqiQjLrkwjo
	 cM49/egW5OUQabbpKj4Rjc2PZZVfNCQREwjOaX3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 280/386] clk: rockchip: fix error for unknown clocks
Date: Tue,  8 Oct 2024 14:08:45 +0200
Message-ID: <20241008115640.407728210@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,12 +433,13 @@ void rockchip_clk_register_branches(stru
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


