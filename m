Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF451D0499;
	Wed,  2 Oct 2024 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877462; cv=none; b=QiMJgV2WqkaVE2IuoXUrAKcdoFzOhvMSrijS55StRedOw1LQXfhkkr8kQIa6ukiQdCTt3xyAm8/iZRjt8+PyxrzpaMTzyf46CLbBLzI6FoNz/4mzcu3FQNAvf0q8BqQpc8To/Xf4WbQtjDt7tKqL4KB+XM/CAUiaWf7rOULirQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877462; c=relaxed/simple;
	bh=YFZAdiL5sVzP5bbxV4nLbuLiynGzNgr4Gzr0w35HJtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psMtYT9Bp0Y9QNE0lPNMohkjIx5BUK8A4pVE7NSQBCbh/D8jKdUTcQ7HOlYqtphzNUlnGE5cwJrY/KVOh6lAyS+Iz0O99gJKq8pD5BUaZojjxE7/OxmIeBT/BILG8S2X6yIdyiQlY/zoKxoGyw9x16wLOQBlo3SUGSiEdzu2OAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blaiFf3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blaiFf3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6ACC4AF0D;
	Wed,  2 Oct 2024 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877462;
	bh=YFZAdiL5sVzP5bbxV4nLbuLiynGzNgr4Gzr0w35HJtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blaiFf3T1BKj/9JnUF94OlQcOW7hwMrCnmp6uWs5aUzPmFjjcK1Yfv5PC0dPJLD2c
	 q5Z/fHoEOz3MFH74RshCbXtADOO6K9F7q+/SOFFryFh9/Wnyngx7PMKyi6ZPdE2XUQ
	 OHqsdQf2HdWQh98VaM7TjpEKBTx53ExSTLybDWyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 086/634] Bluetooth: hci_sync: Ignore errors from HCI_OP_REMOTE_NAME_REQ_CANCEL
Date: Wed,  2 Oct 2024 14:53:06 +0200
Message-ID: <20241002125814.505969899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit cfbfeee61582e638770a1a10deef866c9adb38f5 ]

This ignores errors from HCI_OP_REMOTE_NAME_REQ_CANCEL since it
shouldn't interfere with the stopping of discovery and in certain
conditions it seems to be failing.

Link: https://github.com/bluez/bluez/issues/575
Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f4a54dbc07f19..86fee9d6c1424 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5331,7 +5331,10 @@ int hci_stop_discovery_sync(struct hci_dev *hdev)
 		if (!e)
 			return 0;
 
-		return hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
+		/* Ignore cancel errors since it should interfere with stopping
+		 * of the discovery.
+		 */
+		hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
 	}
 
 	return 0;
-- 
2.43.0



