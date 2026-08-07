Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6346C839;
	Fri,  7 Aug 2026 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114978; cv=none; b=bjnkvNFbIHo7jaJby9pubN9Pcn2hcU4t+2ZJfsGJQ4I7xKoMHVlCSx9DI4uSJvSBr8/75e68O3Bu2JaeefS3+EUaHvSG6T3VqLK8DfyAFIs+pVgw3c9aaQlqRGzsKRI7P56WgmMt4ZlsswI5tOMXmGkNa5JSE2I2zGMhPNBuhQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114978; c=relaxed/simple;
	bh=1AYnMTkJmJBhljrSTr4mMS2VGfKG4VGxaALgNIcana8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzhnS9yJB53cusGOs1W1m8G/R2lbbWKqvXHaDjXSz0qXcE5B3JBMBq5m692+n//NJ3EjSzor+nFdpv3KJ0prQxirHvGjhlW6KTfHRd8zIl9EruaMgj5R8FBbA2Lqf8Mc2TY7SkFwWBUL9vrhysNVNH/T7Usp4h1AiwWSU+Elwq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+vdcd8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+vdcd8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5871D1F000E9;
	Fri,  7 Aug 2026 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114976;
	bh=HdHUvVrVFmtU77NF9FtygJAyhBV548BPBve/tIm+1Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+vdcd8Cr0Ndi0JrbO/89UWHjoEN4AwJXjnGOD6Zi61+Hwo7vVqs3kRwHoww2auCa
	 hhppUJlG+UfG/5pSEPOG0sNJd22RcyY50un783idz2rFAuHvDASm2RcJQtOlgc2FQ0
	 dZ5ishDVSus5jVZNOFyMJ3+SeCMu48MGV9+pqVTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/396] Bluetooth: ISO: Fix not updating BIS sender source address
Date: Fri,  7 Aug 2026 16:34:34 +0200
Message-ID: <20260807143426.755548367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 577cf4c0a1e8471a0d6c0f36bb3716285e27ad5e ]

The source address for a BIS sender/Broadcast Source shall be updated
with the advertisement address since in case privacy is enabled it may
use an RPA rather than an identity address.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 0d255e63fcf3 ("Bluetooth: ISO: hold sk properly in iso_conn_ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 98fa94644b4a6..0d2d9c07bf66b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2001,6 +2001,25 @@ static void iso_conn_ready(struct iso_conn *conn)
 	BT_DBG("conn %p", conn);
 
 	if (sk) {
+		/* Attempt to update source address in case of BIS Sender if
+		 * the advertisement is using a random address.
+		 */
+		if (conn->hcon->type == BIS_LINK &&
+		    conn->hcon->role == HCI_ROLE_MASTER &&
+		    !bacmp(&conn->hcon->dst, BDADDR_ANY)) {
+			struct hci_conn *bis = conn->hcon;
+			struct adv_info *adv;
+
+			adv = hci_find_adv_instance(bis->hdev,
+						    bis->iso_qos.bcast.bis);
+			if (adv && bacmp(&adv->random_addr, BDADDR_ANY)) {
+				lock_sock(sk);
+				iso_pi(sk)->src_type = BDADDR_LE_RANDOM;
+				bacpy(&iso_pi(sk)->src, &adv->random_addr);
+				release_sock(sk);
+			}
+		}
+
 		iso_sock_ready(conn->sk);
 	} else {
 		hcon = conn->hcon;
-- 
2.53.0



