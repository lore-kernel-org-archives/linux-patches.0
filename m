Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0E57C6E9;
	Wed, 21 Feb 2024 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524991; cv=none; b=UPmHJOTBqQErmx5pJQ/henZOS/mU/St4fEfo102WY1YvBhW5YCt13Am5fN42XBgPnIrs7jJsn14nqmYBhItjgBLX7wCm6kGlhsoHq3GvJjTddGjT8QpHuX9cVEYW7mEC3tQlaJFwPwQ/S7vuCYbeJz70fVRF6ct7ZdfbPW9aMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524991; c=relaxed/simple;
	bh=5W4BEMQ4b6mWEG7zZZxc18CTP1Hkl2NoHjf+rW1FJc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evWiR4sSf1xnz+WEBpsOoLjHH599LJaViXctzRf3TXxY/xMGtKWwfD8XlwIZ+/WMQYM7AaBlDOqVXIC7EE7lzD3lAgOttjMO86YQFX5goMkaRWje7Bcq6kmdLNfie2KuAJc4TlbAtlT7SldrG7Y3+YY5dHXQvnzfHn0AyR+Zqaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUtLoMty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUtLoMty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D47C433F1;
	Wed, 21 Feb 2024 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524991;
	bh=5W4BEMQ4b6mWEG7zZZxc18CTP1Hkl2NoHjf+rW1FJc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUtLoMty2zYdXZgOFzxYic/Yy0WDOAo6Gu7hi0zc8j3TrVRR/mGSB+fk1HX7sFTWp
	 cNwm+5uT6wzNJgYsfTJCduJ4yFt5estVSxRIesBjewMOR1++rkRBLpOIvqhXBBwAqe
	 r47BommLpHznOhd8lbcJiG6ax+3Uxl3sEMaLn1Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/267] vlan: skip nested type that is not IFLA_VLAN_QOS_MAPPING
Date: Wed, 21 Feb 2024 14:06:08 +0100
Message-ID: <20240221125940.898565783@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0db85aeb119b..99b277775257 100644
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



