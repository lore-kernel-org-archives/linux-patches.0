Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DD33822A3;
	Wed,  8 Apr 2026 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672103; cv=none; b=dAjhkG8tMRXj/GY4SPkahM3kXGSRJ8u4IknCQobCzVm+jXJvlpaMBflG2kreNEdgU8bQ2PBGRTl0eYkJ3XWRs9e+cUn+htAcnL5a6dSQV5ycSUxL86+DRgZ8xaliAf8e5d5EtVgm9D2wrhOC1VTJAX7m3Er3ega2DqCbdI/dWvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672103; c=relaxed/simple;
	bh=elH5q12n7Xol1dUKL7c84H5xGFAj22mqD1OAOMAm6VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5tgBGmqjWcFg3EKVjerDRmoNFSOYRVZNpC/CM+KriQGaBl0qRyYU+S1dDbtGG443xR2JaIb2mc1DAVFJ4S1XO8yPCQesXxJ/VWMlwQ28F0wDxKnv5vkuZ42P30kNjNcixng5TlXyLnbBMaYMsgf34mPn7+5RYZS7gqOedp4o9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs4LMwdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs4LMwdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35E0C19421;
	Wed,  8 Apr 2026 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672103;
	bh=elH5q12n7Xol1dUKL7c84H5xGFAj22mqD1OAOMAm6VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qs4LMwdR1c0znEOlBmWrI4cAavjkBMIr9ZxMvSH595TJLofl8vpsVbFfhdB7yVDAr
	 SP7d2bOlidSWir+3dc1WS413nlPibKDHyVONIRHZB0/+AJ3DdJ1HZjItRnGn7uhI1D
	 +5/YfEf+Lmdod09qFuM6jox/SE1H+dow6AT5h25E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/312] net: hsr: fix VLAN add unwind on slave errors
Date: Wed,  8 Apr 2026 20:01:46 +0200
Message-ID: <20260408175940.819290356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 81eaae4c19da1..48f34ad9219fd 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -473,8 +473,8 @@ static void hsr_change_rx_flags(struct net_device *dev, int change)
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
@@ -490,33 +490,35 @@ static int hsr_ndo_vlan_rx_add_vid(struct net_device *dev,
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



