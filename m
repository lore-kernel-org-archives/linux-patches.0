Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8B133DEE5;
	Fri,  7 Aug 2026 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113993; cv=none; b=TOxQsVUMtxabKggCCMSCC8uNK3KFuagTg+WiK9noDK4CmkDmVc9FZN+i8KfGwyY4ROJ/vO0M5mQepO2xDToHydaYfAbJ3kc/TrJgYA0f/mmuSdEr3oDgzvTqHyVAGw4qqLfMDT+LAxibmSkkZbcRcl812rAHnzIaCdPkscHQfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113993; c=relaxed/simple;
	bh=3UeSkFgNkHDzGzMh8ImNgk3F3MqEXVu73OSpOUMi1IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNPVg8vc8p30oYTwZoAtaVqg5njIBHx4n3wMkvBTC4hTn+So23Pb7GKeV1DbnL/J0J+vhmy6Qjo2r9J9ykhuh8o1upeJ3NI4vRXf4OADknsH3kVjoJ4iRQp71wOLyX1w1j4mxm/EoiJxYUw+dU3drzim5fYe1oq2mQPW2y8Q2CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/w6+yEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/w6+yEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE6A1F000E9;
	Fri,  7 Aug 2026 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113991;
	bh=BOGlDGfvGcAbwz5H2zQRWvcyO8UtIl/ipRZM9xQho00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/w6+yEGvTJT9E1DPTlvfX2GRgi60dd3FrDeMo37xjdNbY+KOuksh+3AMZCsZfQWv
	 NcbZR+/PnPKd3UgKG080wgDf9z1oQ7cCORe8ZCE1gUfAubVyU9GoB9E/Opuhu/CxQ6
	 JqRqv8x2tlb04TSFHLvtQFClqIaXl6Qa57vyDTlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/337] Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync
Date: Fri,  7 Aug 2026 16:35:08 +0200
Message-ID: <20260807143420.816042810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 111b8f3c77296..8c48d459a5415 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6593,7 +6593,9 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
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



