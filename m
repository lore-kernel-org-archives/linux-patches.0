Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307942686BD;
	Tue, 25 Mar 2025 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905909; cv=none; b=byxVHEuUHP1il+cbj1mzKPk6UvKr8yDgytcxZQznLc+iWGWqrBFGcCDh2GK4h3OG4RXqmpwvYwRPHN+9kqBExyDrsnaLSoUSnoPAK3iDFcv/N4ZsDgN7068zFXNiHAbuQlJvYd4JC5XUypxx4dWT++utune2TSm/haXd3TjnSqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905909; c=relaxed/simple;
	bh=KT+lPZZJBw31moasN4QmXBx/3a8z3F4it1yLSAXbP1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKsehoGI+K4NUeeHvWxSnqkmINvLv5T1WsCSwZBBIL7gb+LVOl874J0DMGPk8wXesamaqvkc8tTyHtJa58bgULPPpzTb1FjfsIhnzdPxr/YrP5o1JWT2ucXMBGXKCzWbG+pNtF/OSqMDL7ZdAW861Bq57s2mGIBjt7WKeJOCGSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOlvOcZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOlvOcZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7254C4CEE4;
	Tue, 25 Mar 2025 12:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905909;
	bh=KT+lPZZJBw31moasN4QmXBx/3a8z3F4it1yLSAXbP1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOlvOcZnizUXljA7n88yH6oLxImMnOnpDpFzjpn7PJx5aHMDhdYjTSrlv+B4NUiYx
	 SNYHLliq6UbaVQF1aZUNWkeixp8fNT5fuRTpJTg2zcvrveYgOivEvqlISz4Tl81/lC
	 RG1qCxcMBuTFtVEroUV1r7A/to6ss4UI7vxTtugo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 031/119] Bluetooth: hci_event: Fix connection regression between LE and non-LE adapters
Date: Tue, 25 Mar 2025 08:21:29 -0400
Message-ID: <20250325122149.859500354@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6203bd8663b74..f2f69eb4295e1 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -684,7 +684,7 @@ enum {
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



