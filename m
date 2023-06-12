Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B7218AE1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0453C433EF;
	Mon, 12 Jun 2023 10:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565752;
	bh=m9xSIDOcOfffIQFAIDosUK20oQWgHcpeLoseulDWA28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0t7/CXB/86aclFDJ0LLgptsBSiS8vaT48b7uTk+muVsAaiGf/Pl+jf9/2zIWu6vE
	 FdkxbstWhIn667kb9zAKDr61gpzvhIsuGmxJQPOGfciM2n+FUKZtDlRIqr5Lkni2mq
	 s4AvG36TDqRxnIf9qj2wm+LnPSPAX9XhrU4Juwbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <lm0963hack@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.14 16/21] Bluetooth: Fix use-after-free in hci_remove_ltk/hci_remove_irk
Date: Mon, 12 Jun 2023 12:26:11 +0200
Message-ID: <20230612101651.607962275@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>
References: <20230612101651.048240731@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit c5d2b6fa26b5b8386a9cc902cdece3a46bef2bd2 upstream.

Similar to commit 0f7d9b31ce7a ("netfilter: nf_tables: fix use-after-free
in nft_set_catchall_destroy()"). We can not access k after kfree_rcu()
call.

Cc: stable@vger.kernel.org
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2468,10 +2468,10 @@ int hci_remove_link_key(struct hci_dev *
 
 int hci_remove_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 bdaddr_type)
 {
-	struct smp_ltk *k;
+	struct smp_ltk *k, *tmp;
 	int removed = 0;
 
-	list_for_each_entry_rcu(k, &hdev->long_term_keys, list) {
+	list_for_each_entry_safe(k, tmp, &hdev->long_term_keys, list) {
 		if (bacmp(bdaddr, &k->bdaddr) || k->bdaddr_type != bdaddr_type)
 			continue;
 
@@ -2487,9 +2487,9 @@ int hci_remove_ltk(struct hci_dev *hdev,
 
 void hci_remove_irk(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 addr_type)
 {
-	struct smp_irk *k;
+	struct smp_irk *k, *tmp;
 
-	list_for_each_entry_rcu(k, &hdev->identity_resolving_keys, list) {
+	list_for_each_entry_safe(k, tmp, &hdev->identity_resolving_keys, list) {
 		if (bacmp(bdaddr, &k->bdaddr) || k->addr_type != addr_type)
 			continue;
 


