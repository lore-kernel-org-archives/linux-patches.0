Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C013FD94;
	Thu, 11 Apr 2024 10:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831149; cv=none; b=Qr0xeDBzAQ6mk8DUu7UB5NbafnLP4cYngOxqFxWv/cDNYek/rwS0+qdhQyIZwlKhGhE8EcNqozaUvSjrjr7G5zkfewYhcLskpzggo4BzbjYhSerTk4nIWbuwo4yRqd7ov2qrpwcq80b+0bmOaVbn50IF/2KhUsK7ds4fqfU1U2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831149; c=relaxed/simple;
	bh=z1LHoPCUCiXAi6FKi/NRc7v6M4qXrQkmBHG+81TReUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCtELO88XU96nTwFCYP0pY/fwnR7Ukd1ShlLrv4hSMdvXscnXc/rvpZ+NQskXGEaSsiRy1cQeEQpifhdVmjjyo64bs1sieY36XbmoKsUpe4tj2jccQisnUZNRd7RzIMngmZU01UFOdtcqsNjUKRqMMMuGyc8CyncD/sGs2FpTF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaGhZfPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaGhZfPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F435C433C7;
	Thu, 11 Apr 2024 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831149;
	bh=z1LHoPCUCiXAi6FKi/NRc7v6M4qXrQkmBHG+81TReUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaGhZfPIOSVhRLTYvkenRTddY6b4m1nyC+o7FrZYAy7wqyPn4eySCqP1/o9QxdI0w
	 DL9V2zYttsNNsNl4a6vTPW/CCsJ9cQ4OmWSeY8sewvpazlwqpcw67VbZWQIET7mjbX
	 gRE2D8Qojsdgly55yZE7F3esa4tY/3/0a8ZdIIAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/114] wifi: rtw89: pci: enlarge RX DMA buffer to consider size of RX descriptor
Date: Thu, 11 Apr 2024 11:55:35 +0200
Message-ID: <20240411095417.115263495@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2f3d1ad3b0f7d..4259b79b138fb 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -559,7 +559,7 @@
 #define RTW89_PCI_TXWD_NUM_MAX		512
 #define RTW89_PCI_TXWD_PAGE_SIZE	128
 #define RTW89_PCI_ADDRINFO_MAX		4
-#define RTW89_PCI_RX_BUF_SIZE		11460
+#define RTW89_PCI_RX_BUF_SIZE		(11454 + 40) /* +40 for rtw89_rxdesc_long_v2 */
 
 #define RTW89_PCI_POLL_BDRAM_RST_CNT	100
 #define RTW89_PCI_MULTITAG		8
-- 
2.43.0



