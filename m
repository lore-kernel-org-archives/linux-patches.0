Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EAA19526
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F5AC433EF;
	Mon, 12 Jun 2023 10:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565836;
	bh=HCZ96EUcsEpO1qmo7iXH+LMxPmqQS/gErolqnh6hiUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD7jSvH/eEuBodCUvbdmzbLwuiGo0ddPLB+pmJixtx3XiinwHhsZ9+fH/Ip7ykSyF
	 YkaMdjw398du9hl9VSthaGGQUM8YUbGjAHZsHYscLCU8x3EYQuBWGpr4DIqXM/Ah96
	 NQT2HCXa5+vk/j0jPDna9ZMeo25ZS7Nrg9BaKLWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/45] Bluetooth: L2CAP: Add missing checks for invalid DCID
Date: Mon, 12 Jun 2023 12:26:04 +0200
Message-ID: <20230612101655.040545161@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit 75767213f3d9b97f63694d02260b6a49a2271876 ]

When receiving a connect response we should make sure that the DCID is
within the valid range and that we don't already have another channel
allocated for the same DCID.
Missing checks may violate the specification (BLUETOOTH CORE SPECIFICATION
Version 5.4 | Vol 3, Part A, Page 1046).

Fixes: 40624183c202 ("Bluetooth: L2CAP: Add missing checks for invalid LE DCID")
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 6bbe0fd79d154..e56863587ea2e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4024,6 +4024,10 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	result = __le16_to_cpu(rsp->result);
 	status = __le16_to_cpu(rsp->status);
 
+	if (result == L2CAP_CR_SUCCESS && (dcid < L2CAP_CID_DYN_START ||
+					   dcid > L2CAP_CID_DYN_END))
+		return -EPROTO;
+
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x result 0x%2.2x status 0x%2.2x",
 	       dcid, scid, result, status);
 
@@ -4055,6 +4059,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	switch (result) {
 	case L2CAP_CR_SUCCESS:
+		if (__l2cap_get_chan_by_dcid(conn, dcid)) {
+			err = -EBADSLT;
+			break;
+		}
+
 		l2cap_state_change(chan, BT_CONFIG);
 		chan->ident = 0;
 		chan->dcid = dcid;
-- 
2.39.2



