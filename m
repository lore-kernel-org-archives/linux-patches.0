Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D629318AE1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055E2C433D2;
	Mon, 12 Jun 2023 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565728;
	bh=4kVhBIgWulDp8tGXjyNDZ3L88PqldOnlPPWZEt33hIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVSolqQW8ZEU7eZ1jr5Wz9Zgq7pW6rjCjQzF8Bfq1tbzSi5nDOXuCIPwogevDGRSE
	 xz+3eU9y0jA7mzfBbjabH2iznf/EGtEw3dQkg+k9+cMv1m8xhj60VarW6UBXJdhVdw
	 LthSicM5Ut6Byaf7sDlvZG6VmUABoElbIF67H/cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/21] Bluetooth: L2CAP: Add missing checks for invalid DCID
Date: Mon, 12 Jun 2023 12:26:00 +0200
Message-ID: <20230612101651.261384955@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>
References: <20230612101651.048240731@linuxfoundation.org>
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
index 281d1b375838a..25d88b8cfae97 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4007,6 +4007,10 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	result = __le16_to_cpu(rsp->result);
 	status = __le16_to_cpu(rsp->status);
 
+	if (result == L2CAP_CR_SUCCESS && (dcid < L2CAP_CID_DYN_START ||
+					   dcid > L2CAP_CID_DYN_END))
+		return -EPROTO;
+
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x result 0x%2.2x status 0x%2.2x",
 	       dcid, scid, result, status);
 
@@ -4038,6 +4042,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
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



