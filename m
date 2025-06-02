Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A144A1E;
	Mon,  2 Jun 2025 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877337; cv=none; b=CNAmNWkj7P1Zk+TAef58eV/TvLZOvEodO/7a8RU03iPW7uUXj2oRLdoQHXFHCMwJdwkLlyYjxCMPQLzb41ILl/5b+mdIpGJdowpaPQ98sAyYDULAw2R+FiXUYWxeGS1aG4QT1ug3OxlCY2KA/sk1u5plsbbWPcDQ3HTZLGacLLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877337; c=relaxed/simple;
	bh=FTAFpcCxrNgTlDOFVc5jG1WWPzTd7xhlWtSCvjvX97I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS8J7SEq6uHa74vCTChDTs2pQf8yRNsAKbw2QcV740ln8BhFmqhDf4ji3DLLRWd9ZjTO3d4qG7644LqnwWS2m2GD9QV5z3mumujNAxeBowO7vXfbr1owrY/dgCqs/VLqpjzGkmRhm6q6eAqTJOxEwnT7G6yN3V4suxCc3GeVJt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl4wgic1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl4wgic1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FB9C4CEEB;
	Mon,  2 Jun 2025 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877336;
	bh=FTAFpcCxrNgTlDOFVc5jG1WWPzTd7xhlWtSCvjvX97I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl4wgic1Jt1CwtFb+UbSU1hsTuNgmEC+46ob6dD1mY0PcL2Y8uc5P+wFzqNbjfqH5
	 7H8dpEsd5MLvkpVsCucUvO5Rg7oPsInwWpdl83hSAHNEsJmjCvt01ldmh8zB3yfwM2
	 Bsd8FzwIdZyNsWUzsorkcb7X/qibl8qJg0dQ5St4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/325] Bluetooth: L2CAP: Fix not checking l2cap_chan security level
Date: Mon,  2 Jun 2025 15:48:34 +0200
Message-ID: <20250602134329.455126969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7af8479d9eb4319b4ba7b47a8c4d2c55af1c31e1 ]

l2cap_check_enc_key_size shall check the security level of the
l2cap_chan rather than the hci_conn since for incoming connection
request that may be different as hci_conn may already been
encrypted using a different security level.

Fixes: 522e9ed157e3 ("Bluetooth: l2cap: Check encryption key size on incoming connection")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 222105e24d2d8..cb9b1edfcea2a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1561,7 +1561,8 @@ static void l2cap_request_info(struct l2cap_conn *conn)
 		       sizeof(req), &req);
 }
 
-static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
+static bool l2cap_check_enc_key_size(struct hci_conn *hcon,
+				     struct l2cap_chan *chan)
 {
 	/* The minimum encryption key size needs to be enforced by the
 	 * host stack before establishing any L2CAP connections. The
@@ -1575,7 +1576,7 @@ static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
 	int min_key_size = hcon->hdev->min_enc_key_size;
 
 	/* On FIPS security level, key size must be 16 bytes */
-	if (hcon->sec_level == BT_SECURITY_FIPS)
+	if (chan->sec_level == BT_SECURITY_FIPS)
 		min_key_size = 16;
 
 	return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
@@ -1603,7 +1604,7 @@ static void l2cap_do_start(struct l2cap_chan *chan)
 	    !__l2cap_no_conn_pending(chan))
 		return;
 
-	if (l2cap_check_enc_key_size(conn->hcon))
+	if (l2cap_check_enc_key_size(conn->hcon, chan))
 		l2cap_start_connection(chan);
 	else
 		__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -1685,7 +1686,7 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
 				continue;
 			}
 
-			if (l2cap_check_enc_key_size(conn->hcon))
+			if (l2cap_check_enc_key_size(conn->hcon, chan))
 				l2cap_start_connection(chan);
 			else
 				l2cap_chan_close(chan, ECONNREFUSED);
@@ -4187,7 +4188,7 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 	/* Check if the ACL is secure enough (if not SDP) */
 	if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
 	    (!hci_conn_check_link_mode(conn->hcon) ||
-	    !l2cap_check_enc_key_size(conn->hcon))) {
+	    !l2cap_check_enc_key_size(conn->hcon, pchan))) {
 		conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
 		result = L2CAP_CR_SEC_BLOCK;
 		goto response;
@@ -8418,7 +8419,7 @@ static void l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 		}
 
 		if (chan->state == BT_CONNECT) {
-			if (!status && l2cap_check_enc_key_size(hcon))
+			if (!status && l2cap_check_enc_key_size(hcon, chan))
 				l2cap_start_connection(chan);
 			else
 				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -8428,7 +8429,7 @@ static void l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 			struct l2cap_conn_rsp rsp;
 			__u16 res, stat;
 
-			if (!status && l2cap_check_enc_key_size(hcon)) {
+			if (!status && l2cap_check_enc_key_size(hcon, chan)) {
 				if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 					res = L2CAP_CR_PEND;
 					stat = L2CAP_CS_AUTHOR_PEND;
-- 
2.39.5



