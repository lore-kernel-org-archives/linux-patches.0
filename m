Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16E2571AC;
	Tue, 25 Mar 2025 12:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906111; cv=none; b=vGvBFK2KNL6vt721pVh/781OQKpy7WX0YOBu3GIShi1+yVd5upTuKg4OY8kG/m5uFsDTNyIW34oe7+sf/fXZljMkBvXZBPolMyT+7HmRGk/dRsPchYr8S2E04u8+odHSjxmwvU0e6GUoy/f0IDXzoVG6Y/sNEuc6j80hYwtR5ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906111; c=relaxed/simple;
	bh=LUwOHKfeWwqf6/KM3prOzwICR3yjr/lVlnbh6Bl+2Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX+2TqUcxge8gD3NQsa3dqTyilADwLd7EYV16VIBzkyZi3ZbBh2wkkgzvTqXk7MHPri9tbCQ14Sc7W1R+Xc5JWfcTBSnwW5CmETSE+tj708ymLiLSPYF3cdWrg6SI1uHV5nweIGFgk364A+fcavpJPZ9xCXiaCAB+UK584K+o4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXQmKHNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXQmKHNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB3AC4CEE4;
	Tue, 25 Mar 2025 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906111;
	bh=LUwOHKfeWwqf6/KM3prOzwICR3yjr/lVlnbh6Bl+2Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXQmKHNOscP9qHEC6xksHVqkToh+GIZZzbNHPn/VaiI5BtSL65mkWdy9fSVBwTlJ6
	 90FyqpEYpiPnmHMtV4AJY5S84r6rhXJc9tXFftDUHVQXEYU5DaXjO+FunW4fCACTiu
	 rs2desMwjoVJnAeT2Z5iUMNkBEAs8qrpwYe+Ed8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 20/77] Bluetooth: hci_event: Fix connection regression between LE and non-LE adapters
Date: Tue, 25 Mar 2025 08:22:15 -0400
Message-ID: <20250325122144.880058522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>

[ Upstream commit f6685a96c8c8a07e260e39bac86d4163cfb38a4d ]

Due to a typo during defining HCI errors it is not possible to connect
LE-capable device with BR/EDR only adapter. The connection is terminated
by the LE adapter because the invalid LL params error code is treated
as unsupported remote feature.

Fixes: 79c0868ad65a ("Bluetooth: hci_event: Use HCI error defines instead of magic values")
Signed-off-by: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 77a3040a3f29d..e4a97b2d09984 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -668,7 +668,7 @@ enum {
 #define HCI_ERROR_REMOTE_POWER_OFF	0x15
 #define HCI_ERROR_LOCAL_HOST_TERM	0x16
 #define HCI_ERROR_PAIRING_NOT_ALLOWED	0x18
-#define HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE	0x1e
+#define HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE	0x1a
 #define HCI_ERROR_INVALID_LL_PARAMS	0x1e
 #define HCI_ERROR_UNSPECIFIED		0x1f
 #define HCI_ERROR_ADVERTISING_TIMEOUT	0x3c
-- 
2.39.5



