Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C01017AE00;
	Tue, 10 Sep 2024 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963488; cv=none; b=kCtI7J26NMnRelg2y326I6ugyVK2fCJMQAswhVvdSoAYQapybJt+XqmLczVpUp5iCr+HZRWVw7lzrEdWQerDOLsQyAelSpWQlLiYCRh7mKM7MsGkffVpfASKRC9/ekeA+ac6+5r28dLTwCX788uD/aqL2HjsuPQSSONeQN25Anw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963488; c=relaxed/simple;
	bh=QGgNlrNWipxnKIB6Jpn5h3GeNrP9FTtIFnKbeVphC+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI8VxMWZtkvI8vj17wEXXhTIw8FAVOIamf+Ep9eZ7Fcem1tmVdOVTFLEmttrk6T5dYwrk5geUeh97KfXEwEt1PS3NHXwfBnvHvcESFJDt0zxRfwAGtqth1MTGgmcBAW6hJhJmcqazldejOZz16nast+BmquYP8TbqhsmDhlOp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+XjezjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+XjezjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6C8C4CED3;
	Tue, 10 Sep 2024 10:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963488;
	bh=QGgNlrNWipxnKIB6Jpn5h3GeNrP9FTtIFnKbeVphC+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+XjezjIv53YiglZ3WTJ2ZUEwNayXq/JMbTgFYLTx1mufkVPn5sI9K7R59783LCCX
	 gpj/xLu4pM3HcFIdGOOFA2FDBZ9KaT4c7gcAPffpFYRKc8xvyd4aAkuRXYDu0EH3P2
	 HhfbcONXB/Znn4iRNRb/PP9XE03HR4SuCJU+OcMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 074/214] Bluetooth: MGMT: Ignore keys being loaded with invalid type
Date: Tue, 10 Sep 2024 11:31:36 +0200
Message-ID: <20240910092601.769203623@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2375,15 +2375,6 @@ static int load_link_keys(struct sock *s
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
@@ -2408,6 +2399,19 @@ static int load_link_keys(struct sock *s
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
@@ -6259,15 +6263,6 @@ static int load_long_term_keys(struct so
 
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
@@ -6283,6 +6278,12 @@ static int load_long_term_keys(struct so
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


