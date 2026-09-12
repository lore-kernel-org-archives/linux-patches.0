Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065DC2D0C94;
	Sat, 12 Sep 2026 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217702; cv=none; b=OvjQxVlCQ1PgTwjGoBwNoSrgqK4Z9I1OYleTzyr/eXxlxu0ze6Rib3fpqSSzpw3x+Q3lolO7+rI/j80mYlJ629poF9Of5bE/ehw5ICuXqLDLTzRBF6v2M5ETDNj+OBxVxydR4m/JMHHEW1vZZvjOKRZPyk4scDGbv0TGQnL6tnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217702; c=relaxed/simple;
	bh=/UhLHboNpW/yr7+W/ClesubAWG63hvEEV25+SANGXm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMkSlb0G54J5G8wCl4rU49DYCrv2XoyMRnNK315HqDtDbu5FX4+gSAokMQYDMSblNpzBeIKZFONkbTXQH5N5XCYheAXhvKFF+Gb6zbZG1Z2wipwYAO7j570Ih3wEKqs0Ly2+UihFFQGmZajpuIrwuR615ji/uj2820FF27fdULs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zceh+9X/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zceh+9X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F331F000FF;
	Sat, 12 Sep 2026 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217700;
	bh=S2rVV08+4uF8rBsmqAr4SIfkKWlowlVStkRYlDH+WNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zceh+9X/jQRnDIS5AC5+YbtHVCfoFRiyqGCXIb/QkxTgxjFH8DKeyd9Npym5EMNXQ
	 +XoCM1bZ08h7DZVbgJ04AyziogieuuaVvK7oxQBXlsGV3Bopx2wutABofbKhEYzJcO
	 g/4Ot03gr49V2c5hB45qA5+jbLaultjs7w5jnGQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0993/1376] Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:56:59 +0200
Message-ID: <20260912065629.697289296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index fd55ad9308c8e..1123428a1c245 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1468,6 +1468,9 @@ static void btmtksdio_remove(struct sdio_func *func)
 	if (test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
 		btmtksdio_close(hdev);
 
+	if (bdev->data->pm_runtime_supported)
+		pm_runtime_dont_use_autosuspend(bdev->dev);
+
 	/* Be consistent the state in btmtksdio_probe */
 	pm_runtime_get_noresume(bdev->dev);
 
-- 
2.53.0



