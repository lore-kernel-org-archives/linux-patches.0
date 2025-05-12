Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60504296D3F;
	Mon, 12 May 2025 17:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071883; cv=none; b=u8germjg0l5w1lv8KHzeZ/jjFCdr4G2Z1AGnmsMUy0YpjXQWRkG8w++CBaKz/Ry65EaS7IvOCXId/18qBpZZpYYTSjnEKw40J3hR12CupI6JVNCOyWLbAH0Zb3MPOO1oI1IibOb74h9H2HmCsk2X7cSUxq274hDrIzCui6Y8+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071883; c=relaxed/simple;
	bh=mta18mzerU+uAMHrq90IvmAT+sLULrefVqbSmnhhGms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srz29mAys8tkN1ps0hnEookrUOm5eTdgSkh/nB7ahuBvBinDViza9PRZm3zxu/U8JLfzqpgyKigVVY6ZEYnv50b8kgVYmN40Xilm7k6d0fgm+GBeC6m1cN0D9Gpa6322dqb/XOOYxVQL1JDjK2l0HMV9wp1DSDeMFrrM6zYYFyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cTaEGTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cTaEGTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79EAC4CEE7;
	Mon, 12 May 2025 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071883;
	bh=mta18mzerU+uAMHrq90IvmAT+sLULrefVqbSmnhhGms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cTaEGTkyObB3BhkYcfo6HkLv6qCx0Hzz066fhnGgRIpdzhKVNIVfgyPktZ54eYqD
	 3PU40W6a8ahyrvwaKazNujeCb2ICvgZkCo9mYQkuk5PK8HOt179uoL88Licpd41WZf
	 9KqSZ0/seonRj8V0JvO7mnxtrL7XFQOqTp+5G0SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 034/197] net: dsa: b53: allow leaky reserved multicast
Date: Mon, 12 May 2025 19:38:04 +0200
Message-ID: <20250512172045.759981351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 5f93185a757ff38b36f849c659aeef368db15a68 ]

Allow reserved multicast to ignore VLAN membership so STP and other
management protocols work without a PVID VLAN configured when using a
vlan aware bridge.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3b49e87e8ef72..a152f632a290e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -373,9 +373,11 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 		b53_read8(dev, B53_VLAN_PAGE, B53_VLAN_CTRL5, &vc5);
 	}
 
+	vc1 &= ~VC1_RX_MCST_FWD_EN;
+
 	if (enable) {
 		vc0 |= VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID;
-		vc1 |= VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN;
+		vc1 |= VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		if (enable_filtering) {
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
@@ -393,7 +395,7 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 
 	} else {
 		vc0 &= ~(VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID);
-		vc1 &= ~(VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN);
+		vc1 &= ~VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		vc5 &= ~VC5_DROP_VTABLE_MISS;
 
-- 
2.39.5



