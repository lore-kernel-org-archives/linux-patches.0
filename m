Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F2E18DF88;
	Tue, 10 Sep 2024 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964931; cv=none; b=L31Rb8iVJ6Py3okSZaFQxpwP47tehUD40No/Fx9Qc3rpidLgsmAe2J785/Oh9LxkSVZb+1K6xvmVOej6nWNErz3vYwGExFEAARiaKmq2ImTxhabjH8ku8TeUbrMAzjXV14iQ5QeY5ii56lyUhpPxFk7661NaT8o5IcjMAb8wKKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964931; c=relaxed/simple;
	bh=nTYM8YURJI2XOWnCxPwe1LBc2PxGaTNTgCI55pj4BtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4I5ipfwlGZ0CTdQbRs02vmUFuftLB+/phm88yMIVR2JlVebEasIirZA2nFpaI0HFnXbam2buK7lKjzGSqb3h/SjDOUSjOZCZa9k1R4fFPEkkXd9oD+4HDgnrUxZ34mfgcdaN7/mDUSAjO73WYhM0Yms3zQa72cCUpPOpE0RsHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIrbh4ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIrbh4ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858D3C4CEC3;
	Tue, 10 Sep 2024 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964930;
	bh=nTYM8YURJI2XOWnCxPwe1LBc2PxGaTNTgCI55pj4BtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIrbh4kyGTnZTsJjBnzwhcdxca8W71qb/z3vNV/LmZ7tM/RNEyXDg3Oq584wtH29L
	 Pu2yFp0mjNzVILY/00DZAXNttb8kiLxfcLP64fF38Tcm3ed0r8pD/N3xkmOhnBEutg
	 aqtOYXCzACZ3tzj+TkTGetqw/f3VcF2Ks8a7YqVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 062/186] Bluetooth: MGMT: Ignore keys being loaded with invalid type
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092557.041241009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 1e9683c9b6ca88cc9340cdca85edd6134c8cffe3 upstream.

Due to 59b047bc98084f8af2c41483e4d68a5adf2fa7f7 there could be keys stored
with the wrong address type so this attempt to detect it and ignore them
instead of just failing to load all keys.

Cc: stable@vger.kernel.org
Link: https://github.com/bluez/bluez/issues/875
Fixes: 59b047bc9808 ("Bluetooth: MGMT/SMP: Fix address type when using SMP over BREDR/LE")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2370,15 +2370,6 @@ static int load_link_keys(struct sock *s
 	bt_dev_dbg(hdev, "debug_keys %u key_count %u", cp->debug_keys,
 		   key_count);
 
-	for (i = 0; i < key_count; i++) {
-		struct mgmt_link_key_info *key = &cp->keys[i];
-
-		if (key->addr.type != BDADDR_BREDR || key->type > 0x08)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_LOAD_LINK_KEYS,
-					       MGMT_STATUS_INVALID_PARAMS);
-	}
-
 	hci_dev_lock(hdev);
 
 	hci_link_keys_clear(hdev);
@@ -2403,6 +2394,19 @@ static int load_link_keys(struct sock *s
 			continue;
 		}
 
+		if (key->addr.type != BDADDR_BREDR) {
+			bt_dev_warn(hdev,
+				    "Invalid link address type %u for %pMR",
+				    key->addr.type, &key->addr.bdaddr);
+			continue;
+		}
+
+		if (key->type > 0x08) {
+			bt_dev_warn(hdev, "Invalid link key type %u for %pMR",
+				    key->type, &key->addr.bdaddr);
+			continue;
+		}
+
 		/* Always ignore debug keys and require a new pairing if
 		 * the user wants to use them.
 		 */
@@ -5993,15 +5997,6 @@ static int load_long_term_keys(struct so
 
 	bt_dev_dbg(hdev, "key_count %u", key_count);
 
-	for (i = 0; i < key_count; i++) {
-		struct mgmt_ltk_info *key = &cp->keys[i];
-
-		if (!ltk_is_valid(key))
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_LOAD_LONG_TERM_KEYS,
-					       MGMT_STATUS_INVALID_PARAMS);
-	}
-
 	hci_dev_lock(hdev);
 
 	hci_smp_ltks_clear(hdev);
@@ -6017,6 +6012,12 @@ static int load_long_term_keys(struct so
 				    &key->addr.bdaddr);
 			continue;
 		}
+
+		if (!ltk_is_valid(key)) {
+			bt_dev_warn(hdev, "Invalid LTK for %pMR",
+				    &key->addr.bdaddr);
+			continue;
+		}
 
 		switch (key->type) {
 		case MGMT_LTK_UNAUTHENTICATED:


