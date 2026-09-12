Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147A03815E7;
	Sat, 12 Sep 2026 19:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241181; cv=none; b=N5rg/VdLzTv5yBOpS32jvVE9gK6bsE+CBN1UAZZqJ92Wiij8K8uixFeujmQDjrRm7eUQ9xGwXCy7GmOCM+YAyk8VMEQrthyldAxvxcWkwoc1Fa0DVuWB3KNDyAaT6Vi2RYKPwxBQLa8DeJOwRa5SPySR/y34w0AL2rWdP6tKGy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241181; c=relaxed/simple;
	bh=H8GcFA6Q1oZyPcLhSqJX/lRT+xaa3/OXwh6yupebC/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qz4dCceZTbqAZn+R3fC25/5L6EFFUI7xL1kaX3zjUEIjQzzUeZiPiNb3wpl8LbdDEZITrc/RKpWiQ+ZUjZUV3bRJzFPc1bGV5X6hpAMeKDJZp5VX0DXQxrRpa+JlyhWikEIZSF8bYfR6sDWUHIOzzdK0isguwZe4IA9UM7bkw8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wiFIefo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wiFIefo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AD11F000FF;
	Sat, 12 Sep 2026 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241179;
	bh=BkH42djEjzHmjSUClG7V7SNjA/wHSqEu4fzp/EWRlCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wiFIefowaFyDVwBIisMTzBbNq4bYFQcXm0CNwZzjN4EOfQUCO+viKl66eIlCy/9s
	 Kd2bpE+VF6VQwI+/sTTU40ObfXKR2vj+OWpo0EsB6e3514z0+ApXZGDwSVb51wtw6v
	 a9714G5pELHhkO9nU8Xw+3UfrQoJx8Ipnugnnujg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 083/798] Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:55:11 +0200
Message-ID: <20260912065518.863391116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit dc6b7c771a963e20aedf4a21ffa22543b9837ba8 upstream.

bcm_request_irq() calls pm_runtime_use_autosuspend(), but bcm_close()
does not call the matching pm_runtime_dont_use_autosuspend() when
tearing down runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: e88ab30d3669 ("Bluetooth: hci_bcm: Add suspend/resume runtime PM functions")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -520,6 +520,7 @@ static int bcm_close(struct hci_uart *hu
 		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
+			pm_runtime_dont_use_autosuspend(bdev->dev);
 			pm_runtime_disable(bdev->dev);
 		}
 


