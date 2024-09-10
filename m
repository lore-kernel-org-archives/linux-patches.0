Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51930188CC1;
	Tue, 10 Sep 2024 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962834; cv=none; b=k7akcjITqfiH/mnKKa8KHq1JP6ciJvCiYu3+zLsZM4G8i4q1sbPouIzha0JzySKz6zViDBlYHspYBNbhm2jujoUhdQYulPyrUqLGKnPIN3ERi2K1anf2bYncBJjqpvRlWEbWL2NolhZsQNMHWQldKTktYws5FUhMn3mr+HiReKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962834; c=relaxed/simple;
	bh=lUevj12nnijXrav4rLmfkhpQgzrXipKcLscSaoFdPT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiRYfG9MLFbO1aB8EYT99FyiErOz11e0IagZmMWSjxIpM97onFlsIGX4Foy4VLU/Ks+ffLtkgDVje6tqX/AkqvhL6QSIpnY8iosRQi5p6R038L/z72ucoVpwbRxjOuVwxICquFUOxLJ1FBSef5EPTvh/zQtfCHHKkOjxwmywq5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UFicsVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UFicsVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD10C4CEC3;
	Tue, 10 Sep 2024 10:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962834;
	bh=lUevj12nnijXrav4rLmfkhpQgzrXipKcLscSaoFdPT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1UFicsVKupE1x/dilv6fGkavHmiiZwnSKL/4jWuIcdHLzvh/9UitvBQMoIhY2aJjm
	 dFQGLUZfWHXd8X26d4ZI5ityDaBGNdVPV3C8P3Hkbfo+dhjk9xDbQEfrW6AwEuJNKE
	 lXssFHSjyYLoqNDKh2ZNY4EeqyiFDUZtZ0CEhWio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 019/192] Bluetooth: MGMT: Ignore keys being loaded with invalid type
Date: Tue, 10 Sep 2024 11:30:43 +0200
Message-ID: <20240910092558.734911581@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
@@ -2900,15 +2900,6 @@ static int load_link_keys(struct sock *s
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
@@ -2933,6 +2924,19 @@ static int load_link_keys(struct sock *s
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
@@ -7215,15 +7219,6 @@ static int load_long_term_keys(struct so
 
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
@@ -7239,6 +7234,12 @@ static int load_long_term_keys(struct so
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


