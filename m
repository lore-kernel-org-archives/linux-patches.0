Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7564ED1A1;
	Wed, 30 Sep 2026 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792000; cv=none; b=LnpNzNCNq/7V+s+EfHKBsLQz3UiRJxlQwimJUVgo8BDDLV8pziOHJvTw17AUlxuICiPCg0YPYo7AJrdLAkrvxE2VSvt6hqazplNgzQqkQlvAT4fWBqGiPnxGHRlEPcGcUmG/w1784L5yhqeaM4zz6aLhbKl0RYK3K8cMtCChx9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792000; c=relaxed/simple;
	bh=wSbwBn+WhPlnIRJJ/+JRrP7l8cA4gcomFJM5/iDvI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgOVNAsWjMnR/PbGu+2AiRXNkYDxkg/fNEottZd8YbiKI6HvRzOyTmBfQ0s+83rxwIGY+qkZrMlWyBOhvW43TrTyOtGlZwW86E94pWgzdEHo5P3bahLcesjrukAKM+n3LU1Sh4TVYV4Fi1KGRfplQ9V5QYkkGLsBMsc4g87SCE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxHj+5Gn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxHj+5Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789961F000FF;
	Wed, 30 Sep 2026 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791999;
	bh=vpgTpjl7L3u8MnOUn3zXXLfEX7Ixl1FrPSzaccbGX8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxHj+5GnCU/NpynR7b59BS0tLh7JWbW6hST3MrSZ/ETFQSHYtPo+ihkL1LpgwbvLD
	 WVZLyxUQiW4WPugpU70/ztrXUqYFmLt1FBiHpUGZLja4d5Gazp/VluWEeQy/CoKiR9
	 KFnbCNLhWVGzPx0IhFVfexV0pW/FfU55YjNdOJbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/752] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 30 Sep 2026 17:26:09 +0200
Message-ID: <20260930152409.060214439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 506cb15816d7d..f6940bce8e194 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -898,10 +898,8 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
 	wmt_params.status = NULL;
 
 	err = mtk_hci_wmt_sync(hdev, &wmt_params);
-	if (err < 0) {
+	if (err < 0)
 		bt_dev_err(hdev, "Failed to send wmt func ctrl (%d)", err);
-		return err;
-	}
 
 	pm_runtime_put_noidle(bdev->dev);
 	pm_runtime_disable(bdev->dev);
-- 
2.53.0



