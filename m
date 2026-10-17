Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A293BF684;
	Sat, 17 Oct 2026 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260521; cv=none; b=eQv3TP1MNwwl6UmTwkie5En+wF0CrnVYsbDD0FovNiW1eUi1rQl4gscJz6R9NSiMcuiP3KZU7IM/lGnBffQ/EuQFz9reEpoMnxRA5+G/HTC/OL/CFRO7IS59n2/oiwgaZAM/SN/YoAJowYve9tFeSuHtjpkffax5CF233vpJit4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260521; c=relaxed/simple;
	bh=x1Yrixba32qhbL+uy5xheW8LCVRe31459QeBRyFxfd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxx1vJXO71WubSMKaJfHU61CC6eG1VNN3eu/FvHLB5iLHQAeGY1QxV9+f2WmkOHTNfSKUf/etQEP/9DFyTvayYv90k/+aX82CyIgygLAQOHH0WDK+asCv5JYlu0CwcyNJY8L95sT123Gphwjr+o19Yi8IUeb7LSICGkP+QMrDSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhtI8+/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhtI8+/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6921F000C4;
	Sat, 17 Oct 2026 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260520;
	bh=C4Z6tHazkYLKJWdEm+E1pYucZxjXQBUuny6jJkrrEy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhtI8+/Wj3HTSx4kBmSAfNmcK5/80Tse62emxurXdZOM1x0gDqPxfk7zqGiFvtDxM
	 qHr8YPgTj8O74yhPkefu+nTQdYqV6y5WNSaYqKcBY6z2eXtZdCCzyV75hDmRW42Cqf
	 GFRx+Fez6RrF/3ssK+P4QhgK1enyo5n08UGHngPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Walters <jaggyaur@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1571/1674] Bluetooth: hci_core: Fix UAF in hci_unregister_dev()
Date: Sat, 17 Oct 2026 18:04:03 +0200
Message-ID: <20261017160511.428077663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index ebbe16bdc3e20..fcdca0c0c8cb9 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2713,6 +2713,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->tx_work);
 	cancel_work_sync(&hdev->power_on);
 	cancel_work_sync(&hdev->error_reset);
+	cancel_delayed_work_sync(&hdev->cmd_timer);
+	cancel_delayed_work_sync(&hdev->ncmd_timer);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.53.0



