Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEB51E8320;
	Tue, 16 Jun 2026 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623256; cv=none; b=isscNjqO0FoyLghoNXroBgNHrM9qKgrMr8W7GL8EVNv8oBLNq6B8/emUmsLVfSkjw1/zqYEKh5DZe8DuX+W/rdCWMbKF3wEPYhZbbkJcZg5gI+rSD485WjZ4jeab9Hs99d1iCXVPT1/9CVn5QSp9BhFnnDbvobnfLr9/oo/UACE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623256; c=relaxed/simple;
	bh=2ooQ0bTWbaZriAQOfmyufpk35fAwEmFYkGLCLGkOwIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt4xOlB/J2ocIdOxWcGSnUurd7w1tfviOIsys9AwjR4GXzzrAxFzoO6PdtD+akzGDPMuBA2uMKcP2wnZljJZtjH6LtR/qINvDKleA8/MF9ZudK3fD/4YCuX9JxEzrOpXKS311peH2ip5Ci75eHWzbEFfXQKoprFHYYc92vWAGrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR6ap/i/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR6ap/i/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AF31F000E9;
	Tue, 16 Jun 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623255;
	bh=VT91/ld7ZBJg6BXj4mPa42xWdsO3vVBoPoyJzkHXq7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR6ap/i/OVXHRKEzsDaDz4HJlRfLa18b2ehk+Lpra8ZbI3hatPp++j5BQFUIFj2Dn
	 FgkoCYOtCAw85fQHHzoIRRc5oNWeKKi2zj0v8AfxDncNnjENyWK3MDUAyPlmmxbGOt
	 x4T9AFUIGYuSzvhkhWoKIcRtYc+JoNqU6fzaSOd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 115/378] net: phy: remove phy ports upon probe failure
Date: Tue, 16 Jun 2026 20:25:46 +0530
Message-ID: <20260616145116.419558127@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit b1e780bb37c641d8291c51d7b4bde33450d18fb4 ]

When phy_probe fails, let's clean the phy_ports that were successfully
added already.

Suggested-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Fixes: 589e934d2735 ("net: phy: Introduce PHY ports representation")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260604092819.723505-3-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c6722592f8672a..111e3f3deb96f4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3797,6 +3797,8 @@ static int phy_probe(struct device *dev)
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
 
+	phy_cleanup_ports(phydev);
+
 	if (!phydev->is_on_sfp_module)
 		phy_led_triggers_unregister(phydev);
 
-- 
2.53.0



