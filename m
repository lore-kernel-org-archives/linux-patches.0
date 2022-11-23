Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A21C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742B6C43470;
	Wed, 23 Nov 2022 09:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195999;
	bh=bwCkclChuXAGyI3r2C3Ee8yAxsmjkMXgiI6MZEUmPQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJZSIa/kp63VawTUlNyq4OEqLzsUX1cAP456ND5Vco/O+Ygiv+s1t5IzeiDzDnAmz
	 FexGBdxNs7nYFJRkkyoyuRVKGxknao517qHITZvl5ubJWfzbFjpgrwZnK4wZLyqSX5
	 JfB3FN6M7xdYqdGwzZIGM40xITSxBzaPssI1Y9pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	=?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Fabio Estevam <festevam@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/181] net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
Date: Wed, 23 Nov 2022 09:50:53 +0100
Message-Id: <20221123084606.224982446@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ed1fe1bebe18884b11e5536b5ac42e3a48960835 ]

There are multi-generational drivers like mv88e6xxx which have code like
this:

int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
				struct ifreq *ifr)
{
	if (!chip->info->ptp_support)
		return -EOPNOTSUPP;

	...
}

DSA wants to deny PTP timestamping on the master if the switch supports
timestamping too. However it currently relies on the presence of the
port_hwtstamp_get() callback to determine PTP capability, and this
clearly does not work in that case (method is present but returns
-EOPNOTSUPP).

We should not deny PTP on the DSA master for those switches which truly
do not support hardware timestamping.

Create a dsa_port_supports_hwtstamp() method which actually probes for
support by calling port_hwtstamp_get() and seeing whether that returned
-EOPNOTSUPP or not.

Fixes: f685e609a301 ("net: dsa: Deny PTP on master if switch supports it")
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221110124345.3901389-1-festevam@gmail.com/
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa_priv.h |  1 +
 net/dsa/master.c   |  3 +--
 net/dsa/port.c     | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a5c9bc7b66c6..e91265434354 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -198,6 +198,7 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
diff --git a/net/dsa/master.c b/net/dsa/master.c
index e8e19857621b..69ec510abe83 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -204,8 +204,7 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		 * switch in the tree that is PTP capable.
 		 */
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->ds->ops->port_hwtstamp_get ||
-			    dp->ds->ops->port_hwtstamp_set)
+			if (dsa_port_supports_hwtstamp(dp, ifr))
 				return -EBUSY;
 		break;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a21015d6bd36..31e8a7a8c3e6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -75,6 +75,22 @@ static bool dsa_port_can_configure_learning(struct dsa_port *dp)
 	return !err;
 }
 
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_hwtstamp_get || !ds->ops->port_hwtstamp_set)
+		return false;
+
+	/* "See through" shim implementations of the "get" method.
+	 * This will clobber the ifreq structure, but we will either return an
+	 * error, or the master will overwrite it with proper values.
+	 */
+	err = ds->ops->port_hwtstamp_get(ds, dp->index, ifr);
+	return err != -EOPNOTSUPP;
+}
+
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
-- 
2.35.1



