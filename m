Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C203D27466A;
	Fri,  7 Aug 2026 15:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116054; cv=none; b=W0/KH85QTPAyrwGA+dBRIH4IOBhrKZG12fuQh60yx96HGmBfcXoFKLpKnkdy+jAStXxapIuzgnjLXRiQ+AUn9JDK3yQcqlphTvIxuNR2IQyYQvwoHCMm6cXIMNyhQY5/mBXC/wAmeEEDY51oMBd+Lt6FfXUo0Bvn7RGqplQjxAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116054; c=relaxed/simple;
	bh=tlsW25Wdq+BA4e48SRGXmYzAkvnlu6dia82TTLB4PjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmAa22l701WLwwbQBdoSBsFF0HNS42uKpoyIhPu/cGvSCcHu9uKruhZyI4yvQvU+V0cLFqIV6OVfKNfaxxOaZ1EZq9UqclQWXs3YtG0+ccl+ZofaZVx1OCscHPODOabR81GskSazPxBkvIy7rhINGz0olpK+9d6lGEomKadcehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLzAbEPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLzAbEPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E1D1F000E9;
	Fri,  7 Aug 2026 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116053;
	bh=H0Ev4ZAQMJiEFe4GhX1Z7cqGnMRqDjiKjsZsxQUUYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLzAbEPAN8gK1psx8udMNomeAk+V5NVT80yNtPmfoZDqvyaG5ZYpbgwtJSvyRhp4I
	 OylGejA0d4eIZd0Jl5Jl8AYcWCiGocRjtGJnFR4C0IrOSKIQ9sGzP7w2yUDm2N7nI5
	 lBW684U8Mk2VyqS/3d1jY8RRRpfL5AvuSGks2HXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/261] Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync
Date: Fri,  7 Aug 2026 16:37:06 +0200
Message-ID: <20260807143416.871670833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
index df207c3f1c5c3..6a5ec74eaf25a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6582,7 +6582,9 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
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



