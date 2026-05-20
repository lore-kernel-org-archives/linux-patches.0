Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650282D7386;
	Wed, 20 May 2026 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302015; cv=none; b=rh12fHXnrYeA+CFRxg0EsDYSBz5ZC93eQCzNHqsNcV7vWe6Id2FEBFrPEJ5oEkfRsPKm+1YPKoETMA768tq/kvh86+kyLCuq0zmtWvWsYp88CYr1NaBLUwn5Q7riwvCXgk1z3lzw1maL7NM8Qkftzlg0mnea4xx7uPMbXDWgjFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302015; c=relaxed/simple;
	bh=d4a5HJaFH/QzcC/paUthaEfG8RoP7nmRi7DKAdOyNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7ekRo0kuRw/AMNiyb9kVVSs2yh/+Rd1FG+pNgKGRnH5sxWj3wpVuBHKp8SfSDW2VKkAdIreupSW5RSlgKMmTtdKXxbtHB2YtB1dP9vKDxyFLG580UkDJGXrLxOCgEB7imeX1OpMPGybrihkSi2jYuDaaIdACuY0E0+mhSa2+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTtIneu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTtIneu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B611F00893;
	Wed, 20 May 2026 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302014;
	bh=a8kb+vxupfa2C2RN0miTx5xS1Dz9+ev59qIwhIKYY34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTtIneu19H3rKmXXFhMZbFdH1/m1RZDrfsrvM664uwJcb63fJYBZ2tqo9AhqVsOAx
	 H+PkTMqetDCIBCRS/WD+3/4htqpCGd3tnun/mZzT1Q6QQnbpwtvIYCxlgO4iSMsDu3
	 WVYQ1ldBYI/9zp5S1Z2WvWkwrzyYPyTdLdUn8HYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/508] Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER
Date: Wed, 20 May 2026 18:18:22 +0200
Message-ID: <20260520162100.321828831@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f6285c4325d63..4607db3037bd9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3282,8 +3282,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 
 	memcpy(conn->dev_class, ev->dev_class, 3);
 
-	hci_dev_unlock(hdev);
-
 	if (ev->link_type == ACL_LINK ||
 	    (!(flags & HCI_PROTO_DEFER) && !lmp_esco_capable(hdev))) {
 		struct hci_cp_accept_conn_req cp;
@@ -3317,7 +3315,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 		hci_connect_cfm(conn, 0);
 	}
 
-	return;
 unlock:
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



