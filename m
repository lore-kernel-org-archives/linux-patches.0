Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C9F33C524;
	Tue, 16 Dec 2025 11:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885530; cv=none; b=FHBVI7aDbbR96EiJ+F9Ky9gE95xt236bCtOElFIeMMnRz7Jdt+c+3c4iY9V78dH7H2VZkTr17uFBWtbACfp+uQH9XUlhAeRsf3pP6745KFsZTtKK/s6G/bACMa3fiWPX3Kb62fCxiGX1W0lfHXXld9DixZSB5vBlYUqWds+ceAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885530; c=relaxed/simple;
	bh=J56Wt3e1eZIzTuHsWqkvh8qNUqg9Tmp68GeNJjfg5Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utCcVpCE2Q5WFToqjk6UtxzFyEpkBHztnzXYbl0n8mbPoQcX/Bg22uIJU+Et4rZuhLC4XW407iyobyQkopZWEJoZDNqpgfA373v2x51RzroIVmxp1Cf5JugfD2oNHYDswbWBtIJGlRM8gfKXeWOKeieWVRuYhsxj3QU7Q9lxraY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0ZFcvdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0ZFcvdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E14C4CEF1;
	Tue, 16 Dec 2025 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885529;
	bh=J56Wt3e1eZIzTuHsWqkvh8qNUqg9Tmp68GeNJjfg5Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0ZFcvdCtN+Y3n1JIc0IQKkBZSOcTtRQmE50r2juCMVWyGyaBiKUPxCNqNq5k7JG+
	 i/bTcAECA3nLQzf+vRD86D69A6J1Gg1LN2FZ1iZfu0nSQg+fCnSmh9QOd06lTXEnlj
	 0r1cj9NbaLp5vnV4BbVa0ChlONOxWvm9srbbUYQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 165/507] drm/panthor: Fix race with suspend during unplug
Date: Tue, 16 Dec 2025 12:10:06 +0100
Message-ID: <20251216111351.496920362@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ketil Johnsen <ketil.johnsen@arm.com>

[ Upstream commit 08be57e6e8aa20ea5a6dd2552e38ac168d6a9b11 ]

There is a race between panthor_device_unplug() and
panthor_device_suspend() which can lead to IRQ handlers running on a
powered down GPU. This is how it can happen:
- unplug routine calls drm_dev_unplug()
- panthor_device_suspend() can now execute, and will skip a lot of
  important work because the device is currently marked as unplugged.
- IRQs will remain active in this case and IRQ handlers can therefore
  try to access a powered down GPU.

The fix is simply to take the PM ref in panthor_device_unplug() a
little bit earlier, before drm_dev_unplug().

Signed-off-by: Ketil Johnsen <ketil.johnsen@arm.com>
Fixes: 5fe909cae118a ("drm/panthor: Add the device logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251022103242.1083311-1-ketil.johnsen@arm.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index f0b2da5b2b967..1c0a9337404f2 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -82,6 +82,8 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 		return;
 	}
 
+	drm_WARN_ON(&ptdev->base, pm_runtime_get_sync(ptdev->base.dev) < 0);
+
 	/* Call drm_dev_unplug() so any access to HW blocks happening after
 	 * that point get rejected.
 	 */
@@ -92,8 +94,6 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 	 */
 	mutex_unlock(&ptdev->unplug.lock);
 
-	drm_WARN_ON(&ptdev->base, pm_runtime_get_sync(ptdev->base.dev) < 0);
-
 	/* Now, try to cleanly shutdown the GPU before the device resources
 	 * get reclaimed.
 	 */
-- 
2.51.0



