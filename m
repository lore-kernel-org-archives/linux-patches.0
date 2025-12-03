Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3145035CBC4;
	Wed,  3 Dec 2025 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779214; cv=none; b=NBHclvJO7HtOtsfC5rGfbxm+XJ7qbZb2Gva6ry1PO74Wrs6lxApN+B7Z1qkc5CxzMRMxdRASf5BkwEXLf7xBwFBWjXYRMZvlMMhen6whBv0qRwEPgEvraBpvr3Eif3xANunkM9PHXnHjZ/I0sXtvx3OoAnP0c9c7FTMi7PheNBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779214; c=relaxed/simple;
	bh=EOwPqpFFbVNXs1u7rBBfNgPpEXYNC+LNO6vShXkJWlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/IVrItdbEwv8ZDG02YRgYI+RPwgOBWq7nb9jl5PavsxPXQ4iRjayDzXqlECSkT6X3BNiGB2ga2G6uOXO59/2wr95GUaak7mQzA5W6q5+jDFzSqY6H+j3PZX1F9hCOanbC+HUlgiEEAl9BrbfkgrK9DNDKEDuv6NpVP3KNh2u1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B6Bq9sS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B6Bq9sS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2191C16AAE;
	Wed,  3 Dec 2025 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779214;
	bh=EOwPqpFFbVNXs1u7rBBfNgPpEXYNC+LNO6vShXkJWlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B6Bq9sS9EhOZYPY0Y51aRkR8RQCnLNzbSgJCcsoPX0S/RQKOulkvvfnsAghLYzJA
	 d7suPZF8l4cNYUEQyED9SYs7uEv5Ae42bzkmagNV2F08Tiyi638YF06kxFTJrXTjDV
	 0gs6LP33M2v2ZuRwPtAtmrHURozF1kR4J+QRw5i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/568] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Wed,  3 Dec 2025 16:23:12 +0100
Message-ID: <20251203152447.684906060@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



