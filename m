Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD2E3D9693;
	Tue, 12 May 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607758; cv=none; b=d8iZ6wSlvwJ+JRQzjUZnFORG6JtlnkUXyzIzcH5PniVcDI+lxJBsxS9CVRI2shEEFwDHR743pQMpOJgQWiF7Pqql7MbdXUhDruBn6Tx9WoaUkzaSCWMYTCWt0sp9kWNDCdypCcGUW9d5ZJx9AcXREG2k832wyk9E8acl7x71lYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607758; c=relaxed/simple;
	bh=eSclj1cBiU7/J070P9oqN0h/1TmEEwmCofVd5XOJmms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqnRfnqH5MlnPhcsTxQ9U/VJMLEOOY4TfnYLfqMXxxXz1g3iwGSCbSPhVrmSBeO55K5bCmiacfJabVFAT13U+do1yOufOaHLaZWBfaWvJhZMESqn1HsdPHBJng5bJo170McrzEDIOIc6yoQTTWcTS3Tzgexd39WVEMIzINlrYdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvryOTV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvryOTV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DA5C2BCB0;
	Tue, 12 May 2026 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607758;
	bh=eSclj1cBiU7/J070P9oqN0h/1TmEEwmCofVd5XOJmms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvryOTV7LEmfuzQKof6XrYm/HL8cCqWw42hYbOqnJouns5T6VWpR0p7kYHMiM/KUt
	 MrjHIJoaKCxW+ikzx0tX+Nr6KNpAHynHZue7exHpvfRRzY58sYBioN2ztpKyo2Bqaw
	 e9e6nQqwhvnk/9+WZ52VnDOGvgVw23cUviQZKbs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/206] Bluetooth: L2CAP: Fix deadlock in l2cap_conn_del()
Date: Tue, 12 May 2026 19:37:57 +0200
Message-ID: <20260512173933.360876907@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 00fdebbbc557a2fc21321ff2eaa22fd70c078608 ]

l2cap_conn_del() calls cancel_delayed_work_sync() for both info_timer
and id_addr_timer while holding conn->lock. However, the work functions
l2cap_info_timeout() and l2cap_conn_update_id_addr() both acquire
conn->lock, creating a potential AB-BA deadlock if the work is already
executing when l2cap_conn_del() takes the lock.

Move the work cancellations before acquiring conn->lock and use
disable_delayed_work_sync() to additionally prevent the works from
being rearmed after cancellation, consistent with the pattern used in
hci_conn_del().

Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Minor context conflict resolved. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 128f5701efb46..307f7fe975b59 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1756,6 +1756,9 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 
 	BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
 
+	disable_delayed_work_sync(&conn->info_timer);
+	disable_delayed_work_sync(&conn->id_addr_timer);
+
 	mutex_lock(&conn->lock);
 
 	kfree_skb(conn->rx_skb);
@@ -1769,8 +1772,6 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 	if (work_pending(&conn->pending_rx_work))
 		cancel_work_sync(&conn->pending_rx_work);
 
-	cancel_delayed_work_sync(&conn->id_addr_timer);
-
 	l2cap_unregister_all_users(conn);
 
 	/* Force the connection to be immediately dropped */
@@ -1789,9 +1790,6 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 		l2cap_chan_put(chan);
 	}
 
-	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
-		cancel_delayed_work_sync(&conn->info_timer);
-
 	hci_chan_del(conn->hchan);
 	conn->hchan = NULL;
 
-- 
2.53.0



