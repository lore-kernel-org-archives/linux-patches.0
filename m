Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D3A3DB339;
	Thu, 17 Sep 2026 18:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670457; cv=none; b=cxn0ATpka0FcG85Ysve8Igki/SnzL1B6KtLwOLasUaDS5yRQyvLUgFpdJXgqlyb7OM9rhGFWzJWfjy8hvT5LVHqDZlwbapQESUhvd5m3z349LsF8H5+fI0Bfyo4XnJAvuPpOLPvOqDJVA5155lmWTbKUHchd0N8X23+qplfeHmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670457; c=relaxed/simple;
	bh=1T6PUC4idb7qZQOG8kr5ecjtM1qNuQJZHMtaf8Huu6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip+yHmB9EOiHQnWFiQ9lgZOKSZ0VdzGudD2m5P4VHSHt3GCzeA8K/rkvZdPcGq5mNHqttoX7DdlQWPIZtcXywrT36A3qC1b6u4CP9XTEoSNfveNiSaVwrEN+wnUuk2szhnfOj33xYYS4uLisEIAvxVdR1VR1g2040QZr5GzPzLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxEKrGPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxEKrGPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589181F00893;
	Thu, 17 Sep 2026 18:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670455;
	bh=NwVy6TXtb+W43sgCJAW5A3Oz93mMILtcc71pmFHNj/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxEKrGPltriKVGRclnMmjbQkGv+M7+W+7wjoeaa+n5ABRZGzMHKqzemH4cA7xBA+1
	 PAtCOe8bmFDctFooZJQhZVwYPxdosGF+2NfHDkmPDW5q5a1MmuzOv2zr/DPyCi/j3W
	 zZLICyMguZa7Pf8sdM677Umwe1Jx6GlPV8iMMxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0666/1102] net: ethtool: copy the rxfh flow handling
Date: Thu, 17 Sep 2026 16:10:09 +0100
Message-ID: <20260917151556.930078297@linuxfoundation.org>
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

[ Upstream commit f4f126535546e275ffd89cdb9cc2fd581ebf3670 ]

RX Flow Hash configuration uses the same argument structure
as flow filters. This is probably why ethtool IOCTL handles
them together. The more checks we add the more convoluted
this code is getting (as some of the checks apply only
to flow filters and others only to the hashing).

Copy the code to separate the handling. This is an exact
copy, the next change will remove unnecessary handling.

Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20250611145949.2674086-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f1986bf87b07 ("eth: nfp: bound the ntuple rule dump by the caller's buffer size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 93 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 18dfb4fdf1f03..bd0467ea39e1a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1059,6 +1059,93 @@ static int ethtool_check_flow_types(struct net_device *dev, u32 input_xfrm)
 	return 0;
 }
 
+static noinline_for_stack int
+ethtool_set_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxnfc info;
+	size_t info_size = sizeof(info);
+	int rc;
+
+	if (!ops->set_rxnfc)
+		return -EOPNOTSUPP;
+
+	rc = ethtool_rxnfc_copy_struct(cmd, &info, &info_size, useraddr);
+	if (rc)
+		return rc;
+
+	if (cmd == ETHTOOL_SRXCLSRLINS && info.fs.flow_type & FLOW_RSS) {
+		/* Nonzero ring with RSS only makes sense
+		 * if NIC adds them together
+		 */
+		if (!ops->cap_rss_rxnfc_adds &&
+		    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
+			return -EINVAL;
+
+		if (!xa_load(&dev->ethtool->rss_ctx, info.rss_context))
+			return -EINVAL;
+	}
+
+	if (cmd == ETHTOOL_SRXFH && ops->get_rxfh) {
+		struct ethtool_rxfh_param rxfh = {};
+
+		rc = ops->get_rxfh(dev, &rxfh);
+		if (rc)
+			return rc;
+
+		rc = ethtool_check_xfrm_rxfh(rxfh.input_xfrm, info.data);
+		if (rc)
+			return rc;
+	}
+
+	rc = ops->set_rxnfc(dev, &info);
+	if (rc)
+		return rc;
+
+	if (cmd == ETHTOOL_SRXCLSRLINS &&
+	    ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL))
+		return -EFAULT;
+
+	return 0;
+}
+
+static noinline_for_stack int
+ethtool_get_rxfh_fields(struct net_device *dev, u32 cmd, void __user *useraddr)
+{
+	struct ethtool_rxnfc info;
+	size_t info_size = sizeof(info);
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int ret;
+	void *rule_buf = NULL;
+
+	if (!ops->get_rxnfc)
+		return -EOPNOTSUPP;
+
+	ret = ethtool_rxnfc_copy_struct(cmd, &info, &info_size, useraddr);
+	if (ret)
+		return ret;
+
+	if (info.cmd == ETHTOOL_GRXCLSRLALL) {
+		if (info.rule_cnt > 0) {
+			if (info.rule_cnt <= KMALLOC_MAX_SIZE / sizeof(u32))
+				rule_buf = kcalloc(info.rule_cnt, sizeof(u32),
+						   GFP_USER);
+			if (!rule_buf)
+				return -ENOMEM;
+		}
+	}
+
+	ret = ops->get_rxnfc(dev, &info, rule_buf);
+	if (ret < 0)
+		goto err_out;
+
+	ret = ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, rule_buf);
+err_out:
+	kfree(rule_buf);
+
+	return ret;
+}
+
 static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 						u32 cmd, void __user *useraddr)
 {
@@ -3336,13 +3423,17 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 				       dev->ethtool_ops->set_priv_flags);
 		break;
 	case ETHTOOL_GRXFH:
+		rc = ethtool_get_rxfh_fields(dev, ethcmd, useraddr);
+		break;
+	case ETHTOOL_SRXFH:
+		rc = ethtool_set_rxfh_fields(dev, ethcmd, useraddr);
+		break;
 	case ETHTOOL_GRXRINGS:
 	case ETHTOOL_GRXCLSRLCNT:
 	case ETHTOOL_GRXCLSRULE:
 	case ETHTOOL_GRXCLSRLALL:
 		rc = ethtool_get_rxnfc(dev, ethcmd, useraddr);
 		break;
-	case ETHTOOL_SRXFH:
 	case ETHTOOL_SRXCLSRLDEL:
 	case ETHTOOL_SRXCLSRLINS:
 		rc = ethtool_set_rxnfc(dev, ethcmd, useraddr);
-- 
2.53.0



