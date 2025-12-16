Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AB335CBB2;
	Tue, 16 Dec 2025 12:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887318; cv=none; b=uufXCu/CUz5pXfRLjVws/nBmIrigQd8Rgj0V9oyGvoDw++Nr/AzXMTz8XhZZLiDZ5YhXJw6UHwYLkTzB8i6JTDuwyGjZ3zd8uSMRn/0jHX6TJnadaA0Qb7Mg+3BqFDnI60wGHcavo5F3GoS30mfX5xN92qC5WKQ/O5kQkMnyC0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887318; c=relaxed/simple;
	bh=R9UJ24gZ5AK6CROSITZymQm1wHhZuDzMOJDVkUjD0DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKISpnU42ifn2O758aFUfs6Ke6Kh97UEM0WnDXrio2muHcqFQxM5HUfNfynPuBU821o72ZPNJVdMuhRwqolYnOuFQoEOn9vwiFpd18B+yebEAxHCB0MEJhyhF65/1yWa096pFdLaFFs/q61r3g4hVslgi8qq9uqnBY13Cpwl68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbgxex0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbgxex0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913E5C4CEF1;
	Tue, 16 Dec 2025 12:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887318;
	bh=R9UJ24gZ5AK6CROSITZymQm1wHhZuDzMOJDVkUjD0DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbgxex0bMGBCDz4jIgfSi7N0N+1ZSLLuckl34i/DXX/SqcrZHAyu9u/FYq6/Bf7a6
	 PxdItrVzTHeDhbAiobEhnC85L1g7Gs1YrZa/fZ2MU4mhDSDQNJJAPib1kHJvFqSguq
	 sZAPlkjQxkdRVWEhKruBUDjXZsXSVfgTz9bRn7+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/614] drm/panthor: Fix race with suspend during unplug
Date: Tue, 16 Dec 2025 12:09:20 +0100
Message-ID: <20251216111408.363520520@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 81df49880bd87..962a10e00848e 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -83,6 +83,8 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 		return;
 	}
 
+	drm_WARN_ON(&ptdev->base, pm_runtime_get_sync(ptdev->base.dev) < 0);
+
 	/* Call drm_dev_unplug() so any access to HW blocks happening after
 	 * that point get rejected.
 	 */
@@ -93,8 +95,6 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 	 */
 	mutex_unlock(&ptdev->unplug.lock);
 
-	drm_WARN_ON(&ptdev->base, pm_runtime_get_sync(ptdev->base.dev) < 0);
-
 	/* Now, try to cleanly shutdown the GPU before the device resources
 	 * get reclaimed.
 	 */
-- 
2.51.0



