Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC668348C6B;
	Wed, 30 Sep 2026 19:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796246; cv=none; b=iKT63uNjS8G8K7p0T3XisPcSYCHy0thwdIaI5g9jz78eWQpY59iuFrFTVR1stR/5BVAybI34lxh5BaaQ03T2fs+YGabCU5MWi2pjYFiz1L6L1dJ+Rr2fbO3VC+AJCSU0aFi+aAVc11KIGGu66S0s2yK0h1uc8o1S5z86KOYo1Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796246; c=relaxed/simple;
	bh=b3BQf2FfS0vnbbr4Q5KVBZmeZ7o0FRmhYveOmERCrKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do0hVsyzt31A0QLXUv+wvymC4KfXogCh8DOm5o2sIRzF+0AOVITQcuVp+6Tj0k4aXchPDcU6GUg7J9wZJ1mNejXkMflqAEZ5ZnfpSumbCjX18ORd2YgOcDpPanrw0k99VkPQFAMAIsSrG+mIBb8GwywHtydb+okYhkHlfb03lLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWkmipYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWkmipYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535111F000FF;
	Wed, 30 Sep 2026 19:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796244;
	bh=4I12Z/6bFlTzsThPKEOTfsuqBIiVZUCYLOqrlvkYlnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWkmipYck3ZdO9ihsrvgnef2balZJ4PaHj3jbI1tSks0fnO2fLsanpV3Ccl1x1vHl
	 chR/34by7BbTeHyXBnf1UUQ0tR1yB76blCnTmld0Z0n5du1PaHvx/ttb8XtNr0lilF
	 Wx937CAe/hipB35qIv02tZGD7UKtvd7ni/FpsYEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0808/1193] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 30 Sep 2026 17:24:52 +0200
Message-ID: <20260930152452.196235328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index cd3275bc3ce08..65dc5729a1f8e 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1220,10 +1220,8 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
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



