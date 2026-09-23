Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CEF4A2058;
	Wed, 23 Sep 2026 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174550; cv=none; b=psh/VlpCjVK5AeRtyZ/qO8IO6/sjerMtyfWSNlunJrKLy8Y9ZtLNyMRewO2ov//A87S9RukTJ14A0GsjfRfcNGG4ULOxDaabAt6IYZPhT0rfV3lIff/qLaMCiPJd4varWwrdafWuy7CFHhIblIWzKYcYQYBARGDt3adeMxDQo2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174550; c=relaxed/simple;
	bh=9KyqL2XoEaS3asE7sDpjN+dkctCiWlkLsSlXvojwvpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc/5vc8YFF9FbBguhfV5A/jk3xj7zTFIUAZ1hgSaKKN7sA00FKjvXRrbMpYsnQBPBA7VimO7llmlC2uCD5qv9LdGH5HOl3dtAYMQ9PUSWtDQu5MRHAzNvpKWLIaMqtMX5ty6Ocu3+NG856MPnI7PJ1N1kf+/tdsmR49RLECQQZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+nPZ+X4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+nPZ+X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807551F000FF;
	Wed, 23 Sep 2026 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174549;
	bh=NgcRjSNXOltXDVIHwjHMdM1ynIPmsIVyJFXo15o7/jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+nPZ+X4szdeLQIIvINUz9hMFKIPensjGp9ww7tB9PBnAHxjFcXKPRvjNKTrd4qne
	 udnp79MFhsXBN9Uz77uqGgiTl0p9ggtw9jjHZqW+M0bGRB2tiWKt95lwfTvk5Ar6tt
	 YMpU0+ofpL84xLsrHpITt+hJYOHZUxzvRnoRYJp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/398] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 23 Sep 2026 16:03:45 +0200
Message-ID: <20260923140647.345672338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index f7dcabc11b859..a9ca2d37b8c5a 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1245,10 +1245,8 @@ static int btmtksdio_shutdown(struct hci_dev *hdev)
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



