Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE6E3FD137;
	Wed, 30 Sep 2026 19:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796795; cv=none; b=Hy6uoyEJ5EJIOco3lk70x3rFKFCHmAuaenjylPBfCDLJ3g0VoZtIe6Br4KnHpVx79K38MHyqsZ0yOFcFAkmmBQv1BJUJvu4YvOrBCx1QXALRIDyh0wYN8XfiHvojxAyBapA9ZNSNZNLd38Sa4qfj52VKagZX1rICC0ZQLG+tiLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796795; c=relaxed/simple;
	bh=sxkqyNq7k8cgWGGoM7r3CpWARwnmUyE9GMPMPHfw1hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR9hZUafVPSiCjcERO4uW+NEk4Q7mrWHCTjhwl9QzFccK1sTHRXpbOYd1z5LtrTVKPzRTJgaVN4K7dJb66rnLDSXDaAPAKFJORhVkTUmSTZoyw3BQ6Ba0mSbrGbBzUal0N1gSLuZ95n5xOs9vGjsLPNYO15NtRbK9eJrMB1iO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnV3ItRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnV3ItRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A091F000FF;
	Wed, 30 Sep 2026 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796794;
	bh=PnxtlWwxXLiH3CW1xpMgv674nBDpWb9dztvzH/W+zt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnV3ItRQeDRJ1eIsNl/2zRaaB9J+7ZwmlwblJNDeb6IzZLxZe3mk9npoFCUc4hOtS
	 4fBch7qb5ATD+oZPj/HTcGklZSWEEGxZlk44SVLwmqKmjJcE4YP4mO3HlfGdGFQ0ce
	 PGBVbWPBsQRC1DRpTJaoHmpM6XCTsSQIgaW/LC8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1037/1193] nfc: nfcmrvl: validate helper command length before pull
Date: Wed, 30 Sep 2026 17:28:41 +0200
Message-ID: <20260930152457.263473196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e83f65596a88a..f7191954db4f6 100644
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



