Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954411519BF;
	Wed,  5 Feb 2025 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767743; cv=none; b=jo1Vjof/Jx5kkqWvRso4Wu4Zpyreom3tePavJ6QwFGCogoPhVJSKde4QTT2p/ng+lwo/Qdchk7glioF7L/YtoD7wKcIfkPn561urzV0FP3TEiG8/MODz0wruELhjL9Roq0L6VEWGCtpz/dR8mmfcx10nAOB5QWvFfSGzw4a45ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767743; c=relaxed/simple;
	bh=+sQMuiGP4A7U9lCM0C5XlSvgAwSO2nlioi3dc7ikrV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLZmttfvpfMvzER3CrAlQ7Cq7DFcGdT6IWl/B+s0Ls+BRgYT297pRS0oZb8PoLdpiR+5Dc9VKwPkVQb+eSUYfTbbscepwExKX7pgPSJixAaqCNM6sJBYC0vhJwA0XtY78zO29jWBMLaYgySx22sAKYsTnTNHU/BN0OZ0VsMUuT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b20P/j0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b20P/j0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A5FC4CED1;
	Wed,  5 Feb 2025 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767743;
	bh=+sQMuiGP4A7U9lCM0C5XlSvgAwSO2nlioi3dc7ikrV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b20P/j0PdTJ/CIh29UVqcb569TnBmQ2lnVxcxjqU53HWU2fKkX+8ll8qh1MxWk3UK
	 XiH6rFEzWdgI6BYx034zQokrFU2xZ37p1pI6dWRxzf0ZLHxkNQqoBCcwkVvnBejRKK
	 intIBgBmUY5W8y6pVsOQuBfAN/+PUDQ9i96JA7ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 503/590] ethtool: Fix set RXNFC command with symmetric RSS hash
Date: Wed,  5 Feb 2025 14:44:18 +0100
Message-ID: <20250205134514.512454593@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 4f5a52adeb1ad675ca33f1e1eacd9c0bbaf393d4 ]

The sanity check that both source and destination are set when symmetric
RSS hash is requested is only relevant for ETHTOOL_SRXFH (rx-flow-hash),
it should not be performed on any other commands (e.g.
ETHTOOL_SRXCLSRLINS/ETHTOOL_SRXCLSRLDEL).

This resolves accessing uninitialized 'info.data' field, and fixes false
errors in rule insertion:
  # ethtool --config-ntuple eth2 flow-type ip4 dst-ip 255.255.255.255 action -1 loc 0
  rmgr: Cannot insert RX class rule: Invalid argument
  Cannot insert classification rule

Fixes: 13e59344fb9d ("net: ethtool: add support for symmetric-xor RSS hash")
Cc: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>
Link: https://patch.msgid.link/20250126191845.316589-1-gal@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 8b28347039b50..7b95cf1addec4 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -997,7 +997,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 	    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
 		return -EINVAL;
 
-	if (ops->get_rxfh) {
+	if (cmd == ETHTOOL_SRXFH && ops->get_rxfh) {
 		struct ethtool_rxfh_param rxfh = {};
 
 		rc = ops->get_rxfh(dev, &rxfh);
-- 
2.39.5



