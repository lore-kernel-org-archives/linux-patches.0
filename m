Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93992FA62A;
	Tue, 17 Jun 2025 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179149; cv=none; b=UfmQ4fVDORLB/lVCelj6biCUPcS6pQ/3ZS+IYM3MWEDly6NHjtWaW1hUr76LbLGJ7C9vF+BbXECwjM3eDCF2QzbN34jlYm0Baagcu1UiY5/XlJnDedJfSZuaINQtDLdGLSJi9uomz9bpLToU1CBEHKxiBSmwi20HuLdMP+GV06A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179149; c=relaxed/simple;
	bh=KZ7k72qK/RVjrcq8d5SgaKecYBEbE9GPwRJF+AuvmHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfMESIJ+PjJHaU5awUIKob2qLHIjCqxXJPZw9xDB5BrBrcoBINdpTwWyK5PGcUrb3OJb6AQ9UQsCB8uFKLROErtjsL6xEsECLrQCDt9oJ8CCbyP6jSyuVbsITqKfLfb+fc/RvRLz77aelf8d6K9cq7hrm7PlKCblhafaPJOuB4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jg+X4eKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jg+X4eKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C6FC4CEF0;
	Tue, 17 Jun 2025 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179149;
	bh=KZ7k72qK/RVjrcq8d5SgaKecYBEbE9GPwRJF+AuvmHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jg+X4eKKEGRMM2ixGGdCsoOeed9mQUZFHHjCN/XuShgN9JP5FhdXupEck+r5kiw2x
	 cye4I5t6DOv0M8C3v2oo/SG/uWFJ6aG3XQZytP/2rrozPbeuwSJSxrRn56l3/reIP4
	 INlstRaGPnjAHc9u2AGXHTwnxVfl8GH631fFBg2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 663/780] Bluetooth: hci_core: fix list_for_each_entry_rcu usage
Date: Tue, 17 Jun 2025 17:26:11 +0200
Message-ID: <20250617152518.468515147@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2668e0e563c43..67c7e0656ff71 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3406,23 +3406,18 @@ static void hci_link_tx_to(struct hci_dev *hdev, __u8 type)
 
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



