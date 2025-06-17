Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A273E2ED176;
	Tue, 17 Jun 2025 16:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176541; cv=none; b=iE84eYdJYE2vGpcQzUXnLLjzSq9Ip4ytgmsm5Z6XSoOhshZ303G/LoXPKEDNEWRlc7HhF1aeSPlknZRvlnZn+bbY8iOFktU9y1+o1epioYwlxJNx6HNA8+Gx9sZMoMURqTSEVwShWD/kP5L1i9Cygu9sWfJJ7IfSIsK9lJvb0pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176541; c=relaxed/simple;
	bh=10xGQac022hY1dr5inw4AqR3hyU42XMNxD6FFBnw4vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEg2nNlYv0nGD3cQYaXPxbNdRqNiJcESmcZLrDLgU/84bsUr9nXhSRTfgGnzd3YbqzXVTYP+PZaI+O78/Wk3sx3RcgtEm489+Y9ETOj8+yRuaFvXlY/3RXl1Uh1bFIrhEhGeT5dcHWCZXnCv8M/j8wZKpNqCmvYrjLCkCrSgI5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igKzwMdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igKzwMdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A4C4CEE3;
	Tue, 17 Jun 2025 16:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176541;
	bh=10xGQac022hY1dr5inw4AqR3hyU42XMNxD6FFBnw4vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igKzwMdGvdObdliFKG2UW5zN7uay5KQfXxVmKNRplyfBVASzismxE1nanGJhml6WA
	 TRDs2fkp8LlNGeF6yE4B4+CSYyWKXvG0CkEn9aPJApsMyEKxVdXAO5WMhlKTFUNsLU
	 fnZoz2XIcFMCYj2Er4bBmyu1Zt0Q7Z2JsT9gFcpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/356] Bluetooth: hci_core: fix list_for_each_entry_rcu usage
Date: Tue, 17 Jun 2025 17:26:46 +0200
Message-ID: <20250617152349.892762891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 308a3a8ce8ea41b26c46169f3263e50f5997c28e ]

Releasing + re-acquiring RCU lock inside list_for_each_entry_rcu() loop
body is not correct.

Fix by taking the update-side hdev->lock instead.

Fixes: c7eaf80bfb0c ("Bluetooth: Fix hci_link_tx_to RCU lock usage")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 30519d47e8a69..febfd389ecf43 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3380,23 +3380,18 @@ static void hci_link_tx_to(struct hci_dev *hdev, __u8 type)
 
 	bt_dev_err(hdev, "link tx timeout");
 
-	rcu_read_lock();
+	hci_dev_lock(hdev);
 
 	/* Kill stalled connections */
-	list_for_each_entry_rcu(c, &h->list, list) {
+	list_for_each_entry(c, &h->list, list) {
 		if (c->type == type && c->sent) {
 			bt_dev_err(hdev, "killing stalled connection %pMR",
 				   &c->dst);
-			/* hci_disconnect might sleep, so, we have to release
-			 * the RCU read lock before calling it.
-			 */
-			rcu_read_unlock();
 			hci_disconnect(c, HCI_ERROR_REMOTE_USER_TERM);
-			rcu_read_lock();
 		}
 	}
 
-	rcu_read_unlock();
+	hci_dev_unlock(hdev);
 }
 
 static struct hci_chan *hci_chan_sent(struct hci_dev *hdev, __u8 type,
-- 
2.39.5



