Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D06FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C40FC433C9;
	Sun, 17 Sep 2023 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981726;
	bh=yzctLx6ZM+yWO4xejStXSNFsBfXorro05HnJ/ZQC2/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQFvhCuPn1WYfl4m6qj4a2++J461ywyYU16tSk+PFvvnpHPLs6azBCJr6izcpNeDH
	 tXk+xwWMBqmWbs7nKvdgrBi8z2ZVh3Y2hoNGs3dNDs1Z3G5HUScs+Mn00Myh8KCOkB
	 lcpVerqk+9jX+XOq374Xh/qZrepTFGvycfl5kfMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <lm0963hack@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/511] Bluetooth: Fix potential use-after-free when clear keys
Date: Sun, 17 Sep 2023 21:08:45 +0200
Message-ID: <20230917191116.233582861@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min Li <lm0963hack@gmail.com>

[ Upstream commit 3673952cf0c6cf81b06c66a0b788abeeb02ff3ae ]

Similar to commit c5d2b6fa26b5 ("Bluetooth: Fix use-after-free in
hci_remove_ltk/hci_remove_irk"). We can not access k after kfree_rcu()
call.

Fixes: d7d41682efc2 ("Bluetooth: Fix Suspicious RCU usage warnings")
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 682a09e7fea66..e777ccf76b2b7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2355,9 +2355,9 @@ void hci_uuids_clear(struct hci_dev *hdev)
 
 void hci_link_keys_clear(struct hci_dev *hdev)
 {
-	struct link_key *key;
+	struct link_key *key, *tmp;
 
-	list_for_each_entry(key, &hdev->link_keys, list) {
+	list_for_each_entry_safe(key, tmp, &hdev->link_keys, list) {
 		list_del_rcu(&key->list);
 		kfree_rcu(key, rcu);
 	}
@@ -2365,9 +2365,9 @@ void hci_link_keys_clear(struct hci_dev *hdev)
 
 void hci_smp_ltks_clear(struct hci_dev *hdev)
 {
-	struct smp_ltk *k;
+	struct smp_ltk *k, *tmp;
 
-	list_for_each_entry(k, &hdev->long_term_keys, list) {
+	list_for_each_entry_safe(k, tmp, &hdev->long_term_keys, list) {
 		list_del_rcu(&k->list);
 		kfree_rcu(k, rcu);
 	}
@@ -2375,9 +2375,9 @@ void hci_smp_ltks_clear(struct hci_dev *hdev)
 
 void hci_smp_irks_clear(struct hci_dev *hdev)
 {
-	struct smp_irk *k;
+	struct smp_irk *k, *tmp;
 
-	list_for_each_entry(k, &hdev->identity_resolving_keys, list) {
+	list_for_each_entry_safe(k, tmp, &hdev->identity_resolving_keys, list) {
 		list_del_rcu(&k->list);
 		kfree_rcu(k, rcu);
 	}
@@ -2385,9 +2385,9 @@ void hci_smp_irks_clear(struct hci_dev *hdev)
 
 void hci_blocked_keys_clear(struct hci_dev *hdev)
 {
-	struct blocked_key *b;
+	struct blocked_key *b, *tmp;
 
-	list_for_each_entry(b, &hdev->blocked_keys, list) {
+	list_for_each_entry_safe(b, tmp, &hdev->blocked_keys, list) {
 		list_del_rcu(&b->list);
 		kfree_rcu(b, rcu);
 	}
-- 
2.40.1



