Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052701474B5;
	Thu, 11 Apr 2024 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832399; cv=none; b=PKJ2quoAb6fkGAhZfJOBupy58b92ztUMQPxjSTYwyg6pBCVJmR8ESgrKbN+b//wYjA2zmB9GHAMf+V7tScBBSf3NmMf4b1MPjrNn6+9dJJZ12D4Z1KHt7fo2Nl6AoO4JItdHRYhLpr0JyZCG+rdNedTEu+LvxmQdL0rcigcOUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832399; c=relaxed/simple;
	bh=Kco5JMaFjAUoRVsbHooKLRG7iyL1zEzyTf3O5I/9YO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMuSM9hC1UUEGNuNiPVw8/sRE0+1rGGqvk8op6J4tn+isJo08z44RZwf0usM7bGmD9u4isFiu6sQmowf/Jmh2LfOJH0MO8JWrHLev/s9Zrl3euC7893rtjGIJKfrb4NIgxObCc4FSWHOK0AFQi9s5vWZkXjbL9F9Lg1Sw37qVCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+24cxfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+24cxfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB7CC433F1;
	Thu, 11 Apr 2024 10:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832398;
	bh=Kco5JMaFjAUoRVsbHooKLRG7iyL1zEzyTf3O5I/9YO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+24cxfXSETt2zKSgXG3/MPAMWkLFROHp5xnbfLMzNrFpXlbSCXE2UtaClYIdwjYF
	 qHKS7AnLKB0pLiZAk+UYowslgFqJNMx5gOLfL2Pv01Ja9n1VeXC+A6OD7vhRJTWJJA
	 JcofR9vFlCXsPw2CjneFh+Hsgz75HATRtEVgCPKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/83] wifi: rtw89: pci: enlarge RX DMA buffer to consider size of RX descriptor
Date: Thu, 11 Apr 2024 11:56:37 +0200
Message-ID: <20240411095412.838345239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit c108b4a50dd7650941d4f4ec5c161655a73711db ]

Hardware puts RX descriptor and packet in RX DMA buffer, so it could be
over one buffer size if packet size is 11454, and then it will be split
into two segments. WiFi 7 chips use larger size of RX descriptor, so
enlarge DMA buffer size according to RX descriptor to have better
performance and simple flow.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240121071826.10159-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index 179740607778a..d982c5dc0889f 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -546,7 +546,7 @@
 #define RTW89_PCI_TXWD_NUM_MAX		512
 #define RTW89_PCI_TXWD_PAGE_SIZE	128
 #define RTW89_PCI_ADDRINFO_MAX		4
-#define RTW89_PCI_RX_BUF_SIZE		11460
+#define RTW89_PCI_RX_BUF_SIZE		(11454 + 40) /* +40 for rtw89_rxdesc_long_v2 */
 
 #define RTW89_PCI_POLL_BDRAM_RST_CNT	100
 #define RTW89_PCI_MULTITAG		8
-- 
2.43.0



