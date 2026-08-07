Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78D247A884;
	Fri,  7 Aug 2026 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116954; cv=none; b=JOE8yJlpkFH6dSIeNIEsHJNWtemTkKSBrxhY+cAFnahCfhcBnxalBwaqJHv7IlyuyHddIjKGMpr+xRNUXL/DOXjps4A48BaPqxm5tXtL7w41LIbBtSa1wCIM4QcPWy4wxFY+ouELT65OSy42b+aSk4Uxv7n4C/P/Qb77RrhyJio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116954; c=relaxed/simple;
	bh=UqYFSw/j4d5Yg6HxOmuj+VGDVXQ6dqlvRM9mYlc3ptc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5Rv0RO3N8oDu89MTfX4Elnsy+fXtkJcqslt31dMfhhMI6NWFHacKH23qcrRbjBhbTE4Zd0qeSRA7xhuZ61AeGDjYu86fCJY4CYoaSvQFx5MduVuCz1LYhHLQZDk+9tijqV3QHkcLQD7z4Z4x5zOizUEZYtc8Kwew01ntV58m6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlroEkD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlroEkD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088791F00A3A;
	Fri,  7 Aug 2026 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116951;
	bh=On5SyXiTsag60sk++bd+RF/4GwshTrUJhY5myZOP4MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlroEkD0+Rsh6+W4cyrqT85M/GpNU2eNHrDkYxBlOqSS3n82XnANj0lqDnHMybKR/
	 pxuW/+U/rvHtn5q4Uk73F10t0QM+80nEdof5h+I/7N01c65LKVusfWCXslEkfsZ3d0
	 F9cPtWATYXydzyuML+vb9/R1skKpu45GIZ9byjdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 147/438] Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync
Date: Fri,  7 Aug 2026 16:35:43 +0200
Message-ID: <20260807143431.140691991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 2c1e4e00613dfd105f978be2276e5e265801ec9f ]

hci_conn_del() caller must hold hdev->lock, check the conn was not
concurrently deleted, and usually inform socket the conn is going to be
deleted.

Use hci_abort_conn_sync() instead of calling hci_conn_del() without
locks etc.

Fixes: 8e8b92ee60de5 ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 70ac18fe74448..0bb015da6f88c 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6672,7 +6672,9 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN) &&
 		    hdev->le_scan_type == LE_SCAN_ACTIVE &&
 		    !hci_dev_test_flag(hdev, HCI_LE_SIMULTANEOUS_ROLES)) {
-			hci_conn_del(conn);
+			conn->state = BT_OPEN;
+			hci_abort_conn_sync(hdev, conn,
+					    HCI_ERROR_REJ_LIMITED_RESOURCES);
 			hci_conn_put(conn);
 			return -EBUSY;
 		}
-- 
2.53.0



