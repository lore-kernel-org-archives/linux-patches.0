Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FEF264A86;
	Mon, 23 Mar 2026 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277327; cv=none; b=V7jqe2xyGaNFZCiz+LNJFyP6SqYzXe394jdLMbnOiQl9IqXfk/ABx6X1i1SDeRIbhPlA429whltPEtRoYYFuAQmMTje17v8+xIe0yFBc8kHga5Ksnc29V0NHX71rlRSBWQHFhXA+rQ8tuQSzYbSFAWdpWAS2DAGov4CqjIg1QII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277327; c=relaxed/simple;
	bh=90tVMNW0P2hgMevGrE/jsRMMu66sSIJ41msPIvV3M8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1/O4vpNLRYhI1/Ja1l6u2V6yEyBtWf6SauilAYCS0iihkNNzrMgRN0FH16EhbSryA1UCFUMSRgfUlwcpkxb+B7MV7+Yr9r13PTEREpVxx42vip+WfKAfqXwM+emKI22rkLfiOTzzIH4q+UWhFeL6UGf4ZUBX+TBqUKtY+bNiGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVRGjJAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVRGjJAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB04C4CEF7;
	Mon, 23 Mar 2026 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277326;
	bh=90tVMNW0P2hgMevGrE/jsRMMu66sSIJ41msPIvV3M8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVRGjJArHu5FubKdH9yDNpPz53mV9SNdi71ZijFm5U6J5lHezUuRvaVQATDK+cQdk
	 twJgb4rnPjEFMeyOo/AazljIvSrdVqJ9jiMdY1Js8m4I77dw+VFmyGNf5S5/XmoMTb
	 JYS/T9QX+r3nqWNIjrKSjrC+pDcxIKKw4bhjjLKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/460] Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU
Date: Mon, 23 Mar 2026 14:46:17 +0100
Message-ID: <20260323134535.934208171@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index de8e18fe50557..560a17d36f7fa 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6686,6 +6686,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 	if (chan->sdu->len + skb->len > chan->sdu_len) {
 		BT_ERR("Too much LE L2CAP data received");
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		err = -EINVAL;
 		goto failed;
 	}
-- 
2.51.0



