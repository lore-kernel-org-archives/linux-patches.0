Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911124F55B6;
	Wed, 30 Sep 2026 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787255; cv=none; b=XA8k9dtNglplO/G/8IWLARgawafhtkyJNAxg2dtXTqUluj/QJG0o59eE5VghLjigS2yjOgaTDoI1vdPXqlt0vUv1R4Veh2nQwIGvbD9UCegDNqvu9T8EM6fr5rb1jO68V2par93Bmwpwyz2+9CMPk3xTc77y7HUJxwhC3KgRTSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787255; c=relaxed/simple;
	bh=bfHDLzLChx5W1EnYW2NBe4fYcVsXySqZLNQ7MEuv5+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmBO+1a57LzszFqPAhP6DfCR07yd3kgFDEj3xPfIO9nPZ3+36yN0DHeKlFD7o/pFxHoN1sb+x39yXUDjq2Jx3UPx9grzOQ8d5eNC2lwcipaWM7yxC0OfnNQKomZGs1poH+j7LOu2iGIZpVBE1CMNWDvz+mY4zWNFRGnKNzdoTmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLQxOpJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLQxOpJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D149F1F000FF;
	Wed, 30 Sep 2026 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787254;
	bh=iZ24bUVFewDd3OS0l2QpWhwYKVcfxpKbJ6vdjAmjkwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLQxOpJEfdokswEDJgbOY2HLc0v3ogbSHzNgjFasWDFB162VXpzeJxzUFpc4cv5gT
	 5op0EgPdJNkFtsRXkH26s1bBOeLxoh0EUF6CD/i6EHQ/JCwuda6XLcTVCj1vjGXgHs
	 xNeaEpMLpok1kYQBv7OyZoj4HLjUW8YKLzMWf/HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 167/457] nfc: nfcmrvl: validate helper command length before pull
Date: Wed, 30 Sep 2026 17:24:32 +0200
Message-ID: <20260930152349.656496247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2b8f401d8fd7a..8b9d5257320dc 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -263,9 +263,14 @@ static int process_state_fw_dnld(struct nfcmrvl_private *priv,
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



