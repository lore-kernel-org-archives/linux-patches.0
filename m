Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53BD243964;
	Tue, 29 Apr 2025 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948877; cv=none; b=uAJgG3GoKczJKDoLoQ2hNUo7ZxHOZ+iWp6NAKHHrZWb031wK+vkuiX4BxLtfKcrYkIG+gUIZyZzk35pS+8feqnTdRVf8ZhplRliUmGc4c7V4memGMo6S6SeF6BOwZvmU3CfBtYTzTROoh8dFuRC9JMIR377HVlSoej+ZkM0TPMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948877; c=relaxed/simple;
	bh=aaSV4lYZbh+F+H0XC81Jy9OFCRT0rf2HBA1r+dbmGuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k20/58ge5kENoFRisZWf6Q5seS7DB9XgQyMEHBAFJe2kV5T3o6Q0Ph5jRDc2WP8h9o9C8gyOhHIY+wPTfsQTgVu5fBQKzlE7aRUNdIaBIcmCkgzwDmLX8uhFrkjWScun9DFB6ynAm3HKE8LV6okTBC9MpZFE4mLGtaecpTxfrEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZgQfbHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZgQfbHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668EDC4CEE3;
	Tue, 29 Apr 2025 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948877;
	bh=aaSV4lYZbh+F+H0XC81Jy9OFCRT0rf2HBA1r+dbmGuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZgQfbHFJ6K0YPIH/yxk27DANwtXI4rVmBmjHLuk/vabnFK8Yolaq+7rm4WRIrVSd
	 bHid7MI7LKuc6b8lDhd6EXf01Oz6wAmzKGlc1Zs7kpsg+oXNie3zyH082eZfaleyid
	 Oy3MfDYFZjbGXNgzX6nsLTca8cMQvMBgFGtEm0GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/373] net: b53: enable BPDU reception for management port
Date: Tue, 29 Apr 2025 18:40:24 +0200
Message-ID: <20250429161129.207632505@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 36355ddfe8955f226a88a543ed354b9f6b84cd70 ]

For STP to work, receiving BPDUs is essential, but the appropriate bit
was never set. Without GC_RX_BPDU_EN, the switch chip will filter all
BPDUs, even if an appropriate PVID VLAN was setup.

Fixes: ff39c2d68679 ("net: dsa: b53: Add bridge support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250414200434.194422-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index df67262c30924..27025ca5a7598 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -724,6 +724,15 @@ static void b53_enable_mib(struct b53_device *dev)
 	b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, gc);
 }
 
+static void b53_enable_stp(struct b53_device *dev)
+{
+	u8 gc;
+
+	b53_read8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, &gc);
+	gc |= GC_RX_BPDU_EN;
+	b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, gc);
+}
+
 static u16 b53_default_pvid(struct b53_device *dev)
 {
 	if (is5325(dev) || is5365(dev))
@@ -863,6 +872,7 @@ static int b53_switch_reset(struct b53_device *dev)
 	}
 
 	b53_enable_mib(dev);
+	b53_enable_stp(dev);
 
 	return b53_flush_arl(dev, FAST_AGE_STATIC);
 }
-- 
2.39.5



