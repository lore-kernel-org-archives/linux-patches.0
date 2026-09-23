Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F83C49BD70;
	Wed, 23 Sep 2026 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173221; cv=none; b=G1reioXpSQNrYRBGj4SE3rr6wAiYRlYZb2h8lbJ43uqnkMiRZLAQuy6LOH7Es3G8BSv+WSNgjgEljTov/svTRWMapHz8+DIgWGw4uwqFOGInQFXMySo9s+Sp8ul4AUZT0+aOtal4YT4aNtzeeVCseUKyBEcbVV0NHYADcYBUTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173221; c=relaxed/simple;
	bh=iHGKvhaPtpyGCnYPxRLDvp+9vOWauDZI10PRjx2QpSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z23J2150bq+cIvGotwqy0GU/GvhLE30pKDbdN8tukeC2qcKCC4Iv47D/UvcPs/qJgQBsbhPqWXZF0jcZR0s2n09F6kbBtBobACjjBXKqw3nKgYUitiZWU8V41RuA8956IlHWcA7ZUC3KQ8Vp+BeS3tpkqYIqYRuMOO7ydcEG7qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV4Ocgna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV4Ocgna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39041F000FF;
	Wed, 23 Sep 2026 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173220;
	bh=Gmw8NVRuQCd3VyehyB7go1fN4+elyb3rgOIbH2hDBzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZV4OcgnajC8gcwCu19PEPdDmCfysAkYpDnNV4Ydc2QkN6KieLpiYNeVze37mUQ257
	 ijCo9JMkynHigHrn3vejjJZP7REgZIG9axSqzXYeH2hUDuH3vFZ/qyGn88wqfS9s/r
	 pmtNViy8sYBFc/2uf49ptI5MLZc1C0AjKu3kdJ6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 177/438] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 23 Sep 2026 16:03:18 +0200
Message-ID: <20260923140649.353256264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7fab678925d19..a15ae6598c665 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1262,10 +1262,8 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
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



