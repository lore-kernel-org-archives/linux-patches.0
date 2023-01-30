Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B69528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85822C433EF;
	Mon, 30 Jan 2023 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087114;
	bh=WK9M1JMhE4yIcDv0R2RgSIobbe4NY9UaaaXM3uuJVt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8kR/rnHRgxAtWG6MlobMAQ7Oy6TK14WikJnpwoD0n/9eaCt61FD7XCGt3SxHfY12
	 wPCFR/NIZcOCpVGuxncKB24hE2z+1UwCT9nmi9Y99AIaEeV2G8QXm79pbhb9A3SmXU
	 9IRkPvM3pVyEE5amN+mCVYskARfgsX+TCJsynjoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/313] Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()
Date: Mon, 30 Jan 2023 14:48:55 +0100
Message-Id: <20230130134341.293145273@linuxfoundation.org>
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

[ Upstream commit 1ed8b37cbaf14574c779064ef1372af62e8ba6aa ]

When hci_cmd_sync_queue() failed in hci_update_adv_data(), inst_ptr is
not freed, which will cause memory leak, convert to use ERR_PTR/PTR_ERR
to pass the instance to callback so no memory needs to be allocated.

Fixes: 651cd3d65b0f ("Bluetooth: convert hci_update_adv_data to hci_sync")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 8d6c8cbfe1de..67dd4c9fa4a5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6168,20 +6168,13 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 
 static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
 {
-	u8 instance = *(u8 *)data;
-
-	kfree(data);
+	u8 instance = PTR_ERR(data);
 
 	return hci_update_adv_data_sync(hdev, instance);
 }
 
 int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 {
-	u8 *inst_ptr = kmalloc(1, GFP_KERNEL);
-
-	if (!inst_ptr)
-		return -ENOMEM;
-
-	*inst_ptr = instance;
-	return hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
+	return hci_cmd_sync_queue(hdev, _update_adv_data_sync,
+				  ERR_PTR(instance), NULL);
 }
-- 
2.39.0



