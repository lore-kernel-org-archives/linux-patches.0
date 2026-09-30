Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB413D25B2;
	Wed, 30 Sep 2026 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797234; cv=none; b=niJwJU+d+GzUVlbyKPfbDYpUheYW1sLE3Th2OvJIE3r14ltAtfBWDKXntxs6v833oqau3Sw2MF0oZsdc6yCsHS+yMQWcnTD+koR9RPyVNhxvBCnDT+O9/o6OjreztRqi9bTgkOjh2/InnMd0EoIWGpM8NSaanYwQ7Clz4bCSIeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797234; c=relaxed/simple;
	bh=nVor6WX04G+Do1RvD7JhUgnzKesoRciW6x0E/D0Kflo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBlSRtgres3zseCUe8A7cRecW7Jesz99RnyQ4CF8x3DoSNTZe0aPj2OvKp/DsCvoI+S13eJtMeCEaiA7QC92oIkbSomj0hKBmmquP6XCirZ78HHsJ1/uir48TzeP+X2dDaXPCtX7C0tB8jSZg+eY/xMgGQtkelPV7QRpdcN6dDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjNNPMwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjNNPMwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DF11F000FF;
	Wed, 30 Sep 2026 19:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797233;
	bh=49/ASjjgpgp1LUHAksJ4mMwdrD+dwjiY5G80tdO4yTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjNNPMwPMnnv3h6AW5CUpDwOcqQAC/w4A1XfusFP3H7Q+Bx02uoynWbLQqoB+fZgP
	 9p3iJntLgcjz938c/110ZLnYF6RP6eQ8UeIGwCPB8StcLD7FfE+wH9fK4BqnqCXwse
	 GXHFhA1asX0U7BTz2MSO5+KlkvP0TPz0NvH+3Eqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1149/1193] Bluetooth: L2CAP: validate frame length before control and FCS access
Date: Wed, 30 Sep 2026 17:30:33 +0200
Message-ID: <20260930152459.766579740@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 6c78a213d9070b610c7f418af2c25b66180b7e37 upstream.

l2cap_data_rcv() unpacks either a two-byte or four-byte control field
without first ensuring that it is present. A short ERTM or streaming-mode
frame can therefore cause an out-of-bounds read.

There is a second short-frame case when CRC16 is enabled. After the
control field is pulled, l2cap_check_fcs() subtracts two from skb->len
without checking it. If fewer than two bytes remain, the subtraction
wraps; skb_trim() leaves the buffer unchanged and the subsequent FCS
load reads past the logical end of the frame.

Validate that the frame contains both its control field and, when
enabled, its FCS before either field is accessed.

Fixes: 1c2acffb76d4 ("Bluetooth: Add initial support for ERTM packets transfers")
Fixes: fcc203c30d72 ("Bluetooth: Add support for FCS option to L2CAP")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6629,9 +6629,17 @@ static int l2cap_stream_rx(struct l2cap_
 static int l2cap_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 {
 	struct l2cap_ctrl *control = &bt_cb(skb)->l2cap;
-	u16 len;
+	u16 len, min_len;
 	u8 event;
 
+	min_len = test_bit(FLAG_EXT_CTRL, &chan->flags) ?
+		  L2CAP_EXT_CTRL_SIZE : L2CAP_ENH_CTRL_SIZE;
+	if (chan->fcs == L2CAP_FCS_CRC16)
+		min_len += L2CAP_FCS_SIZE;
+
+	if (skb->len < min_len)
+		goto drop;
+
 	__unpack_control(chan, skb);
 
 	len = skb->len;


