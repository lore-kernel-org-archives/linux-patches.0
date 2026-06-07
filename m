Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1621E98EF;
	Sun,  7 Jun 2026 10:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827164; cv=none; b=Ezr8U2trh+tcnEaYI+VF+rSO4CGA8WuZlHkcfk2alHnCyCNWqBVxfVCKspElTthz51A3XOab5NWxlMNE9wwExEYfkxXRBNpLMvJ3CDQOQOmyYpE+27YarMqPBnX0u+yBW/clEYIFY3yzHSOXd0PSPuWTemPXxIxNEKwe/hV5sek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827164; c=relaxed/simple;
	bh=vWS2R2xvqLqfS01Z3bfIcCbhIgngnj1Ju9F2rQ2OalY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpnBb3IruJIZFpaqgvQIO6jCVR1GNIr10OxPXPYmiabEGVwlEIqUSqpOImew9og5ce/lt4SNaUNRqFj3+v9uq4A7Ylc1BResw7FAeToZYtaGTxRBCjjxW53Vvn3MX+StRKD4yv5Ki/t5JPeO+QguztHrYFLRsShAednZpcG3ZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+oFYeTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+oFYeTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9751F00893;
	Sun,  7 Jun 2026 10:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827163;
	bh=sJJkDbd3KF8MMfx8cIoodbzpkgzjHXA5eW0FrhMaVCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+oFYeTbEyISigfJq18pVSHuS44vNNMPucaRG+5lt2bzJ5Kvl/mqRP3Qe3EPeV5ei
	 fqnQystfESouCMNTgFbbJ/z3wsiT4jUuU2QRPEpVSrfvXmkPyA5w0x/Peb496F/Voi
	 ESJzY1N07KhYYallNmpYtiHGI0WMilLTly/D7KEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 068/332] ethtool: coalesce: cap profile updates at NET_DIM_PARAMS_NUM_PROFILES
Date: Sun,  7 Jun 2026 11:57:17 +0200
Message-ID: <20260607095730.635028723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7281b096b072f6c6e30420e3467d738f2e4c4b57 ]

ethnl_update_profile() walks the ETHTOOL_A_PROFILE_IRQ_MODERATION
nest list with an index 'i' and writes new_profile[i++] without
bounding i. The destination is kmemdup()'d at NET_DIM_PARAMS_NUM_PROFILES
entries (5), but the Netlink nest count is entirely user-controlled.
Netlink policies do not have support for constraining the number
of nested entries (or number of multi-attr entries).

Fixes: f750dfe825b9 ("ethtool: provide customized dim profile management")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/coalesce.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 3e18ca1ccc5ef6..cace02d964cb21 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -463,6 +463,12 @@ static int ethnl_update_profile(struct net_device *dev,
 
 	nla_for_each_nested_type(nest, ETHTOOL_A_PROFILE_IRQ_MODERATION,
 				 nests, rem) {
+		if (i >= NET_DIM_PARAMS_NUM_PROFILES) {
+			NL_SET_BAD_ATTR(extack, nest);
+			ret = -E2BIG;
+			goto err_out;
+		}
+
 		ret = nla_parse_nested(tb, len_irq_moder - 1, nest,
 				       coalesce_irq_moderation_policy,
 				       extack);
-- 
2.53.0



