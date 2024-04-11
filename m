Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E012D1448F3;
	Thu, 11 Apr 2024 10:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830046; cv=none; b=A05UJT93mEifQPyvDas92wCx1Z9PYKaEhINdnOmG5L7DnSgn/wLOr6gDY2xj/NvnnlaQt1Lwllysy2yrLg7Kp9DW/+WGrVFmv1tSbPeZWWRcb7u0XXfUqrPwLDzyLzxRSBmfPAlJcVpC9pCjZNt8MLpldmXt4PcRPhPxE49rSfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830046; c=relaxed/simple;
	bh=4fHzsk2FtdPgBcoKpArdGXcLviUj11NPS9gJxmM7078=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW9oFz7Gm+sXV/giC/M/MiKnW8GKjwa9F1DWWN8gs6uE4IlggviOQvPxSSmjoNWWvG9v8gA5u4pnglAvxg1oQOzF5gtiaBoQ6jOWWUlTLeqUt6zgMtmwSxn6Ex5Mbg7Rtb+S1ue0aAzyjGQ7nvOV7DFR+zteqDgdQ4ZdCKTavz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru35FK5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru35FK5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618ADC433F1;
	Thu, 11 Apr 2024 10:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830045;
	bh=4fHzsk2FtdPgBcoKpArdGXcLviUj11NPS9gJxmM7078=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru35FK5nKDfJq7LfkdbUpQgpUV3VGfMXKA6FzgPa2Z23CyoTKO+eEKf/47Ac8BW1e
	 cVzooLGKBZyduL7sU4nFN/J0xjFZ3Jg4/nimjy7gevkbOjFhshfZWWBhA84QbKqfVN
	 TmnGSCnl3yr6fGt6+wCetUo/cr8ZZEvVBH4OG2IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 009/143] wifi: rtw89: pci: enlarge RX DMA buffer to consider size of RX descriptor
Date: Thu, 11 Apr 2024 11:54:37 +0200
Message-ID: <20240411095421.190000084@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 83a36358504f4..772a84bd8db6b 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -996,7 +996,7 @@
 #define RTW89_PCI_TXWD_NUM_MAX		512
 #define RTW89_PCI_TXWD_PAGE_SIZE	128
 #define RTW89_PCI_ADDRINFO_MAX		4
-#define RTW89_PCI_RX_BUF_SIZE		11460
+#define RTW89_PCI_RX_BUF_SIZE		(11454 + 40) /* +40 for rtw89_rxdesc_long_v2 */
 
 #define RTW89_PCI_POLL_BDRAM_RST_CNT	100
 #define RTW89_PCI_MULTITAG		8
-- 
2.43.0



