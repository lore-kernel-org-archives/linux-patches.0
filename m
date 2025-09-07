Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA551A0BFD;
	Sun,  7 Sep 2025 20:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277230; cv=none; b=qes7pEjHAGDkHnP+DCd68WNZkJPNZAJFHRGVnhwmKB3tDZAs1/TzCFjCHNWsJHZYa+ivmJNLKJf7M/7xgcDUaSEIGBkRlBrEh4vZiVkgdv1teNuXFSHd5w05PMXdlwri+OmfosDz5h+N0swcn/EO4WtjE0j+K/gPAl8tI+/4148=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277230; c=relaxed/simple;
	bh=sx62alKdaqvVgboo8mZ6mwmPDAj4CWx3tq8GFOqYzew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf3bmRLXkFXxhMH2oK8YKCCIV3aFofGFsDl8EXZk55WI7FIaFGH01WDv8bPv6dDGO6t5kqDHYCYCJdWgnE5zsT9xm3V6W9BbdSx0qvmUmJ7RnrJovRIhEe8oXGioKKIuEDPmgfTTSEdzWnCLSXXWIawdvTXxt8IqjJB+LpnxnSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5vF1Acy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5vF1Acy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71948C4CEF0;
	Sun,  7 Sep 2025 20:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277229;
	bh=sx62alKdaqvVgboo8mZ6mwmPDAj4CWx3tq8GFOqYzew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5vF1AcyaGxJ/P+vTLUIZe1RyQQTX5joVtAHkUvf3bL9QJfwj1mKnLBrdMV8IrhlM
	 byPg9TDpoPD9wPTLeYNNEIeJZcknvzPGQOng+olcTOqQcn5AwBs2zqQUd+ueye4mBW
	 NUQbSfXs6HKy6BiB/xmmiTz45XpbZ5puJYyelUBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 124/175] net: dsa: add hook to determine whether EEE is supported
Date: Sun,  7 Sep 2025 21:58:39 +0200
Message-ID: <20250907195617.791021145@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 9723a77318b7c0cfd06ea207e52a042f8c815318 upstream.

Add a hook to determine whether the switch supports EEE. This will
return false if the switch does not, or true if it does. If the
method is not implemented, we assume (currently) that the switch
supports EEE.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/E1tL144-006cZD-El@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dsa.h |    1 +
 net/dsa/user.c    |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1003,6 +1003,7 @@ struct dsa_switch_ops {
 	/*
 	 * Port's MAC EEE settings
 	 */
+	bool	(*support_eee)(struct dsa_switch *ds, int port);
 	int	(*set_mac_eee)(struct dsa_switch *ds, int port,
 			       struct ethtool_keee *e);
 	int	(*get_mac_eee)(struct dsa_switch *ds, int port,
--- a/net/dsa/user.c
+++ b/net/dsa/user.c
@@ -1231,6 +1231,10 @@ static int dsa_user_set_eee(struct net_d
 	struct dsa_switch *ds = dp->ds;
 	int ret;
 
+	/* Check whether the switch supports EEE */
+	if (ds->ops->support_eee && !ds->ops->support_eee(ds, dp->index))
+		return -EOPNOTSUPP;
+
 	/* Port's PHY and MAC both need to be EEE capable */
 	if (!dev->phydev || !dp->pl)
 		return -ENODEV;
@@ -1251,6 +1255,10 @@ static int dsa_user_get_eee(struct net_d
 	struct dsa_switch *ds = dp->ds;
 	int ret;
 
+	/* Check whether the switch supports EEE */
+	if (ds->ops->support_eee && !ds->ops->support_eee(ds, dp->index))
+		return -EOPNOTSUPP;
+
 	/* Port's PHY and MAC both need to be EEE capable */
 	if (!dev->phydev || !dp->pl)
 		return -ENODEV;


