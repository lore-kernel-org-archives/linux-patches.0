Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3C341C69;
	Tue, 11 Nov 2025 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825452; cv=none; b=mddF9QvVzsmwUEeEHtanxh1/toH1JXuMPoh4gC+dG6/u9Yz9qpx2SEYOA/yk2RKdNA4t+ZzFfBW1gS+L+1nUceT6tw7BCxuNKQgGT/hJJoDJQk8k3MMPZmFUx9+YSuqZ+yXp5cSJlPmJcqVApoXT23X945IESx+sZizE24bUw7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825452; c=relaxed/simple;
	bh=3KQ8HWD0UFg0qpPhqOVXjiiPW6W8dhnBp1ZhN9AbGg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/tQ0Gh2ndZbXVJk3fOqyAmE4Yckx5cUjLZc44m27vzIQRgNujGeGjHl1wk2xQTPIRRfCtn4UuhMhsAMo3feEjA7tsStDlZ0Cheov6EMqTXyHA60siTRESWupspkZYVA10eGqCYIwHv6hTiHVaXESLLn7oocRARAsZFc/HU9aVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkSEQjf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkSEQjf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD35C116B1;
	Tue, 11 Nov 2025 01:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825452;
	bh=3KQ8HWD0UFg0qpPhqOVXjiiPW6W8dhnBp1ZhN9AbGg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkSEQjf4ytWKc0w3nruPh4jLtoNQQl/Za7lI55aSEu//+QXbPeLHENIQpKEoLVd++
	 JUx6gWeT3RE1b4BQRaFUgj+5m2leEFyJihlK2b4gscYtOgNeAxHCUqLuB8VZj7VC7M
	 HicGokwQAjwnrmTUcl1LbSQqdjjfZpUKBc9bOS0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 764/849] net: vlan: sync VLAN features with lower device
Date: Tue, 11 Nov 2025 09:45:34 +0900
Message-ID: <20251111004554.903325473@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit c211f5d7cbd5cb34489d526648bb9c8ecc907dee ]

After registering a VLAN device and setting its feature flags, we need to
synchronize the VLAN features with the lower device. For example, the VLAN
device does not have the NETIF_F_LRO flag, it should be synchronized with
the lower device based on the NETIF_F_UPPER_DISABLES definition.

As the dev->vlan_features has changed, we need to call
netdev_update_features(). The caller must run after netdev_upper_dev_link()
links the lower devices, so this patch adds the netdev_update_features()
call in register_vlan_dev().

Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251030073539.133779-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index fda3a80e9340c..2b74ed56eb166 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -193,6 +193,8 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	vlan_group_set_device(grp, vlan->vlan_proto, vlan_id, dev);
 	grp->nr_vlan_devs++;
 
+	netdev_update_features(dev);
+
 	return 0;
 
 out_unregister_netdev:
-- 
2.51.0



