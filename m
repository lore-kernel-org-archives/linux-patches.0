Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2B8341069;
	Tue, 16 Dec 2025 11:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884176; cv=none; b=BLiR9aUKcoce1tifQZBEPIpn2ZJj7Km365Z7twiAUn0y3KY9BuXYTAGIcxV7Ywo+iZD6zIZSeb5ddzBkKiqvWV0XFn/db6/96xEcbUnY6ANNW48WBclqQnLKblDEYh7ToQ3EgjaoWKYwQR82xeSw+V7QTPE/5BEbJi8/6HckEd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884176; c=relaxed/simple;
	bh=7gIG2grRrRud4HU+CXsohF+Y7NFULwyGJ4jerROMLWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esvvF+Y3naEeIehp033MTjsqfoHPSIO3oPBMt2zzC3pAKbUDsc57th2/Flgu/woTqaC8XraPc1tJ7zbN5vsulAPRQ4Uyp1hFyEV/ZFnZHat3O2fEBGHpsxINEcWhtDMvzE5UbQeRPL5AQziOj8VfSE5ZAa66KBXXilxEx/z5/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fqp5mKbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fqp5mKbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9EBC4CEF1;
	Tue, 16 Dec 2025 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884176;
	bh=7gIG2grRrRud4HU+CXsohF+Y7NFULwyGJ4jerROMLWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fqp5mKbIFPAmQnHM7NrkR5WcfEtbHSWoCdT3f4d5ACdlIeZWyq/L6DqrZCMVx5GtZ
	 07+Mt2sQN/lBXRLK3l0wGGEIdDiYmKCjXea3jSiGf7k9ntH64fuCaW3AxTsk7jBnhz
	 XgCuc/dDAENKYHrhMGAYtbbAJg08O+1GeKSslcnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/354] drm/panthor: Fix race with suspend during unplug
Date: Tue, 16 Dec 2025 12:11:22 +0100
Message-ID: <20251216111325.090135121@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 01dff89bed4e1..e36d414044e02 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -64,6 +64,8 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 		return;
 	}
 
+	drm_WARN_ON(&ptdev->base, pm_runtime_get_sync(ptdev->base.dev) < 0);
+
 	/* Call drm_dev_unplug() so any access to HW blocks happening after
 	 * that point get rejected.
 	 */
@@ -74,8 +76,6 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 	 */
 	mutex_unlock(&ptdev->unplug.lock);
 
-	drm_WARN_ON(&ptdev->base, pm_runtime_get_sync(ptdev->base.dev) < 0);
-
 	/* Now, try to cleanly shutdown the GPU before the device resources
 	 * get reclaimed.
 	 */
-- 
2.51.0



