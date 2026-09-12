Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298D3BB136;
	Sat, 12 Sep 2026 20:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243560; cv=none; b=jvBs6BennM9jToCLgwsJ0XNvMo2woLeyzpLUtnne6bJ1JnmKn/AoY2sUcBaKo+Y3Rwo1FsLMARMJjPVqQVZ0mvV4GEgWwQEuRstZA8i+eD9+892zSpAW4itgZUmPrAVU5WlssXrjWv1/nXMrgJfMs87MDz7Z9GemJOqVFsq37Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243560; c=relaxed/simple;
	bh=89gVWn0XI3bB8wOVjHDA8ecfRR/am6CJ0IPMdpAQmgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjccnhOEf7fBaY//GoJMtDX3h0eUaSzGgSTKPRnCZ75KmUfYq6+1IPuHGiaml2JB6LZZSICD9U9r+1LfOot+QFesxF+L8p4pjZLZC7SWambH2ok4O/n0E8MEEYQrxvjmeDIr0r5SMs0HPaZeiVNrBYrRSa1eefZyUcrDlEyWKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppn3lIfK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppn3lIfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6B11F000FF;
	Sat, 12 Sep 2026 20:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243558;
	bh=rqLu4texlv3CKf5g7U008antpTDEHvzMr7NSNTWhavU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppn3lIfKzsJ0B6mOsSdJT8Tzj//NuZdzmv7u6HNqc20XtLcYa5x6x7qEkt4Jp1bsu
	 6GoDU14yPee1m2Ba5fo31wpiHoId1NJpuPFGvOyvChcH3Fqk4RzjRQTizvGN+mSQX0
	 xQcTK6gxN3QbEk4iQ+22UR3gT4df0J4QXbVsox9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chen <zhangchen01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 798/798] Bluetooth: L2CAP: Fix send LE flow credits in ACL link
Date: Sat, 12 Sep 2026 09:07:06 +0200
Message-ID: <20260912065535.351136279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Chen <zhangchen01@kylinos.cn>

[ Upstream commit f39f905e55f529b036321220af1ba4f4085564a5 ]

When the L2CAP channel mode is L2CAP_MODE_ERTM/L2CAP_MODE_STREAMING,
l2cap_publish_rx_avail will be called and le flow credits will be sent in
l2cap_chan_rx_avail, even though the link type is ACL.

The logs in question as follows:
> ACL Data RX: Handle 129 flags 0x02 dlen 12
      L2CAP: Unknown (0x16) ident 4 len 4
        40 00 ed 05
< ACL Data TX: Handle 129 flags 0x00 dlen 10
      L2CAP: Command Reject (0x01) ident 4 len 2
        Reason: Command not understood (0x0000)

Bluetooth: Unknown BR/EDR signaling command 0x16
Bluetooth: Wrong link type (-22)

Fixes: ce60b9231b66 ("Bluetooth: compute LE flow credits based on recvbuf space")
Signed-off-by: Zhang Chen <zhangchen01@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index f59146ae72439..1122566c4b500 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7781,6 +7781,10 @@ static void l2cap_chan_le_send_credits(struct l2cap_chan *chan)
 	struct l2cap_le_credits pkt;
 	u16 return_credits = l2cap_le_rx_credits(chan);
 
+	if (chan->mode != L2CAP_MODE_LE_FLOWCTL &&
+	    chan->mode != L2CAP_MODE_EXT_FLOWCTL)
+		return;
+
 	if (chan->rx_credits >= return_credits)
 		return;
 
-- 
2.53.0



