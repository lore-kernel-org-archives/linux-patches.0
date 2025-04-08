Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456CE266EFC;
	Tue,  8 Apr 2025 11:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111339; cv=none; b=Tq1SuWlbzq761BDljGBWTS740hIG+AguobcZ+DQmRU6KM8qw+2+vL02nEDE5BHnbeO1On3zc9NopPphnCXwbFxLLK8edlds65wdwphPAqWqyx5e9t8RAkIxY8c6hVcoPYcbh+JHNXreGypQ32WUwWFA0qYTROoAcIITRm6qPCk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111339; c=relaxed/simple;
	bh=IIAImU4eO1JjT8xkNlk2G+jBsaDICttetMnDo+kFojk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtWoVDOse9ztY5OSycpGdD3gIhIWFTKXffMHPa7BPtYf7ibI7h2+KCs2zfIIXWyuu2oUjrjX3qojSxRDCPzHLFeiXiC7k8AgEX1fDvz++gwB2v0l5MhK/2Petr2JevzIfJGCf66mZGrTNJp/nuWlYP7kuB3kt/xalxPTpHjlFSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giU24cKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giU24cKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2BEC4CEE5;
	Tue,  8 Apr 2025 11:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111339;
	bh=IIAImU4eO1JjT8xkNlk2G+jBsaDICttetMnDo+kFojk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giU24cKsdcv0LOyntcBvTS9ZkTbzfdcaBl9oSB/RSPJYfYXuW8Ff3ZGA9ZLZKl6Y9
	 eYJ8SxOvLjJTMNC/cMz7V26vLgfRy2MKGJCvKsxmBKROr+bw4NbuGYYpVz6mxFg3El
	 hQTn18mevNPTG7t0rSgTJktbSdXcPpaDk2Ddo4Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sicelo A. Mhlongo" <absicsz@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 397/731] power: supply: bq27xxx_battery: do not update cached flags prematurely
Date: Tue,  8 Apr 2025 12:44:54 +0200
Message-ID: <20250408104923.507404544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sicelo A. Mhlongo <absicsz@gmail.com>

[ Upstream commit 45291874a762dbb12a619dc2efaf84598859007a ]

Commit 243f8ffc883a1 ("power: supply: bq27xxx_battery: Notify also about
status changes") intended to notify userspace when the status changes,
based on the flags register. However, the cached state is updated too
early, before the flags are tested for any changes. Remove the premature
update.

Fixes: 243f8ffc883a1 ("power: supply: bq27xxx_battery: Notify also about status changes")
Signed-off-by: Sicelo A. Mhlongo <absicsz@gmail.com>
Link: https://lore.kernel.org/r/20241125152945.47937-1-absicsz@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 90a5bccfc6b9b..a8d8bcaace2f0 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1918,7 +1918,6 @@ static void bq27xxx_battery_update_unlocked(struct bq27xxx_device_info *di)
 		cache.flags = -1; /* read error */
 	if (cache.flags >= 0) {
 		cache.capacity = bq27xxx_battery_read_soc(di);
-		di->cache.flags = cache.flags;
 
 		/*
 		 * On gauges with signed current reporting the current must be
-- 
2.39.5



