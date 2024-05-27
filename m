Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D07262BE;
	Mon, 27 May 2024 19:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838308; cv=none; b=tHaIKBGqbd4d7oobShomhh10mniZ3htnn9SRFk5noKMoA7YbP8FKiOtre/S4QwaL0OeATaTRJAgzu6bDyIQLWH64MBYsu/TvAeFaaD5HzURuZZfVGbcOrwbEn5WzcBwHfZRcnB6zsEuuMF86wUFblVDNDnx4bv7DaqUBIhhfXvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838308; c=relaxed/simple;
	bh=8jTGDWWWVkGYiWEU/9YY3TcLaHXtcdc9T2aPyGvQhR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7J9K0p9GTLW7fgAqt+VGDtWGeCAE16RiUyMeRW0jk9BtFQz6x/3upuTSva1zykmHhadtABOt6EYruiGfjB0WdeCHt33IGZrzAsVKRuQQDXfl70LBKYwfTKhSN0fC/OyeGSzzhvAMbIEUvXTzneiyfmqVMtcACEt0xCQBthCFSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9EnJUXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9EnJUXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA22C2BBFC;
	Mon, 27 May 2024 19:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838307;
	bh=8jTGDWWWVkGYiWEU/9YY3TcLaHXtcdc9T2aPyGvQhR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9EnJUXJ5LI8LdGBayAGZOJVMEIN4kQ8uXTzpRROcW73wVqfTKfiyKcRVrtY4lOwe
	 iR1/Sa4i+3aY574nVFiwIrXQcx1LJC3Q63s0jTuyrmfgR7hteGSRx6JUss66ECVa1I
	 huXc2ksmI5uBY+vFZAxhzX5hsdVxWFvC7lXbYLrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 342/493] Bluetooth: Remove usage of the deprecated ida_simple_xx() API
Date: Mon, 27 May 2024 20:55:44 +0200
Message-ID: <20240527185641.459277745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9c16d0c8d93e3d2a95c5ed927b061f244db75579 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 84a4bb6548a2 ("Bluetooth: HCI: Remove HCI_AMP support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 9 +++++----
 net/bluetooth/hci_sock.c | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index befe645d3f9bf..101ea9137dfef 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2609,10 +2609,11 @@ int hci_register_dev(struct hci_dev *hdev)
 	 */
 	switch (hdev->dev_type) {
 	case HCI_PRIMARY:
-		id = ida_simple_get(&hci_index_ida, 0, HCI_MAX_ID, GFP_KERNEL);
+		id = ida_alloc_max(&hci_index_ida, HCI_MAX_ID - 1, GFP_KERNEL);
 		break;
 	case HCI_AMP:
-		id = ida_simple_get(&hci_index_ida, 1, HCI_MAX_ID, GFP_KERNEL);
+		id = ida_alloc_range(&hci_index_ida, 1, HCI_MAX_ID - 1,
+				     GFP_KERNEL);
 		break;
 	default:
 		return -EINVAL;
@@ -2711,7 +2712,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-	ida_simple_remove(&hci_index_ida, hdev->id);
+	ida_free(&hci_index_ida, hdev->id);
 
 	return error;
 }
@@ -2793,7 +2794,7 @@ void hci_release_dev(struct hci_dev *hdev)
 	hci_dev_unlock(hdev);
 
 	ida_destroy(&hdev->unset_handle_ida);
-	ida_simple_remove(&hci_index_ida, hdev->id);
+	ida_free(&hci_index_ida, hdev->id);
 	kfree_skb(hdev->sent_cmd);
 	kfree_skb(hdev->req_skb);
 	kfree_skb(hdev->recv_event);
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 3f5f0932330d2..703b84bd48d5b 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -101,7 +101,7 @@ static bool hci_sock_gen_cookie(struct sock *sk)
 	int id = hci_pi(sk)->cookie;
 
 	if (!id) {
-		id = ida_simple_get(&sock_cookie_ida, 1, 0, GFP_KERNEL);
+		id = ida_alloc_min(&sock_cookie_ida, 1, GFP_KERNEL);
 		if (id < 0)
 			id = 0xffffffff;
 
@@ -119,7 +119,7 @@ static void hci_sock_free_cookie(struct sock *sk)
 
 	if (id) {
 		hci_pi(sk)->cookie = 0xffffffff;
-		ida_simple_remove(&sock_cookie_ida, id);
+		ida_free(&sock_cookie_ida, id);
 	}
 }
 
-- 
2.43.0



