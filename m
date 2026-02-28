Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFC1340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301039; cv=none; b=m3iYFBdC+b2tUkw4VQJ3ATKGo5b7NObk1WWDQC0OobuQM0KTMdepTfOfF6pIteT053JkRfmTAWDQLHWxyNTrEb/9KnE0OpKrYHXIirtMdDnceXv7gE4gpu1ps2pcYZtr/+ZqJXbAQbyGobqC3+at//QZHWfNKL9KjM8+tZ4dFwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301039; c=relaxed/simple;
	bh=dwA9fqQFtdTJqGazQwPPmQkvqvsYa5a3b4Tfkc8Bcsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnZs5HtcqDyYKCb9Cwf5YU/WDXodtz0JMPP1VfG7VRYnB8/yO6chYgsrd45Z45YuJ0wEbPiuHNuhH8zkKrxQmuJJM05CxQinQva8Boor6gPlUXNyJEqbae2WTcS/fiMNpKXJrz62UkJh3M1jMQsMNgL9l8AmNmf4Pr4MircWHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2QM95fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2QM95fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10627C116D0;
	Sat, 28 Feb 2026 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301039;
	bh=dwA9fqQFtdTJqGazQwPPmQkvqvsYa5a3b4Tfkc8Bcsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2QM95faxKB5m2ck+igknQSAsUE2WmOoZkTofLiMXSnr+f9NBcAnmvJyoH12tqbEH
	 ZP62YD8D2XLHN/HwIqoKLpd7BwQ+NGEsVub1yjght0EyW+DFn/6noe09+oDiJkAUJU
	 3Ek13HECL1B84NTxCKohLzFNvLdIaXDB7qUFbQgl5pm+BoDlC9/4hE6IWZfvzWTmvl
	 DM+Vdh1ewdrpAx0zBaKq4TYWH2ChEhILDts1od1Rl9Y1Kp7KQCwpV1qsXaodJQr4o+
	 SKut9KQmCCAgunmrrQpO7KDbN3C84qtlMjRMZFpEIo0E0goPnSfEBsbCta3sUMDM4e
	 k+LbF50F916DA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>,
	Manikandan Muralidharan <manikandan.m@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/752] drm/atmel-hlcdc: fix memory leak from the atomic_destroy_state callback
Date: Sat, 28 Feb 2026 12:38:08 -0500
Message-ID: <20260228174750.1542406-177-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit f12352471061df83a36edf54bbb16284793284e4 ]

After several commits, the slab memory increases. Some drm_crtc_commit
objects are not freed. The atomic_destroy_state callback only put the
framebuffer. Use the __drm_atomic_helper_plane_destroy_state() function
to put all the objects that are no longer needed.

It has been seen after hours of usage of a graphics application or using
kmemleak:

unreferenced object 0xc63a6580 (size 64):
  comm "egt_basic", pid 171, jiffies 4294940784
  hex dump (first 32 bytes):
    40 50 34 c5 01 00 00 00 ff ff ff ff 8c 65 3a c6  @P4..........e:.
    8c 65 3a c6 ff ff ff ff 98 65 3a c6 98 65 3a c6  .e:......e:..e:.
  backtrace (crc c25aa925):
    kmemleak_alloc+0x34/0x3c
    __kmalloc_cache_noprof+0x150/0x1a4
    drm_atomic_helper_setup_commit+0x1e8/0x7bc
    drm_atomic_helper_commit+0x3c/0x15c
    drm_atomic_commit+0xc0/0xf4
    drm_atomic_helper_set_config+0x84/0xb8
    drm_mode_setcrtc+0x32c/0x810
    drm_ioctl+0x20c/0x488
    sys_ioctl+0x14c/0xc20
    ret_fast_syscall+0x0/0x54

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Reviewed-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Link: https://patch.msgid.link/20251024-lcd_fixes_mainlining-v1-1-79b615130dc3@microchip.com
Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 3787db014501e..410ec747cc7e0 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -1204,8 +1204,7 @@ static void atmel_hlcdc_plane_atomic_destroy_state(struct drm_plane *p,
 			      state->dscrs[i]->self);
 	}
 
-	if (s->fb)
-		drm_framebuffer_put(s->fb);
+	__drm_atomic_helper_plane_destroy_state(s);
 
 	kfree(state);
 }
-- 
2.51.0

