Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE54F510;
	Wed,  5 Feb 2025 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764131; cv=none; b=sP8YifUpbqUspEJ2PrtcLtfjPv2dAzvV2pQYp5qOvXY1hTrXtIq5MyaDWn6JoaicVAkPCOzugfxPhOh34qBapHw2FMIE3eUa4pA//s35+S7u7Qs5KjSe6Ou0q3+FTPS5ndwyXsiG7Hq/34jMoCsiHCBvPVZCjQWdIVLQArZc3CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764131; c=relaxed/simple;
	bh=FJowA8M4VVZYFZ9pWsgI42VmXuNVeayoP8gsKOppb5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txNFcAzpoUdKs48iAxE7gpYKWARURAQp2/A5MzDgdMszCSkXd/UxlrVRyuFqobHxkTOpu46LxxJVMg4sSzeBfWj25Vlj+8Yr+Rj3cBd1v6w+SawH+/t5rfUvvXsS9WnVTBZs/DwD6cNrjDtTnVOtD16Yc8qnaDwtXgKk9jM5tzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKDpsh+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKDpsh+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BC4C4CED1;
	Wed,  5 Feb 2025 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764130;
	bh=FJowA8M4VVZYFZ9pWsgI42VmXuNVeayoP8gsKOppb5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKDpsh+fqXqd5ihk1Ex6U3FdBsaQlnd+SGG35/wFQW2RChx15s2kmIe57v7oLSA2e
	 8hmdGMAPwtxL5/EgQ70Jqhd2Pr65bFhonKfrltZrh0rQp6yQHg526+U6UhnRoAj0/r
	 SYhKcgB+VmoC3fwUJQTAAykUNtGuin3Lu89Kmn/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Adrian Larumbe <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 050/623] drm/panthor: Preserve the result returned by panthor_fw_resume()
Date: Wed,  5 Feb 2025 14:36:32 +0100
Message-ID: <20250205134458.144182868@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



