Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AB31FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD4FC4339B;
	Fri,  3 Feb 2023 10:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419570;
	bh=ggLNVICNooX+34agooo+RUYzkN4eak0mZ6Lj56XmyjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JL8szHtLtD+bMoUgEpTTbUYGSysJ+RVoVmM/Nzm6G3ROtn+mp73bSytlFUf/nWpIc
	 edochOh/1EpivBUmZbElLG7WRDpeK+f1VNeC2r3Eciq4jbDMWTSJn24+Y0W3q/m9LK
	 Y78vZQtkzH+gmjm++LEDGBV7TqxLkKVqSYwBxAzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Heidrich <szymon.heidrich@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/80] net: usb: sr9700: Handle negative len
Date: Fri,  3 Feb 2023 11:12:10 +0100
Message-Id: <20230203101015.903905358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit ecf7cf8efb59789e2b21d2f9ab926142579092b2 ]

Packet len computed as difference of length word extracted from
skb data and four may result in a negative value. In such case
processing of the buffer should be interrupted rather than
setting sr_skb->len to an unexpectedly large value (due to cast
from signed to unsigned integer) and passing sr_skb to
usbnet_skb_return.

Fixes: e9da0b56fe27 ("sr9700: sanity check for packet length")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Link: https://lore.kernel.org/r/20230114182326.30479-1-szymon.heidrich@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 83640628c47d..8bee8286e41a 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.39.0



