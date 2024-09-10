Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13382199937;
	Tue, 10 Sep 2024 10:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963973; cv=none; b=SnEuGLd3Pwhi/KtOdvMx5UzPHsjnZ2lCIe5AoJ5YVVrefLvgwW0FSw96KGeJcyT/H/3FLOw1PWohgSCuPU5REqTIQyNKkUSdaMUAqiRU8IJvcNSfWMVVe5QnZkCg9vh/XeSRfTtB4lF71JtmjYVDsFXsL6UbJkdlOD+FoOg9x0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963973; c=relaxed/simple;
	bh=HUApwNqcm5rdfzb60a2s2vVdqAQGGzZw9C7KD0fW2YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQtHPJy9zYRJ0Bajp5xL8jnNBwDP67Rg0GBhlEiv2MhTbaYHUlysBe3wESTZVceN1JOYyeU/GTGVAhX6QSgbvc4PPsIf0nMQ4GWscquhNOAg+Xn26Sd9elHWEqjM9tcW4xLVCvGtHmcYeWXDTQloxKvTj6gC/8B6DzMZKTWUhg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmAVoteU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmAVoteU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83825C4CECD;
	Tue, 10 Sep 2024 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963972;
	bh=HUApwNqcm5rdfzb60a2s2vVdqAQGGzZw9C7KD0fW2YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmAVoteUlY29PGOP9deB99qX/6dVQT7c0/PlsD5FKTkzs7OW+g/kynYWsIBSBu/Cm
	 iZXmvXjQ0shhTfpfes9AY7UvkkGqGpPjiflfFQKkkkfpY/X6XiSuFi9J+G7hST89xa
	 Zg/hbrykI7FkpKZ2CwekNDbOulMMNWCV5wtmjubc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 024/269] Bluetooth: MGMT: Ignore keys being loaded with invalid type
Date: Tue, 10 Sep 2024 11:30:11 +0200
Message-ID: <20240910092609.113304927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2824,15 +2824,6 @@ static int load_link_keys(struct sock *s
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
@@ -2857,6 +2848,19 @@ static int load_link_keys(struct sock *s
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
@@ -7139,15 +7143,6 @@ static int load_long_term_keys(struct so
 
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
@@ -7163,6 +7158,12 @@ static int load_long_term_keys(struct so
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


