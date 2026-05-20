Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DB1372B31;
	Wed, 20 May 2026 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294994; cv=none; b=Ukl7Bef0OE9Yk3gt3SN8zBbb0orDRX7MYCFdG0xOXTtR/AXBhgrhn1amQHNzuvEinrbcw6HhdOYr2O5CbTSXD9Y1Njkm4P3KDu9FBqVxDeMZlpj3ycxVoXP/be46HVKVG9Q48pxckWy79VUKfhErXxStcvpkWWn3xkgl1yd3P7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294994; c=relaxed/simple;
	bh=FT7ElktXJxxof888J3I5DkiAr3dEczTdvsZYY5OlwbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKKC5OP64Vihy3kJXyqlFWneC0fekb16naXQCRHp6DXbRrI0OvfVXWnXwVGj+Dd2LpIyZdmPZINyhZgnQlOpId0c+oV8mmwRQO+V61jJ0H6NQvmW55MN2AA0jH5HAUFqRG9oUOXxBKHxGEoK4DIX+jcxzvy0cCpteWLwOT8Peq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Z4/PWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Z4/PWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFBE1F000E9;
	Wed, 20 May 2026 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294992;
	bh=vYg5DlNGVif+//7cVl3umeuwW2scNhC0f/6ZMTHw/iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6Z4/PWaKvSIMlZMMLYuxJjAMZFp1yoasrZ5ImiM30RhiOLZovGgsEP5fDTaX4fox
	 3WkbQIe2ptjUzPuDRFpf8hKUeH0z4sMhnk01aefTtgTlPfhDjwk5e4w0Qd9ksePHt1
	 Ol0kIZqLHE7Ybwfd1ZkQ0+hCLBcOq8hIiQY8oK/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0213/1146] Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER
Date: Wed, 20 May 2026 18:07:43 +0200
Message-ID: <20260520162153.083069475@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 0df1c0cbc8f78..1b3b9131affaa 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3340,8 +3340,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 
 	memcpy(conn->dev_class, ev->dev_class, 3);
 
-	hci_dev_unlock(hdev);
-
 	if (ev->link_type == ACL_LINK ||
 	    (!(flags & HCI_PROTO_DEFER) && !lmp_esco_capable(hdev))) {
 		struct hci_cp_accept_conn_req cp;
@@ -3375,7 +3373,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 		hci_connect_cfm(conn, 0);
 	}
 
-	return;
 unlock:
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



