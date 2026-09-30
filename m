Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C6751C078;
	Wed, 30 Sep 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789271; cv=none; b=V3iJvAP9z0AY0e41n8gJIN+0e65+TXitleqMTB2LwjRviZJn30LF44z4jUnvVEA5NnFr6OmlKH8QVUihiPYkpbLeXPFOLYOnHbOtOHpZ04zp6NuVU+H+G3CfNBJYoUncutq4w+U6vITKEyVgthG4x9180jWC3tlX2p0EHIBk6Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789271; c=relaxed/simple;
	bh=2k9QtNxnspdp6Wj7rCRlFOMSB3ptmnEuloEB0ntFHOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARcCqwpRS0JeiwB1/PZ7ldIaThfQAT/QnaFmlW0q7NzOIyqVTun0FTupXcqMb+kUAb5ywcZEhNWGrfKhvzMRK+wevKuvRPzSqS2yKioh3chZEJfVE1mduGPOkRjZCNbydIO/OXApy9dkTgp/kgiWsFO5lmZbrNtB3Z7sBp/tfN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBOnWxlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBOnWxlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCA41F0089B;
	Wed, 30 Sep 2026 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789269;
	bh=H7DnfkjO6bwyufzy8AZIsCUy8X8seGYlRf/Ir+b6fEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBOnWxlvmiVREW7Nhw4z6ss0hTscsyo+uT0uim8xJ1qmBdzCFHaTGXSUWxhu6iT1g
	 94pCzFeCsQjBj8R1eRyddnRbpWvtOBphGGHv/a5uWG7q//RngG3GmSg9fgArH4T8Up
	 5fA7pYsW34J/hHKYE8K89sJS8fLJk5R5YnnQvYCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/877] nfc: nfcmrvl: validate helper command length before pull
Date: Wed, 30 Sep 2026 17:21:52 +0200
Message-ID: <20260930152423.338135431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 93094418fd247..9716caddb88e8 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -262,9 +262,14 @@ static int process_state_fw_dnld(struct nfcmrvl_private *priv,
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



