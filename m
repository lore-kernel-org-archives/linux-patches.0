Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFF721D00A;
	Mon, 23 Mar 2026 13:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274053; cv=none; b=aR1oZJASoQhZijN3wsyj7WN0BGpB3V8JPQLJ9XYMc7Fk0/TaFp5vXvYgd0RnuMpNfV4tbVqQU7DzydgrCObZZfrAD966k1onm02hup3CbCATdJ7awYDZ8ejAam59+Rxm5h2qxgTzL1GOe5Rghd1csTyHgpsDb7YeoBoX5tKhzy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274053; c=relaxed/simple;
	bh=RbeoQd7qZDPbgJLGkLjZ8sHdSA3LCUExbH3Q7e98a0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez7Imlj0FvoE48yOJFKzlDH/i2ctRrESjc5bWOIeUsv22n2pwK+qcH2orTkSddbMITrvA9tkjMv8JgcrRkDKhPNJeztuidM/QCMiQn3cTBIvP14RZJUip813e9TKg6yEWDfeZIqNxEZZGBPpI3TZE9TKCkQixPz6yNFxMrnnwKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9J+HGpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9J+HGpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61294C4CEF7;
	Mon, 23 Mar 2026 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274053;
	bh=RbeoQd7qZDPbgJLGkLjZ8sHdSA3LCUExbH3Q7e98a0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9J+HGpQKVfZk5Zc+r7GlFN8DS9vGAFnpmn5NOPer2A+2yWiVZWoVFA7BgSZsoxMs
	 wcMX9L1O2RmbWk4rQDFgvpYUPfOHNZ95aK/ohrl/e4oK0MeZB9vQ+w/qUQxFMMeU/e
	 z73M2DDMy4v4qbxLX/E0r5vCJSkhrxuuS8xXhzbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.19 094/220] Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ
Date: Mon, 23 Mar 2026 14:44:31 +0100
Message-ID: <20260323134507.568882929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 5b3e2052334f2ff6d5200e952f4aa66994d09899 upstream.

Currently the code attempts to accept requests regardless of the
command identifier which may cause multiple requests to be marked
as pending (FLAG_DEFER_SETUP) which can cause more than
L2CAP_ECRED_MAX_CID(5) to be allocated in l2cap_ecred_rsp_defer
causing an overflow.

The spec is quite clear that the same identifier shall not be used on
subsequent requests:

'Within each signaling channel a different Identifier shall be used
for each successive request or indication.'
https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-62/out/en/host/logical-link-control-and-adaptation-protocol-specification.html#UUID-32a25a06-4aa4-c6c7-77c5-dcfe3682355d

So this attempts to check if there are any channels pending with the
same identifier and rejects if any are found.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5045,7 +5045,7 @@ static inline int l2cap_ecred_conn_req(s
 	u16 mtu, mps;
 	__le16 psm;
 	u8 result, rsp_len = 0;
-	int i, num_scid;
+	int i, num_scid = 0;
 	bool defer = false;
 
 	if (!enable_ecred)
@@ -5057,6 +5057,14 @@ static inline int l2cap_ecred_conn_req(s
 		result = L2CAP_CR_LE_INVALID_PARAMS;
 		goto response;
 	}
+
+	/* Check if there are no pending channels with the same ident */
+	__l2cap_chan_list_id(conn, cmd->ident, l2cap_ecred_list_defer,
+			     &num_scid);
+	if (num_scid) {
+		result = L2CAP_CR_LE_INVALID_PARAMS;
+		goto response;
+	}
 
 	cmd_len -= sizeof(*req);
 	num_scid = cmd_len / sizeof(u16);


