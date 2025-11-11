Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D26D2DC32A;
	Tue, 11 Nov 2025 01:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823676; cv=none; b=uXP5CeVxTCZSUtF+CtsELrmtl67U6m+DeiTtIEyJFv3gPL+e48dTsse8GsEFwBsWJgD128bVRLhj3NJDlWnUXjsD1ujs94L6GYAYcGiCNm8CgP6reFpZ2/lUli8f0HQCJ0Z63I67QbiAGG7HdITSobaF/VOYRsIc3sqs8OwV/H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823676; c=relaxed/simple;
	bh=R4+uQSXJM68l9QrCo77Y7Qz3FaT5XiyXpXD8ucWpmiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH9DwW3GV37bs+M0g8C2MgrczMTzGY7TKZ5841r+0/FbdAC7gRnaYAW0/gbYm/CxFpp6KsDdYOkaDF+rWuYZa/bvCx305+A2vWru8LkqMNX7fW7LjCJ3IX4TiAOGIi5XBzGEqcrV/xgDBe5lb8FLLyxezV4H8mYmiUopTS/RgZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=La5i5wu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="La5i5wu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917D8C4CEF5;
	Tue, 11 Nov 2025 01:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823676;
	bh=R4+uQSXJM68l9QrCo77Y7Qz3FaT5XiyXpXD8ucWpmiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=La5i5wu/2QBwba8NxBaeEnx06L0+e3EKJw78l9pSI+mr3F7HnTOhu7DEnoyCFcjaL
	 wfOlIU0eFEH60qlMUmE1jb12KXoeVdv/2Lx4M3KhbGKMYToCKhfBwRc/xWSdRknKXw
	 1Ss0uYQZAkPjwaRU/Yu0Lkn7M7iND4VZG/mOcfbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 348/849] net: wangxun: limit tx_max_coalesced_frames_irq
Date: Tue, 11 Nov 2025 09:38:38 +0900
Message-ID: <20251111004544.833930679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index c12a4cb951f68..254a48ede2660 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
@@ -334,8 +334,11 @@ int wx_set_coalesce(struct net_device *netdev,
 			return -EOPNOTSUPP;
 	}
 
-	if (ec->tx_max_coalesced_frames_irq)
-		wx->tx_work_limit = ec->tx_max_coalesced_frames_irq;
+	if (ec->tx_max_coalesced_frames_irq > U16_MAX  ||
+	    !ec->tx_max_coalesced_frames_irq)
+		return -EINVAL;
+
+	wx->tx_work_limit = ec->tx_max_coalesced_frames_irq;
 
 	switch (wx->mac.type) {
 	case wx_mac_sp:
-- 
2.51.0



