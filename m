Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB1D73722;
	Mon, 29 Jan 2024 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548536; cv=none; b=tGfx0/lqL27+Vz/nKMIALAxxK1saZDpmKbMUlzY4WKufX8/18CTsIKsw9njXW/W6BIb4DFJByH+DOUNWD9dL7YZPGAlCOLTOoV9BofM7+pgn4LqzYLegRf9Tub1Feit/BqQlWWxxCFpBy7APcK6x8S85TxjXl18iwEvT/qEAmJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548536; c=relaxed/simple;
	bh=Ht5K8UXGgkMTbW/kpsa9kWGZfQI9WeMVXXxafd+GpjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDC//jui8Z2VuB/zJfezOduA46TRp5SSZLupOdxjwy6s3F7ZO3JWYC7aBGal/v7YbD0uTCtd7BxCvaD1YLdXVTBuQDozAvOdL6x7461lUpwgntPqU2P51/ewtnqfPTWieJ4tqZrFCyjK00e3X168wLVg3Skz5d0V4kkhpQOfwwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTvsds/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTvsds/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A5AC433F1;
	Mon, 29 Jan 2024 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548535;
	bh=Ht5K8UXGgkMTbW/kpsa9kWGZfQI9WeMVXXxafd+GpjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTvsds/vf4kIiS17oXGobXynCh7KuJqCZxEduZ21tYlAUSBtkMGwzyNYL17QPHeD5
	 grFWT1Nko0UdhldsCJCRu4FBHyScZDl+bAEG9k2aPfgutSwfv5aASsSyn4T4NIAH9N
	 OaW44L/TMWHLYPxs/VmagHJcvq/PWiDw3aGyfMSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/331] vlan: skip nested type that is not IFLA_VLAN_QOS_MAPPING
Date: Mon, 29 Jan 2024 09:03:58 -0800
Message-ID: <20240129170020.008432165@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



