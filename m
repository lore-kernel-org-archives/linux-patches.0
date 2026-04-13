Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E024DCF6;
	Mon, 13 Apr 2026 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097049; cv=none; b=a4LdX///peCclFkDDkVsHtbfFBRGr+gfUXm4Dt0rp0+lUrXCaf4bJV8hc/r0hSvIfj5Tz52h6+tGJyIizDIj/UnhXRF721BJ/VXGjJqI8Y/Qh7yYSYb8ZRdOpnD7GblxKVUSPrbXW7aeVwukaLzBORul1D2NEDv6SvRsPIGJkeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097049; c=relaxed/simple;
	bh=qXUA+bZcfcUCWdn/uHdwC1vtd+eKD7s8om9Q4iM7yM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnZwCW4vGufwmkdmPUskZcB2jH/B1e2Y5wPh+hdkqzhiXSk7139nMwQFCiQQKJfNWlV4y/nkWiZDnoQEh7r69/jp6xrzpn3xu+v2Fs/2b/rUiLEq07RyFRwWfW05nFbOIV1lLDS4wyK1dmoZKmXGFW9e3e4Su4P1644je0/6Xn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTbWnDwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTbWnDwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23217C2BCAF;
	Mon, 13 Apr 2026 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097049;
	bh=qXUA+bZcfcUCWdn/uHdwC1vtd+eKD7s8om9Q4iM7yM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTbWnDwMMj+3PExciGNYuDUZseJ+fjqQKiaVy+okGlyJuaXSxYYZvAtl08v2UU7dc
	 vTX1OeBCSfh91d9Y7PzV98PgKYZF+B0wSIZLvYGEEgAgp0e7/qVin2BI4Jno6+qFSc
	 fmbQS35VZAZFg9+PLrE1r5REYxSKwy5NyOQIfoUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 42/55] nfc: pn533: allocate rx skb before consuming bytes
Date: Mon, 13 Apr 2026 18:01:16 +0200
Message-ID: <20260413155726.403685721@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit c71ba669b570c7b3f86ec875be222ea11dacb352 upstream.

pn532_receive_buf() reports the number of accepted bytes to the serdev
core. The current code consumes bytes into recv_skb and may already hand
a complete frame to pn533_recv_frame() before allocating a fresh receive
buffer.

If that alloc_skb() fails, the callback returns 0 even though it has
already consumed bytes, and it leaves recv_skb as NULL for the next
receive callback. That breaks the receive_buf() accounting contract and
can also lead to a NULL dereference on the next skb_put_u8().

Allocate the receive skb lazily before consuming the next byte instead.
If allocation fails, return the number of bytes already accepted.

Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260405094003.3-pn533-v2-pengpeng@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/uart.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -211,6 +211,13 @@ static int pn532_receive_buf(struct serd
 
 	del_timer(&dev->cmd_timeout);
 	for (i = 0; i < count; i++) {
+		if (!dev->recv_skb) {
+			dev->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN,
+						  GFP_KERNEL);
+			if (!dev->recv_skb)
+				return i;
+		}
+
 		if (unlikely(!skb_tailroom(dev->recv_skb)))
 			skb_trim(dev->recv_skb, 0);
 
@@ -219,9 +226,7 @@ static int pn532_receive_buf(struct serd
 			continue;
 
 		pn533_recv_frame(dev->priv, dev->recv_skb, 0);
-		dev->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
-		if (!dev->recv_skb)
-			return 0;
+		dev->recv_skb = NULL;
 	}
 
 	return i;


