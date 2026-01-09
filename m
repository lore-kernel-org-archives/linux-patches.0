Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D682131E107;
	Fri,  9 Jan 2026 12:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961986; cv=none; b=A8vp8GtAG4duia8+kMtYziG2hGbORZtwARUlGFxHsehoPYmtvdhDxfa+FwWEHljliszi8UI5WHYl/rRL/BTtkZn6mDj7J4N2XnuG7zUekCLhpcxbukB5RR+rsD/yBWhKhqw/OZRJfewwjESoIJSjNWPH3PwSYYgwGsQXFW0OSfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961986; c=relaxed/simple;
	bh=38CXshL7B6VDRBls15sMTnNXxTky+SQ55Fy1G98kijc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayfxp4a/CMEaHORX8O921CVoVaYjDwF02WJFcRiHVorU3vVPv9wEhjAjEuudbcldWf0ScL+4IMkKNdZup/OGk3fDnXo6Ug969oNs630zUApQRu2PcYkBrm1QJe5NhGx+ekCaaJIgIctDGNe3wh4roB4XadGj3FLEv2HB1NFh+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJW1Qi3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJW1Qi3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645B4C4CEF1;
	Fri,  9 Jan 2026 12:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961986;
	bh=38CXshL7B6VDRBls15sMTnNXxTky+SQ55Fy1G98kijc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJW1Qi3x1vbtJKTt6Lu7ksbILbKNgLxGFPP0DUkHuPDqZySSHlRboli9BqRygIHuy
	 7bLFwoBDqKrloEbnAlM1axwshQvedyctXgN0KM/ddadJd9jzWdb/0Il1nVi3kpRys6
	 WUgfv5+OdbVNcDYOA4PGTPpoUDGkD/5nL1tbhVtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/634] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Fri,  9 Jan 2026 12:37:31 +0100
Message-ID: <20260109112123.954896735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 634f3853cc98d73bdec8918010ee29b06981583e ]

Add a sanity check to skip path discovery if the maximum number of
encapsulation is reached. While at it, check for underflow too.

Fixes: 26267bf9bb57 ("netfilter: flowtable: bridge vlan hardware offload and switchdev")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 9d335aa58907d..786519740b559 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -140,12 +140,19 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				info->num_encaps--;
+				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+					info->indev = NULL;
+					break;
+				}
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.51.0



