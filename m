Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C2B24CEEA;
	Sat, 12 Sep 2026 10:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210468; cv=none; b=m5alxnzpLaE9xNCdU6mMv7ZGusxrDSYPL2BFId3FWznJv1XWEzsNqsaYK2NU0H9pT3tfM8l1MfV5h9fu1PnJMRLwz6To5a59Ar+Bi/Ml8AKyq2QjXw1fMPw4rFn4eAYwuaIToAMwKNaXJqOPl9OT79Pe6tJQAbXzEsT2TKlzRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210468; c=relaxed/simple;
	bh=cw67qWU3Unfls6vyFVWTiDg4HxBYnBcsxjxGqr1P+FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY2SVM8d1vFZ62RCy8HBU5/tdsOARpiXk4Oj7JxQ4jj/bc4g3+qMNOcJ3+2/gspE0TYp8wsLoPDqq+3Zpd76EzOq/UI5EjUd492gCxQxjN2nRcLAwVf8NtKVD68ko2xAl87mok+913UrJGPMOYs4l3dZ0M3JdUIId9Wq2AOaSy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5Gf0vwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5Gf0vwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA631F000FF;
	Sat, 12 Sep 2026 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210467;
	bh=fOCv5Bw1X5cr9xTicjdMIfjPpETlgzCxqTVVB1AlZ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5Gf0vwU3tqkiJcev8tm7TkwUD0ZPglPzx+TNM3Qte3xZvOvyeZ0bbx6N9R5cQ+xP
	 AmKJAbmOMyBBhPnEedloNOZFbN+sJz1nlRQZi2i/pzgkQ2uX3FsL5a3a5tKgCPmtOh
	 282hRkKjIItKdU0JZqTgWdmMf0p/5vLZDlACqSF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1032/1518] Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:53:21 +0200
Message-ID: <20260912065646.796298067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b0c0b37940115383e7ea65d4d988f9b9e613ab92 ]

btmtksdio_setup() calls pm_runtime_use_autosuspend() when runtime PM
is supported, but btmtksdio_remove() does not call the matching
pm_runtime_dont_use_autosuspend() when removing the device.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call in the remove
path before restoring the runtime PM usage reference.

This issue was found by manual code inspection.

Fixes: 7f3c563c575e ("Bluetooth: btmtksdio: Add runtime PM support to SDIO based Bluetooth")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index d262f60fd3917..7b5359ebdc648 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1481,6 +1481,9 @@ static void btmtksdio_remove(struct sdio_func *func)
 	if (test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
 		btmtksdio_close(hdev);
 
+	if (bdev->data->pm_runtime_supported)
+		pm_runtime_dont_use_autosuspend(bdev->dev);
+
 	/* Be consistent the state in btmtksdio_probe */
 	pm_runtime_get_noresume(bdev->dev);
 
-- 
2.53.0



