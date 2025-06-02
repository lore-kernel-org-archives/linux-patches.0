Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5EE22A807;
	Mon,  2 Jun 2025 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876395; cv=none; b=T/sZDDJwLiyZ6YF8G0xHN5jqnzuGworN2MYFZ3wUhnjKrNz9Q8lvRo+EZrhRbT91a2ZObJBgWoohrGi8gs1XNFMs6LBCuIGRPN+nJ1vC12zZwHyEA8dlfkxmTDN5xti5AxGLdIApwFy24yUH5t2wFSkYszjX/Uejf+OdSOLm5aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876395; c=relaxed/simple;
	bh=Zt4hum/i1e+Bjx5cvSQN4z/l88w7usSO6JBeENZfT88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlVYZ62bs6X1vW893eMn6Lhsieteb2Euz+rEFMPF30jG3tGi+9M5fMoTme8hHnSf4sXPm9trxYYIpO48oHsY/CW1O9w+oTlL2dLy8GoFzTQYsz3iC6b+xfYYRghiZ6osZRLpK+gAqfXz0O2pybcjnQyXbz6Z02zi0CqMdCLJVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt919peU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt919peU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AA3C4CEEE;
	Mon,  2 Jun 2025 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876394;
	bh=Zt4hum/i1e+Bjx5cvSQN4z/l88w7usSO6JBeENZfT88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt919peUsiitzmWfn9pPE5+i6GHOhFFDImXSQeqSTJmmRR14hy/GRtpSVlxnVyuXa
	 S3T34cVDZRQbDIaH9eZPBbq4Eorba5wR/SV8YIWeJi8hhBWdnmy34+KB6H2MV+orVz
	 /YpktMXCM+q9CtBwR++DE79OMuEg33FJAijkq8FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/207] Bluetooth: L2CAP: Fix not checking l2cap_chan security level
Date: Mon,  2 Jun 2025 15:48:56 +0200
Message-ID: <20250602134305.161396516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d34e161a30b37..872a0249f53c8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1537,7 +1537,8 @@ static void l2cap_request_info(struct l2cap_conn *conn)
 		       sizeof(req), &req);
 }
 
-static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
+static bool l2cap_check_enc_key_size(struct hci_conn *hcon,
+				     struct l2cap_chan *chan)
 {
 	/* The minimum encryption key size needs to be enforced by the
 	 * host stack before establishing any L2CAP connections. The
@@ -1551,7 +1552,7 @@ static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
 	int min_key_size = hcon->hdev->min_enc_key_size;
 
 	/* On FIPS security level, key size must be 16 bytes */
-	if (hcon->sec_level == BT_SECURITY_FIPS)
+	if (chan->sec_level == BT_SECURITY_FIPS)
 		min_key_size = 16;
 
 	return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
@@ -1579,7 +1580,7 @@ static void l2cap_do_start(struct l2cap_chan *chan)
 	    !__l2cap_no_conn_pending(chan))
 		return;
 
-	if (l2cap_check_enc_key_size(conn->hcon))
+	if (l2cap_check_enc_key_size(conn->hcon, chan))
 		l2cap_start_connection(chan);
 	else
 		__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -1661,7 +1662,7 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
 				continue;
 			}
 
-			if (l2cap_check_enc_key_size(conn->hcon))
+			if (l2cap_check_enc_key_size(conn->hcon, chan))
 				l2cap_start_connection(chan);
 			else
 				l2cap_chan_close(chan, ECONNREFUSED);
@@ -4163,7 +4164,7 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 	/* Check if the ACL is secure enough (if not SDP) */
 	if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
 	    (!hci_conn_check_link_mode(conn->hcon) ||
-	    !l2cap_check_enc_key_size(conn->hcon))) {
+	    !l2cap_check_enc_key_size(conn->hcon, pchan))) {
 		conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
 		result = L2CAP_CR_SEC_BLOCK;
 		goto response;
@@ -8373,7 +8374,7 @@ static void l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 		}
 
 		if (chan->state == BT_CONNECT) {
-			if (!status && l2cap_check_enc_key_size(hcon))
+			if (!status && l2cap_check_enc_key_size(hcon, chan))
 				l2cap_start_connection(chan);
 			else
 				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -8383,7 +8384,7 @@ static void l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 			struct l2cap_conn_rsp rsp;
 			__u16 res, stat;
 
-			if (!status && l2cap_check_enc_key_size(hcon)) {
+			if (!status && l2cap_check_enc_key_size(hcon, chan)) {
 				if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 					res = L2CAP_CR_PEND;
 					stat = L2CAP_CS_AUTHOR_PEND;
-- 
2.39.5



