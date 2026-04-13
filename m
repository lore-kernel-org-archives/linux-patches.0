Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146C6313298;
	Mon, 13 Apr 2026 16:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098154; cv=none; b=u0VVZDTTWYGR4LIB3JReAzZ0naef76kOIR44MVdJUo5DZs234kGXn9YX80MdQbctONXyauFHtBByg4eCYXjZ8AWxJiytjVeTtWQIwDRIZzikYRZzPYbcJNFsIx/4VoDQ3dfzlDpKEmcWNt+xwCHSdK9vwBo2NYRDivp4ZUt1++Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098154; c=relaxed/simple;
	bh=a37JlJ//onUta125/zCb/4sgcPMjLpDoAX+TXmmfD78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaLjOMjysyyFRSax6RxMeEB8Tg6Q/YTt9dgjnBh67RcTr77FI9UUk3c+2uAnADsFqgiDV7JNzC5WegUNAk8nbNToJG/Aw8jPX9M2IW9tORR0Kj5RqQ68z2FbmvBnQCB/fYPiGiy3ErEcFyXES0ktTgHNAjHxo50BdGCUQRg+7VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaFLH4aX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaFLH4aX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FD4C2BCB0;
	Mon, 13 Apr 2026 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098153;
	bh=a37JlJ//onUta125/zCb/4sgcPMjLpDoAX+TXmmfD78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaFLH4aX0pJr93UEh1n1t6JoOj1J9NAGh5dWkVyYfphBnB/jn2iCjV1Ka9pqAz9a3
	 i1K62LsriEFkLqfTyTlpqlmjjX6/zR+zvNgnFi7rHpL0QVLQ5ehXl9GsFJDKYym5zi
	 mKYE6dYi/t9Bni27bXDFvWNarVXw934kNVrIQzh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 415/570] NFC: pn533: bound the UART receive buffer
Date: Mon, 13 Apr 2026 17:59:06 +0200
Message-ID: <20260413155846.019354991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 30fe3f5f6494f827d812ff179f295a8e532709d6 ]

pn532_receive_buf() appends every incoming byte to dev->recv_skb and
only resets the buffer after pn532_uart_rx_is_frame() recognizes a
complete frame. A continuous stream of bytes without a valid PN532 frame
header therefore keeps growing the skb until skb_put_u8() hits the tail
limit.

Drop the accumulated partial frame once the fixed receive buffer is full
so malformed UART traffic cannot grow the skb past
PN532_UART_SKB_BUFF_LEN.

Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260326142033.82297-1-pengpeng@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/uart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 7ad98973648cc..615ceff0adeee 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -211,6 +211,9 @@ static int pn532_receive_buf(struct serdev_device *serdev,
 
 	del_timer(&dev->cmd_timeout);
 	for (i = 0; i < count; i++) {
+		if (unlikely(!skb_tailroom(dev->recv_skb)))
+			skb_trim(dev->recv_skb, 0);
+
 		skb_put_u8(dev->recv_skb, *data++);
 		if (!pn532_uart_rx_is_frame(dev->recv_skb))
 			continue;
-- 
2.53.0



