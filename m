Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E3F34DB6E;
	Fri, 21 Nov 2025 13:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732277; cv=none; b=iWctZZnk6xlu+/lZZ9E6Di1zmaZ9oNZ2m2IjvMu3gVrTa4E12iEMcQSQ2ODEyFqcPECxfui81Ip0R98SYVQWm4SCMvmhjxPxHHv6cFGxcg+zlWEyCxOp1e0zcaxgHje4e+pHlkMhuJRtAPRxLNPGOwbdSDeW9JrBX8S6/le0/c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732277; c=relaxed/simple;
	bh=4Q2R23RrZ5/y9N+p7/jGV04KxSkyCrVXOZn9lM5rHt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTUth1UeyjVlhu/GDIObJHDM/8qzAOKRX6/pzPcLzGsQ7G53VmJL4IyusXurjURZyxlUm/qKtv6kO8d+moxLRox578e+gPhLWN8Ojz4/pdsSYNiqkaBhEauF0ey2GAoxyE57KdIuEb3PstZsId5M2Npft9P54hjlH5lr7o5OLR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOGT+5YE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOGT+5YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F03C4CEF1;
	Fri, 21 Nov 2025 13:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732276;
	bh=4Q2R23RrZ5/y9N+p7/jGV04KxSkyCrVXOZn9lM5rHt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOGT+5YEdjyySuhQ7yy15bt3ONgog6+LkrJJMG6ofrlgQ8VdYNv8gqCY5q3gO+z+Q
	 C8TINvcU8dHh1ErCEMpCioQd2sNudeOaw5AqnosTuIeOCRKz1txI67WYTtHzN48o0f
	 pvLzxNGd7yea7VX72w2xGysn4U7KuCDohfr/yNAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/529] Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once
Date: Fri, 21 Nov 2025 14:05:30 +0100
Message-ID: <20251121130232.106082547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@163.com>

[ Upstream commit 09b0cd1297b4dbfe736aeaa0ceeab2265f47f772 ]

hci_cmd_sync_dequeue_once() does lookup and then cancel
the entry under two separate lock sections. Meanwhile,
hci_cmd_sync_work() can also delete the same entry,
leading to double list_del() and "UAF".

Fix this by holding cmd_sync_work_lock across both
lookup and cancel, so that the entry cannot be removed
concurrently.

Fixes: 505ea2b29592 ("Bluetooth: hci_sync: Add helper functions to manipulate cmd_sync queue")
Reported-by: Cen Zhang <zzzccc427@163.com>
Signed-off-by: Cen Zhang <zzzccc427@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a128e5709fa15..47924f20565d4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -881,11 +881,17 @@ bool hci_cmd_sync_dequeue_once(struct hci_dev *hdev,
 {
 	struct hci_cmd_sync_work_entry *entry;
 
-	entry = hci_cmd_sync_lookup_entry(hdev, func, data, destroy);
-	if (!entry)
+	mutex_lock(&hdev->cmd_sync_work_lock);
+
+	entry = _hci_cmd_sync_lookup_entry(hdev, func, data, destroy);
+	if (!entry) {
+		mutex_unlock(&hdev->cmd_sync_work_lock);
 		return false;
+	}
 
-	hci_cmd_sync_cancel_entry(hdev, entry);
+	_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
+
+	mutex_unlock(&hdev->cmd_sync_work_lock);
 
 	return true;
 }
-- 
2.51.0



