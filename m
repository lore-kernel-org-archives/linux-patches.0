Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46003431FA;
	Tue, 11 Nov 2025 01:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824078; cv=none; b=cPYKWIhrSzsGrJ4WiGtSZfYxt/M+Viq0KzEqK7lk1DyC/wZ5fWbQqod7lMS8cEY2jUrqvCnZcyFxDQ5Yji5UulXO5xcAPvZ23FVTJRhfOH+6u5uEDyyFPgJG5bFGOHWcGJA8s+kr4w5aiMGGIStSPljdYtaCIxbmGYiw9du6CpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824078; c=relaxed/simple;
	bh=NSKdRJmnsGjkFTNMMf0H4UjltGvwBeY15SoMg3hFnGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RWcP3AOKAT6NV8moiL6rjTYesrk6h8xolhJDgo9+X6JhsJQxHvzUVFLb4yzkw/Sp6uKL5dOTD+AVZ871TY4Bu0xznXR6WuPfyHehkPRDhIgR5+llmjar/uSwUHyp3MR4EbryywlqpGyAJPa435m6/uuQo7kEWMGYhfFPNTCQmh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joY/wbyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joY/wbyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C4C4CEFB;
	Tue, 11 Nov 2025 01:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824078;
	bh=NSKdRJmnsGjkFTNMMf0H4UjltGvwBeY15SoMg3hFnGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joY/wbyTIeSmGEmtUawy0oMJ2TPUdIuhMPNCWIuwXusHYAO7HvA1ZkOSWU5qatiRu
	 Iiht8AM1FFsQL3/cYUDz8MbieAt/F6vU2Bac1CwuEVeo4DXzpxQSRsLtbblboH+0NV
	 04P/X+H3XC6+FZ98v8mT0qq3Me/xFgCVZuKAlMBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 432/849] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Tue, 11 Nov 2025 09:40:02 +0900
Message-ID: <20251111004546.877447933@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e180bdf2f82b0..664d5058e66e0 100644
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



