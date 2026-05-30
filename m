Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2FC3148DA;
	Sat, 30 May 2026 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162143; cv=none; b=hJ94bDr+/jMT0I5e3OhnJYo/ExTJyoq1F7B5yHd3h44o7NhtZRfow7cgggpd68oMwac9wO8XKDkthzTBismeUHevr8ork8k47J+f3d3yRTJcXbl7s7Qj2rdV5RKcREEDhWf4e4pH3ItnpDe0MJ/xrrOEiui7vqpt+YGL2CwyzV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162143; c=relaxed/simple;
	bh=b27T23S4cDYQ+UPEOvU0YRx83tZBCcwZrPlHzjXPrdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ovtzYajV0Hau1bonEGln97/xG+g1gYJ83vamY/W0Nul/i/rr8wy4B62KpgiswfQ+MpepoSjn0aZZSbrXce1Ze9RA1cOSJuJ1lO4b0gsEETDqM3REtQzmlLfDXjT7LyBGD/chdKtrx/fA2VqKCEwrK1aa5wfslwv77avNen9aDg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmAv455p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmAv455p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E754E1F00893;
	Sat, 30 May 2026 17:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162142;
	bh=Uf01Jm+vwyOPZ/UfbLe1JaVtMlqhkGuGu8Tgxbv4YAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmAv455pMxNPYTo0KR/AiHa/UlH3V7FW5qZgJtZ1FEKOxSO3GSLLBf/Uw5VHBtJ9l
	 trw8GLIdVn9T2U4uyCcjdr2rWxxbdoArZY3OXphgjVg+WDLA44aOcncnyDVwGwzAwW
	 c6x5C7drqU3uoYL34jhIoln2k5YhGPsEQWLlJxoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.1 826/969] drm/panfrost: Fix wait_bo ioctl leaking positive return from dma_resv_wait_timeout()
Date: Sat, 30 May 2026 18:05:50 +0200
Message-ID: <20260530160323.452290195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

commit 459d75523b71c0ec254d153d8850d0b7008af396 upstream.

dma_resv_wait_timeout() returns a positive 'remaining jiffies' value
on success, 0 on timeout, and -errno on failure.

panfrost_ioctl_wait_bo() returns this 'long' result from an int-typed
ioctl handler, so positive values reach userspace as bogus errors.
Explicitly set ret to 0 on the success path.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/fe33f82fded7be1c18e2e0eb2db451d5a738cf39.1776581974.git.gye976@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -330,6 +330,8 @@ panfrost_ioctl_wait_bo(struct drm_device
 				    true, timeout);
 	if (!ret)
 		ret = timeout ? -ETIMEDOUT : -EBUSY;
+	else if (ret > 0)
+		ret = 0;
 
 	drm_gem_object_put(gem_obj);
 


