Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7467B21772B;
	Tue, 29 Apr 2025 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945471; cv=none; b=lwEOkXM+nLhmigm5l999SdgaO+ySnZGQ6iD5V2xep5sTWpZlZma3oAHkK/XZmCCoq8D/pOxNZ/Qjmb/7yXVnHC+vRe0AgeyO9HtD+NXQbRYiv4qW+BbmfymQn5t+OvtJCosCIYl3Nhswv8SyEt1MO3ONNqRuTlDO63iWcTbd5qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945471; c=relaxed/simple;
	bh=TEW1jrIJgao7KSy31y1qLP01VVEnjW79D8pOtojhQYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMMYiKYq0h/s7ASvHfom99xQdNNgV+JbQhZGT25VrPxUSVLDHHii1ftR/wR9qD0jiPxvqJp0xYDZx5Fpaj6/rK3QosotJrauKRPjU3y99kpduYbQG+8E7BvjH9ctlykcl9ZEtq8ord4QAdDRSos3ujCCuMD7xX5Z+WLHiH75bYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cMlrhdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cMlrhdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F572C4CEE3;
	Tue, 29 Apr 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945470;
	bh=TEW1jrIJgao7KSy31y1qLP01VVEnjW79D8pOtojhQYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cMlrhdDdH30K2E4gkKlMNKTzGJkrTYIf7HVElKiCznImep1zOzkTIwa3hR3itKnf
	 3N6XFSFC2TJ4pGZy3GmHc7N2Ah7B5PMAGEJkyBudra0BKRT9yBh4dBMYcSKvGTI/Ib
	 gB3+HgscUWfx5aDLjMSlTJknqb/X8eEkBeRMqxaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/179] net: b53: enable BPDU reception for management port
Date: Tue, 29 Apr 2025 18:40:34 +0200
Message-ID: <20250429161053.163162786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1458416f4f912..9f5852657852a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -671,6 +671,15 @@ static void b53_enable_mib(struct b53_device *dev)
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
@@ -777,6 +786,7 @@ static int b53_switch_reset(struct b53_device *dev)
 	}
 
 	b53_enable_mib(dev);
+	b53_enable_stp(dev);
 
 	return b53_flush_arl(dev, FAST_AGE_STATIC);
 }
-- 
2.39.5



