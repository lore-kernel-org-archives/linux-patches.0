Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0382FB0BE;
	Tue, 30 Sep 2025 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246116; cv=none; b=EK//P3tNt4n3BxJ+XEAgA9ZAlHveO/WT+6CweNfqtwHuq4KK1V9yXkTUOIxH4k638UH8w1o0mwNOSBdL2YFwmIfjOTl0iZsWylXNudIKA+0mo7URDgxfuA0SXuwXqN8AJ0khkyqyQldoy/ZDml2p+Wq2KveXEUUuQmb+P4+i2vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246116; c=relaxed/simple;
	bh=tWt7wLG1CYvtMjMpAKY4R14K6lYMKl5foMs0YWJ5yVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEwB0wCenUbOhx4fX8Yx83OGIafFOvzvCwsI4yuGO/XRU8uknDbk41tn77EG8aDEoHlwfGWgM+2fN4lTirs4c5jboyaW9kXRBmkBGddXmbDH/8X1TyoZy6k9eKHe9YYV+RjzWBMG/iJnf0M7SMndg7DaqTRsd961lijGbk88wWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXzDcEZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXzDcEZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851DDC4CEF0;
	Tue, 30 Sep 2025 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246115;
	bh=tWt7wLG1CYvtMjMpAKY4R14K6lYMKl5foMs0YWJ5yVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXzDcEZE3oOALCjYDDEMYDyFewhDsPAkgvuTr4BfxiPKp6J5FaYYe2vRL1aobfIF9
	 1euM+Hw0olDqwqZ6WyUbMcdcs290r/A3MZmSKCimLTvPjxTyExYM+004IMXF+CiOev
	 c6dTJMEIs/sDAZg94xK/4AqWbk13CYflnbOWQ19s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 56/89] net: dsa: lantiq_gswip: suppress -EINVAL errors for bridge FDB entries added to the CPU port
Date: Tue, 30 Sep 2025 16:48:10 +0200
Message-ID: <20250930143824.241089653@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 987afe147965ef7a8e7d144ffef0d70af14bb1d4 ]

The blamed commit and others in that patch set started the trend
of reusing existing DSA driver API for a new purpose: calling
ds->ops->port_fdb_add() on the CPU port.

The lantiq_gswip driver was not prepared to handle that, as can be seen
from the many errors that Daniel presents in the logs:

[  174.050000] gswip 1e108000.switch: port 2 failed to add fa:aa:72:f4:8b:1e vid 1 to fdb: -22
[  174.060000] gswip 1e108000.switch lan2: entered promiscuous mode
[  174.070000] gswip 1e108000.switch: port 2 failed to add 00:01:02:03:04:02 vid 0 to fdb: -22
[  174.090000] gswip 1e108000.switch: port 2 failed to add 00:01:02:03:04:02 vid 1 to fdb: -22
[  174.090000] gswip 1e108000.switch: port 2 failed to delete fa:aa:72:f4:8b:1e vid 1 from fdb: -2

The errors are because gswip_port_fdb() wants to get a handle to the
bridge that originated these FDB events, to associate it with a FID.
Absolutely honourable purpose, however this only works for user ports.

To get the bridge that generated an FDB entry for the CPU port, one
would need to look at the db.bridge.dev argument. But this was
introduced in commit c26933639b54 ("net: dsa: request drivers to perform
FDB isolation"), first appeared in v5.18, and when the blamed commit was
introduced in v5.14, no such API existed.

So the core DSA feature was introduced way too soon for lantiq_gswip.
Not acting on these host FDB entries and suppressing any errors has no
other negative effect, and practically returns us to not supporting the
host filtering feature at all - peacefully, this time.

Fixes: 10fae4ac89ce ("net: dsa: include bridge addresses which are local in the host fdb list")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Closes: https://lore.kernel.org/netdev/aJfNMLNoi1VOsPrN@pidgin.makrotopia.org/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250918072142.894692-3-vladimir.oltean@nxp.com
Tested-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 497964a5174bf..b1f18a840da77 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1368,8 +1368,9 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 	int i;
 	int err;
 
+	/* Operation not supported on the CPU port, don't throw errors */
 	if (!bridge)
-		return -EINVAL;
+		return 0;
 
 	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
 		if (priv->vlans[i].bridge == bridge) {
-- 
2.51.0



