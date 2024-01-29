Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCFE15B973;
	Mon, 29 Jan 2024 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548125; cv=none; b=FXixE/KZ2eK0ndTLC398j61Oi7NZ7Lx8D6c2XV2G+G6JFoHMVEuOGam1waGeY/3OAwLguKjdZWtgUGICNXOJZkkCDZEdefZ0kWYcvHPybxYQcxmdr37Lj5+Yv0OHd2V1MAKkhug4tGyviMTk+wuArg8Y36XKvdRVgwBYaCqd5bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548125; c=relaxed/simple;
	bh=dCrlwWSlU5BBm1RtfEOZBsrBUIy2If/LOhIe50LFbGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTT4wX0e6RKbGo2xmu0eJX6J3JB1Lo9+8Wd3wSuQ+QgXZPwFuJB60q/rP9L+9ywymYXAOUUynor/F2H66wNjGlkc0a0639sjKZYVUCOO3T1z8xXYHQR0bzPnBNyT5G3pX4kSZqE/6use4a0y3Ndhp+6zBknkX14A5+MrAri2DwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoco83n6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoco83n6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F5C433C7;
	Mon, 29 Jan 2024 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548125;
	bh=dCrlwWSlU5BBm1RtfEOZBsrBUIy2If/LOhIe50LFbGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoco83n6fTxX51PrYJYxxg0OaVAUUM+fv8D6HNPjFixGXblUIZrmVQEVocO6hFAHl
	 4reTKHcKlnNghCupskngwJdP9Dj5USqRudMvCjGyTsYNTdLZtnD4QxLbckQrNUX/7m
	 r6fQkbpN2dnmtZdxlKI1+/p1ms3a3tKKES3Jh2eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 153/346] vlan: skip nested type that is not IFLA_VLAN_QOS_MAPPING
Date: Mon, 29 Jan 2024 09:03:04 -0800
Message-ID: <20240129170020.910749297@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 6c21660fe221a15c789dee2bc2fd95516bc5aeaf ]

In the vlan_changelink function, a loop is used to parse the nested
attributes IFLA_VLAN_EGRESS_QOS and IFLA_VLAN_INGRESS_QOS in order to
obtain the struct ifla_vlan_qos_mapping. These two nested attributes are
checked in the vlan_validate_qos_map function, which calls
nla_validate_nested_deprecated with the vlan_map_policy.

However, this deprecated validator applies a LIBERAL strictness, allowing
the presence of an attribute with the type IFLA_VLAN_QOS_UNSPEC.
Consequently, the loop in vlan_changelink may parse an attribute of type
IFLA_VLAN_QOS_UNSPEC and believe it carries a payload of
struct ifla_vlan_qos_mapping, which is not necessarily true.

To address this issue and ensure compatibility, this patch introduces two
type checks that skip attributes whose type is not IFLA_VLAN_QOS_MAPPING.

Fixes: 07b5b17e157b ("[VLAN]: Use rtnl_link API")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240118130306.1644001-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 214532173536..a3b68243fd4b 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -118,12 +118,16 @@ static int vlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	}
 	if (data[IFLA_VLAN_INGRESS_QOS]) {
 		nla_for_each_nested(attr, data[IFLA_VLAN_INGRESS_QOS], rem) {
+			if (nla_type(attr) != IFLA_VLAN_QOS_MAPPING)
+				continue;
 			m = nla_data(attr);
 			vlan_dev_set_ingress_priority(dev, m->to, m->from);
 		}
 	}
 	if (data[IFLA_VLAN_EGRESS_QOS]) {
 		nla_for_each_nested(attr, data[IFLA_VLAN_EGRESS_QOS], rem) {
+			if (nla_type(attr) != IFLA_VLAN_QOS_MAPPING)
+				continue;
 			m = nla_data(attr);
 			err = vlan_dev_set_egress_priority(dev, m->from, m->to);
 			if (err)
-- 
2.43.0



