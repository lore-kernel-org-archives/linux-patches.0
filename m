Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A863818C02E;
	Tue, 10 Sep 2024 10:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964311; cv=none; b=iZsBReuJcVuf8wLVU6r2sJLQKXlE5y/fsK9yP9rNqKXOsNhHv7tUwyqBCZ3Yo1RBeupRUhxo6XFCTA9qNASgj5bjd95ZKeSA1zNaVPugF3PI9gs78JULAuqLFkIYYR9foEwVeASDqwPV/0y2WASdjx1sydLoMDmG0LcebFrGOh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964311; c=relaxed/simple;
	bh=oyvT+4TQra6uc2nf/FcIrlNaSvBoufV9y2VGuDuJIQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn3Kq5ZhIuu+bk66QrVg5qFkMKnJe+OS/EBxNMFT3KR9oXlaFrILBdmSZZNeYsi2bJzaynQBRtBpLpFK6Q/XE3oO196MqieHhZ2CwtuyHd69BdrKLnzwjDbtQdlEvt3WhGQ8Mm1AC5tXTRkwTN23OPB4eLDEBZOWuYvxq1SkJmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWchx1oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWchx1oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA7C4CEC3;
	Tue, 10 Sep 2024 10:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964311;
	bh=oyvT+4TQra6uc2nf/FcIrlNaSvBoufV9y2VGuDuJIQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWchx1oC+q0/SkDCcL2joW0qoIB4OlFGiQ+0SO6JqWie9/aiCMse+/BQqnD766x/H
	 T7/q4YVoJN30828w3rBPIOHwuw6tm4avMaCYsx5dk3SesAZ7sUMglGH2K9tgENvFx/
	 c3ZGJ1ZYtnAuWLn9dJ2u1yraEO7WsYgOnndX0Ons=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/269] phy: zynqmp: Take the phy mutex in xlate
Date: Tue, 10 Sep 2024 11:32:06 +0200
Message-ID: <20240910092613.157122821@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 8c8b1ca31e4c..c72b52955a86 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -846,6 +846,7 @@ static struct phy *xpsgtr_xlate(struct device *dev,
 	phy_type = args->args[1];
 	phy_instance = args->args[2];
 
+	guard(mutex)(&gtr_phy->phy->mutex);
 	ret = xpsgtr_set_lane_type(gtr_phy, phy_type, phy_instance);
 	if (ret < 0) {
 		dev_err(gtr_dev->dev, "Invalid PHY type and/or instance\n");
-- 
2.43.0



