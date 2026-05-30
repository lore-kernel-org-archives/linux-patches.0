Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC8E39A7FE;
	Sat, 30 May 2026 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166256; cv=none; b=GfuIP635KL528FW+UGh6DXRM5aGs7Gs3luqFxe2UyoIHQoJMwJTXVhM2afJ3vqYyvf0YAuqu5LzMHI/6Gn7BVnt+hWbQnqQA/ZTTtGkqCuR5bc+/lCxCGA9Sp39YdKaOW5ZTzazWtSomKrvcWEuG6i04kZIOcXZ0esVMP48gzjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166256; c=relaxed/simple;
	bh=wU7tZwWMOKCXhiFWm1ZlcvLJY6d+ksDv04YHK3be9Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/JMCgBFVHhYmb4ieMDcGpawpLqq9WQB+7totxaldqbtSFVgT4W/XamzTvzSUA70DJlXRuFyVRBac7FQwoSaKtbcFxMIVCFGabP5tCjJqn9RBicUZO6hnGSlq7tft3FIHAoOC/pMCB8ok+mSEaDwfI5zzm0+FSTI8ncOkUSCHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3cJAMAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3cJAMAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870171F00893;
	Sat, 30 May 2026 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166255;
	bh=gyCxHEgJ68IvjlF/qFz7UyhpgElbq4MLJFjbElwRNoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3cJAMAzRvZZDPiaIsUmGkKhT3c2FYk5u7EPkLm9Bivm8kN7kW1kQ5a99xtliUyPC
	 UqqdUWWJjsfWAiYK6AYe01sq4w74ehUK6QIZJXfPF8znGJBc2fmrHYec16j4AxIWOH
	 ANENKI0yGvH+Dq0uPrsfxQssb2KT/fIuwbJMuUBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/589] Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER
Date: Sat, 30 May 2026 18:03:18 +0200
Message-ID: <20260530160233.268244054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6310f4f9890eb..a2995dcb0ffeb 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2786,8 +2786,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	memcpy(conn->dev_class, ev->dev_class, 3);
 
-	hci_dev_unlock(hdev);
-
 	if (ev->link_type == ACL_LINK ||
 	    (!(flags & HCI_PROTO_DEFER) && !lmp_esco_capable(hdev))) {
 		struct hci_cp_accept_conn_req cp;
@@ -2821,7 +2819,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		hci_connect_cfm(conn, 0);
 	}
 
-	return;
 unlock:
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



