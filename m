Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AED5208A6;
	Wed, 30 Sep 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793114; cv=none; b=lxTpNwkPZ4x0IWD+lmPiWujWMbPkh4VCtUv3/B1tx3ieKKO0mxjgQfZp4MSJ2kTXm7BQAZ3GIyH5iE2UPAo7+SrAQLOVDJjEYeqTiBcWMS+IFZrJf+bfTYQ+TVz9QzN5EprY3ipFN1hQzfTYQYMzrN3uhD0JWOY72iXFn19EbDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793114; c=relaxed/simple;
	bh=BvuxXpc5cY/RsfpIKsktWWIGsvStq4TGZsrMHJStMj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/wCR4L4dzIUZF+HZHFwDOnF1xFw08VcHn9zkv93+8hZkyr8tJTWJGjLfBsC4MsoUFtIhvZtw+e6UdLW0sm8Agfm4gsyd15RaNBHY3MKIsklT5I9Iag4LbDs+nR5HGVaM5sz/0wdB6USFjhKrAVPmo0XDDmhy5aYRweufVLz2Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cszpuPj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cszpuPj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C361F000FF;
	Wed, 30 Sep 2026 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793112;
	bh=WynzRMXGX3cr4mlUENjU3Cpj8aj7PAEFCkMwsZwTX8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cszpuPj4exQL+oqCMsO+AWUaDITJp+qGtWzYjoUnLuoegj5i+i41M0FKUsX57hPhu
	 IwUxZSvGjk0h64ZnclvhSzMVg7LtbMMmZv8PDi3V0w/QSNM/9V8qaeFnryCi/e/PVK
	 u2PWbKjPTFmQqnOl73JwIGqBHdvsbVcWqybYC234=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/395] nfc: nfcmrvl: validate helper command length before pull
Date: Wed, 30 Sep 2026 17:26:43 +0200
Message-ID: <20260930152343.703388772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a9b03dcc41006..2b734c1c1d1f9 100644
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



