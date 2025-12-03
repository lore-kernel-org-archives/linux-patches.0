Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B903148C1;
	Wed,  3 Dec 2025 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776288; cv=none; b=k6fkzCgAlCBpmBwzQtH0yrmDkDNdmbw2Avqd/tcBqNF3in+cWNAy76erOoovc4VzzrObh8rSEMK/QzzZVaTV+BzU0JUZZowcbmYKbnRdBlcsOhQ7p2qUi7HQYuxXvlkTUbVS2ab/iAPgMKVqUQdVRy3ji+aMILdJeEwL3tTm6Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776288; c=relaxed/simple;
	bh=+q1v+R412vGRE1KAj2amxzHRJPGwiAUYiKJNa4UtZ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kw22X5oSlXn8oUkasdiyUxXZEasSQMH+OfUh91m7WUnsUcO8jfckEXUEYojDP5ZMFUE8kPEF26Bw0W1W7+5vHPqZdQ9ZMlMUqQZ7spj2QgJZ86cBf0L4cWcvRbMbb32GUiZoQT+O4dG+TJ85xAQXtEF3I0r35oNZNGtYJyR51Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFj7MZpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFj7MZpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8323EC4CEF5;
	Wed,  3 Dec 2025 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776286;
	bh=+q1v+R412vGRE1KAj2amxzHRJPGwiAUYiKJNa4UtZ8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFj7MZpS/nIjyyB6PmKV3DlYDY+Ig3oyIPy9GF0+p1ROfZCcRWjuvVeIH0PP2qcuD
	 7lOzGAPALYItSuJbUBVzwh+2wmekdXDPuDzWdngbtxYJX5Ek/SlKdeuV12EOmyIjXy
	 rdYonRj4kIugOBhH99oDcLd46T9IYe7CwJmF0AN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/300] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Wed,  3 Dec 2025 16:25:08 +0100
Message-ID: <20251203152404.477229627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 004e49f748419..beea7e014b157 100644
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



