Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873EB46A616;
	Tue, 21 Jul 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649722; cv=none; b=mz3Cr2koagVL/Od66vdtryW8GXtaVLhuLNybaj7i6XCB/Zv0muD8+Z5M4epqSnZAto0px02EawWqSwGywgI4EYtspofqLYusX1dosgqAUx8P9KNl5I2k5S6zeIGqbUez2NEnsoX3OeZ/0XXXm19Cfg0GVyPMTj8QKCbJEU/DpbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649722; c=relaxed/simple;
	bh=kIiBmW5oikHdIrANtqUj8RFhiNzVwdHwm7USJSSAItg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tdc/Gf5R7QcV4dcBnggpQbBZzzzROtXRf/gDsEk2iI1xWQHeTykuDhmQhUJfdB51OIqQpi8ylt1gH0cLfK37R4E5VKDcN7AkKmH0HFrsz36oZHgpsSEGHW7E7zx1xzynZvlVJQJy0qn6AX+tQxaa5vcZPhk0Y0uwzWL0SI0gaFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvyZVkCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvyZVkCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB3A1F000E9;
	Tue, 21 Jul 2026 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649721;
	bh=uwxeJNq1x79V80Wmfp2oF1UJJj5uKBBC/2QnlBmSyHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvyZVkCqWr6GgSLhYtsr7wY4ziH+IBQjs0TMkZOPIEhc/zR1eSw+r2TldNkuaDDzU
	 dbufZAp3PgGYom2JhrNvbtpdD78cgRgjSKuiDQrNicSMCqniGHgSB2wvjy0+uUVMIF
	 yLqtoNy9hLtBD7uVue0RgqtcMq+kDl5aQ9fk+2yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Walters <jaggyaur@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0681/2077] Bluetooth: hci_core: Fix UAF in hci_unregister_dev()
Date: Tue, 21 Jul 2026 17:05:54 +0200
Message-ID: <20260721152608.858479351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Jordan Walters <jaggyaur@gmail.com>

[ Upstream commit 5edcc018fa6e80b2c478454a4a8229c23d67c181 ]

hci_unregister_dev() does not disable cmd_timer and ncmd_timer
before the hci_dev structure is freed. If a timeout fires
during device teardown, the callback dereferences freed memory
(including the hdev->reset function pointer), leading to a
use-after-free.

Add disable_delayed_work_sync() calls alongside the existing
disable_work_sync() calls to ensure both timers are fully
quiesced before teardown proceeds.

Fixes: 0d151a103775 ("Bluetooth: hci_core: cancel all works upon hci_unregister_dev()")
Signed-off-by: Jordan Walters <jaggyaur@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 28d7929dc59377..1cbc666527c57c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2671,6 +2671,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	disable_work_sync(&hdev->tx_work);
 	disable_work_sync(&hdev->power_on);
 	disable_work_sync(&hdev->error_reset);
+	disable_delayed_work_sync(&hdev->cmd_timer);
+	disable_delayed_work_sync(&hdev->ncmd_timer);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.53.0



