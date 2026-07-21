Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3633471257;
	Tue, 21 Jul 2026 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662249; cv=none; b=MzKcGEPRRkVG4pJv5WgO3p75srdfpxxi7l74O0UEliJOqq+dz//vQz9ath9wOOUwKf5TkzLCGb6dFJCf2uZ4Jsc+q4Om42Q6ZkFF8uwVkWDGH3VqA5SWrENAf/buwIHkBZikBB/v2Upxzth9jh74SbSl4KfPqgVxCxXp7hlS1xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662249; c=relaxed/simple;
	bh=yiYsCstMmACBAXQsrqaG+Gm50Bl0hdzDkYhgIjUre+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEE/u91sHzEzmq0vtpkSvV/iTE8V/IMjpY04Y5AD+xBz6Sqn8vv6Dg/jw6RDgkDLMbPerBha1tRPnto77LYHgV0SONwmg+89u26k6j6Ci/hmahutxfB38y4GB7jmn1IFs/lPVFnFPtWShV8S2yLhiIwrnJ7SkI1HgIy+RXIc/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyHx5hBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyHx5hBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AB61F000E9;
	Tue, 21 Jul 2026 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662248;
	bh=/oHoNSnK89jWi3QvlMIC3z58MUIlhsRdBXxzIKtVcL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyHx5hBeIKPu1HJcssA99wuXwnJ7oxB6TVreS+5X8qhfAXn/Cwv0chXZYDpMfKnSF
	 fao4W5wZjnsFkYdqRS5L2RNgjWxMNGU5ScjHs7MZlsZlBMnKq7i9Tb+G/ArGx627Kz
	 F8hmn66b5/d40gQ6rH9RODVk4jOtr4ISDvhQzvLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Walters <jaggyaur@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0320/1276] Bluetooth: hci_core: Fix UAF in hci_unregister_dev()
Date: Tue, 21 Jul 2026 17:12:43 +0200
Message-ID: <20260721152453.257463026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index e96ccdd7ef15e7..6800bb56dc398d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2729,6 +2729,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	disable_work_sync(&hdev->tx_work);
 	disable_work_sync(&hdev->power_on);
 	disable_work_sync(&hdev->error_reset);
+	disable_delayed_work_sync(&hdev->cmd_timer);
+	disable_delayed_work_sync(&hdev->ncmd_timer);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.53.0



