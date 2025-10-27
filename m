Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B4932B9B2;
	Mon, 27 Oct 2025 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593211; cv=none; b=tldXlf0h36eVfSyFQpmBXihriVCxYpv1mr+unj1oVHSwtIdJ7tPTQNr6V7GiY1zLGPpUJq25qnmaIhtzKue+WDAbgNQAeOwwaiZnFDc7QhI8980XYVPmIohtT+HnAWkSF5lePN9/yGaqJOV6gi3E1IZeOTvDwQgPnoaNEexWb7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593211; c=relaxed/simple;
	bh=Vs5rJc/YYAC1zS9DMvQrbqOxMEO9M55f1CwRDEgNt/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOjKm8tftZRjNL9cry373a+PGBIFhMF7KDnydGZUf1lsLWCp6eOddeVKSwmq3Wqes1sIU6Qnh/eFKjSUHnTdiaHxO2Bb5ORf/aNL8FCEqtwI9zeRS1VToHXeoHhHV4G17tqYwUMSDNxOv46S5+eILTiL5yzNBLplj4/naoCUP8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2n/Zfc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2n/Zfc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FF5C4CEF1;
	Mon, 27 Oct 2025 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593210;
	bh=Vs5rJc/YYAC1zS9DMvQrbqOxMEO9M55f1CwRDEgNt/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2n/Zfc5SlI7JUZvQCo28Xti4aLj87Yq+D8bnI4apWeXwDT4BgLRohhM1UO17Sjsu
	 zP2tIxv3N3Csr4/YPGOh54ZXz8+9P6RS7PeGzME/Qra2bTNxNr/d8Yj5RrIBsaeqfu
	 w+K49Ryj0pmRrMOni+MK9cdkUCur/sot8gQsq6/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 055/184] net: hsr: prevent creation of HSR device with slaves from another netns
Date: Mon, 27 Oct 2025 19:35:37 +0100
Message-ID: <20251027183516.381140184@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c0178eec8884231a5ae0592b9fce827bccb77e86 ]

HSR/PRP driver does not handle correctly having slaves/interlink devices
in a different net namespace. Currently, it is possible to create a HSR
link in a different net namespace than the slaves/interlink with the
following command:

 ip link add hsr0 netns hsr-ns type hsr slave1 eth1 slave2 eth2

As there is no use-case on supporting this scenario, enforce that HSR
device link matches netns defined by IFLA_LINK_NETNSID.

The iproute2 command mentioned above will throw the following error:

 Error: hsr: HSR slaves/interlink must be on the same net namespace than HSR link.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20251020135533.9373-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index b120470246cc5..c96b63adf96ff 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -34,12 +34,18 @@ static int hsr_newlink(struct net_device *dev,
 		       struct netlink_ext_ack *extack)
 {
 	struct net *link_net = rtnl_newlink_link_net(params);
+	struct net_device *link[2], *interlink = NULL;
 	struct nlattr **data = params->data;
 	enum hsr_version proto_version;
 	unsigned char multicast_spec;
 	u8 proto = HSR_PROTOCOL_HSR;
 
-	struct net_device *link[2], *interlink = NULL;
+	if (!net_eq(link_net, dev_net(dev))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "HSR slaves/interlink must be on the same net namespace than HSR link");
+		return -EINVAL;
+	}
+
 	if (!data) {
 		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
 		return -EINVAL;
-- 
2.51.0



