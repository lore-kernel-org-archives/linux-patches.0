Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146213C465;
	Tue, 30 Sep 2025 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246013; cv=none; b=WBaokLjCsgzfVNjc+B49RJsVU6XMbF2qpaowHnm300u9348feNqGNjj86gO0LiaHZg54CGNByMSl+5jyA9/aas56JE4xvUsE35TkgId3OJRrfuYESzIjMK8LhXf3mnYEtrYtFLS+8ImF8IQwC9JMw6I6lZvQN1R5RRjBunV5htI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246013; c=relaxed/simple;
	bh=OtBSJVkDmHuEBgrpUa0m7JyZJjyslrZEocHsXBcCvuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUb7GtB9D9e7wItZEekU/V9VmVidoPbW9xc9yTDGKl2YWJzsTYmRp6S4BDNH3TZ4kc42JyeFMNdqvC17U3QVoGllIGAUzCJxivslDXkMEhzoGbM1H62bCZbZ+s/oxnsOsxs44vELuHbigoA5c7+/IprVKMAVLps0d+BYjNedLXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nu33rZma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nu33rZma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1976AC4CEF0;
	Tue, 30 Sep 2025 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246012;
	bh=OtBSJVkDmHuEBgrpUa0m7JyZJjyslrZEocHsXBcCvuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nu33rZmaE68TBr16wKFNDcdD1oO0vmf6Z2x7Hri2rVWSxx5JpmG8qBvZG8zlwTZn6
	 IH7r3HqR7aOUREZLUpNydBhNXsV/kLpuPSLfO7llhoaUvV5+d+MSfd6K8uNyYhvwr0
	 6ZMUBZmVgNFUbTSvUC6xd30DsLafr7gs4i5WOPD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 25/89] net: sfp: add quirk for FLYPRO copper SFP+ module
Date: Tue, 30 Sep 2025 16:47:39 +0200
Message-ID: <20250930143822.943468004@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit ddbf0e78a8b20ec18d314d31336a0230fdc9b394 ]

Add quirk for a copper SFP that identifies itself as "FLYPRO"
"SFP-10GT-CS-30M". It uses RollBall protocol to talk to the PHY.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250831105910.3174-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e8670249d32c1..f1827a1bd7a59 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -491,6 +491,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
 		  sfp_fixup_nokia),
 
+	// FLYPRO SFP-10GT-CS-30M uses Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("FLYPRO", "SFP-10GT-CS-30M", sfp_fixup_rollball),
+
 	// Fiberstore SFP-10G-T doesn't identify as copper, uses the Rollball
 	// protocol to talk to the PHY and needs 4 sec wait before probing the
 	// PHY.
-- 
2.51.0



