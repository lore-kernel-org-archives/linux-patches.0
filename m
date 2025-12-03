Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983F34B669;
	Wed,  3 Dec 2025 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778742; cv=none; b=L8Uq4oDiUJ1TjL+fnVOuVEjcx6jhna898aoGISk3/INcb3uw659zSo3ocxN8+qblNYbjkz+cseWf0+Cu0PWT2fROE7kJuD7ofCrkJtkiZC7GxVmljTrhuxeq3Hhsr4J4nliyEOfMY/yP/DoVIIsGEZpRc81uep6QDhi3Iy6TCbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778742; c=relaxed/simple;
	bh=yAzePoYwwIt2hqioYH6c8xjJrr8yLdmZe1YYqeAqYDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0WZhUf436h8H7Ky3HQU2eGNVFm6p0CKv2YmNC2WTlF/UaW98R1exsZEGtFGsjK/Gs1ad3BWF52TMprTXUqRGsKTGw3wrMras7zZDxm1ze1DTid6Ty/YIhlB3ysJtRTgZik05IJM01NYleGEVm8uuVf29eHzkd06O76Y9Gw5U5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3In3FAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3In3FAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0668C4CEF5;
	Wed,  3 Dec 2025 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778742;
	bh=yAzePoYwwIt2hqioYH6c8xjJrr8yLdmZe1YYqeAqYDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3In3FAP4s451FfDLPl6wZZna1EbTHuc7DgzfXfUh+WfW+yO52GAaCQJdhpLOZBN8
	 MPHwqJbEJhmce2DZJeJp/SXEWjMLDiZiuR8++HcBOV6psLF1uxZSrhwVQLyAncnMfj
	 iBYWMU1EO6t4IZtvojH6+n/3z69R1bRiCm8va//U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/568] Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once
Date: Wed,  3 Dec 2025 16:20:48 +0100
Message-ID: <20251203152442.377822367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 851a43a5aee0c..2937e7a37bcba 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -838,11 +838,17 @@ bool hci_cmd_sync_dequeue_once(struct hci_dev *hdev,
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



