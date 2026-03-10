Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E238A718;
	Tue, 10 Mar 2026 11:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141277; cv=none; b=Rw/Y9KZzr4562wGsoHI9OzbRSlIuL6vIMl7mnVBOicSLoCNyVU11NpdmAdSuGMQzYnFDwrN2DCkINBejM1ybVCovCWuMS+ab13Y0z4vC+N1meyzr8JSqa/c/tAf7cQgUPjnlFTB3EymyW7ddc0uJ7yX/pilwSrGskc7FYnDCcQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141277; c=relaxed/simple;
	bh=NzsAjgBh1XFB7I6GwHwk3AaFUuEac0b4uJ809TgV7kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAfyFG6815kvwqh1YC/ouvZx7cwtQCyKU+j0qKs2mPCfKflnUYv+CMQgktjfObDmB8Di4cZyD2pF43RAL6ZgOM8UPya3BDbmcWUHfVFFn/ji+Ftbc14uGmDNOUM09EYtWtpe3YGX79z3nffdfZI95HncfengAyqRVaMPY3243RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnuGc0aL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnuGc0aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29694C19423;
	Tue, 10 Mar 2026 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141276;
	bh=NzsAjgBh1XFB7I6GwHwk3AaFUuEac0b4uJ809TgV7kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnuGc0aL/VWyoZfjpKde6mpCP8rPwpuQd+G4g3ElPNkjwWHg9R37n85TxmHOLFRNR
	 334o4PGPqReKcLQAHPDQBz1SBrgLNdptm6OckqCFZRlYiMxJ89juLpNlQWa78/ca+l
	 KNBxbRr6djrVwBilJ06RQyDrJ4JQvqGx6ym0TU/bHuHZlf/80JhQYn0tn5D06aZdLZ
	 cUFJm1e20kfGtV5tq/zuddUitf+qI1pBO0aQJHChNTAR0k4L4Z4E33q5xzxoEeIio2
	 0CkZ1L/mdgxovJ9ddcYj/JAPyf+YzqSFyvbodiHvvzWJgpIEqW0VM51+dRl8P+U3zX
	 yTq37bCuHeHoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 279/311] nfc: nci: complete pending data exchange on device close
Date: Tue, 10 Mar 2026 07:05:26 -0400
Message-ID: <6fa018e48704ff3aab6fe595dae4722f4122e283.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66083581945bd5b8e99fe49b5aeb83d03f62d053 ]

In nci_close_device(), complete any pending data exchange before
closing. The data exchange callback (e.g.
rawsock_data_exchange_complete) holds a socket reference.

NIPA occasionally hits this leak:

unreferenced object 0xff1100000f435000 (size 2048):
  comm "nci_dev", pid 3954, jiffies 4295441245
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    27 00 01 40 00 00 00 00 00 00 00 00 00 00 00 00  '..@............
  backtrace (crc ec2b3c5):
    __kmalloc_noprof+0x4db/0x730
    sk_prot_alloc.isra.0+0xe4/0x1d0
    sk_alloc+0x36/0x760
    rawsock_create+0xd1/0x540
    nfc_sock_create+0x11f/0x280
    __sock_create+0x22d/0x630
    __sys_socket+0x115/0x1d0
    __x64_sys_socket+0x72/0xd0
    do_syscall_64+0x117/0xfc0
    entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 38f04c6b1b68 ("NFC: protect nci_data_exchange transactions")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index f6dc0a94b8d54..d334b7aa8c172 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -567,6 +567,10 @@ static int nci_close_device(struct nci_dev *ndev)
 		flush_workqueue(ndev->cmd_wq);
 		timer_delete_sync(&ndev->cmd_timer);
 		timer_delete_sync(&ndev->data_timer);
+		if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+			nci_data_exchange_complete(ndev, NULL,
+						   ndev->cur_conn_id,
+						   -ENODEV);
 		mutex_unlock(&ndev->req_lock);
 		return 0;
 	}
@@ -598,6 +602,11 @@ static int nci_close_device(struct nci_dev *ndev)
 	flush_workqueue(ndev->cmd_wq);
 
 	timer_delete_sync(&ndev->cmd_timer);
+	timer_delete_sync(&ndev->data_timer);
+
+	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+		nci_data_exchange_complete(ndev, NULL, ndev->cur_conn_id,
+					   -ENODEV);
 
 	/* Clear flags except NCI_UNREG */
 	ndev->flags &= BIT(NCI_UNREG);
-- 
2.51.0

