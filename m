Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D751C041;
	Wed, 30 Sep 2026 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792668; cv=none; b=alptUDmDkNGUao/Y13Aok8JrgHSVp/VEOqxaTjp9XB0jAU+kwzmOjMcfbmCbKXVjCKfAlge7vnStfA6PsXM7hNbH4uFUkk7p/nnCKDwizZu+KE6FYVmmf7erWy2TVSQW6ipTbhdXoc7tI6qJe1jzieHM7HO4aX6YqdxvI70x9io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792668; c=relaxed/simple;
	bh=+gcAkzcLnbDnblNaQ8XiO7xwYxu6smAixZ+eEhVGqU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7iWrQ4Rk1PmqSm8501JkuFI3J9Nr46cgefzpgEZtznxQljGClUZDlmWmkaYloQbIcRnzgUu9F5UjdrxTXWQ4q4iQu0JSHoswCelN299M7MHsQxB/ntFfJ4TLNfeYoCjN+IP3Hb/tLsGC1ZEmoHs1XyMRgbqioC6kamLjizr/hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb78Msor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb78Msor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D6B1F000FF;
	Wed, 30 Sep 2026 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792667;
	bh=vsCXgnRlIEJ80KZicYru6/E2xQsr2RiUPpiGpmzsFnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cb78MsorZ5qwVWs01ysIkPaZIEy2g0SxTvTJ73JudtKPllLHlfxDn6dUEw+gbA34c
	 j8F8oWXXbWYJSpV7KgncfUgqHpv0mMZzlRVpJcFgG6L3Rk5g/6n3cGdKLS3kT8YYqc
	 IRcC3/oy2nV8kKybMW9SWGBPSiTOh9VihNMaIKw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 735/752] Bluetooth: L2CAP: validate frame length before control and FCS access
Date: Wed, 30 Sep 2026 17:30:05 +0200
Message-ID: <20260930152414.121523361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
@@ -7662,9 +7662,17 @@ static int l2cap_stream_rx(struct l2cap_
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


