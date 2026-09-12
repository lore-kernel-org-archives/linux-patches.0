Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12F37E2F3;
	Sat, 12 Sep 2026 19:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240748; cv=none; b=Ai5mb2dtygDAEBJG7pMlYpokfrV7e5RF3pKlp4hljcC99PFpnBJqEgml7TicVwOAl9Cc0I0k2FO/+0U9bOzq8ynsHyC4RCLNsFOglxkw+Y30ZPADBJqevoEgcOAgcshYot4T6ATIG3FpIL2CMhh8wtYqIFHKK1IWJq2D/kMe0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240748; c=relaxed/simple;
	bh=brpna8QAr+8AfZUhGQQQP8ANzuPUEvAbRmKBN/1YY9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAoWzxWJY4/+L0MYufDdKrzgkgwsuEFy7okZ4JRElmsz9N0m0Yb1+ekqVoxmSFe64gAg8pf3GCQWVNYJ31w3kfjr9kWl2An6VmWcyLLvPJE4MAShrtje0NEcPamd9gB5FeaZEd51OQqNiMSa1vtFIX+dwnxwIDu/6svLh3PF22s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeF/8obE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeF/8obE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7031F000FF;
	Sat, 12 Sep 2026 19:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240746;
	bh=3Ac9rUaDkAkricXFV8crdmO7AOEE7RLIfkD0kuj5zSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeF/8obEVbeYcJsvvIoZ3LgdjefolVIrTZCmG/fPbR060mcdfZxPuLnGNwQOG4YHC
	 hGScpvO+pqR/R5B6DHIqAf7oilPF6Qf3KwLUHcil7LpDr5Y8Czs/IAptIRTcdrCQpk
	 Tc+3bp5sTsFzlLihqaJYm3U8cGHzKxv7B4A+hHcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chen <zhangchen01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 931/935] Bluetooth: L2CAP: Fix send LE flow credits in ACL link
Date: Sat, 12 Sep 2026 09:06:01 +0200
Message-ID: <20260912065548.175787565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index f9a5d118e5e67..bd9dfd35f9097 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7771,6 +7771,10 @@ static void l2cap_chan_le_send_credits(struct l2cap_chan *chan)
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



