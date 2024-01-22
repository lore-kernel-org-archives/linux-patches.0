Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490A8132C38;
	Tue, 23 Jan 2024 00:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969124; cv=none; b=prwaUS87Hnul2TgBu3Kzym7JGxTp3JIQiosRohoODzgHXtu6AgoV1tFc8IpwcjFnn7xkKS35oGMJ2/J+95Fswog43ACgHzoBwZBUQ1MAtiPGuiLAFZSvtFgx6E/inDmVhthLcwK8rtmqE6NymEu4FAZhU/Gtw6NJXW49REkIr/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969124; c=relaxed/simple;
	bh=FrqCtne8DPFhSHJe3rAdzQll6XjYw4p1L0EpTp6LxLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7OZOyUMkX5S4pYkH7Hc+ZxsYHCI2TD8OMyXr00PHjfGVDLpwODrIMTtrk5/9/DgY1q5T8AOY8VQRz7h4qqZCVldbjGGotpvPv25rQB8YOCR/lk1kk6Nme0G6Z5fUtldAjJvXCaWgi/1mzDwBzGTwE042RJphCk8Zg0HPiYtpAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaLUMlTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaLUMlTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBD6C43399;
	Tue, 23 Jan 2024 00:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969124;
	bh=FrqCtne8DPFhSHJe3rAdzQll6XjYw4p1L0EpTp6LxLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaLUMlTvhYc5lROPYKjm8I8VcPooakHnlrLTJT1JHLfoip5+WaNys7QJd8eG3vIVx
	 67p/YroTX1LopdEAgAhtkoR/2kqUHIVqc0lPtfFy2yX3TygLYu5TgnWIqyRYS+Xvip
	 KYL8dZ2OPz+dBf1KQRn7QWSAyWxDGhiQlz7YM6Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 036/641] thermal: core: Fix NULL pointer dereference in zone registration error path
Date: Mon, 22 Jan 2024 15:49:00 -0800
Message-ID: <20240122235819.210965058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 04e6ccfc93c5a1aa1d75a537cf27e418895e20ea ]

If device_register() in thermal_zone_device_register_with_trips()
returns an error, the tz variable is set to NULL and subsequently
dereferenced in kfree(tz->tzp).

Commit adc8749b150c ("thermal/drivers/core: Use put_device() if
device_register() fails") added the tz = NULL assignment in question to
avoid a possible double-free after dropping the reference to the zone
device.  However, after commit 4649620d9404 ("thermal: core: Make
thermal_zone_device_unregister() return after freeing the zone"), that
assignment has become redundant, because dropping the reference to the
zone device does not cause the zone object to be freed any more.

Drop it to address the NULL pointer dereference.

Fixes: 3d439b1a2ad3 ("thermal/core: Alloc-copy-free the thermal zone parameters structure")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9c17d35ccbbd..1bc7ba459406 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1369,7 +1369,6 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	device_del(&tz->device);
 release_device:
 	put_device(&tz->device);
-	tz = NULL;
 remove_id:
 	ida_free(&thermal_tz_ida, id);
 free_tzp:
-- 
2.43.0



