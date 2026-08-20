Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BFC44062A;
	Thu, 20 Aug 2026 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248290; cv=none; b=V38zzGdT2oYwRJxCHXZET7nxUv9hni/Cmm6QFwSG62BcuG75GOpTahafmafti1ccdtgAKEC6DqSfUBQSNMg+mjttVWUeNNR8/I+2Ag6VL1V5yPKq+J1CeX5sVpswLDY3cM6yxnDI9R2tx1B0Lwp85lHrvihAKALfjmw3YuUFJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248290; c=relaxed/simple;
	bh=OS5nFf49dXnWx6fwnJIMJofccnwLJ/uAvCTue0hJaDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTN8M/cafH8Cb78G0eO7ZiUrTGjfN19SeKw6ppP0Ckycqj5gVwtvAXe58dcATx7bnHiqHiwHbrwI8ZENAeSaSbHADsruwOnoZ3u0W8KGUNnA9bVK/QS6tMJjWHXHpIZeVHrBX6HysZ0ayzrlWNreiBTFvBhYti2GJt3NFreudXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz/5OyEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz/5OyEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D394D1F000E9;
	Thu, 20 Aug 2026 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248289;
	bh=Mp00coAtnLBcGzlqoQvZxG+SJ8BtB0quVh5UvBV/N5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tz/5OyEgt1Vqczdn/uG6NIFN80v4ituyZIBHpctZP2fv1exxNnLi84eMh1VehbTuj
	 hNbs7IOqv2Lqp76cz9uhCQiT2mzJLnfbtpELhpZg0h1GE0V57yrh0p4BmYIEMCllYN
	 Sjq3CYzcaMT5hlQxVeeJRLG6mBTPRGCFjgopv5rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/303] Bluetooth: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 20 Aug 2026 16:55:11 +0200
Message-ID: <20260820145258.566469581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    9 +++++----
 net/bluetooth/hci_sock.c |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2596,10 +2596,11 @@ int hci_register_dev(struct hci_dev *hde
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
@@ -2698,7 +2699,7 @@ err_wqueue:
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-	ida_simple_remove(&hci_index_ida, hdev->id);
+	ida_free(&hci_index_ida, hdev->id);
 
 	return error;
 }
@@ -2787,7 +2788,7 @@ void hci_release_dev(struct hci_dev *hde
 	hci_dev_unlock(hdev);
 
 	ida_destroy(&hdev->unset_handle_ida);
-	ida_simple_remove(&hci_index_ida, hdev->id);
+	ida_free(&hci_index_ida, hdev->id);
 	kfree_skb(hdev->sent_cmd);
 	kfree_skb(hdev->recv_event);
 	kfree(hdev);
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -101,7 +101,7 @@ static bool hci_sock_gen_cookie(struct s
 	int id = hci_pi(sk)->cookie;
 
 	if (!id) {
-		id = ida_simple_get(&sock_cookie_ida, 1, 0, GFP_KERNEL);
+		id = ida_alloc_min(&sock_cookie_ida, 1, GFP_KERNEL);
 		if (id < 0)
 			id = 0xffffffff;
 
@@ -119,7 +119,7 @@ static void hci_sock_free_cookie(struct
 
 	if (id) {
 		hci_pi(sk)->cookie = 0xffffffff;
-		ida_simple_remove(&sock_cookie_ida, id);
+		ida_free(&sock_cookie_ida, id);
 	}
 }
 


