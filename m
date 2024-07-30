Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143C71A6169;
	Tue, 30 Jul 2024 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357486; cv=none; b=SCZiaaj5uMlxyOdQ/kW51o+j1IsifIeLj/bUGjkav4KI3dlYYrTkVppYhyhwFPoT60O9YeHTHCaUFHrwWbGDBMVulPhWbPuvC4ED+BFCEU4nDUQTXxmH4Nogrts7q1esYnb9/21OOWq8bTEtyDQlMzizXC0A7a2URVaVdldfX4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357486; c=relaxed/simple;
	bh=orxPFtQLiwdxOonatrzzIwZFzJkhzXfKz0AZDPK/TlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIwFYRZDxsA9RqtJxRZeMweSyjHOUXu91TIqjgwiECbeqYukQ5G9hXA1RbQvcsKmhJt5eJWyYD9UKRUwxhV7loWNIoIVN3/QyBBQxThAPOYdgQonrO/r+qg4WM5gpnaLENRJcf9geBkJdgAvm1I4877vQI8z2gZeZFbvaJR7Jek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLt7qw9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLt7qw9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FECC32782;
	Tue, 30 Jul 2024 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357485;
	bh=orxPFtQLiwdxOonatrzzIwZFzJkhzXfKz0AZDPK/TlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLt7qw9E+32fcT5tGhvNR3W/vFhYfqvCZqHSJdxFwGsQviZms1kYOt58ppDH+rPqr
	 WbEWvblRtu2VqQDD8JhSwITeblP1QFYNGcj5kaiDEtOLgCJZD2EWE+EluN0bqSFmkW
	 stydU7A63cObfjnmFCziATlVE6qkuE+hFxZafd/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 258/809] Bluetooth: hci_core, hci_sync: cleanup struct discovery_state
Date: Tue, 30 Jul 2024 17:42:14 +0200
Message-ID: <20240730151734.786639916@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit da63f331353c9e1e6dc29e49e28f8f4fe5d642fd ]

After commit 78db544b5d27 ("Bluetooth: hci_core: Remove le_restart_scan
work"), 'scan_start' and 'scan_duration' of 'struct discovery_state'
are still initialized but actually unused. So remove the aforementioned
fields and adjust 'hci_discovery_filter_clear()' and 'le_scan_disable()'
accordingly. Compile tested only.

Fixes: 78db544b5d27 ("Bluetooth: hci_core: Remove le_restart_scan work")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 4 ----
 net/bluetooth/hci_sync.c         | 2 --
 2 files changed, 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c43716edf2056..b15f51ae3bfd9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -91,8 +91,6 @@ struct discovery_state {
 	s8			rssi;
 	u16			uuid_count;
 	u8			(*uuids)[16];
-	unsigned long		scan_start;
-	unsigned long		scan_duration;
 	unsigned long		name_resolve_timeout;
 };
 
@@ -890,8 +888,6 @@ static inline void hci_discovery_filter_clear(struct hci_dev *hdev)
 	hdev->discovery.uuid_count = 0;
 	kfree(hdev->discovery.uuids);
 	hdev->discovery.uuids = NULL;
-	hdev->discovery.scan_start = 0;
-	hdev->discovery.scan_duration = 0;
 }
 
 bool hci_discovery_active(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index eea34e6a236fd..bb704088559fb 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -371,8 +371,6 @@ static void le_scan_disable(struct work_struct *work)
 		goto _return;
 	}
 
-	hdev->discovery.scan_start = 0;
-
 	/* If we were running LE only scan, change discovery state. If
 	 * we were running both LE and BR/EDR inquiry simultaneously,
 	 * and BR/EDR inquiry is already finished, stop discovery,
-- 
2.43.0



