Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AC54F5E19;
	Wed, 30 Sep 2026 18:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793349; cv=none; b=J/c7Pebu+1oVSPMMfUm0Tq0EsDNyMQkdmyau/rvR38KuBsX+Mu4p+l0foyd9StM4nQ4Q53dBNSGYqp6NE13dBto9UYG8fTFbP94zLJ5RgJFGB0RRd3A3u044yxlym6iudTg16XAG5w26U5adLv61DrQeBNJlZ+JT3FzFGtkklm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793349; c=relaxed/simple;
	bh=hwAu+ZqQs3yoJOaXcXG+lPMjyFyNJZJZRWJpnzvdJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frig1Dru7f4eE0hkA5ITN6xVXDGPOWmPaqhMi82L8PED+D6y+OXb1abxiArxm/1I0mBwgtEM4pwkRsw4LGzBEaboxEkuSwTdVx8b4aMvg7jIy5KxE4+P0qeTGgU4mRFCwNtS+dYLv8E/V48vsLzqognYDde6vCV1jiKM7qggF60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNqgcXP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNqgcXP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B461F00898;
	Wed, 30 Sep 2026 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793347;
	bh=ctRc7bYoyyJBgp2s6SICgyQRoW8EcpfOaT2qOet7kME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNqgcXP3fojye62sOslW/sMm6kTyQLjklGsPUOwXCUpOQBUJEhlW0XK0KJx4whTa9
	 ED9e6KO1EQwc+x8fMFvMDSxJv/Lx8sWiFzINVpx139fQpAF1SqLueQ8OyTgIxhb5Fx
	 9uATNtW0KNZgusblnLAQfoeIshpH5cY9Oq/yVLq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Sviridkin <f@lex.la>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/395] net: phylink: record the PHY only once bringup cannot fail
Date: Wed, 30 Sep 2026 17:27:20 +0200
Message-ID: <20260930152344.513107401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Sviridkin <f@lex.la>

[ Upstream commit a940003f44e7e441c228151dd212642152700ec8 ]

phylink_bringup_phy() stores the PHY in pl->phydev before its last
fallible step: on a MAC whose phylink ops implement LPI,
phy_eee_rx_clock_stop() can fail with a real MDIO error. The callers
unwind with phy_detach(), which knows nothing about pl->phydev, so a
pointer to a PHY that is no longer attached outlives the failed
connect.

What that costs depends on how the caller got here.
phylink_connect_phy() goes through phylink_attach_phy(), which refuses
to attach while pl->phydev is set, turning a transient MDIO error into
a permanent -EBUSY. The SFP path is worse than that: sfp_sm_probe_phy()
answers the failure with phy_device_remove() and phy_device_free(), and
it assigns sfp->mod_phy only past that error return, so nothing clears
pl->phydev and it is left pointing at a freed phy_device that
phylink_resolve() and the ethtool helpers go on reading.
phylink_fwnode_phy_connect() has no such check, so a later connect
overwrites the stale pointer and hides the problem. A disconnect does
not: phylink_disconnect_phy() hands that pointer to phy_disconnect(),
and the second phy_detach() on the same PHY drops references the first
one already released.

Found while making a DSA port survive a PHY whose driver arrives after
the switch probes: keeping the port across a failed connect and
retrying is what makes this window reachable.

Publish the pointer after the last call that can fail instead of
unwinding it afterwards. Nothing between the two points reads
pl->phydev, and the registration that follows cannot fail:
phy_request_interrupt() falls back to polling on its own. The PHY-side
state keeps the order it had, so no MDIO operation moves relative to
another.

Fixes: 03abf2a7c654 ("net: phylink: add EEE management")
Signed-off-by: Aleksei Sviridkin <f@lex.la>
Link: https://patch.msgid.link/20260920222044.1752860-1-f@lex.la
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 848b6ec9bd85b..0b618842d41d7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2115,7 +2115,6 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	mutex_lock(&pl->phydev_mutex);
 	mutex_lock(&phy->lock);
 	mutex_lock(&pl->state_mutex);
-	pl->phydev = phy;
 	pl->phy_state.interface = interface;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
@@ -2182,10 +2181,25 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 			ret = 0;
 	}
 
-	if (ret == 0 && phy_interrupt_is_valid(phy))
+	if (ret)
+		return ret;
+
+	/* Nothing below can fail, so the PHY can be recorded now. Doing it
+	 * here rather than above keeps a failed bringup from leaving
+	 * pl->phydev pointing at a PHY the caller is about to detach.
+	 */
+	mutex_lock(&pl->phydev_mutex);
+	mutex_lock(&phy->lock);
+	mutex_lock(&pl->state_mutex);
+	pl->phydev = phy;
+	mutex_unlock(&pl->state_mutex);
+	mutex_unlock(&phy->lock);
+	mutex_unlock(&pl->phydev_mutex);
+
+	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
 
-	return ret;
+	return 0;
 }
 
 static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
-- 
2.53.0



