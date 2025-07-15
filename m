Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BD9271449;
	Tue, 15 Jul 2025 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585870; cv=none; b=GhZgNeh77iUVeWtxMjEvNydjbEHE2HlWjAFz9AnNrOb2GjHzd4LUMAcmFBwIZDVAf/khS9D0cn4N8hCmTJSP+IAnltA0uyUGxzjYcmIMF3zpyZITs/riQesu6K8bQBQbUXSrurfofbW4zGKPth+sEPovZXeIqAwrEq8aEDgPwik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585870; c=relaxed/simple;
	bh=rijU3W4wOdbPxagQiPQBQhnSu1gwkT1j8NiEYvf7AZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLOLTJxg+WuB7j+ugCBiL9D2G9ErJeuUqITthP6Ix1YVKes+zGQPVJ3qs5hrcbwor35dWBizchWPis7mR5OjrhCfBtC7Et1C24qb29rt0wv2pj/VORSlTZOUiiSfuqBkfCXTa3F0b/POXVUl5nNjcr0E21qVbijSCHpojX0y6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbXkpBuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbXkpBuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC281C4CEF1;
	Tue, 15 Jul 2025 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585870;
	bh=rijU3W4wOdbPxagQiPQBQhnSu1gwkT1j8NiEYvf7AZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbXkpBuYw6pdRn+os4aArShWoAl6Dth4vzZC/XYBu8EXjzncVsy/oDOOs2Uvp+J69
	 QEHNN5Qu7/TsPZwIK6Srtq0jvWF+PP+IjVA6btLpZnpMv119F93ZlUBXPfuaCZ6v6m
	 D5HRsQfsfss21Y7hePGsYhCn8dcRa8SDLprKBwSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/109] Bluetooth: hci_event: Fix not marking Broadcast Sink BIS as connected
Date: Tue, 15 Jul 2025 15:12:24 +0200
Message-ID: <20250715130759.209834131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4029330e29a99..8d4ab29e37946 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6916,7 +6916,10 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
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



