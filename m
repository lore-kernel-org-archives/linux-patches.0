Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D74928B4FD;
	Mon, 13 Apr 2026 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097904; cv=none; b=TuL9P7ly6s9qff2/APxWyZb26Oz1ERI+1BlD6w1cvY3S5x3/8BCV+/VodB5HpnEeN0CFvSknBoPV5AqVlbHJifEtJwry7AOM0tzr1b4o8Xh+tRkRynA0tvYZBlCuOFg9dY311cfNB1UIQ5FJTtlHObbBTdD6+zPCThd3bW2Z7eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097904; c=relaxed/simple;
	bh=gRtouCgv0KftyvxvCu4TA8mMbXflmtyh4oKsgm8EhiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWOxBIfzUSPOncNRH5u57iI6jLyGMJ8q7nKLjY//pajl5TOPo8t/7rF5nuxuJeuHP52gxt8HfWmYlvWuavBkoIJpCftNsq7aa2WQ7UqfMpAQIdyxnnNQMa/Kl4USypXbmLT/wJn5c1cpapwGpOpuzOgB3r/3eod/sJtPe4ZZZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xspKuK6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xspKuK6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ADEC2BCAF;
	Mon, 13 Apr 2026 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097904;
	bh=gRtouCgv0KftyvxvCu4TA8mMbXflmtyh4oKsgm8EhiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xspKuK6BADIWH1pGqY/x/cPG6ck6fOt9hquStiBTKhVWPm9dOJabCcMeoyMxMs5gv
	 rgH2oZTVI+M3p7ni/f6f0z0ZkSeY801U2C42JOxza+6E0x9HM0wMir6TZ74chybjrE
	 szZFdX7fqdgGpb1QDEXOPWweYzAx16Jt4oJZwTMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/570] Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()
Date: Mon, 13 Apr 2026 17:57:28 +0200
Message-ID: <20260413155842.370745547@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit c65bd945d1c08c3db756821b6bf9f1c4a77b29c6 ]

l2cap_ecred_data_rcv() reads the SDU length field from skb->data using
get_unaligned_le16() without first verifying that skb contains at least
L2CAP_SDULEN_SIZE (2) bytes. When skb->len is less than 2, this reads
past the valid data in the skb.

The ERTM reassembly path correctly calls pskb_may_pull() before reading
the SDU length (l2cap_reassemble_sdu, L2CAP_SAR_START case). Apply the
same validation to the Enhanced Credit Based Flow Control data path.

Fixes: aac23bf63659 ("Bluetooth: Implement LE L2CAP reassembly")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 5010c200b2c41..e69c6041437b0 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7650,6 +7650,11 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 	if (!chan->sdu) {
 		u16 sdu_len;
 
+		if (!pskb_may_pull(skb, L2CAP_SDULEN_SIZE)) {
+			err = -EINVAL;
+			goto failed;
+		}
+
 		sdu_len = get_unaligned_le16(skb->data);
 		skb_pull(skb, L2CAP_SDULEN_SIZE);
 
-- 
2.51.0



