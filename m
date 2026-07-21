Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD9B411691;
	Tue, 21 Jul 2026 19:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661220; cv=none; b=EJ2kLAe2d7FaKYcK+yYNlOfCFtoMz4EMGTJskXTXX44hTBPOwIysVrMUXQIn3lAUh+L1UEK4Lbyswlgp975G5YYuZHUz6pR2HYsFMOzKEQ+U27mhIySTt14Pn7QuT0sGUWx01Wn1uq9s/pbCqWMdpzP/PcqTL0ITyAD+Pi3Dh5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661220; c=relaxed/simple;
	bh=lH21WGGMdKuZ+grqYoCW37wNtFUDUaRWms1VQZGHv+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMj7qNuZbg6q0xdgZd5b2GHwW+rclbIrdfOSyNSolnCa3JxD1VIfXdKpeikC6XBU/6SrH9E9s115hz3rQz5Ugd9XWCa8dVZuCw7t0oyrV7Z19T3mlnWBLgioM1C7P9j42Hoj7Yi4He36wdykSR9nD2Fq7fdSbHZTpAFJPgGEIiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMc6C55r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMc6C55r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BF31F000E9;
	Tue, 21 Jul 2026 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661219;
	bh=WkgtP2x8WoFTrIypzvdIJHHXkGrN46wpa/AqEw+Xa60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMc6C55rdPUo9KpuSitlKCCxYCAgbVb4WErP8xX3sHwQ8AzYmpLka49eOYSN6KBJj
	 /lLFHfQsEHXEs3QgxlG6iWT/liYb5a3++WqdMfIb7qx01UmeE2hSN0lT6yBwOjUXzD
	 9L/g9G1IbxbnZ7Dfzc9u009sXA9sFIUwP5hCcQ5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1275/2077] net: dsa: mxl862xx: fix use-after-free of DSA ports in crc_err_work
Date: Tue, 21 Jul 2026 17:15:48 +0200
Message-ID: <20260721152622.890982238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit bcb3b8314611ed9cb4ff4bff484ef9b154fd1b83 ]

Upon an MDIO CRC error mxl862xx_crc_err_work_fn() walks the DSA ports
and closes the CPU port conduits:

	dsa_switch_for_each_cpu_port(dp, priv->ds)
		dev_close(dp->conduit);

mxl862xx_remove() unregisters the switch before cancelling this work:

	set_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags);
	cancel_delayed_work_sync(&priv->stats_work);
	dsa_unregister_switch(ds);
	mxl862xx_host_shutdown(priv);

dsa_unregister_switch() frees the dsa_port objects. If a CRC error
schedules the work during teardown it can run after the ports have been
freed and dereference freed memory.

Guard the port walk with MXL862XX_FLAG_WORK_STOPPED, which is already set
before dsa_unregister_switch(). DSA tears the ports down under
rtnl_lock(), so checking the flag under rtnl_lock() means the work either
runs before teardown and sees valid ports, or runs afterwards, observes
the flag and skips the walk. This mirrors the host_flood_work handler,
which skips torn-down ports under rtnl_lock().

Link: https://sashiko.dev/#/patchset/cover.1780968180.git.daniel%40makrotopia.org?part=2
Fixes: a319d0c8c8ce ("net: dsa: mxl862xx: add CRC for MDIO communication")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/5e55169926c02f2b914e5ada529d7453b943cda4.1781702256.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mxl862xx/mxl862xx-host.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mxl862xx/mxl862xx-host.c b/drivers/net/dsa/mxl862xx/mxl862xx-host.c
index 882c5d9609418c..4acd216f7cc009 100644
--- a/drivers/net/dsa/mxl862xx/mxl862xx-host.c
+++ b/drivers/net/dsa/mxl862xx/mxl862xx-host.c
@@ -41,12 +41,13 @@ static void mxl862xx_crc_err_work_fn(struct work_struct *work)
 						  crc_err_work);
 	struct dsa_port *dp;
 
-	dev_warn(&priv->mdiodev->dev,
-		 "MDIO CRC error detected, shutting down all ports\n");
-
 	rtnl_lock();
-	dsa_switch_for_each_cpu_port(dp, priv->ds)
-		dev_close(dp->conduit);
+	if (!test_bit(MXL862XX_FLAG_WORK_STOPPED, &priv->flags)) {
+		dev_warn(&priv->mdiodev->dev,
+			 "MDIO CRC error detected, shutting down all ports\n");
+		dsa_switch_for_each_cpu_port(dp, priv->ds)
+			dev_close(dp->conduit);
+	}
 	rtnl_unlock();
 
 	clear_bit(MXL862XX_FLAG_CRC_ERR, &priv->flags);
-- 
2.53.0



