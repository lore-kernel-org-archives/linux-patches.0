Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AEC2DF73;
	Mon,  8 Apr 2024 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581645; cv=none; b=dsqR7/vtkZM5QuHrXZS6HlfEbTz1nop2Zn7ts+BZI5PwW6ZAf8jc/DkEmNqAZ7t5dQNg8V9W9Aqf2o2Q9tgySXDebIcHDJU7g4cOR3bxFyne5gi0+zMXnEx4rFB4/YVGU4byHI3RtSaHm4TqccGCtShd8+PHWM8rNOZ17nievDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581645; c=relaxed/simple;
	bh=NUsdpof4R7/qY9JOb6s9aYkNeOYkNRJSpT7K6zhlIXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdUWBi6ngLD86MbuZ6KZsjbhNPXvAlbzvZrOwFCdjqPCPdFqX6jQOllxU23RaWDSMZ2Xquvlkqo6uDZV7xu1CXd7xMkSivnagfS7qnASgzEV0qzj4N6Fj6ue5RGMwIu91e6hnv8ZRXagtlE+pwibUlU/gZX7k5xu+eDsd2Ak+jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8TgWu7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8TgWu7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69043C433F1;
	Mon,  8 Apr 2024 13:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581644;
	bh=NUsdpof4R7/qY9JOb6s9aYkNeOYkNRJSpT7K6zhlIXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8TgWu7rnhelJpWYnfZN0Jui5/YTQJ7GMDErcXuTM7hBeZ+UVid60x19ESvF8U6tk
	 NCcGVen1folo/HyXXdMuQxHIKUWqGYdPpeMCXrA0Sza5Rac/eELYG0hbarKs78v5Z8
	 BJV4f2NAHnKYe1fK859BBrjVhxdR2IZD58L4isd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Jeremy Cline <jeremy@jcline.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7ea9413ea6749baf5574@syzkaller.appspotmail.com,
	syzbot+29b5ca705d2e0f4a44d2@syzkaller.appspotmail.com
Subject: [PATCH 6.8 007/273] nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet
Date: Mon,  8 Apr 2024 14:54:42 +0200
Message-ID: <20240408125309.511046440@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit d24b03535e5eb82e025219c2f632b485409c898f ]

syzbot reported the following uninit-value access issue [1][2]:

nci_rx_work() parses and processes received packet. When the payload
length is zero, each message type handler reads uninitialized payload
and KMSAN detects this issue. The receipt of a packet with a zero-size
payload is considered unexpected, and therefore, such packets should be
silently discarded.

This patch resolved this issue by checking payload size before calling
each message type handler codes.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reported-and-tested-by: syzbot+7ea9413ea6749baf5574@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+29b5ca705d2e0f4a44d2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7ea9413ea6749baf5574 [1]
Closes: https://syzkaller.appspot.com/bug?extid=29b5ca705d2e0f4a44d2 [2]
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Jeremy Cline <jeremy@jcline.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index cdad47b140fa4..0d26c8ec9993e 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1516,6 +1516,11 @@ static void nci_rx_work(struct work_struct *work)
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
 				     RAW_PAYLOAD_NCI, NFC_DIRECTION_RX);
 
+		if (!nci_plen(skb->data)) {
+			kfree_skb(skb);
+			break;
+		}
+
 		/* Process frame */
 		switch (nci_mt(skb->data)) {
 		case NCI_MT_RSP_PKT:
-- 
2.43.0



