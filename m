Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EDB35A3AD;
	Mon,  4 May 2026 14:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904188; cv=none; b=DqeNsvJOefIxH5AefLVn5UTvDV9/RF5bnZ2T2fUGHOSzuHima5WW4zfuyLZYHv9QYxrM5hzjCUYOZpR7I0Poiufe/DrL1K0vnBqABm83bvUs117OY4uKKA+AYzDfLlE+aTtFWERA2ig/X+KH2I0kRK4k9L/91jGhXCTJaGaf6yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904188; c=relaxed/simple;
	bh=W7kuUgZMpAhax/pVJde5KgFab6yGwdfgWGYcwOjeVH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/o/caonCu5B+mKiKYNpKYPzptWHfUUy4YKCKtvg+c6BXU5jB3lWx2NKTUcnskGQmhHnRfsmy1kTHTt6IZ5VsdRb2hPAma9fONTUM86LluooAU5s1DctkizYwde8lfugZ4f8sLT4lxV8d5j8nv0oeRM7I2eLQ5ylEd+8gUE6zbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8VrakDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8VrakDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831B2C2BCB8;
	Mon,  4 May 2026 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904187;
	bh=W7kuUgZMpAhax/pVJde5KgFab6yGwdfgWGYcwOjeVH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8VrakDxuuoQ+gM+dlEXvmkLoFGXrnxGSrsTNpHxlvXSqiBhTgL0LAdidZeX98/w8
	 To7OkLfgP81UGWTP3IEn8noh60je6vPOIQyFKVOozPtaTTjeX2HvyqNgwhTriuSrmp
	 f2KHRx7Zb01mGaASOa7jlE+eXIA5+7quOBGal7Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 217/275] Bluetooth: hci_event: fix potential UAF in SSP passkey handlers
Date: Mon,  4 May 2026 15:52:37 +0200
Message-ID: <20260504135151.131902774@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit 85fa3512048793076eef658f66489112dcc91993 upstream.

hci_conn lookup and field access must be covered by hdev lock in
hci_user_passkey_notify_evt() and hci_keypress_notify_evt(), otherwise
the connection can be freed concurrently.

Extend the hci_dev_lock critical section to cover all conn usage in both
handlers.

Keep the existing keypress notification behavior unchanged by routing
the early exits through a common unlock path.

Fixes: 92a25256f142 ("Bluetooth: mgmt: Implement support for passkey notification")
Cc: stable@vger.kernel.org
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5422,9 +5422,11 @@ static void hci_user_passkey_notify_evt(
 
 	bt_dev_dbg(hdev, "");
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	conn->passkey_notify = __le32_to_cpu(ev->passkey);
 	conn->passkey_entered = 0;
@@ -5433,6 +5435,9 @@ static void hci_user_passkey_notify_evt(
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_keypress_notify_evt(struct hci_dev *hdev, void *data,
@@ -5443,14 +5448,16 @@ static void hci_keypress_notify_evt(stru
 
 	bt_dev_dbg(hdev, "");
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
-		return;
+		goto unlock;
 
 	switch (ev->type) {
 	case HCI_KEYPRESS_STARTED:
 		conn->passkey_entered = 0;
-		return;
+		goto unlock;
 
 	case HCI_KEYPRESS_ENTERED:
 		conn->passkey_entered++;
@@ -5465,13 +5472,16 @@ static void hci_keypress_notify_evt(stru
 		break;
 
 	case HCI_KEYPRESS_COMPLETED:
-		return;
+		goto unlock;
 	}
 
 	if (hci_dev_test_flag(hdev, HCI_MGMT))
 		mgmt_user_passkey_notify(hdev, &conn->dst, conn->type,
 					 conn->dst_type, conn->passkey_notify,
 					 conn->passkey_entered);
+
+unlock:
+	hci_dev_unlock(hdev);
 }
 
 static void hci_simple_pair_complete_evt(struct hci_dev *hdev, void *data,


