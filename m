Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312483F4DC0;
	Wed, 20 May 2026 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300265; cv=none; b=gInpjSLxuAP1/+JGfjbAd/YP3FwhY2bgmSBjGcyJ2fFq9DFvgwWHwRWIDb3DQcaU13WvNXfKy/LxMCnlAr+Ev6UB57r//Dw4UtaaNV594IObKk42Sq62xspcnyQRiIjWGyYkzrWfK5e/hjg2YeNG1tQmVDNF0mAwadch/AgVMlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300265; c=relaxed/simple;
	bh=kFZTbSTFZ5WEwNQQnaTNXJ/aZcPRd7pffqh6kDdkQ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKlJV4R3UcCknO+Jl4RgV+tn/KYkWaeoO0ljVyxtiQuc7nRGr8BzH8dfBm3rt3485OgQqbPZ0TqxbmGG+PjkF7HRphb/LpSfZU7/gYW5ZN6SNCXzBw97Kw8tlon5rqlQzUWnExntZAvWz84pKB4hcbyfWPgWyrwnFqMYQIfqh/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MK9lzXld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MK9lzXld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969D91F000E9;
	Wed, 20 May 2026 18:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300264;
	bh=gRsIR8rH+yPXDLUbjh6tZ5KLECztYBFuTrWPu7DJeAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MK9lzXldr7iNL1D9+hc/GV+E0SPxqd4FGTihUnKSCtdDt0v47TJW6JalyRiHG7LHT
	 Ha9ESDlz9Ps3i7OnyyfBKt/2uWYO3Qiyr8YDesrlMvJzl3/lgm2QrYAy84RajfrN+9
	 pRCKofngNRG2Q5q7QurUosJ6sMXlrMjMp7TC12Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/666] Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER
Date: Wed, 20 May 2026 18:15:19 +0200
Message-ID: <20260520162113.562541079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a14c00ad7278..92270b99ee0f2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3284,8 +3284,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 
 	memcpy(conn->dev_class, ev->dev_class, 3);
 
-	hci_dev_unlock(hdev);
-
 	if (ev->link_type == ACL_LINK ||
 	    (!(flags & HCI_PROTO_DEFER) && !lmp_esco_capable(hdev))) {
 		struct hci_cp_accept_conn_req cp;
@@ -3319,7 +3317,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 		hci_connect_cfm(conn, 0);
 	}
 
-	return;
 unlock:
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



