Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021BE7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BB9C433C7;
	Sun, 17 Sep 2023 20:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981971;
	bh=kmW15roF7+RoVm7TXv3fKfC0O++K/5LYnoqpzTzcVrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcjrUIn3UEvu1u8mIjSk6/itx0lVNQKsBJQv4Z/qXbL3ZlNt6Wt3VcwK+11TyCLgK
	 q6g8mcmPjBYb6icX7IVgzJgGgaem5N/5vo5bnbizPHcZwRoGZvWrw9QA4oru+iGbPL
	 SyM97tTM+6/UuSypErBttrzbUD5MD2oWdRvEyoRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/219] net: dsa: sja1105: block FDB accesses that are concurrent with a switch reset
Date: Sun, 17 Sep 2023 21:15:27 +0200
Message-ID: <20230917191048.172290062@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 86899e9e1e29e854b5f6dcc24ba4f75f792c89aa ]

Currently, when we add the first sja1105 port to a bridge with
vlan_filtering 1, then we sometimes see this output:

sja1105 spi2.2: port 4 failed to read back entry for be:79:b4:9e:9e:96 vid 3088: -ENOENT
sja1105 spi2.2: Reset switch and programmed static config. Reason: VLAN filtering
sja1105 spi2.2: port 0 failed to add be:79:b4:9e:9e:96 vid 0 to fdb: -2

It is because sja1105_fdb_add() runs from the dsa_owq which is no longer
serialized with switch resets since it dropped the rtnl_lock() in the
blamed commit.

Either performing the FDB accesses before the reset, or after the reset,
is equally fine, because sja1105_static_fdb_change() backs up those
changes in the static config, but FDB access during reset isn't ok.

Make sja1105_static_config_reload() take the fdb_lock to fix that.

Fixes: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c6c74e302e4dd..f1f1368e8146f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2304,6 +2304,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	int rc, i;
 	s64 now;
 
+	mutex_lock(&priv->fdb_lock);
 	mutex_lock(&priv->mgmt_lock);
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
@@ -2418,6 +2419,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		goto out;
 out:
 	mutex_unlock(&priv->mgmt_lock);
+	mutex_unlock(&priv->fdb_lock);
 
 	return rc;
 }
-- 
2.40.1



