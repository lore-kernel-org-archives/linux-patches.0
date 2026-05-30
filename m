Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173583148DA;
	Sat, 30 May 2026 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160970; cv=none; b=GNodBc+V6moA3PKkLye6svUg+X4MTpkBrORLc8Ofo3BrrJRx20nqOA8WJG3qZcZ2y82MF88bquOcOYwvXpa+P4hW6uoxr+N7qYzn3lUVXB6OWMWJZIEbwwzMXjAgagqh5/i9IzjZRAYiQN8nHTR6sAu8TMWE7+dWFFVn8G3KSHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160970; c=relaxed/simple;
	bh=mo/zsIrGd+3008a3NgqBFPVLZQnvUWgPI8qQktVYIyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyRpkl3OHlohKVPRuBBppB/L6BZHTKSDVxKTQc/VA5eyJx5bjDktlY7o86p8Qo1lE1njsP+/1JH7dZxAfyBByzUEdHXNKmpxAE454YEjaIRTQEUbx52//ZyTMcTJ+ljN5Lh/sF5Tjvw/3QYHDRdMCkHWTQa9a8FRA+6ZV5xgWGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZI5fI6GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI5fI6GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CFC1F00893;
	Sat, 30 May 2026 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160968;
	bh=6n6iMU+QJ6EVaYbJ+dWH33GcOEk8r3s5oFTmmePDLV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI5fI6GP/0aBPYWJ4A6LDmblYa4GS5ARQIHcR/LfDU0Zn8obrZ9OE9klx6J0QEOHB
	 XhlvFE6ZUeEsgUWs7zu8R3I0ZUdPoA+EedPegyyzx2qRHWla24iBRPYrhYhh2t2Vhb
	 qgJsu+FQWeoRIvECo8RBOpPHCBRx6y27TgYFXPq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 487/969] Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER
Date: Sat, 30 May 2026 18:00:11 +0200
Message-ID: <20260530160313.755903442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 5c7209a341ff2ac338b2b0375c34a307b37c9ac2 ]

When protocol sets HCI_PROTO_DEFER, hci_conn_request_evt() calls
hci_connect_cfm(conn) without hdev->lock. Generally hci_connect_cfm()
assumes it is held, and if conn is deleted concurrently -> UAF.

Only SCO and ISO set HCI_PROTO_DEFER and only for defer setup listen,
and HCI_EV_CONN_REQUEST is not generated for ISO.  In the non-deferred
listening socket code paths, hci_connect_cfm(conn) is called with
hdev->lock held.

Fix by holding the lock.

Fixes: 70c464256310 ("Bluetooth: Refactor connection request handling")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 31606454c7c81..d572ce3061cf9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3365,8 +3365,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 
 	memcpy(conn->dev_class, ev->dev_class, 3);
 
-	hci_dev_unlock(hdev);
-
 	if (ev->link_type == ACL_LINK ||
 	    (!(flags & HCI_PROTO_DEFER) && !lmp_esco_capable(hdev))) {
 		struct hci_cp_accept_conn_req cp;
@@ -3400,7 +3398,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 		hci_connect_cfm(conn, 0);
 	}
 
-	return;
 unlock:
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



