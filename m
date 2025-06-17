Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB18D2EE5EE;
	Tue, 17 Jun 2025 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177926; cv=none; b=srTVjJPK+Qh4i/1MbPqjF/ICGif6fr653MgwvBGcaylElXl1iQE1fJN1uWpLgNyfjXzR8QPok9Wc1nrxUhmO8V/rDcxOugp6CYemIUyWvlvyg9v42qfiIx4vSNfk5Ea4DA3R2lPONlUQ0G1Tj7MEnEfvtTrM5ClDkohw5OFKycY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177926; c=relaxed/simple;
	bh=fAETykJc/JWz7S42FLkZcXzNOe9e7xVqexzTrqDZVYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7RLnNsHROBD8RM7tRc4M4A5iy522EQblilc3/GN4ZQfZWHlqbptxRO3dzviru2x/QlkAGRdwE3pgLpwcZQhd2CT7WHZcv0OybC5gxfWEPHOYOJ2+xScfqCztND+eShbut8F3RnlAvegcnbnWNwVGkzbbhuqtwiKIrsgkYBnolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrwriVNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrwriVNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB51C4CEE3;
	Tue, 17 Jun 2025 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177925;
	bh=fAETykJc/JWz7S42FLkZcXzNOe9e7xVqexzTrqDZVYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrwriVNzfLgSuljL+/p8vnnkT2j8/+kWjpmB6MoXe6ryrzpUB+AsznE9rSm8RMxjk
	 9eCPr+woZJPWQ68GR3utN1eewVLFGJ4/vTOgXLtaclVz/D0CvJwVfrxOSKidzNDpO/
	 eNbuToHxO4Ku/IdVDGigErh6GMJhLRfacMoZIDYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 419/512] Bluetooth: hci_core: fix list_for_each_entry_rcu usage
Date: Tue, 17 Jun 2025 17:26:25 +0200
Message-ID: <20250617152436.553858086@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 743b63287a18f..831f41f6bc6de 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3416,23 +3416,18 @@ static void hci_link_tx_to(struct hci_dev *hdev, __u8 type)
 
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



