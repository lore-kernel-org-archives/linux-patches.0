Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACE2FA636;
	Tue, 17 Jun 2025 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179339; cv=none; b=M8GvQm57Vvth8M/G8J/GGh5q+w9gkWw02o4ifFIHM1OjpHYKwccrD/nZj+eFuCYSWlq1RFhJzLq2HAqSh3xi9HehX5myqOBUY9U32xtocx0eNOwFh0MTi30DDL3bTKAFjqyCSBSWyL+E8Z8JpQs+zmFGGeFJOiEegWGOJHJLdxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179339; c=relaxed/simple;
	bh=0oXcfkGOBaAHuT0xtddk5HFtCpADzP4IBE57Xq0bdro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsWSyDtoOLTrQVcacF69lZ8eGUeLGR+4IlI0gnBdJBZiJ7e+e0BWHiGvuwlotkpV+87uiIYqdfpu15DhTnCTCLLcHPhNQJchzVMAn0q+bc9MT7kH8peeOOg4umnX5UXoMnD4gdaMcdpv1XpYjZPQst9o+12DOoVMBeTEOkV7/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyMu1LAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyMu1LAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A38C4CEE3;
	Tue, 17 Jun 2025 16:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179339;
	bh=0oXcfkGOBaAHuT0xtddk5HFtCpADzP4IBE57Xq0bdro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyMu1LAyyLZek+e1yIPBReZ+Dmg82E0JAa9SpnOKWBQAhFY4eWUCqUvE2KFpSxEhY
	 gp8OICfhAhalS5yFtvLROn0UAxgt3UFA0SODP3RwJ431RKTDb5oGxnG7Pq93nentFK
	 XUuFQlZY34VvbnkM34APNNkk32lzEQqkXr4XCdaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 716/780] net: phy: phy_caps: Dont skip better duplex macth on non-exact match
Date: Tue, 17 Jun 2025 17:27:04 +0200
Message-ID: <20250617152520.651414248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit d4e6cb324dcc952618fec6b25aa3fc7bfc2750b4 ]

When performing a non-exact phy_caps lookup, we are looking for a
supported mode that matches as closely as possible the passed speed/duplex.

Blamed patch broke that logic by returning a match too early in case
the caller asks for half-duplex, as a full-duplex linkmode may match
first, and returned as a non-exact match without even trying to mach on
half-duplex modes.

Reported-by: Jijie Shao <shaojijie@huawei.com>
Closes: https://lore.kernel.org/netdev/20250603102500.4ec743cf@fedora/T/#m22ed60ca635c67dc7d9cbb47e8995b2beb5c1576
Tested-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Fixes: fc81e257d19f ("net: phy: phy_caps: Allow looking-up link caps based on speed and duplex")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250606094321.483602-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_caps.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy_caps.c b/drivers/net/phy/phy_caps.c
index 7033216897264..38417e2886118 100644
--- a/drivers/net/phy/phy_caps.c
+++ b/drivers/net/phy/phy_caps.c
@@ -188,6 +188,9 @@ phy_caps_lookup_by_linkmode_rev(const unsigned long *linkmodes, bool fdx_only)
  * When @exact is not set, we return either an exact match, or matching capabilities
  * at lower speed, or the lowest matching speed, or NULL.
  *
+ * Non-exact matches will try to return an exact speed and duplex match, but may
+ * return matching capabilities with same speed but a different duplex.
+ *
  * Returns: a matched link_capabilities according to the above process, NULL
  *	    otherwise.
  */
@@ -195,7 +198,7 @@ const struct link_capabilities *
 phy_caps_lookup(int speed, unsigned int duplex, const unsigned long *supported,
 		bool exact)
 {
-	const struct link_capabilities *lcap, *last = NULL;
+	const struct link_capabilities *lcap, *match = NULL, *last = NULL;
 
 	for_each_link_caps_desc_speed(lcap) {
 		if (linkmode_intersects(lcap->linkmodes, supported)) {
@@ -204,16 +207,19 @@ phy_caps_lookup(int speed, unsigned int duplex, const unsigned long *supported,
 			if (lcap->speed == speed && lcap->duplex == duplex) {
 				return lcap;
 			} else if (!exact) {
-				if (lcap->speed <= speed)
-					return lcap;
+				if (!match && lcap->speed <= speed)
+					match = lcap;
+
+				if (lcap->speed < speed)
+					break;
 			}
 		}
 	}
 
-	if (!exact)
-		return last;
+	if (!match && !exact)
+		match = last;
 
-	return NULL;
+	return match;
 }
 EXPORT_SYMBOL_GPL(phy_caps_lookup);
 
-- 
2.39.5



