Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B7014A09A;
	Wed,  5 Feb 2025 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763671; cv=none; b=cvBF0VGRCVlPnLzsGu1SGScKgO01QBl1UiNbETVO/CDJkteXGyZufrTxYZ3znibpkB2X4bAyqd47/UbgaPDKo49ovHR1MrFwvV4kP00OGr8UlS8hImbI9TR52etslqSBuCDzqhzXoKQP8AzQ7wvQjcjWgYGQCrZ6jF9aFEorldY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763671; c=relaxed/simple;
	bh=w2vz3HtAAbm24u1NEbQ7xPfirr0/uREg46lIxgCtEBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c61hNixqSmEDdQ4GDkr2j7p2PH1f9XV6132OYjknN15lv0PFwMZl2TDMzOMwc932P8D1iwFhxEfls0TDTXIPytiPgldH609zRnnlREi68/VNlQ7Z08A8oQlwGwQ/kzhmO86ZOg0W7z3jid/UIzQw9hOoZSlqOgF59okbwHJsxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHrmm75M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHrmm75M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02864C4CED1;
	Wed,  5 Feb 2025 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763670;
	bh=w2vz3HtAAbm24u1NEbQ7xPfirr0/uREg46lIxgCtEBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHrmm75MwlxYzLwD9G0UMpSAijV4+zFe9WBOpb9C/zZDHZAVN14hStvAXJTeLvRw5
	 j2p79FCFwf02NE0ylfpNeMA3iUqdGG7ss3pzuO2cdo73fToGoU4UVb5BXvV4+unUp/
	 N8lPS7zqQJEHVdQTQO0qcA5Dnhd3ZanCdfXE3jPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Adrian Larumbe <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/590] drm/panthor: Preserve the result returned by panthor_fw_resume()
Date: Wed,  5 Feb 2025 14:36:41 +0100
Message-ID: <20250205134457.018097557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 4bd56ca8226dda6115bca385b166ef87e867d807 ]

WARN() will return true if the condition is true, false otherwise.
If we store the return of drm_WARN_ON() in ret, we lose the actual
error code.

v3:
- Add R-b
v2:
- Add R-b

Fixes: 5fe909cae118 ("drm/panthor: Add the device logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Adrian Larumbe <adrian.larumbe@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241211075419.2333731-2-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 6fbff516c1c1f..01dff89bed4e1 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -445,8 +445,8 @@ int panthor_device_resume(struct device *dev)
 	    drm_dev_enter(&ptdev->base, &cookie)) {
 		panthor_gpu_resume(ptdev);
 		panthor_mmu_resume(ptdev);
-		ret = drm_WARN_ON(&ptdev->base, panthor_fw_resume(ptdev));
-		if (!ret) {
+		ret = panthor_fw_resume(ptdev);
+		if (!drm_WARN_ON(&ptdev->base, ret)) {
 			panthor_sched_resume(ptdev);
 		} else {
 			panthor_mmu_suspend(ptdev);
-- 
2.39.5



