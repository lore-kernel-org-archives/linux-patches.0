Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9D6272E7C;
	Tue, 11 Nov 2025 01:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823428; cv=none; b=a2dmXSmWFvkQzzU5GDQ8uWxFGu6XbCWG82+JBvOAbHYByOtcZj9UYuwJ+ISLO7HVT0teyN13k71p5KWsR6WYbEaH9BI+tvYc/1S4hflqtwyuycwGaosvWWOcPLhzkrMCMf/H2rASUj9jffhVSGtOGcfapxHBQlkgLzeRl9QvNqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823428; c=relaxed/simple;
	bh=I+FMaZUB9MKISY9LvNzfjSHf1uryXSv99VUXsATXMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4NGI/vLGQNbTzw8Dtq/jD/ouOi+kdHZE+I2q986ZCI8B0XXr2KPnlJ0oJoNAPmZe9yTMrNL9f/QOow9q3LNJSwO5EY9JLev0xMDKaWw3GbnJSaQhKxjkUdJxle67Fn4rgtdSF/AvrgARdWhw0VPyKTDybMp2IWWa3P6ccxTLBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZgeTh1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZgeTh1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA69C4CEF5;
	Tue, 11 Nov 2025 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823428;
	bh=I+FMaZUB9MKISY9LvNzfjSHf1uryXSv99VUXsATXMl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZgeTh1exxvO2swIsX5diG/ZiSKLy9iOwFLEs/hMF1l6ONf8ZfgGdqfE7Tn2FQfGA
	 lmt5m0RzBXIosvMOvoAx+xWiCDHgx3R7fQX4p/mq1Z/9mQ0IihrhpKSUcOarwVfaZz
	 4waRkLTc5qjGfWwo3aEWZFYwrm3JFWqadkqdmJ+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/565] net: wangxun: limit tx_max_coalesced_frames_irq
Date: Tue, 11 Nov 2025 09:41:41 +0900
Message-ID: <20251111004532.423082537@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit fd4aa243f154a80bbeb3dd311d2114eeb538f479 ]

Add limitation on tx_max_coalesced_frames_irq as 0 ~ 65535, because
'wx->tx_work_limit' is declared as a member of type u16.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250821023408.53472-3-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
index abe5921dde020..87c0af203dc4d 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
@@ -319,8 +319,11 @@ int wx_set_coalesce(struct net_device *netdev,
 			return -EOPNOTSUPP;
 	}
 
-	if (ec->tx_max_coalesced_frames_irq)
-		wx->tx_work_limit = ec->tx_max_coalesced_frames_irq;
+	if (ec->tx_max_coalesced_frames_irq > U16_MAX  ||
+	    !ec->tx_max_coalesced_frames_irq)
+		return -EINVAL;
+
+	wx->tx_work_limit = ec->tx_max_coalesced_frames_irq;
 
 	if (wx->mac.type == wx_mac_sp)
 		max_eitr = WX_SP_MAX_EITR;
-- 
2.51.0



