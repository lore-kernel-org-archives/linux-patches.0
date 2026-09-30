Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDB5187C2;
	Wed, 30 Sep 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788471; cv=none; b=Wuubc4qbka3uoJrLH9TJKOwB/OzXxybnObFyi7IsyRNrhSjxdVOduQuiMeEMeD4CfBpHygR+Ek5SIPQ0CzKHyBoQjVLhR3a5HT1o6owCuCZpzogRaadn+LxKj1q1R0nkCweKek/ZCY01PWX+jOPjfhlr4DA4qOMQ2vnehMbc6uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788471; c=relaxed/simple;
	bh=EnI4Zwe4PaJO7kahA6FwWW92da9kSHiNpSw3r1SOtVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3Q35pQ6aeRBMA2F3RT0hHdWE2lAOW4qGXznwks3dLmiuogS6TenPnTi8+5jIQoH2KXMM1fvDJTRHfUFSIs/Kp9ekNoIvx6PNYMyMcoLxZD6f4GwTUP1/XqxbZmo1pbyeUJ+evjNqDdfJzDCn0gIBwyX67qu6xu4sTiUxkmgyjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn4k5sgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn4k5sgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85AC1F000FF;
	Wed, 30 Sep 2026 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788470;
	bh=vC81ddxeRaohcbZfdEXbddPJC6dqfoQk4tcrhWDEquU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fn4k5sgjsP6P6bB48nZadUFywaUfmH5ADWJ2/9JeHbsYo+cTXiUiH1R2Ycc/aZOhN
	 cfwY06jmhKC1x3/mzz/Hh5g4XQQ4h+sOznHHOgscgDDNof6g4Sh6NXyxIEMOfz/Chb
	 ZMZRSa9b0mHFv+fC39S9vF1lF+mqNvYariziJgPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/877] Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown
Date: Wed, 30 Sep 2026 17:17:27 +0200
Message-ID: <20260930152417.664903652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 0e8fb01981432..575bac139715b 100644
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



