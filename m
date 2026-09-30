Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B264F4CFB;
	Wed, 30 Sep 2026 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783787; cv=none; b=dPOQ1a46pOi84D8l0k5z6cHmBSyPHetYKvmpKAn7sC3b9TSsox4HSvGfynK8m9V2EvnXHtjaBWjZs6ehCyp3VO+uPClDU1l/q/CaocNUhiAI8m3tepOy+Rv+zL/wSieZATux3nwnEwagAIKLd6FJkGwB4dl7oqU1P/kl/C7Jcgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783787; c=relaxed/simple;
	bh=tfJ79pupjhdfAiex5YMMMJSGoDEGV7EEl/kc3ib4cxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmifz2jgmW79o2tt7ZEb8j4j6BdX2WkQ0aT35W6ES40aaC73LaDFdIE9j0Zo+AdDOafJ2QO9vPXcFU7g4+MdtBW8YxDY7xDSat6nXQAtqaZFVCz78VQAZACH24Cq9LJuZ1xBizaUIzXX+8wudaNcZwyPz0jnIw6ryi6NT8VAAAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWwOwTTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWwOwTTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C330A1F000FF;
	Wed, 30 Sep 2026 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783784;
	bh=7VTCZocItut/Kca1AT0QgwKyfKXnLRnE/D+FyEr9anc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWwOwTTldSOVq4fsEg2GE/EJLcStAHchiEJdipwVZoUE9njNR1neUZOS24aTIK//9
	 cgcWItgUR1o8wjldcaYHgHdOFt3Dnv9ApUiCE9EbcDGd1OhhXXAw5rxFMsxwRj1kql
	 bpDmFyaRrgWNzkk041Aht81dQqOpMJk0g8Tsx/LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 521/595] nfc: nfcmrvl: validate helper command length before pull
Date: Wed, 30 Sep 2026 17:26:54 +0200
Message-ID: <20260930152358.908860676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 686f942332b1667f13f3b8d6a2f50bcfbf42e277 ]

The firmware download receive path removes the NCI data header and
reads the helper command before validating the remaining packet length.
A short frame can therefore reach the data access before the malformed
packet is rejected.

Validate the complete helper command length before stripping the NCI
data header.

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715084325.40276-1-pengpeng@iscas.ac.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index 52c8ae504e328..1bc8c15cba13d 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -274,9 +274,14 @@ static int process_state_fw_dnld(struct nfcmrvl_private *priv,
 		 * B8..N: payload
 		 */
 
-		/* Remove NCI HDR */
-		skb_pull(skb, 3);
-		if (skb->data[0] != HELPER_CMD_PACKET_FORMAT || skb->len != 5) {
+		if (skb->len != NCI_DATA_HDR_SIZE + 5) {
+			nfc_err(priv->dev, "bad command");
+			return -EINVAL;
+		}
+
+		/* Remove NCI header */
+		skb_pull(skb, NCI_DATA_HDR_SIZE);
+		if (skb->data[0] != HELPER_CMD_PACKET_FORMAT) {
 			nfc_err(priv->dev, "bad command");
 			return -EINVAL;
 		}
-- 
2.53.0



