Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE05332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301243; cv=none; b=lHP6rPht0ZAXsYD0H35orptSDfx22XCEdXp65sg7jWf++HsmZjcD3n6dZEsE7w6rPrgNZrgwjBosruUN/NceMaY9rQIfK8E+NgRELLoWQevVX/1my4NEr93npUnZfCU9lBH2F58vsNLyRqLcWrC4ZP+hHZ3siVZd7Ucyyw9xMwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301243; c=relaxed/simple;
	bh=dJMssyz69qshYFj1P0Z+P9H6EwkDVsF3N1ezNEZ4jGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diTrPMyqDlTihqI1aukUu1hM0Kz+eLTcMmtXV88sCgtKn62XiBjOA41CwnlCW3Koe3xUSpXio2N+F2TvXVqFPbogOTELC+CMY8qmA6DTlMq+WB5rhTEbtGjcyCjtLfDhKMElE6B3gJceSO1QPxBxRyt+Noe3VXRX4HDSycFMTlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wgb8C5BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wgb8C5BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F02C116D0;
	Sat, 28 Feb 2026 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301243;
	bh=dJMssyz69qshYFj1P0Z+P9H6EwkDVsF3N1ezNEZ4jGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wgb8C5BTzdZyxmzkB8s37imCGSFRUwxNDFonZOxvyO9aAIwoXNxaMz0PxYv+/eBhZ
	 3gHtAU254Z1R89pZEbXdfu0Xm5WGdDt9Wubhxh44JeG3EdCMkBkF4LSgQ3EPNmbn1V
	 zp+t4xdzQcetgFvWN/WG2EmlMVY0QNwUkXn2Tx8oYl/RYgUVIzrr2MxCnYSWHfP+C9
	 cLnEs3YpZ1CiPFDx0qZNW4+/g3Tm29t/A/K33coooesqwTT1QSSEGfPRueGURs0a4i
	 TK4er6nBCDm7CZxBYehREqywbFleht3xZ6G4lptoTyQGWpo3NeP7/xXAF8lbK8mCOA
	 w/DfnYImmIwmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Christian Eggers <ceggers@arri.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 424/752] Bluetooth: L2CAP: Fix missing key size check for L2CAP_LE_CONN_REQ
Date: Sat, 28 Feb 2026 12:42:15 -0500
Message-ID: <20260228174750.1542406-424-sashal@kernel.org>
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

[ Upstream commit 138d7eca445ef37a0333425d269ee59900ca1104 ]

This adds a check for encryption key size upon receiving
L2CAP_LE_CONN_REQ which is required by L2CAP/LE/CFC/BV-15-C which
expects L2CAP_CR_LE_BAD_KEY_SIZE.

Link: https://lore.kernel.org/linux-bluetooth/5782243.rdbgypaU67@n9w6sw14/
Fixes: 27e2d4c8d28b ("Bluetooth: Add basic LE L2CAP connect request receiving support")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 29af3f63e89ce..72a4bb1fee46a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4900,6 +4900,13 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 		goto response_unlock;
 	}
 
+	/* Check if Key Size is sufficient for the security level */
+	if (!l2cap_check_enc_key_size(conn->hcon, pchan)) {
+		result = L2CAP_CR_LE_BAD_KEY_SIZE;
+		chan = NULL;
+		goto response_unlock;
+	}
+
 	/* Check for valid dynamic CID range */
 	if (scid < L2CAP_CID_DYN_START || scid > L2CAP_CID_LE_DYN_END) {
 		result = L2CAP_CR_LE_INVALID_SCID;
-- 
2.51.0

