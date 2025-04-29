Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8CC3FFD;
	Tue, 29 Apr 2025 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949646; cv=none; b=PepdRauEpvIInqDgO3qDFrOwnbJVHnHqD9nuey1vspfE+VHKfj2MUiT5QsvOLKzcb7AA/iwJCgm/mXTjK8kbkDvi6Xq7f7JCiHL3A5kk6u3sSMyFKdu6wwD9TDv/zO1BmqkM9faE9AyDM7dQExTsZLrrQSfXj8OZLgEXqrwOTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949646; c=relaxed/simple;
	bh=dQFfjjjVOD5bedv56xqdoQJzqpG1a2TYPB5JWL/L6Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhcGLcpP0nqUvdCdUSh7a02mOB+WUdR4UcZ92Q3BmFdERUsABVt8yhsqrR1llNunG/lN2olxzPt4LcnurhOhExlwIV21KsbuoD1vUpseWPgoLu/0B2ftzaj6MnQAns3hLLRLJcq0eAfwFNkUuUf9Xdwu40QHi2bxczcBtH1iNM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlVR4SH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlVR4SH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0E9C4CEE3;
	Tue, 29 Apr 2025 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949645;
	bh=dQFfjjjVOD5bedv56xqdoQJzqpG1a2TYPB5JWL/L6Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlVR4SH3660O0Nsc4WRH3xb6i9evpBuEr/G+M7it+4vnmzGrxD1SJPEwyau9CAUtR
	 S6J3dC6OhD0rwkZTYvi1qnuYlHQWvzbCMtuqbxnwzuX3SIceWVEI8mHwPtvoNJn1n0
	 EjaGxHNtwOa/oeoPL3JQgaUM3Vaz26A5Gpbcm3Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/167] net: dsa: add support for mac_prepare() and mac_finish() calls
Date: Tue, 29 Apr 2025 18:41:59 +0200
Message-ID: <20250429161052.206546974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit dd805cf3e80e038aeb06902399ce9bd6fafb4ff3 ]

Add DSA support for the phylink mac_prepare() and mac_finish() calls.
These were introduced as part of the PCS support to allow MACs to
perform preparatory steps prior to configuration, and finalisation
steps after the MAC and PCS has been configured.

Introducing phylink_pcs support to the mv88e6xxx DSA driver needs some
code moved out of its mac_config() stage into the mac_prepare() and
mac_finish() stages, and this commit facilitates such code in DSA
drivers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 52fdc41c3278 ("net: dsa: mv88e6xxx: fix internal PHYs for 6320 family")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/port.c    | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f96b61d9768e0..e26bace774799 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -888,9 +888,15 @@ struct dsa_switch_ops {
 						      phy_interface_t iface);
 	int	(*phylink_mac_link_state)(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state);
+	int	(*phylink_mac_prepare)(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface);
 	void	(*phylink_mac_config)(struct dsa_switch *ds, int port,
 				      unsigned int mode,
 				      const struct phylink_link_state *state);
+	int	(*phylink_mac_finish)(struct dsa_switch *ds, int port,
+				      unsigned int mode,
+				      phy_interface_t interface);
 	void	(*phylink_mac_an_restart)(struct dsa_switch *ds, int port);
 	void	(*phylink_mac_link_down)(struct dsa_switch *ds, int port,
 					 unsigned int mode,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 750fe68d9b2a0..cd1741792f6a9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1599,6 +1599,21 @@ dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 	return pcs;
 }
 
+static int dsa_port_phylink_mac_prepare(struct phylink_config *config,
+					unsigned int mode,
+					phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	if (ds->ops->phylink_mac_prepare)
+		err = ds->ops->phylink_mac_prepare(ds, dp->index, mode,
+						   interface);
+
+	return err;
+}
+
 static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)
@@ -1612,6 +1627,21 @@ static void dsa_port_phylink_mac_config(struct phylink_config *config,
 	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
 }
 
+static int dsa_port_phylink_mac_finish(struct phylink_config *config,
+				       unsigned int mode,
+				       phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	if (ds->ops->phylink_mac_finish)
+		err = ds->ops->phylink_mac_finish(ds, dp->index, mode,
+						  interface);
+
+	return err;
+}
+
 static void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
@@ -1667,7 +1697,9 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
 	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
 	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
+	.mac_prepare = dsa_port_phylink_mac_prepare,
 	.mac_config = dsa_port_phylink_mac_config,
+	.mac_finish = dsa_port_phylink_mac_finish,
 	.mac_an_restart = dsa_port_phylink_mac_an_restart,
 	.mac_link_down = dsa_port_phylink_mac_link_down,
 	.mac_link_up = dsa_port_phylink_mac_link_up,
-- 
2.39.5



