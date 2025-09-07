Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A871CDFAC;
	Sun,  7 Sep 2025 20:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275627; cv=none; b=aKYMAT9iHxDgpFEnazTcj2iHOBZrNV1j0d573x2F4qhPcyhmnaZXvnpAT5Gh3KXLqTRNM//Z8D9V6t9mLQqF+mIfOw57oB0FZFQEhrYypmvQ+huJkS6oKOsuinuXSgtv3TRqTZkx+Z4o7kDD/+mniLQCb/R/yg236BKsaDO5a8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275627; c=relaxed/simple;
	bh=rauZ2p14W0TgA8AiqRQ2UQtTUYO7dnEYFe/rtKkBubY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+o7ncUOBJIqtm465O8Ytq+JQcxANmdZ/ZNn4WRzokcP5ObRV1QCyHuz06PDB6vHfUTJWaeUCu1fX0dZPclfE7RSOXuOwIQMMnxtXnJ3bWXLti5zW5aMG3u8dvCVsXUyRbFTG5wZOj5tXPYRQnkWiKhGqoN+UfvnDgRktBjC3mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywGJNSzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywGJNSzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCA3C4CEF0;
	Sun,  7 Sep 2025 20:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275626;
	bh=rauZ2p14W0TgA8AiqRQ2UQtTUYO7dnEYFe/rtKkBubY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywGJNSzUYXAMWQp1tgdVBjv4C3+Jbo96sRpyPF2Oxr1nw40V504dCNYRP4wTORDRM
	 8Bs6QwD25B+VoeVMQLc6R2o+j+dJkWKu2d3AKC8jFZQMWIj0Ck/t3SWP5OexkFczd4
	 VG0Obm9s9jjJ/pQMVNcJPU+Q1cBQWnyYo8JUROjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/52] net: thunder_bgx: add a missing of_node_put
Date: Sun,  7 Sep 2025 21:57:34 +0200
Message-ID: <20250907195602.400757058@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a71909bb2ee5..f5dbe2f5af659 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1497,13 +1497,17 @@ static int bgx_init_of_phy(struct bgx *bgx)
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



