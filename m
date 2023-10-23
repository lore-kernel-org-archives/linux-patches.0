Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B471515492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QttXQHDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23A4C433C7;
	Mon, 23 Oct 2023 11:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060270;
	bh=EQbvuCRc5NdvCuDfcbJYqriwxtqNwrcc+GkHcBcX9sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QttXQHDolbUjzWm0y+rid5iksYj6g9LAv5SAFZul2bGy4vgX7llxMHK57nXdiS9cm
	 zp9c3hSgbi9QAW2xuC+4g9qxuWQtnk4Ku9bpzZVJVuStXvX0FyD+eT9905VxfR/0JJ
	 MSQgD51AjD2EMJmoL5jcC5XE5yKieB40ejLxCPPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/196] Bluetooth: Avoid redundant authentication
Date: Mon, 23 Oct 2023 12:56:13 +0200
Message-ID: <20231023104831.581865904@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit 1d8e801422d66e4b8c7b187c52196bef94eed887 ]

While executing the Android 13 CTS Verifier Secure Server test on a
ChromeOS device, it was observed that the Bluetooth host initiates
authentication for an RFCOMM connection after SSP completes.
When this happens, some Intel Bluetooth controllers, like AC9560, would
disconnect with "Connection Rejected due to Security Reasons (0x0e)".

Historically, BlueZ did not mandate this authentication while an
authenticated combination key was already in use for the connection.
This behavior was changed since commit 7b5a9241b780
("Bluetooth: Introduce requirements for security level 4").
So, this patch addresses the aforementioned disconnection issue by
restoring the previous behavior.

Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 63 ++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f8ba3f5aa877b..728be9307f526 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2364,34 +2364,41 @@ int hci_conn_security(struct hci_conn *conn, __u8 sec_level, __u8 auth_type,
 	if (!test_bit(HCI_CONN_AUTH, &conn->flags))
 		goto auth;
 
-	/* An authenticated FIPS approved combination key has sufficient
-	 * security for security level 4. */
-	if (conn->key_type == HCI_LK_AUTH_COMBINATION_P256 &&
-	    sec_level == BT_SECURITY_FIPS)
-		goto encrypt;
-
-	/* An authenticated combination key has sufficient security for
-	   security level 3. */
-	if ((conn->key_type == HCI_LK_AUTH_COMBINATION_P192 ||
-	     conn->key_type == HCI_LK_AUTH_COMBINATION_P256) &&
-	    sec_level == BT_SECURITY_HIGH)
-		goto encrypt;
-
-	/* An unauthenticated combination key has sufficient security for
-	   security level 1 and 2. */
-	if ((conn->key_type == HCI_LK_UNAUTH_COMBINATION_P192 ||
-	     conn->key_type == HCI_LK_UNAUTH_COMBINATION_P256) &&
-	    (sec_level == BT_SECURITY_MEDIUM || sec_level == BT_SECURITY_LOW))
-		goto encrypt;
-
-	/* A combination key has always sufficient security for the security
-	   levels 1 or 2. High security level requires the combination key
-	   is generated using maximum PIN code length (16).
-	   For pre 2.1 units. */
-	if (conn->key_type == HCI_LK_COMBINATION &&
-	    (sec_level == BT_SECURITY_MEDIUM || sec_level == BT_SECURITY_LOW ||
-	     conn->pin_length == 16))
-		goto encrypt;
+	switch (conn->key_type) {
+	case HCI_LK_AUTH_COMBINATION_P256:
+		/* An authenticated FIPS approved combination key has
+		 * sufficient security for security level 4 or lower.
+		 */
+		if (sec_level <= BT_SECURITY_FIPS)
+			goto encrypt;
+		break;
+	case HCI_LK_AUTH_COMBINATION_P192:
+		/* An authenticated combination key has sufficient security for
+		 * security level 3 or lower.
+		 */
+		if (sec_level <= BT_SECURITY_HIGH)
+			goto encrypt;
+		break;
+	case HCI_LK_UNAUTH_COMBINATION_P192:
+	case HCI_LK_UNAUTH_COMBINATION_P256:
+		/* An unauthenticated combination key has sufficient security
+		 * for security level 2 or lower.
+		 */
+		if (sec_level <= BT_SECURITY_MEDIUM)
+			goto encrypt;
+		break;
+	case HCI_LK_COMBINATION:
+		/* A combination key has always sufficient security for the
+		 * security levels 2 or lower. High security level requires the
+		 * combination key is generated using maximum PIN code length
+		 * (16). For pre 2.1 units.
+		 */
+		if (sec_level <= BT_SECURITY_MEDIUM || conn->pin_length == 16)
+			goto encrypt;
+		break;
+	default:
+		break;
+	}
 
 auth:
 	if (test_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags))
-- 
2.40.1



