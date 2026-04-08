Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AAD328B75;
	Wed,  8 Apr 2026 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673093; cv=none; b=AQtBEuVHoGMeuWbLVBNcgctidGGUkFoDDBCE2oVCoSG6u59Am1yaELnVn6QNR4+Du47jPUvIK5Mh0HSDj/dvaDH1U3KTWgFyYPWFW4N3hWcrb0T40ujNW/V8mSIEZmnp5APjWJm+8BqxQeKCBJr93bcWr4j06RM46UDnTFSO2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673093; c=relaxed/simple;
	bh=O+Ti3gCrz+wC9LuJV3DLRrGFt6YtREMWNqTkFiF6n94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p90dh3j4IQfqtj+QcMpLdyJpHAafXUhnW56n/I6LFUfutBqinM4zeUK4zkYG56EMnXdMrNahputHF7+tCVDy44j9TcYNXnx4xWeG0BwNx18s2/abqttuoR6AuPFvqx5Ka8nUviQrmM06PlC1sjCaNTascjOqPVa4RItqSsNLwbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8Zpj+O/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8Zpj+O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289F4C19421;
	Wed,  8 Apr 2026 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673093;
	bh=O+Ti3gCrz+wC9LuJV3DLRrGFt6YtREMWNqTkFiF6n94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8Zpj+O/V8c3X94L8D4EJYRYldbZsHwSPf5Z6tcF4rH2BkyY6zNb9gBnmJ23W2isT
	 j5aRwLq/4R6xiv6M+Lxzc4uYgJFebol+KNfs2ArIK9C+DWzg7hX4bmDqcnLgxOemI0
	 QJUD/+XbFwTUrtC//RyyqSpiexwkDIvksyh2rVdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/277] net: hsr: fix VLAN add unwind on slave errors
Date: Wed,  8 Apr 2026 20:01:23 +0200
Message-ID: <20260408175937.533774587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit 2e3514e63bfb0e972b1f19668547a455d0129e88 ]

When vlan_vid_add() fails for a secondary slave, the error path calls
vlan_vid_del() on the failing port instead of the peer slave that had
already succeeded. This results in asymmetric VLAN state across the HSR
pair.

Fix this by switching to a centralized unwind path that removes the VID
from any slave device that was already programmed.

Fixes: 1a8a63a5305e ("net: hsr: Add VLAN CTAG filter support")
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260401092243.52121-3-luka.gejak@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index d1bfc49b5f017..fd2fea25eff0d 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -532,8 +532,8 @@ static void hsr_change_rx_flags(struct net_device *dev, int change)
 static int hsr_ndo_vlan_rx_add_vid(struct net_device *dev,
 				   __be16 proto, u16 vid)
 {
-	bool is_slave_a_added = false;
-	bool is_slave_b_added = false;
+	struct net_device *slave_a_dev = NULL;
+	struct net_device *slave_b_dev = NULL;
 	struct hsr_port *port;
 	struct hsr_priv *hsr;
 	int ret = 0;
@@ -549,33 +549,35 @@ static int hsr_ndo_vlan_rx_add_vid(struct net_device *dev,
 		switch (port->type) {
 		case HSR_PT_SLAVE_A:
 			if (ret) {
-				/* clean up Slave-B */
 				netdev_err(dev, "add vid failed for Slave-A\n");
-				if (is_slave_b_added)
-					vlan_vid_del(port->dev, proto, vid);
-				return ret;
+				goto unwind;
 			}
-
-			is_slave_a_added = true;
+			slave_a_dev = port->dev;
 			break;
-
 		case HSR_PT_SLAVE_B:
 			if (ret) {
-				/* clean up Slave-A */
 				netdev_err(dev, "add vid failed for Slave-B\n");
-				if (is_slave_a_added)
-					vlan_vid_del(port->dev, proto, vid);
-				return ret;
+				goto unwind;
 			}
-
-			is_slave_b_added = true;
+			slave_b_dev = port->dev;
 			break;
 		default:
+			if (ret)
+				goto unwind;
 			break;
 		}
 	}
 
 	return 0;
+
+unwind:
+	if (slave_a_dev)
+		vlan_vid_del(slave_a_dev, proto, vid);
+
+	if (slave_b_dev)
+		vlan_vid_del(slave_b_dev, proto, vid);
+
+	return ret;
 }
 
 static int hsr_ndo_vlan_rx_kill_vid(struct net_device *dev,
-- 
2.53.0



