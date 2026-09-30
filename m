Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12548511221;
	Wed, 30 Sep 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785914; cv=none; b=rLFwBz2qG6K6PVI+HLa22mPZjS3axvDllNHM+kVW0JZZLJZWukWx2IoKFtnH6XAm3ox8TEu/tj5+K1aPGhwFQl/oP/E2QUEAWVwDnipyS8hVgZGzojbCt2n3RCZOnl66LLmAZgna5udRdhywlBwLS/YtLwHtiVc9zv1ESRN3qPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785914; c=relaxed/simple;
	bh=K/HAV2xnM0vaZqhRyY1xa2F0Xh3/ZDAhuV6vNCQNA+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2fWaoO9nPjD7CtQbxR3au0q7PaUJy0nCvo8b5DIhG7XdqrBxqNrIV9k8e/CFVxRHd8j8EBc8y9nd0BLtcL7maNCY4jRIy21PbpR/hSGT55PeLZGNsHSeoVqMfr5l+y1JSObPuvYcZeIwqv5wWwV66HpbHeQFndRjlYTNmwPMj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AxFCLYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AxFCLYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEE21F00893;
	Wed, 30 Sep 2026 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785912;
	bh=bbNXUPaqa++3BT4Q1WP+htEiXJAdSPtrkfqzvgLHoWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AxFCLYC/oW3unnWoTt6ENAPf8OyjHkjZKGIaaoVWfLsEWEHktxBEtRLOpWx4TrWN
	 cZLxP/lErqmr1buMLgGbJDmBeiD3sUtmSVk9UhUADK+7Dy1Zc1hQVn/4EJ7tJtxD84
	 XfHf9awHuahc2m5vxbq9ujK1Rbwz8A+6qgxRA1kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 675/982] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 30 Sep 2026 17:23:31 +0200
Message-ID: <20260930152431.261356291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 7b60ee5f46f2ee329de661f7c68b6818d8136220 ]

In btmtksdio_shutdown(), pm_runtime_get_sync() is called at the
beginning of the function.  However, if sending the WMT function
control command fails later, the driver returns early.

It bypasses the corresponding pm_runtime_put_noidle() and
pm_runtime_disable() calls, leaking the PM usage counter and leaving PM
runtime enabled indefinitely.

Fall through to execute the PM runtime cleanup block even if WMT errors.

Fixes: 7f3c563c575e ("Bluetooth: btmtksdio: Add runtime PM support to SDIO based Bluetooth")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 0432ae9bc6601..0fe86fd809512 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1216,10 +1216,8 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
 	wmt_params.status = NULL;
 
 	err = mtk_hci_wmt_sync(hdev, &wmt_params);
-	if (err < 0) {
+	if (err < 0)
 		bt_dev_err(hdev, "Failed to send wmt func ctrl (%d)", err);
-		return err;
-	}
 
 ignore_wmt_cmd:
 	pm_runtime_put_noidle(bdev->dev);
-- 
2.53.0



