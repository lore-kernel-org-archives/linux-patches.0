Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0A750EC11;
	Wed, 30 Sep 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783587; cv=none; b=DtPKOvTDRajnYLRtPoWnKUru9jjpRyAyHyr+czY83hKg9zK/IVLMJciuXfEZYu7wFA53CFJlS7c66EclroqxwuBHCY66UF6pp3l0lBV4LMxzDt1yiguKUPDZd4v5SQWP7VrhSdUNEFhLEj4OULqezf19IPwdE4S8Fxe6TkFTVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783587; c=relaxed/simple;
	bh=5bAJRZKkVLwJVKh/edbVADd9QBDaaQIL+L8w+UKvEKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz/bleTYYEhtdci6+Pyb2fKdOvmyQdzsYDsRsHbuGU0YDSV70QvGadkcxoBxWjdQZmO+2XkMFtG1/zJ8lp4U+kbPelP9TVoelbnclWQrCmO5byvNqpMNF4fuIuWQTmymrSOsHTiG3nOdwL7LjRXQ3AH8vQKQ0GgzdEbkvurmf2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os5DUQAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os5DUQAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B601F00893;
	Wed, 30 Sep 2026 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783583;
	bh=HO+Vd0Cit5esyKrZm6ISW7l1URO1ggytWpZWCWnABvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Os5DUQABpGWlJ4q9hrmMELLe3/tumtHYYkxsoZI1tXvGkvC4F7eq98DJUJBS4waSz
	 dAtsn4ymYXH2jOsP8dWMxzvomJV2VkkCV9MT3ius7GVDmb3rvUG+ncEh73QHwZPuvL
	 Kx0oaJ/MBvtHLF65/EZGNaBeFFES8077wdrQIZi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/595] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 30 Sep 2026 17:24:58 +0200
Message-ID: <20260930152356.387984919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 971e9f6c36bbe..ba6e492821dc7 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -897,10 +897,8 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
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



