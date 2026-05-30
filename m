Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C131E858;
	Sat, 30 May 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164006; cv=none; b=jNE9KmgP4A3UikYfn5J/WTExWBlnkKyM0oJ6mrZaABbnXp8DU1EGi9OZGWTALyBCZTyxwSjWdTgU6Te5GWX4mQmYOywUQk8eTTF+hSGjeklpfOQVx5+DVrRQMk73F1qMqvda3In+wku/9sF3xt+SvV/VR3rCZg4EZl4PQcEMdiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164006; c=relaxed/simple;
	bh=stJ3M3hPBoi9GfJHHwk2GajrN5wIWdnnPBtUnl8kmEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzZF6ZheMyj+/LW96L/XS6Ammpl+haL02Zx/5ayGlPPX/+fjnKuvuqxbo5UOmYTQAlDlm94PEb9gOw9aOUZeUo3xxqaBIR1s0Ol+Dy7q/QinTOu3ohMOzu7RloyU08TW8GuBL3oEH06oU0tkv3jCv2nki+dzpiOJyCnu97v89rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1u7zfKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1u7zfKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125C71F0089D;
	Sat, 30 May 2026 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164005;
	bh=LRvV92IpPxJbvd1mONJY0gyw2CUyzMIjKD2EuHipjeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1u7zfKxISAWPOva+9b+GWW9u8Ok8caPzly6R3EC7CHQze8nUrlnLB7HDs//wTGBq
	 I6UME+AlKUztbl3Sy03jLWnwM+lYqIIJFbbzsToXfh+JZ2bAW9eCVo/TSeD/z7dax/
	 1zFhciqL8pzolIIa+0MRc1V1Ko/riILvg8wkI9T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/776] Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER
Date: Sat, 30 May 2026 18:02:19 +0200
Message-ID: <20260530160251.438797154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8d6fc3a0c9a7e..dc79a362aef7f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2882,8 +2882,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	memcpy(conn->dev_class, ev->dev_class, 3);
 
-	hci_dev_unlock(hdev);
-
 	if (ev->link_type == ACL_LINK ||
 	    (!(flags & HCI_PROTO_DEFER) && !lmp_esco_capable(hdev))) {
 		struct hci_cp_accept_conn_req cp;
@@ -2917,7 +2915,6 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		hci_connect_cfm(conn, 0);
 	}
 
-	return;
 unlock:
 	hci_dev_unlock(hdev);
 }
-- 
2.53.0



