Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F68C1D6DB5;
	Tue, 11 Nov 2025 00:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822390; cv=none; b=QX1dDkr8fpnkekN0YMitKhfAetTMhuAcmS8X7EMGn1Hk4NFYF73dW5BMqOLpybTkqKxIc0KsRgP1RVNIQmVFG74uJvJgMH1aM6q+1PkxRh1ZtSjLZeAMHhI8H0Rqtf38eAEPYXrBHIw2X3oO7lh88ZEGKI/RPyKxKJb65CJtsq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822390; c=relaxed/simple;
	bh=SJbsX4IYIrJGxrBY3ic8+JZgiX4A3uyQezcau1mrmmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6eg//U+Kie2J8nFV6JXwR107g/OWuNQCoNQdH8Y+WyDoL8EJk7tUgI18XWPur8LYU8LDI4W7MHUg7eAHcCA7zYs2jKY9WgF4M5GsvjryZtxtYJU/fx3Dtww5jvL8lsHjcrAWD2Cocx8pUuHldCwgjkHOUBohsI18P+A1FgC3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olJ2EouT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olJ2EouT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35676C19424;
	Tue, 11 Nov 2025 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822390;
	bh=SJbsX4IYIrJGxrBY3ic8+JZgiX4A3uyQezcau1mrmmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olJ2EouTk2jdmaV+foCE/02nHWLxrMtI12HAHxifHJu+MRujYmG+37xiicqP63iIl
	 P8brA8553hu8kAQPIESgxmBC9+s7OCrHUZAzocm6bjmK6wr8HUhoFf2opNSIZZEe6x
	 Hl/52hGh3PruTeRnU1PmBtNf726k/dUdhW6Fp0XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/565] Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once
Date: Tue, 11 Nov 2025 09:38:17 +0900
Message-ID: <20251111004527.823306305@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 853acfa8e9433..c08e46ee70b24 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -863,11 +863,17 @@ bool hci_cmd_sync_dequeue_once(struct hci_dev *hdev,
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



