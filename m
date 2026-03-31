Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3DA3E3C5C;
	Tue, 31 Mar 2026 16:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975005; cv=none; b=svFO0XJsdPoJFdRqblMX0/QbroE18J4tBx1MUB+5D2ljurnTVKBvPMFJwccnblBqvbskAN/8qeOJQfUwZPzzrb3KsbgifidQ/uytsJ3fJyemxOFVtQ5UDrUc1otPKmNA/2zDFXJwFPrlm6YUAvaJe4tjm4IrNLtRrEST0MVXgns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975005; c=relaxed/simple;
	bh=lcaxrvLmE4C0ci9pOcW11BSYItolD/ZNcd3IsbFxbAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvDVBs4iXC7BZIKTPkW1PHziRv2ZrFhLqvkveN/bRicBWcXJcKzFKyszyykJleRVTzMhR2VyrnOFb8AtuapBAl1h7S44I694iIT7Y8FiSHFJOWnllz26YV8sjny0yuU4R+or+sGxQKMDwo+e/8AXEQZ0+0wxlSUAIm9+Xg3MXLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPRHiZ/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPRHiZ/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2ADC19423;
	Tue, 31 Mar 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975005;
	bh=lcaxrvLmE4C0ci9pOcW11BSYItolD/ZNcd3IsbFxbAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPRHiZ/AC0VGOLK8HTOB87iR5lFGkCZI2UBnfcOtGN0B38ztuVikpTvP9BbR3IMfr
	 DrgY22I1WTl/SX7H0t+hwXrWsUSTsSTI9juiCUDe4vmx8VqzO+6c+MLfOA2FnD98q3
	 1g8INcC6QX13Y18/sQsb/DUN+gXapKxXREW7T3R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 094/342] Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()
Date: Tue, 31 Mar 2026 18:18:47 +0200
Message-ID: <20260331161802.478169483@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 583fe3b654c11..848a9b945de89 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6672,6 +6672,11 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
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



