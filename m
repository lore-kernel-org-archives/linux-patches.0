Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101521AF0AC;
	Tue, 15 Oct 2024 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997853; cv=none; b=oVZvlxi53HwFyYnlA7U3mXtfIcniI2xKyoUR+0oU+mccDBF7KZP+iWNxK1yxZ+AXSHKlC3cLet3uo2s7xy+ksbl7UiuP3DjTHHJVKNMObN1Lv/VEZ64LcEbXF914+ITrEM5Y3kfeNF0uyvqlK+2QgIGVatvQslNnaktTuyPE07E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997853; c=relaxed/simple;
	bh=V9zhEj7s03Y6pERRkKuoL9OQjfeM7Vb5FnhxeAd0v8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERk8WVmCwqB6uQGE2T+9ZRkkQbttql6cp9uTVgPl8z1excfamM7XRjIZQ2yaW+skqU5f/mK5/XfW96Hot97dnQJD8mvmzeaDXWsD3B4HD1+E3khR2/KU51ZzX441PeCg0QfHvR+tNFQqwq7GEh06zZcryhaZcs8bOJd43L7dB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfxaWRV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfxaWRV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D92C4CEC6;
	Tue, 15 Oct 2024 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997852;
	bh=V9zhEj7s03Y6pERRkKuoL9OQjfeM7Vb5FnhxeAd0v8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfxaWRV5Z1biWFqKNWjX2rsYfujAArQBJHJ0U0VZKkUTUTlQJWiyUzl2tvqGicO+Y
	 butjBKeXDfw9pIPD9Ci8TbWLCprIr7jwXKbUCldmJBE6QxKAWvfqiJVy+pxikSm2CV
	 zzrX9HqdSzMDdZouvFAo9Pb7m6tH6JoBnYOPqiWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/518] Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue, 15 Oct 2024 14:42:59 +0200
Message-ID: <20241015123927.608345451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 7b1ab460592ca818e7b52f27cd3ec86af79220d1 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: bb7f4f0bcee6 ("btmrvl: add platform specific wakeup interrupt support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 33d58b30c5acf..6e40a984ba7b3 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -105,7 +105,7 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 		} else {
 			ret = devm_request_irq(dev, cfg->irq_bt,
 					       btmrvl_wake_irq_bt,
-					       0, "bt_wake", card);
+					       IRQF_NO_AUTOEN, "bt_wake", card);
 			if (ret) {
 				dev_err(dev,
 					"Failed to request irq_bt %d (%d)\n",
@@ -114,7 +114,6 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 
 			/* Configure wakeup (enabled by default) */
 			device_init_wakeup(dev, true);
-			disable_irq(cfg->irq_bt);
 		}
 	}
 
-- 
2.43.0



