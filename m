Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521123ADBB4;
	Wed, 23 Sep 2026 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173145; cv=none; b=N1JbU/9C1QaDag4H8LLfJiT6b64mOPtpqUP5E0nT/9T9LonTH4EYnv5XO24DMkEdSVjrwZ91Fqdaff6/7vswm2TfP1bPh8qnlja71koLyUfgx+td4FwVhRfUaggkad0kwoIR1DTxpspniqOV0UdJBk6BZ67Y0QIJA4965uDdJYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173145; c=relaxed/simple;
	bh=FAIvJ1w2KqJ7dbFAbaX1yMj99g8S80A5fu6pvpnQSYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKvoVipXc0G/dOKlyP9jNyXyseAB/Yk541UzUmgs3ZpKSe3uIcuXD/9waDuTiQ9p7TiN94LswsiBHG6JioLepJipWM0zQvUc7QqPMDjag8Ytb7v+ixHXO60JeakXVcWkYYXWNB55jLtVy38FU8AvVGERqAisstqYMB4xGoLzY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9y7sMLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9y7sMLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C46C1F000FF;
	Wed, 23 Sep 2026 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173144;
	bh=ReLWYjKRos0SxZjW+qjQuOTD5XlGG/BGz7zJSxT3sEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9y7sMLbXQM+7N073Ms9s6lEMvzSEG9P/9K/0xjL21TMD8gYeI3z3XM2FbvAhohv3
	 fLnOf1Mu2HF4fLyL6aTDr4i2Kzm+aJSsMEtBgyAwi2B5HY7+QYpODfIl6PDL07Ncii
	 IHhXwaGNJeOKxr9EcdvsDxIpNB+ZMPOgR54MJT9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 155/438] net: dsa: mxl862xx: disable the stats poll on teardown
Date: Wed, 23 Sep 2026 16:02:56 +0200
Message-ID: <20260923140648.786908152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 9e92ad4630f5dd1838ce6bbe6b1bd2c73d34de36 ]

mxl862xx_setup() arms the stats poll before mxl862xx_setup_mdio(), and
nothing stops it until dsa_register_switch() has returned an error to
mxl862xx_probe(). DSA frees the dsa_port list before it returns, so a
poll that fires once .setup or a later step of dsa_tree_setup() has
failed walks freed ports. On shutdown the user ports stay registered,
and the WORK_STOPPED flag test in mxl862xx_get_stats64() is not atomic
with the cancel in mxl862xx_shutdown(), so a re-arm that read the flag
before it was set queues the poll after cancel_delayed_work_sync() has
returned.

Arm the poll once .setup has succeeded and stop it from a .teardown op,
which DSA calls on unregister and after a failed registration, in both
cases before it frees the ports. Use disable_delayed_work_sync() there
and in shutdown(): it drains a running poll as the cancel did and turns
every later attempt to queue the work into a no-op, so the re-arm
cannot bring the poll back. remove() and the probe error path only set
WORK_STOPPED, which crc_err_work tests before it walks the ports.

Fixes: a21d33a5265f ("net: dsa: mxl862xx: implement .get_stats64")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/1eb6f7fc1789b67e4b11e3f4d5ff080d0b6f7cbb.1789045590.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mxl862xx/mxl862xx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mxl862xx/mxl862xx.c b/drivers/net/dsa/mxl862xx/mxl862xx.c
index cfa7e3e269a28..e05ad52cd297e 100644
--- a/drivers/net/dsa/mxl862xx/mxl862xx.c
+++ b/drivers/net/dsa/mxl862xx/mxl862xx.c
@@ -685,10 +685,22 @@ static int mxl862xx_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = mxl862xx_setup_mdio(ds);
+	if (ret)
+		return ret;
+
 	schedule_delayed_work(&priv->stats_work,
 			      MXL862XX_STATS_POLL_INTERVAL);
 
-	return mxl862xx_setup_mdio(ds);
+	return 0;
+}
+
+static void mxl862xx_teardown(struct dsa_switch *ds)
+{
+	struct mxl862xx_priv *priv = ds->priv;
+
+	set_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags);
+	disable_delayed_work_sync(&priv->stats_work);
 }
 
 static int mxl862xx_port_state(struct dsa_switch *ds, int port, bool enable)
@@ -2047,9 +2059,7 @@ static void mxl862xx_get_stats64(struct dsa_switch *ds, int port,
 
 	spin_unlock_bh(&priv->ports[port].stats_lock);
 
-	/* Trigger a fresh poll so the next read sees up-to-date counters.
-	 * No-op if the work is already pending, running, or teardown started.
-	 */
+	/* Trigger a fresh poll so the next read sees up-to-date counters. */
 	if (!test_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags))
 		schedule_delayed_work(&priv->stats_work, 0);
 }
@@ -2057,6 +2067,7 @@ static void mxl862xx_get_stats64(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops mxl862xx_switch_ops = {
 	.get_tag_protocol = mxl862xx_get_tag_protocol,
 	.setup = mxl862xx_setup,
+	.teardown = mxl862xx_teardown,
 	.port_setup = mxl862xx_port_setup,
 	.port_teardown = mxl862xx_port_teardown,
 	.phylink_get_caps = mxl862xx_phylink_get_caps,
@@ -2131,7 +2142,6 @@ static int mxl862xx_probe(struct mdio_device *mdiodev)
 	err = dsa_register_switch(ds);
 	if (err) {
 		set_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags);
-		cancel_delayed_work_sync(&priv->stats_work);
 		mxl862xx_host_shutdown(priv);
 		for (i = 0; i < MXL862XX_MAX_PORTS; i++)
 			cancel_work_sync(&priv->ports[i].host_flood_work);
@@ -2152,7 +2162,6 @@ static void mxl862xx_remove(struct mdio_device *mdiodev)
 	priv = ds->priv;
 
 	set_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags);
-	cancel_delayed_work_sync(&priv->stats_work);
 
 	dsa_unregister_switch(ds);
 
@@ -2181,7 +2190,7 @@ static void mxl862xx_shutdown(struct mdio_device *mdiodev)
 	dsa_switch_shutdown(ds);
 
 	set_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags);
-	cancel_delayed_work_sync(&priv->stats_work);
+	disable_delayed_work_sync(&priv->stats_work);
 
 	mxl862xx_host_shutdown(priv);
 
-- 
2.53.0



