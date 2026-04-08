Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3763D9031;
	Wed,  8 Apr 2026 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674446; cv=none; b=UovnkLxDIbdFGA6mcewITuJmZUSu/0oCnqo6egImddadlF0bKgQwKkxaZQD+QGAfmmkWgbKOFZEZ0hu29ytL7jq8oghMpSmosnTNu2ogLNqeG+GgnDqTNaEyQH54qIvn/TogUGgPWZ8gH/UVkvuypMdxvVrtoLHcXyeyumg3cok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674446; c=relaxed/simple;
	bh=jbQ2HV2pFxN3ZpkvaNafW4F1fRTJkb+Smx15QccuPQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1B/FYdSlRiDsr0gMi5wOn9edSVVqeMBgPuyTSmNgOdlceNDI0iBV90L8h5eGy95nsEoWEVZgHH4iiW3dZE4AJJyOMnJn4vL0OvWg/HQ1tWvnYUg0lgkhlnqwegcAXJ9rNXyqHn4f/jxwZ+CxVW5IGAHhnq9MJGbGou5FZeLwhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQ9Ytxkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQ9Ytxkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A4DC19421;
	Wed,  8 Apr 2026 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674446;
	bh=jbQ2HV2pFxN3ZpkvaNafW4F1fRTJkb+Smx15QccuPQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQ9YtxkfMZbVVhTdgnNCAztDZt/3tYVaxsNKOSDma79GCow9tia8NFLRJFpxAc5Y7
	 /UllwRO0pMx/sCDfVtd0L0huui0iN7OMHUWhgUyIRO4fi0r0i2UtCKmG1HPxABUeR6
	 2HLjDU+85exRH14NufkD6YV4u0NNziHl/575RM8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 099/311] Bluetooth: hci_sync: fix leaks when hci_cmd_sync_queue_once fails
Date: Wed,  8 Apr 2026 20:01:39 +0200
Message-ID: <20260408175943.111972875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit aca377208e7f7322bf4e107cdec6e7d7e8aa7a88 ]

When hci_cmd_sync_queue_once() returns with error, the destroy callback
will not be called.

Fix leaking references / memory on these failures.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 035c25007c9e ("Bluetooth: hci_sync: Fix UAF in le_read_features_complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b501f89caf619..7dfd630d38f05 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7429,13 +7429,16 @@ int hci_le_read_remote_features(struct hci_conn *conn)
 	 * role is possible. Otherwise just transition into the
 	 * connected state without requesting the remote features.
 	 */
-	if (conn->out || (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES))
+	if (conn->out || (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES)) {
 		err = hci_cmd_sync_queue_once(hdev,
 					      hci_le_read_remote_features_sync,
 					      hci_conn_hold(conn),
 					      le_read_features_complete);
-	else
+		if (err)
+			hci_conn_drop(conn);
+	} else {
 		err = -EOPNOTSUPP;
+	}
 
 	return (err == -EEXIST) ? 0 : err;
 }
@@ -7474,6 +7477,9 @@ int hci_acl_change_pkt_type(struct hci_conn *conn, u16 pkt_type)
 
 	err = hci_cmd_sync_queue_once(hdev, hci_change_conn_ptype_sync, cp,
 				      pkt_type_changed);
+	if (err)
+		kfree(cp);
+
 	return (err == -EEXIST) ? 0 : err;
 }
 
@@ -7513,5 +7519,8 @@ int hci_le_set_phy(struct hci_conn *conn, u8 tx_phys, u8 rx_phys)
 
 	err = hci_cmd_sync_queue_once(hdev, hci_le_set_phy_sync, cp,
 				      le_phy_update_complete);
+	if (err)
+		kfree(cp);
+
 	return (err == -EEXIST) ? 0 : err;
 }
-- 
2.53.0



