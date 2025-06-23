Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1D63FD4;
	Mon, 23 Jun 2025 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715262; cv=none; b=heDPlb/o+3TU5uJxg+om76UcfOlchK02hJsNcjtTXKEKwwzVudcWG4jcqHeCy1Xs4zDHbX/Kt8OV4bpUEbIZ6j1lxEDxXQmvO1yVOuVlnb4Ge0apRx2MsdWrixYnVPp0Kad/L7qHdNUd37DttgGPwIw1VaHsCMVv09QIYWKVvE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715262; c=relaxed/simple;
	bh=JJ4TN8onF338IM3Zpo/BQLnsysvJgcn8JGkfBxJKz8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5kdnLDr7ifuZ7QhiGHkIVHB6R5miEywYJnsszafVSTkbS0bj8VSdWkGjjU+DgfdD42zJ1C7hsWk2wBYlb0qqf0Q77tabpfJsU0OMLIRl/Dpeil/+vWXFshvEDXFq2u9hqAVjm7971NEMYpfNb7wYdF5mc3TJOEZowRukFuwOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6f8v/Ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6f8v/Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9008C4CEEA;
	Mon, 23 Jun 2025 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715262;
	bh=JJ4TN8onF338IM3Zpo/BQLnsysvJgcn8JGkfBxJKz8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6f8v/GewdDgoSB37bwqg75WxKG5C5M/SOxc6n5VRbHQ8jQLjgvB0aXUBu0WkXoDZ
	 uHNtnPPOQ8zhWzbehwRFgpg1oO18aLM+fSudjsgPNVYoVEE8VzI/8CIOzNQ3UuLX5w
	 cpTWj8HctkjvJBGU8Q6baCfdkWHGpMDiKFz5WiQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/508] Bluetooth: hci_core: fix list_for_each_entry_rcu usage
Date: Mon, 23 Jun 2025 15:04:29 +0200
Message-ID: <20250623130650.775679958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3cd7c212375fc..dc53e3078ba79 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3402,23 +3402,18 @@ static void hci_link_tx_to(struct hci_dev *hdev, __u8 type)
 
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



