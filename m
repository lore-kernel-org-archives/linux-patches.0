Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FEE384CD5;
	Thu, 17 Sep 2026 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670460; cv=none; b=ud5Hn6BqpSPbVk8ZI4hHQMmhH43+U1j9pndveozWfWZl5T69zsmOOcNldCcSSXXJJ728NEDSR8zqGmZIKv+Fsq4sXDv9hNF9rXhIdhPBfl4vbwR9p3/ww1cox7acbHsahfT1ciR//+z1BShwglrOtdbMkdgbB4+Y1EfYjiUVpAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670460; c=relaxed/simple;
	bh=AlmciJmqbRUd9JlvxYVmwS1ZioZj35StQp6Bw1ZKiBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC8+mSZVFH4fXEj4BdXdld8d+cTU9Ud/vgEZLBeW2+6V/OMWq5oMRIElHurXKdwbwTd8CdEC33mIDCAegZag7J26ztXMj0QOVpMOFEgjdDu6I5q/15kjKmdtRTPm7Rs/aJtmEhVFE2B8UM5umZ5oDzrz6pbx7XBN6l6i9oqfhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkJzSPkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkJzSPkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545771F000FF;
	Thu, 17 Sep 2026 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670458;
	bh=HIBQVjPeEV1/uS1L6VgxmzZ1/6qtju8ivECvW6BVaVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkJzSPkSxRKX/m8GSWdU8emiCb5w0FzdXKdGPUoAOKz6CTvavflRHGNyDPavYfh9U
	 YV1FjAH5F3ylY8LvkCL/y5t7AF4rnKtfilptrb1i0iDkLswwww5KxVbFUEPDFndvNU
	 cnR2dl1IrMvdapRiLewiesWKPSg2srkF+7XrzxzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0667/1102] net: ethtool: remove the duplicated handling from rxfh and rxnfc
Date: Thu, 17 Sep 2026 16:10:10 +0100
Message-ID: <20260917151556.957152341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2a644c5cecc028c4fcd6545dd736b4dee949b090 ]

Now that the handles have been separated - remove the RX Flow Hash
handling from rxnfc functions and vice versa.

Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20250611145949.2674086-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1986bf87b07 ("eth: nfp: bound the ntuple rule dump by the caller's buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 57 ++++-----------------------------------------
 1 file changed, 5 insertions(+), 52 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index bd0467ea39e1a..e53af2fc5a23a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1074,19 +1074,7 @@ ethtool_set_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	if (rc)
 		return rc;
 
-	if (cmd == ETHTOOL_SRXCLSRLINS && info.fs.flow_type & FLOW_RSS) {
-		/* Nonzero ring with RSS only makes sense
-		 * if NIC adds them together
-		 */
-		if (!ops->cap_rss_rxnfc_adds &&
-		    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
-			return -EINVAL;
-
-		if (!xa_load(&dev->ethtool->rss_ctx, info.rss_context))
-			return -EINVAL;
-	}
-
-	if (cmd == ETHTOOL_SRXFH && ops->get_rxfh) {
+	if (ops->get_rxfh) {
 		struct ethtool_rxfh_param rxfh = {};
 
 		rc = ops->get_rxfh(dev, &rxfh);
@@ -1098,15 +1086,7 @@ ethtool_set_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 			return rc;
 	}
 
-	rc = ops->set_rxnfc(dev, &info);
-	if (rc)
-		return rc;
-
-	if (cmd == ETHTOOL_SRXCLSRLINS &&
-	    ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL))
-		return -EFAULT;
-
-	return 0;
+	return ops->set_rxnfc(dev, &info);
 }
 
 static noinline_for_stack int
@@ -1116,7 +1096,6 @@ ethtool_get_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	size_t info_size = sizeof(info);
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int ret;
-	void *rule_buf = NULL;
 
 	if (!ops->get_rxnfc)
 		return -EOPNOTSUPP;
@@ -1125,25 +1104,11 @@ ethtool_get_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
 	if (ret)
 		return ret;
 
-	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
-		if (info.rule_cnt > 0) {
-			if (info.rule_cnt <= KMALLOC_MAX_SIZE / sizeof(u32))
-				rule_buf = kcalloc(info.rule_cnt, sizeof(u32),
-						   GFP_USER);
-			if (!rule_buf)
-				return -ENOMEM;
-		}
-	}
-
-	ret = ops->get_rxnfc(dev, &info, rule_buf);
+	ret = ops->get_rxnfc(dev, &info, NULL);
 	if (ret < 0)
-		goto err_out;
-
-	ret = ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, rule_buf);
-err_out:
-	kfree(rule_buf);
+		return ret;
 
-	return ret;
+	return ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL);
 }
 
 static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
@@ -1167,18 +1132,6 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 	    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
 		return -EINVAL;
 
-	if (cmd == ETHTOOL_SRXFH && ops->get_rxfh) {
-		struct ethtool_rxfh_param rxfh = {};
-
-		rc = ops->get_rxfh(dev, &rxfh);
-		if (rc)
-			return rc;
-
-		rc = ethtool_check_xfrm_rxfh(rxfh.input_xfrm, info.data);
-		if (rc)
-			return rc;
-	}
-
 	rc = ops->set_rxnfc(dev, &info);
 	if (rc)
 		return rc;
-- 
2.53.0



