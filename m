Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E9E198E69;
	Tue, 10 Sep 2024 10:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962962; cv=none; b=pfDdMubrEYfpjSeA6Tk2NdHzoLFGm+JEE7a5mYvGdE1Y1m2wc8nxA6CAMyDCR5uNrKgOipPwBH6gPOXM6SmMQQzncmIJLntvaowDEh4rFMHwZLoqg04QftAxwszPuN9TuzIfAcr09QMzYvk3F+XUqHUGvdYLaOEl+2/aKkCLCwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962962; c=relaxed/simple;
	bh=qx1/YXJ9upR323Jl/PEfctEpNn/lldhtkZ8IwTWe+vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbewrDP+tn2XTWdiENqtoN8T/M/CPi9fXRQrjxcD07xlPZ6qASd/4iE0FXRO0Li8Q13jgNJHF5lNLkdeVSbdxtFKy6OQl/yDreIqNqA8l/XcRdvgLniTMu6OlcWOvPT3ITO5ycQbjfUOiPYm36omxC42yNziJmqi+gY79mxgAKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VB25MiAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB25MiAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B517C4CEC6;
	Tue, 10 Sep 2024 10:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962961;
	bh=qx1/YXJ9upR323Jl/PEfctEpNn/lldhtkZ8IwTWe+vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB25MiAIfuLeca1L47aoUPRJK9HkmL3xaFinW+W8bkdM+XWWic5TcZ5IGclyuZR/k
	 9rtxdgnRj3J6TCNT0cVeGREfovXilHkRrwYz6hTjjJydOpVuiAq2J2ZGIOlOjFd+xi
	 XVMrwd0aQ6t7UASx2tpknz66M5UDqvArWcctu620=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/192] phy: zynqmp: Take the phy mutex in xlate
Date: Tue, 10 Sep 2024 11:31:53 +0200
Message-ID: <20240910092601.661764328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit d79c6840917097285e03a49f709321f5fb972750 ]

Take the phy mutex in xlate to protect against concurrent
modification/access to gtr_phy. This does not typically cause any
issues, since in most systems the phys are only xlated once and
thereafter accessed with the phy API (which takes the locks). However,
we are about to allow userspace to access phys for debugging, so it's
important to avoid any data races.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://lore.kernel.org/r/20240628205540.3098010-5-sean.anderson@linux.dev
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index ac9a9124a36d..cc36fb7616ae 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -847,6 +847,7 @@ static struct phy *xpsgtr_xlate(struct device *dev,
 	phy_type = args->args[1];
 	phy_instance = args->args[2];
 
+	guard(mutex)(&gtr_phy->phy->mutex);
 	ret = xpsgtr_set_lane_type(gtr_phy, phy_type, phy_instance);
 	if (ret < 0) {
 		dev_err(gtr_dev->dev, "Invalid PHY type and/or instance\n");
-- 
2.43.0



