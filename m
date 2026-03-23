Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A081EB9F2;
	Mon, 23 Mar 2026 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274289; cv=none; b=n5aOwsfMA9i2k59BrHsIRn63IQRidBMOthJC4ZScSJioX4g2c3jCqpb1bUlZNA12BCATogEYx0gMat5Pz8171mj6c9X6x/TwC7009kif4Vn7HucAGPtvOzBWLnINPY59q2vz3i5PMdA5YQEjhIWm7s0rHcvuHl5LaJHtxMl6c+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274289; c=relaxed/simple;
	bh=rWeuZXR+RA7PbBEthBoEBGeJITdSWsFg/JoC1EiiYyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKRajfFS0UeFYWp1jdYS79/0LqnVXC9hEX8G3JDOQ3m0PxJGCcu+X3TiieJlQnmkwBiSDTgVFtCIvl9JBbVuki/ZDMhvVy7hfMwpo+T+SWduKj22u1jS9rz34eiT4qBpnuYtl5eu7dERaAMd22AhZbfgnO3vn62Ed1x64MPCQqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW70N6Qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW70N6Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A718C4CEF7;
	Mon, 23 Mar 2026 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274289;
	bh=rWeuZXR+RA7PbBEthBoEBGeJITdSWsFg/JoC1EiiYyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW70N6QmHAF7lJkdVHsTEuksx40KDycJ4U6ClHaNEhIQe5u3vSV7FX2H8WIeLLFFd
	 VC/4P/Dnm1I+XH7fRGMwmF7YV7PQF7d7KVHWg4FZXlpIYQEDP2UhDlTelemSy04hnY
	 e6yvo5vANm8AZcGhtt+GsOFmpAPHZEI8TgEmu27E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+14b6d57fb728e27ce23c@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 125/220] Bluetooth: L2CAP: Fix use-after-free in l2cap_unregister_user
Date: Mon, 23 Mar 2026 14:45:02 +0100
Message-ID: <20260323134508.534896653@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit 752a6c9596dd25efd6978a73ff21f3b592668f4a ]

After commit ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in
hci_chan_del"), l2cap_conn_del() uses conn->lock to protect access to
conn->users. However, l2cap_register_user() and l2cap_unregister_user()
don't use conn->lock, creating a race condition where these functions can
access conn->users and conn->hchan concurrently with l2cap_conn_del().

This can lead to use-after-free and list corruption bugs, as reported
by syzbot.

Fix this by changing l2cap_register_user() and l2cap_unregister_user()
to use conn->lock instead of hci_dev_lock(), ensuring consistent locking
for the l2cap_conn structure.

Reported-by: syzbot+14b6d57fb728e27ce23c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14b6d57fb728e27ce23c
Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 05acc2e98f58f..9ea030fc9a9cc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1686,17 +1686,15 @@ static void l2cap_info_timeout(struct work_struct *work)
 
 int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user)
 {
-	struct hci_dev *hdev = conn->hcon->hdev;
 	int ret;
 
 	/* We need to check whether l2cap_conn is registered. If it is not, we
-	 * must not register the l2cap_user. l2cap_conn_del() is unregisters
-	 * l2cap_conn objects, but doesn't provide its own locking. Instead, it
-	 * relies on the parent hci_conn object to be locked. This itself relies
-	 * on the hci_dev object to be locked. So we must lock the hci device
-	 * here, too. */
+	 * must not register the l2cap_user. l2cap_conn_del() unregisters
+	 * l2cap_conn objects under conn->lock, and we use the same lock here
+	 * to protect access to conn->users and conn->hchan.
+	 */
 
-	hci_dev_lock(hdev);
+	mutex_lock(&conn->lock);
 
 	if (!list_empty(&user->list)) {
 		ret = -EINVAL;
@@ -1717,16 +1715,14 @@ int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user)
 	ret = 0;
 
 out_unlock:
-	hci_dev_unlock(hdev);
+	mutex_unlock(&conn->lock);
 	return ret;
 }
 EXPORT_SYMBOL(l2cap_register_user);
 
 void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user)
 {
-	struct hci_dev *hdev = conn->hcon->hdev;
-
-	hci_dev_lock(hdev);
+	mutex_lock(&conn->lock);
 
 	if (list_empty(&user->list))
 		goto out_unlock;
@@ -1735,7 +1731,7 @@ void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user)
 	user->remove(conn, user);
 
 out_unlock:
-	hci_dev_unlock(hdev);
+	mutex_unlock(&conn->lock);
 }
 EXPORT_SYMBOL(l2cap_unregister_user);
 
-- 
2.51.0



