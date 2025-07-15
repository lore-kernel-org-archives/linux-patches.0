Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F222E2EFF;
	Tue, 15 Jul 2025 13:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585471; cv=none; b=qNpf90n8On+Gfckp/Tnd2/d+nQbRZFBvG7ACvqb3XuSpR5JUGPVpNJDW4KQCU0pIGx6OppLdj3UXJOCptd+xe2OSAfe+UVQHeigZGUMN/uA2VmBaG1zy3ngEkDbWdlNn2nSQItnn75hIIFiClMtBJMlSHrVK9wqVxo5In8cZUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585471; c=relaxed/simple;
	bh=VZtPdH+OZcCio11O1i1+iVOgcP2R/vE83u72mbpyifc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIZHh14Bz5QCzHxf6Ff263nwcoN+iNeJtf/trMBitVq4pF0NxJxgKiihl1AstFTM8HqO+z2NwHGTiplk9vhl10o40dqlrEo0Rz6D7tZ6pAMEER7ZGdCYjemdeg8HCmNyBrrjsoYTjNO7mMGT44tD4xsq4b3KId59Vb7dtjaSDtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBfuGBzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBfuGBzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89991C4CEE3;
	Tue, 15 Jul 2025 13:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585470;
	bh=VZtPdH+OZcCio11O1i1+iVOgcP2R/vE83u72mbpyifc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBfuGBzzEB/aZ4YI/AlXpghsKrmMyTTYwnVskdIFMYu9Ac4M1wVSAi12lx+J80KB7
	 gUBdr7a7DTNK3D7h2Htx9yg6OVa6lvK+I2vJTVxKP1CgYWVTUV9oQOxl6J9InfwjSX
	 fsYBqStwm1RjnGf0IWA8xb+SbHbx+KiExxuYVwSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/163] Bluetooth: hci_event: Fix not marking Broadcast Sink BIS as connected
Date: Tue, 15 Jul 2025 15:11:29 +0200
Message-ID: <20250715130809.616578700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c7349772c268ec3c91d83cbfbbcf63f1bd7c256c ]

Upon receiving HCI_EVT_LE_BIG_SYNC_ESTABLISHED with status 0x00
(success) the corresponding BIS hci_conn state shall be set to
BT_CONNECTED otherwise they will be left with BT_OPEN which is invalid
at that point, also create the debugfs and sysfs entries following the
same logic as the likes of Broadcast Source BIS and CIS connections.

Fixes: f777d8827817 ("Bluetooth: ISO: Notify user space about failed bis connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7fdf17351e4a2..b7dcebc701898 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6945,7 +6945,10 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 		bis->iso_qos.bcast.in.sdu = le16_to_cpu(ev->max_pdu);
 
 		if (!ev->status) {
+			bis->state = BT_CONNECTED;
 			set_bit(HCI_CONN_BIG_SYNC, &bis->flags);
+			hci_debugfs_create_conn(bis);
+			hci_conn_add_sysfs(bis);
 			hci_iso_setup_path(bis);
 		}
 	}
-- 
2.39.5



