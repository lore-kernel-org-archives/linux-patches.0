Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F511DE8AF;
	Sun,  7 Sep 2025 20:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277265; cv=none; b=U/asmKM552VJNhz4rpRNpYWwdFZ59OPHfF3XpCVdQdrSEHs9Lhh3erliQQa8zrWxEIcKrWYIQvTOhaR7/evrMZ9G9uTWzoBSYSQIpeEsxrL5lsLAgO1TUTPF/KAsAbOUu3uQXfcA4eP+GhFMH2bXQTJNe3JPsQYMC0vfOpSVAjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277265; c=relaxed/simple;
	bh=5MOEFD9jZQL4v0LPh0cW0/K3Q+eAjmT8rWriBHBHKr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoUxdGrfwYv/Ark6NFaZriy0SXXWKLWLuxxuT3NHGVqwR5qfCIpWz46z/bAA0PvSWpTzdKrnYZE1YH84jgMOk8EC/5kX4E3N39t3UFtZrsc0eW3fCxeEo/Esjx76fZO+ZNit8OyXpvbgibbYJ233W2IOiD2OQC1n7Lku2rPIobY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0BDHl7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0BDHl7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4687C4CEF0;
	Sun,  7 Sep 2025 20:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277265;
	bh=5MOEFD9jZQL4v0LPh0cW0/K3Q+eAjmT8rWriBHBHKr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0BDHl7Am8kVLAkLd7XEvBe9S4pL3bY2le06hlCULg44r68nayt5rpqIydNGVYl1f
	 KpMRVvVJJBH4ABzwMv1CTPJCSjqR1oBistda0mHJdEHaNW2UF0R5xblgwHsjidXHmc
	 ted4pAmoijg1fpx9RdUTAFBmYQt1vkgk8hDU86wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/175] net: thunder_bgx: add a missing of_node_put
Date: Sun,  7 Sep 2025 21:57:55 +0200
Message-ID: <20250907195616.728240226@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa80c37022323..5afc0735b5827 100644
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



