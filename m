Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC93C44064A;
	Mon, 31 Aug 2026 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184982; cv=none; b=cUdp4/zIahvsJBJrbr9aWKhJntkr2vXidxcv9t4C6wlpxfJaGYlMJ0HksPLobJxI4DcQJY9El1fAs/xQ7pYjbqZdgmsFMXvFAVbrmGnb5N1IZrDHmeRfWM+3TTXQNhZaJyAMIfbgYub9Rs+DD7y0RgcpRSQ1PVdVyc9rn1D2xJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184982; c=relaxed/simple;
	bh=TU39EiD0Tkrvb45gnAY61lpwcUv0d0sxIqmyuZ9Byqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezVruEVUdXiX9/KCNYZW4vydgCN1omZ07RmHq7AFj002IcTL3NCo9ZZTQtFORkh1kbToUnIgNHXuHWiyCLifW2kjC34CFKRcjEyLyDW4Hq/4cUjd7/eR2i4eeZL4HGEJbs/WZC4JXuEpOkrpXSrMAlJ+VO5y5EJgdHXrDO1up6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecW+jfqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecW+jfqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7581F000E9;
	Mon, 31 Aug 2026 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184981;
	bh=WHriFXDee6hJmTuBQBAG3KTxzJ5RxDfUxkZTwvAHrqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecW+jfqs+J4ckyL/y4xrWBC1y1/RJG+Ymd2dhrZYJpSgM8WmYDbS9JnPe9FMkFDSl
	 5imsCDWisT5jUL+5boEDnwLO3LJUbATAO+L8jnkwFEqY+UBEVpmJPDOCDQCtobNytf
	 SknjQyOy2/6zZxl5z+62Ha7hjHGj4w5IjaKVmobI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/69] Revert "PM: sleep: Use complete() in device_pm_sleep_init()"
Date: Mon, 31 Aug 2026 15:34:46 +0200
Message-ID: <20260831133359.158056026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

This reverts commit 31064374d24dc18cf132ffb9d350f318f3274b06.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 3d3e710f71733..9cd0a837af425 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -102,7 +102,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -239,10 +239,6 @@ static void dpm_wait(struct device *dev, bool async)
 	if (!dev)
 		return;
 
-	/* Devices with no PM support don't use the completion. */
-	if (dev->power.no_pm)
-		return;
-
 	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
-- 
2.53.0



