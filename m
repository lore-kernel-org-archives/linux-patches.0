Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4993C4B8D;
	Sat, 17 Oct 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260801; cv=none; b=Sfl2VJnlg4U3YFPng0OAQcHv3V305S/BmrtqWpgeO28mdHzxqrezQJHLZw20IL2BRvdkYv2Bm4Y/LnyNgehejU0EunTn6at+Hv5ZwYn5T71Sx1aBZwTFGAYBSFt001chRYCb/VOXxwb5m/bNblTvPlVoLySL28WeRAcnxoBNFSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260801; c=relaxed/simple;
	bh=7TlwC4xwiSGRLw5pj38D9Dhmp/hz3cnd8txlksxJi/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSZXiRFVpYBs9rjb7dk6d62e7EFcwUfBrmjjLrgTIDEYq3tbXQvvEVxcaVtC12h6sZTo8jDi9DpYD7DlQJHK7okx8+cZWDKwZuuFVnd4kb3bTcCOSp06kr3QSRir3IJOu8Nyskn31An7C16EEgbvspFUJ+d5/Sac1uTAIV/jssY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjvy9HhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjvy9HhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5431F000C4;
	Sat, 17 Oct 2026 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260799;
	bh=gME61Q4S42e7aBJG8Bb9FLOUs+64+y9cYciPp0QOmjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjvy9HhPq8tczxyet5vcMJCI6WJ2pnnRTFBXypr2ZtN639YRqT3y02QEJSkeAD2Ti
	 ayabitvokdTqC9W2+k91Tq4Ep4pXZJOJyUw3Pw2TR8QYxp/GKAyuWs5eOkerlhEAqe
	 NuQrrOlr6PKWsQSY7B0idpBzz+6JtEUXC9tZFHV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kangjing Huang <huangkangjing@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1663/1674] Revert "ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"
Date: Sat, 17 Oct 2026 18:05:35 +0200
Message-ID: <20261017160513.757094283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1a81ea738c030dfa83929a954e8c2cd15a91a883 ]

This reverts commit ecce70cf17d91c3dd87a0c4ea00b2d1387729701.

Revert the GUID trick code causing the layering violation.
I will try to allow the users to turn RDMA-capable on/off via sysfs later

Cc: Kangjing Huang <huangkangjing@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 40 +++++++++-------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8c450e5fd4f0b..d522ace20840d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2206,7 +2206,8 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 	if (ib_dev->node_type != RDMA_NODE_IB_CA)
 		smb_direct_port = SMB_DIRECT_PORT_IWARP;
 
-	if (!rdma_frwr_is_supported(&ib_dev->attrs))
+	if (!ib_dev->ops.get_netdev ||
+	    !rdma_frwr_is_supported(&ib_dev->attrs))
 		return 0;
 
 	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
@@ -2309,38 +2310,17 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
 			struct net_device *ndev;
 
-			if (smb_dev->ib_dev->ops.get_netdev) {
-				ndev = smb_dev->ib_dev->ops.get_netdev(
-					smb_dev->ib_dev, i + 1);
-				if (!ndev)
-					continue;
+			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
+							       i + 1);
+			if (!ndev)
+				continue;
 
-				if (ndev == netdev) {
-					dev_put(ndev);
-					rdma_capable = true;
-					goto out;
-				}
+			if (ndev == netdev) {
 				dev_put(ndev);
-			/* if ib_dev does not implement ops.get_netdev
-			 * check for matching infiniband GUID in hw_addr
-			 */
-			} else if (netdev->type == ARPHRD_INFINIBAND) {
-				struct netdev_hw_addr *ha;
-				union ib_gid gid;
-				u32 port_num;
-				int ret;
-
-				netdev_hw_addr_list_for_each(
-					ha, &netdev->dev_addrs) {
-					memcpy(&gid, ha->addr + 4, sizeof(gid));
-					ret = ib_find_gid(smb_dev->ib_dev, &gid,
-							  &port_num, NULL);
-					if (!ret) {
-						rdma_capable = true;
-						goto out;
-					}
-				}
+				rdma_capable = true;
+				goto out;
 			}
+			dev_put(ndev);
 		}
 	}
 out:
-- 
2.53.0



