Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE85446D093;
	Tue, 21 Jul 2026 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656751; cv=none; b=hoWtprU1QS9DNoFNIP31Pe+XFQYwPhPa0+x8teb5dowDR+oNRyhot0p96UfVh39S/Rr6WTHr9AdE+ZDn7f+PI+OQ64sov1fXVxK9cYn/wAbZ9ZB5QjwuooxOH7lv4RH76vyAe7ML2QLSvpUdYBwFxVpoeqGWAfU0PN7I9lntV0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656751; c=relaxed/simple;
	bh=CvMl7eyN0xC2Laoeee431w6DzbR8BfCmveUcTOTOqbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkHxlWAj1nsnYJrA2lkMoQGvQ/PjTrdvN5LiHAPkLZlIY/CESjdxF008BBMZVfEtU45P+tIBatsb82R+46oyeglPoDHY9KnGF7A+ZamLM0W4tMt2CCE6pW/hbRbpynpqkQSgDSNIAKzwiJGEjfn7ex5DWHggFcJPPOWuosFBNlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUHgTtq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUHgTtq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42BA1F000E9;
	Tue, 21 Jul 2026 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656750;
	bh=jF2/SEm2uasZJoA7gOdtsH18IGnbOMBdo1z+Ogu60CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUHgTtq5LBdXcUjniNA5ZTDHyCszAZtBbe2LUf7MmmbUrNDhgdFXj+9TOUmJgDL8B
	 79KWJxR7abKpDoJwHUheRhawWg9lR2IqTn1SeJ7BSisy/2csEiQdegQa2epy4OIbwp
	 7z9mkicAp2w9W+up74gvYlgAkUQ4LXWVlTs2RquM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Walters <jaggyaur@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0468/1611] Bluetooth: hci_core: Fix UAF in hci_unregister_dev()
Date: Tue, 21 Jul 2026 17:09:44 +0200
Message-ID: <20260721152525.845269935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0f86b81b39730a..a1d7e7985f76af 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2707,6 +2707,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	disable_work_sync(&hdev->tx_work);
 	disable_work_sync(&hdev->power_on);
 	disable_work_sync(&hdev->error_reset);
+	disable_delayed_work_sync(&hdev->cmd_timer);
+	disable_delayed_work_sync(&hdev->ncmd_timer);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.53.0



