Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B74D2EFE;
	Wed, 30 Sep 2026 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787931; cv=none; b=CYP0drQhdZhmsnm23MAxxW1x2f4I0aACLphmuUt32RQAIuC59VPvl8nMhFkx5DMEvymahepAIuF6yk5IgdJRJAflzHquZmKI+wRWSVjj7s3XVvmyBOUg/zPi6IC+ZT/xvLhDiBs5Qc/R5d1rbHAcObvD5/gZrhlVrxw5+jTDQQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787931; c=relaxed/simple;
	bh=bMu3JJI+muM3IuiGgM/+inzKlAkMuZlLf/UUV6Qa5R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDTIPQatg695HIlZtKGRw6nKl8sMAPOJ0UJsvlR7pXoHqituu+bni5UN/CpTtL0SuoSwKnCoejolSjfD89dGiqrPCHFN26jH5wtGvjbx+TGLKdVc3wZZWNsQ3BY0S6W+dpl+PCjHG6OkDt8JUX5CULTHOpjLrhd9WAov0N5WKyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sqt6t/oT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sqt6t/oT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E199E1F000FF;
	Wed, 30 Sep 2026 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787930;
	bh=ROWSXPQ70xL2Vvke9AhWi7zEUdACRppU0x9ARA1ZLwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sqt6t/oT8GoAPb4kAveZJuRfRIi8H9g/N+MuZxYlGgeI/iDFb+ckDlPhaYHYHzK6I
	 fwQ2C7ZzFLh73IywMWmv7miF8rm8TEZkO40mZZurAZQFD9vGScoZ/4n0XArmNpRgHO
	 cA7DtA0crsKWPmBK0q2VX4MZT4k/uoUMKYHxJFss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 405/457] Bluetooth: L2CAP: validate frame length before control and FCS access
Date: Wed, 30 Sep 2026 17:28:30 +0200
Message-ID: <20260930152354.735581773@linuxfoundation.org>
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
@@ -6701,9 +6701,17 @@ static int l2cap_stream_rx(struct l2cap_
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


