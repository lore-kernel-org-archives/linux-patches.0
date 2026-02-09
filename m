Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A8137BE7E;
	Mon,  9 Feb 2026 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647984; cv=none; b=c6v3FXFef+RONNRD/QknRHmBpa0sZOJoAajh/eE1hP89IXy2/iMfezPmvGG2qqDYj7kjZ05ZAlS12lyxsIDK4phZWkwF8yhCdHfGX/k8taOtdAIdUAuQJVcT4dgZk1g3Tp4NZUXxIX8envxMRIIv152Yh8idbySoXgoFYUPP/bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647984; c=relaxed/simple;
	bh=lRdtxXcTTbmwS5yyBgAytduMBH8X4KdaGPlEU8NN9IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1nwcLEt1nRGnA27/VbVz+5xO8SGGqioQLakMv5ohRT72uKnwmQpEFMS8hV2Wn7YJEQF4VDf2d1NxqB6ed9Bw446L7oE9PmhKQcNuZJmhxb1MH4HQlkyXf/ZoqNtVrHRDH+DQ6ZQWA1zxznZnNTI0yNRNp9ziZJMxMdP4VVGVwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjm8Q52H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjm8Q52H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40033C16AAE;
	Mon,  9 Feb 2026 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647984;
	bh=lRdtxXcTTbmwS5yyBgAytduMBH8X4KdaGPlEU8NN9IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjm8Q52HLHP7P1VxQdgrYKz8LSgREa0+naznw/tJS7CDLYaIGqB2MixU1brfxE6IW
	 46OGONs2y8x8zZ9xvfRPF6mL1BVZVTNY4UYZbvZ9OERBpDYlpOjItu13aPcfanC/zi
	 MxoCKFsJ++sQNAFPWuleaKeEdRyvwpXYP4c9tb3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/113] net: phy: add phy_interface_copy()
Date: Mon,  9 Feb 2026 15:23:55 +0100
Message-ID: <20260209142313.275298195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit a571f08d3db215dd6ec294d8faac8cc4184bc4e4 ]

Add a helper for copying PHY interface bitmasks. This will be used by
the SFP bus code, which will then be moved to phylink in the subsequent
patches.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1uydVU-000000061W8-2IDT@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: adcbadfd8e05 ("net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6fe5d564beed4..49283facf9320 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -187,6 +187,11 @@ static inline bool phy_interface_empty(const unsigned long *intf)
 	return bitmap_empty(intf, PHY_INTERFACE_MODE_MAX);
 }
 
+static inline void phy_interface_copy(unsigned long *d, const unsigned long *s)
+{
+	bitmap_copy(d, s, PHY_INTERFACE_MODE_MAX);
+}
+
 static inline unsigned int phy_interface_weight(const unsigned long *intf)
 {
 	return bitmap_weight(intf, PHY_INTERFACE_MODE_MAX);
-- 
2.51.0



