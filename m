Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF434166A;
	Wed,  3 Dec 2025 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777831; cv=none; b=pRhW3vFRuKEdRxMn9Jo85TYYvUQWGy2lbEi5S35wz+IS6yyoRYKFs4a/nhXFL2JX54IKtSGzfr8L13Tkl/Z3HZstK3AYnAjnLkNBg3i0s+vMuDfRfahhz7ogXEM6Ux8tkKVPZqGN4vcFxgKB0m/XTaMWAIdGK1Hy5X6VQAGRZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777831; c=relaxed/simple;
	bh=uAqcw2IM+hIAjaLdv/Tim/Y9m8B1h6xg+ZnAYcFqS/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IdKJSTEvHaRcikR8wBwBRcmaOEL8jsiwSlyLx6cHK0LbxcgatdnMgxfTRO+5a1+ucvdBUrFLyH2ReOxdP5Xiq7EF1rQe0oyerRWMmI6vGb3ax49VF98rWiTD5Dgne0JNjcIEf7JQo0JJDWPgeEa2YIgTBxumogyxN/4G0v0KaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VV7mjPjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VV7mjPjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B63C4CEF5;
	Wed,  3 Dec 2025 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777830;
	bh=uAqcw2IM+hIAjaLdv/Tim/Y9m8B1h6xg+ZnAYcFqS/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VV7mjPjRxj9Bpi5l+0fwkymk7xUBvtTVQ2lgAm+3BXyXmXr89z8pinHJsu+JjcAnZ
	 7fWhICIsJf9Yo9Y6p8LR9/Nc27h8JK6d57hLFRaYNRivhCUG7w9OjREB3bXlnpT7f4
	 lmRa9ZLc9iadzZyfO4x3MtOUraYkJvVPAk+zpdxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/392] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Wed,  3 Dec 2025 16:24:43 +0100
Message-ID: <20251203152418.985817026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juraj Šarinay <juraj@sarinay.com>

[ Upstream commit 21f82062d0f241e55dd59eb630e8710862cc90b4 ]

An exchange with a NFC target must complete within NCI_DATA_TIMEOUT.
A delay of 700 ms is not sufficient for cryptographic operations on smart
cards. CardOS 6.0 may need up to 1.3 seconds to perform 256-bit ECDH
or 3072-bit RSA. To prevent brute-force attacks, passports and similar
documents introduce even longer delays into access control protocols
(BAC/PACE).

The timeout should be higher, but not too much. The expiration allows
us to detect that a NFC target has disappeared.

Signed-off-by: Juraj Šarinay <juraj@sarinay.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250902113630.62393-1-juraj@sarinay.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nfc/nci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index ea8595651c384..e066bdbc807be 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -52,7 +52,7 @@ enum nci_state {
 #define NCI_RF_DISC_SELECT_TIMEOUT		5000
 #define NCI_RF_DEACTIVATE_TIMEOUT		30000
 #define NCI_CMD_TIMEOUT				5000
-#define NCI_DATA_TIMEOUT			700
+#define NCI_DATA_TIMEOUT			3000
 
 struct nci_dev;
 
-- 
2.51.0



