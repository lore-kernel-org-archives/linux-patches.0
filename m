Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F1628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF63C433EF;
	Mon, 30 Jan 2023 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087111;
	bh=jsjzwYVYQETmXhiYx0H+t8hrCqNDD5XK4EmbWh/wSag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFYns6jMXpLIFnKCTYamV9oD4yt3eGVDGf1QNEY0TZV7OBo9Gokpmx8rxn/sRdaCY
	 u61dTwZvyQNF8YEkWFTDaPP3kPZhuEvjY4/SvIKbldv0llUZ4xNi/MRVheaRTbq+gf
	 wo5N9DhKLnsrrNURxUOVFCC3S93rXPfJDzdRtbN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/313] Bluetooth: hci_conn: Fix memory leaks
Date: Mon, 30 Jan 2023 14:48:54 +0100
Message-Id: <20230130134341.245678760@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 3aa21311f36d8a2730c7ccef37235e951f23927b ]

When hci_cmd_sync_queue() failed in hci_le_terminate_big() or
hci_le_big_terminate(), the memory pointed by variable d is not freed,
which will cause memory leak. Add release process to error path.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 8aab2e882958..3c3b79f2e4c0 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -821,6 +821,7 @@ static void terminate_big_destroy(struct hci_dev *hdev, void *data, int err)
 static int hci_le_terminate_big(struct hci_dev *hdev, u8 big, u8 bis)
 {
 	struct iso_list_data *d;
+	int ret;
 
 	bt_dev_dbg(hdev, "big 0x%2.2x bis 0x%2.2x", big, bis);
 
@@ -832,8 +833,12 @@ static int hci_le_terminate_big(struct hci_dev *hdev, u8 big, u8 bis)
 	d->big = big;
 	d->bis = bis;
 
-	return hci_cmd_sync_queue(hdev, terminate_big_sync, d,
-				  terminate_big_destroy);
+	ret = hci_cmd_sync_queue(hdev, terminate_big_sync, d,
+				 terminate_big_destroy);
+	if (ret)
+		kfree(d);
+
+	return ret;
 }
 
 static int big_terminate_sync(struct hci_dev *hdev, void *data)
@@ -858,6 +863,7 @@ static int big_terminate_sync(struct hci_dev *hdev, void *data)
 static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, u16 sync_handle)
 {
 	struct iso_list_data *d;
+	int ret;
 
 	bt_dev_dbg(hdev, "big 0x%2.2x sync_handle 0x%4.4x", big, sync_handle);
 
@@ -869,8 +875,12 @@ static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, u16 sync_handle)
 	d->big = big;
 	d->sync_handle = sync_handle;
 
-	return hci_cmd_sync_queue(hdev, big_terminate_sync, d,
-				  terminate_big_destroy);
+	ret = hci_cmd_sync_queue(hdev, big_terminate_sync, d,
+				 terminate_big_destroy);
+	if (ret)
+		kfree(d);
+
+	return ret;
 }
 
 /* Cleanup BIS connection
-- 
2.39.0



