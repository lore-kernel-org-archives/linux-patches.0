Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8262C21DD;
	Tue, 21 Jul 2026 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649725; cv=none; b=HPhxijJXbgRdb648+CSTC4McjFvUUg0sUqTO+lO+V5sqKBUiihmK/9sieV5vUKpoC11He0mTzO7A41JI0dwWhNYd4n/DFwVV0F3S70+pKOQBg0gvfHRIhe0cHPpUQXmEKhKj6gMY1EnDrqSeB5T33qD555kxyHnsyRoHyepLAos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649725; c=relaxed/simple;
	bh=/wJwUxYr3kNUFPUhhtog6/QgUWE8zQzi1sKQj/PIC7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bafLjVkBYL/hP88BlGN9koSs0d29Ep7rGMMG3g3+A+xfPZcfmndbnTO9B3kAtc++OZtbRw8imXfYP4jSu7Xqizt1t1NP5slT0czzstkZQzLbBSOScX2KyEOwVBz0Go40A8U2odi+C5rOeFE2DMNHjZLc5kqZKYEjf0BFjtI+hZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eaEjKkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eaEjKkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E111F000E9;
	Tue, 21 Jul 2026 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649723;
	bh=Qp5YCeig+Kb9kK+hzVK1KgfJ/JCxXmYdpdoNupb9EyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eaEjKkBhpTvul3DqgbMvOHYVrtSFyHTq2ygMnMzfQGXFGA2Kwq5aKsttgzzqQSss
	 3lFi4SAA/yISgoNo3PQwISdRqMQI+TP1wvLCfISvZpRokmbhIt0VcpjPkLAOiKh79l
	 GZUaWWG/RE6u48wVCcNyh0NhmkfbSoUJmE3/J5Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0682/2077] Bluetooth: btmtk: fix URB leak in alloc_mtk_intr_urb error path
Date: Tue, 21 Jul 2026 17:05:55 +0200
Message-ID: <20260721152608.880392691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit f396f4005180928cd9e15e352a6512865d3bc908 ]

When btmtk_isopkt_pad() fails, the previously allocated URB is not freed,
leaking the urb structure. Add usb_free_urb() before returning the error.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 8ff66b276af03e..c29e1841b2b3fb 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1074,8 +1074,10 @@ struct urb *alloc_mtk_intr_urb(struct hci_dev *hdev, struct sk_buff *skb,
 	if (!urb)
 		return ERR_PTR(-ENOMEM);
 
-	if (btmtk_isopkt_pad(hdev, skb))
+	if (btmtk_isopkt_pad(hdev, skb)) {
+		usb_free_urb(urb);
 		return ERR_PTR(-EINVAL);
+	}
 
 	pipe = usb_sndintpipe(btmtk_data->udev,
 			      btmtk_data->isopkt_tx_ep->bEndpointAddress);
-- 
2.53.0



