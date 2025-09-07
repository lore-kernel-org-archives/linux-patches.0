Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EBA4315A;
	Sun,  7 Sep 2025 20:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277656; cv=none; b=UZyC+gzzZ8ai6sRdSA5yLebojsQ0GBPoqPaNNenONfq2q6/n+0h7IEXqL3GrJiDY9avLN/E4QwmuU8g4xFePjcJgczn6w3wRqOTDmIS3bHLGyhKA3IR8+lDHSaXP8EqzZSoG4snCD4kYi/Wta0Z6tl7TOrOI0A+og0DnVgKtueU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277656; c=relaxed/simple;
	bh=yXM6x6yFBx7QgghWDPbW9g33Si6yqEr6mLGCJu5UQE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1WlStxPgYdOxOepcQ+LEbnql1bqX2xM7LUH1maz40m1PJZ4CW3+Ca4Ts2IpoJDSAewb8cQsIg7m1ajB+aauiJr9+NvL4Ee3LgO9Lw4FIQoLllMIJTX4COpddoimsmAQLaOnNmpOY8tgrk1jq2dzY2hT2FPIW3ZzXMMeZidgE9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkjcqCef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkjcqCef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9632CC4CEF0;
	Sun,  7 Sep 2025 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277656;
	bh=yXM6x6yFBx7QgghWDPbW9g33Si6yqEr6mLGCJu5UQE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkjcqCefp2eHSrSCcAeLVkJ7GFza3+HhZsEv4uu4z7P6gikME7cgN+3P98p0uArtD
	 J2IcBz44CIfThgiirR30I4c8T3Ex4YuWWcbstgKOUpLL8CoCp0q40O4CaPfbymPA7D
	 EJ99Rk3ILvDL3e7UMI9VIs8Rm1Npvz04MESe+U24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 083/183] net: thunder_bgx: add a missing of_node_put
Date: Sun,  7 Sep 2025 21:58:30 +0200
Message-ID: <20250907195617.768397139@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9d28f94912589f04ab51fbccaef287d4f40e0d1f ]

phy_np needs to get freed, just like the other child nodes.

Fixes: 5fc7cf179449 ("net: thunderx: Cleanup PHY probing code.")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250901213018.47392-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/cavium/thunder/thunder_bgx.c  | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 21495b5dce254..0f913db4814ea 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1493,13 +1493,17 @@ static int bgx_init_of_phy(struct bgx *bgx)
 		 * this cortina phy, for which there is no driver
 		 * support, ignore it.
 		 */
-		if (phy_np &&
-		    !of_device_is_compatible(phy_np, "cortina,cs4223-slice")) {
-			/* Wait until the phy drivers are available */
-			pd = of_phy_find_device(phy_np);
-			if (!pd)
-				goto defer;
-			bgx->lmac[lmac].phydev = pd;
+		if (phy_np) {
+			if (!of_device_is_compatible(phy_np, "cortina,cs4223-slice")) {
+				/* Wait until the phy drivers are available */
+				pd = of_phy_find_device(phy_np);
+				if (!pd) {
+					of_node_put(phy_np);
+					goto defer;
+				}
+				bgx->lmac[lmac].phydev = pd;
+			}
+			of_node_put(phy_np);
 		}
 
 		lmac++;
-- 
2.50.1



