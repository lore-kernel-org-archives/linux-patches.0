Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC187415F10;
	Tue, 21 Jul 2026 18:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657569; cv=none; b=UzVgtG7uKQHQ7gwqFeRMbgp9jCAoz29rXh+Vk8XG1YZccW9pBi1Ai7x7N8JhvTEgScwA4ZtEigKENdox3yGcefMV6s/D9jOFO3D26ibh+Td6Tbjzwu2VeIvbMVDLmlh58ARAqdks+1p2TuizfJBFE2jG6cOudXYClfockHPryPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657569; c=relaxed/simple;
	bh=EFHzmzdPb7UUaC6Yv+qvpOyp1MypW0k0jkjvstPMpGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hicj2UkRoSG3HgclZVNTy1wRk5GT6XPdCCrSrI+3zSo7FrQBUhQzBVXY9olRIhScatpop8Ki3BGREb6yWXbr/yiJF67m2IKTcjgVdzIxi6NYAJLTTCzAX+dmf3Do61nF9Gl/bQVxra4lnIUzqlMOjudiaQntjErN7+kMQ4mPv5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThZ5xfbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThZ5xfbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B73B1F000E9;
	Tue, 21 Jul 2026 18:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657568;
	bh=XJTO1U+jG2798+hc+yH+RqrRixW6TKOu/vbAQTMv6qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThZ5xfbhkAxs7Pv6EIRRmAdy5PJGW5qSIa0QRFihawEPcASERkuj5PZhBjPJRcUn5
	 UP/Q6bI4kL6k5CW9rvMlELgSW/a5sKe41ZZ1v3IViVm0FKyPwbJ7dqBttHXH9a5M1N
	 fVJLIfECmfmK9mhDXellnNjAKI09lPfb81DEmHaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0814/1611] dpaa2-switch: fix VLAN upper check not rejecting bridge join
Date: Tue, 21 Jul 2026 17:15:30 +0200
Message-ID: <20260721152533.698841952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit ed2294f94e34e97342850c40b320833d881c3819 ]

The blamed commit refactored the prechangeupper event handling but
failed to actually return an error in case
dpaa2_switch_prevent_bridging_with_8021q_upper() detected a 802.1q upper
on a port which tries to join a bridge. Fix this by returning err
instead of 0.

Fixes: 45035febc495 ("net: dpaa2-switch: refactor prechangeupper sanity checks")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260616105430.3725910-1-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index e212a014c8d414..28ac76b8783c3c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2177,7 +2177,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot join a bridge while VLAN uppers are present");
-		return 0;
+		return err;
 	}
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
-- 
2.53.0



