Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DDF32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301240; cv=none; b=Xy1lxx0O/sTMurX+5ZiMY6JgkJcXaFROo8HCOWbj8xTg7aFsPTIM587kId7e1PKnOUGGlK8lzXmZe7/fp06wk6g2huRK7QyUvOU0nsPrsL2DcT7DmCNCKZ3wm96qNGboizZt/J2TZP10m5A0yY5atuDSI65LMklcuFlTeOGJ81o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301240; c=relaxed/simple;
	bh=lEa1RlafBsckoZh6eMRjQETxXFx6+7H+LvTwJMaPMvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDF7h6tzq2bf9ExBPUxNcTjdy/x6vF/oTsSr4LIIp+1AT2Phnm53co+9/0qFVwLDjnBtbiCPE3XPy0ABobNR+YYVD+bAq0wcPIOctBOH9LE2C1CdwfkFckBy83MigJ02pm1++XP6scB9lCFZoQQvDsChK1KNQ+0uQWSuqH+S/Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/30uNzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/30uNzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF058C19423;
	Sat, 28 Feb 2026 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301240;
	bh=lEa1RlafBsckoZh6eMRjQETxXFx6+7H+LvTwJMaPMvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/30uNzGzNzvbbDHlAMiQ+mmLeqOawykFdrGSnn18o4tSU9Z/mun2VeiMDiJ1+56r
	 XVfLrwURQqGTl176fGTCa4WgdZuHRAdxtjis+qd9YE9fKhLBaaCQSpkiFn+tBU8Duk
	 gQq0ZzEMvS4spmLpPuhXJx2nqOx1kQ3fhippHSzCWPffmXbh4oqOmo+C1kxlrMVMUJ
	 OUB4G78118EeM9S1OspvyLR9AzWIo7v/WFKWiwD+KMN3lOhNnSHZ2KlBQauhLphv2H
	 sMo6Z/ljT2LZ/p1C43dPKR7UtEU3gfy/wrfTQvPltGtubsSEAzXC7M/3dE6VFmPtAa
	 mP6EPrrvJ1A7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 420/752] Bluetooth: L2CAP: Fix result of L2CAP_ECRED_CONN_RSP when MTU is too short
Date: Sat, 28 Feb 2026 12:42:11 -0500
Message-ID: <20260228174750.1542406-420-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c28d2bff70444a85b3b86aaf241ece9408c7858c ]

Test L2CAP/ECFC/BV-26-C expect the response to L2CAP_ECRED_CONN_REQ with
and MTU value < L2CAP_ECRED_MIN_MTU (64) to be L2CAP_CR_LE_INVALID_PARAMS
rather than L2CAP_CR_LE_UNACCEPT_PARAMS.

Also fix not including the correct number of CIDs in the response since
the spec requires all CIDs being rejected to be included in the
response.

Link: https://github.com/bluez/bluez/issues/1868
Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/l2cap.h |  6 +++---
 net/bluetooth/l2cap_core.c    | 14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 9820ccc379f1c..f08ed93bb6fa3 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -284,9 +284,9 @@ struct l2cap_conn_rsp {
 #define L2CAP_CR_LE_BAD_KEY_SIZE	0x0007
 #define L2CAP_CR_LE_ENCRYPTION		0x0008
 #define L2CAP_CR_LE_INVALID_SCID	0x0009
-#define L2CAP_CR_LE_SCID_IN_USE		0X000A
-#define L2CAP_CR_LE_UNACCEPT_PARAMS	0X000B
-#define L2CAP_CR_LE_INVALID_PARAMS	0X000C
+#define L2CAP_CR_LE_SCID_IN_USE		0x000A
+#define L2CAP_CR_LE_UNACCEPT_PARAMS	0x000B
+#define L2CAP_CR_LE_INVALID_PARAMS	0x000C
 
 /* connect/create channel status */
 #define L2CAP_CS_NO_INFO	0x0000
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e705b4a171dec..0b236e977d70e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5035,13 +5035,15 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	struct l2cap_chan *chan, *pchan;
 	u16 mtu, mps;
 	__le16 psm;
-	u8 result, len = 0;
+	u8 result, rsp_len = 0;
 	int i, num_scid;
 	bool defer = false;
 
 	if (!enable_ecred)
 		return -EINVAL;
 
+	memset(pdu, 0, sizeof(*pdu));
+
 	if (cmd_len < sizeof(*req) || (cmd_len - sizeof(*req)) % sizeof(u16)) {
 		result = L2CAP_CR_LE_INVALID_PARAMS;
 		goto response;
@@ -5050,6 +5052,9 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	cmd_len -= sizeof(*req);
 	num_scid = cmd_len / sizeof(u16);
 
+	/* Always respond with the same number of scids as in the request */
+	rsp_len = cmd_len;
+
 	if (num_scid > L2CAP_ECRED_MAX_CID) {
 		result = L2CAP_CR_LE_INVALID_PARAMS;
 		goto response;
@@ -5059,7 +5064,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	mps  = __le16_to_cpu(req->mps);
 
 	if (mtu < L2CAP_ECRED_MIN_MTU || mps < L2CAP_ECRED_MIN_MPS) {
-		result = L2CAP_CR_LE_UNACCEPT_PARAMS;
+		result = L2CAP_CR_LE_INVALID_PARAMS;
 		goto response;
 	}
 
@@ -5079,8 +5084,6 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
 	BT_DBG("psm 0x%2.2x mtu %u mps %u", __le16_to_cpu(psm), mtu, mps);
 
-	memset(pdu, 0, sizeof(*pdu));
-
 	/* Check if we have socket listening on psm */
 	pchan = l2cap_global_chan_by_psm(BT_LISTEN, psm, &conn->hcon->src,
 					 &conn->hcon->dst, LE_LINK);
@@ -5105,7 +5108,6 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		BT_DBG("scid[%d] 0x%4.4x", i, scid);
 
 		pdu->dcid[i] = 0x0000;
-		len += sizeof(*pdu->dcid);
 
 		/* Check for valid dynamic CID range */
 		if (scid < L2CAP_CID_DYN_START || scid > L2CAP_CID_LE_DYN_END) {
@@ -5172,7 +5174,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		return 0;
 
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_ECRED_CONN_RSP,
-		       sizeof(*pdu) + len, pdu);
+		       sizeof(*pdu) + rsp_len, pdu);
 
 	return 0;
 }
-- 
2.51.0

