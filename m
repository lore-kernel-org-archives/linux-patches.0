Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73588317141;
	Mon, 13 Apr 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099078; cv=none; b=MHc7+nngO8f/TZ1y5YMxKSz8ihbCpnoSImL870ONza+JefQWX1SNnwOxF/2A94BCAIq6OHD4f2Y1u8W5ynahUVPwDQAYeXR83Bf/zbnXjEQ2970bk31hpkkddhFnAmKOrciZcRJluztKv22ZB1h2kDH1ax3+SOPFD71l/5vddh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099078; c=relaxed/simple;
	bh=iO7Kgss9/8iwdzclTsuNxbOIUgHvoxR3b/Ild3TLz+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSRHlyuS4AtQSeavNRX6DHoc23+XvF0eSZMA/JVB4jAeSyE6J4zVr+ljuJ2GXvRAEd7VrNFsU3GZ8yzTVfr26kwhqrED/AWaJ8rW1eTtlWlP2+KcqMJQwPKTfPiH1QigVLVgLRmmZWnRhwtnyirJr0JUw0Ob7w8xfB4lA2SQODc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bbb6s3DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bbb6s3DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0527FC2BCAF;
	Mon, 13 Apr 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099078;
	bh=iO7Kgss9/8iwdzclTsuNxbOIUgHvoxR3b/Ild3TLz+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bbb6s3DSiNkTh51zchxjKOwHPkKs4h/qXOhnUK7Mi0TJgjnizUoEKyHbRTOR4p9So
	 m3b7fi4CSkR76O/8AXnVxTvjPaunFCgHPVEkdvqGzaNhSd9LyZifci9GC2AXF5BFC3
	 6miiAXA0T+5lCFmWswdoRY3EIUCNAfJWlF+X9Kbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/491] Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU
Date: Mon, 13 Apr 2026 17:57:26 +0200
Message-ID: <20260413155826.597214539@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit b6a2bf43aa37670432843bc73ae2a6288ba4d6f8 ]

Core 6.0, Vol 3, Part A, 3.4.3:
"... If the sum of the payload sizes for the K-frames exceeds the
specified SDU length, the receiver shall disconnect the channel."

This fixes L2CAP/LE/CFC/BV-27-C (running together with 'l2test -r -P
0x0027 -V le_public').

Fixes: aac23bf63659 ("Bluetooth: Implement LE L2CAP reassembly")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9c1d68b1e83b5..ed113cfdce23b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7705,6 +7705,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 	if (chan->sdu->len + skb->len > chan->sdu_len) {
 		BT_ERR("Too much LE L2CAP data received");
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		err = -EINVAL;
 		goto failed;
 	}
-- 
2.51.0



