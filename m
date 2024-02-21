Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB7B69954;
	Wed, 21 Feb 2024 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521104; cv=none; b=QgZAlwB5RpcsWZy4d2J1VwRcpBDl8Qm8sdpJmPxWiacdMbhwMmrHxeh5LtdyW60EoXL/56lk2LZCNrYM2l5CxiML00tDIhFn3x5ncYPgEvtu0kGMgoww28awDcz+RKYjeWEaaS35HN8EJm5xYs0qm+U+zTPn9wzgNz9pWtpm1rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521104; c=relaxed/simple;
	bh=SZbcjJ/8jqEpx2Ucqy3TuDGDNN1zoPfaOTy9C/NOt7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR3K2PTGdMS6OuCIVtWi/urqz3J9n2JbGrxPJhxfc6f9OY2wZJVEEGFJmeWsXVV9JsG3KaXJqv0F4hpl2/wfyRA23cwDJUB19ZdY94op4IQX+xmg9jHdVps+vINwwVGTgfV959vjE+rAL9jQDyAnHL8BQTFu5umqUcj/pq/EaWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7sqoibE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7sqoibE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C01C433C7;
	Wed, 21 Feb 2024 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521104;
	bh=SZbcjJ/8jqEpx2Ucqy3TuDGDNN1zoPfaOTy9C/NOt7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7sqoibE2OV7HKHXnK1K7rqJK+z4Vt24yMEZI1unF998N4Dav3yox/fOppcwMFbPD
	 CezdMXbvyPRGKtRT+urBQ2DSoysUyvOd4y5PTj5+8LNC+ubDvJd/vEftsBXgAQSPo3
	 ZfmoaQJaJ6ZwCTzNqL4t+rvq5j0HNUPy2b/u3F0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/202] vlan: skip nested type that is not IFLA_VLAN_QOS_MAPPING
Date: Wed, 21 Feb 2024 14:05:26 +0100
Message-ID: <20240221125932.593719229@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 74042b9d7f73..231eae2f1685 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -120,12 +120,16 @@ static int vlan_changelink(struct net_device *dev, struct nlattr *tb[],
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



