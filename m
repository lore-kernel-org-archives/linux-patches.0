Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6721D00A;
	Mon, 23 Mar 2026 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274956; cv=none; b=EkeUS1G9bWsTASHm/PyMDjDomLE9vYCrSfsuuityCnpxbHgovsAGW/eT7nDxaMHKQuy9XqgpS1K1DvFWab+dn73NgR7zNKimSrJPEoJYGjFSb0eHf/UPtMGsClaAektRq59dbmKSTP1hc6BP6EkwuzT6v1CwE6R0pfEQXOC42W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274956; c=relaxed/simple;
	bh=QZmiPlYcKQOCP4J8kRXxWg1O9enlnKGTMmQ1WklChBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw2Qr3GxIfdHnazYAuSzUVyDJro4PYi1M2fG3dvNkYrIPin/mZhK5bcQS6GYlUncVam9xCxAJMUalOPSpgpYKbjj0p9sflQNnk45BhKPTYPVI1fNSss1aejfvoX517IxQfIMJPjmb4q12IQjRSxXmzr2F+zk6am+bYFi9fWjq2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJWqLxX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJWqLxX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926AAC4CEF7;
	Mon, 23 Mar 2026 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274955;
	bh=QZmiPlYcKQOCP4J8kRXxWg1O9enlnKGTMmQ1WklChBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJWqLxX7aNN6RaQBpIkTzebB1hCm3WOJkgkrP2CFRnX5ZqChoxAJo+8HCK87is4TY
	 wXXANOfxJz11vAa33Ws88WOawGhiIiMoJRO85aZhvCsRyNdk3aI7FIr4e8K64zfZsb
	 MQGjEvsJJW+u/kVSZM5J5kAWGrorHFEUYedjiTkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+14b6d57fb728e27ce23c@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/212] Bluetooth: L2CAP: Fix use-after-free in l2cap_unregister_user
Date: Mon, 23 Mar 2026 14:45:50 +0100
Message-ID: <20260323134507.846374370@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



