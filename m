Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1255826E155;
	Tue, 25 Mar 2025 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906351; cv=none; b=P8j3wL5TsbjbEcGDW6/0Sq7Oms7p+C4Q10G4pwB4GWqVu2ksesZNlAKeXq4pnl/ryyGjzDG2OEdJ0yjo9gnV3T4tZD1Ae8PIxu9QuqCXLnnywC1puapwQTuozpFvBnu7EBcnt3cc8gBwpsn9sOb/LZWo6TInAroDu+uKIeKfFlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906351; c=relaxed/simple;
	bh=6knjCtz10noC2KHHuLCqPZPwuQrfUqrNuIvNG8yaNGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXq92z1nK6ZblZbyZ4Td8/l3QVG0sA5KF+7QecuZVO+0BsKEHha3JHHBC41wMwMO2yFNlVrfyhSTsnNKbQACjMw0EcwIAHZwtcN9fSU4Paf9nU6qGXzI+Q9HgoOA0DQTutasJ5Wrn8icSnEeEOSd2EGSOOaeXusOTWXa57AAuCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPIZRS9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPIZRS9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6800C4CEEF;
	Tue, 25 Mar 2025 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906350;
	bh=6knjCtz10noC2KHHuLCqPZPwuQrfUqrNuIvNG8yaNGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPIZRS9ABRzl1Kxnj6Dp5rtwOId+0qdW1llj7YogL5Oe/NuRLTQrRSYvWH7MhKtU+
	 zlD+bNrp+wue5YGYAzGK3/0LjEyPi/xoaF2nPcQn5UO2/zbYkcOt9wpv18jPNtsm5R
	 TZQze0HmZc0SU+GLJJ9HPs6yUE9UWgY88hPOl8tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/116] Bluetooth: hci_event: Fix connection regression between LE and non-LE adapters
Date: Tue, 25 Mar 2025 08:21:58 -0400
Message-ID: <20250325122150.006443750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bb4eaa52e14c..dd10e02bfc746 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -683,7 +683,7 @@ enum {
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



