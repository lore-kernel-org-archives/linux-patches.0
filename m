Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475402E2DF4;
	Wed, 28 Jan 2026 15:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615053; cv=none; b=duJWZkK2Yy6PaiCdSvLvAC9H2VQWVO3UWpJHqXnd0U2TSmAPvw0DGlxzukoPVbVD7+ZXSejoLT8DBPCIHvhYocC9i8d7h3BtW4sUEs5jO1xUhM5LCEGLpXobau0YSoHS8HXWZhU6VZnEdPMjXvcMpDzUo2Ktk7070h9A0zhwPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615053; c=relaxed/simple;
	bh=KJRQaxYVsXypOBJP7Mq6xMwLZ8O6Pnl2YpLZnYGCC9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXTU3JTpzlE1ybBpkvAgbo34a0VmPrnJnnhopjMirpWXzrAAFVpJlWbKp8uYo8qOjNeTXb6tlrWH02EJ7YVrxosfBTzbFVMPwasZEZnCPrauLXpwaE6tMIVjWoHJn/dmAo8Ux9203j3pta+A8fIcFhS9hDfGTHBNkUoxCkrfo2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT1UTiV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT1UTiV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC4FC4CEF1;
	Wed, 28 Jan 2026 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615053;
	bh=KJRQaxYVsXypOBJP7Mq6xMwLZ8O6Pnl2YpLZnYGCC9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT1UTiV3yfAq1Rb6JWnOUQGoh28tpdJuWgdpZi8Se1F2m3i62Ls8scLG/VVBvBVEa
	 1rec4g/NKhF0whPxQcwZv+gScNJkwm3LutcbetA0xxMcdIF34pbZoY4h5fSurC6M8u
	 ibazZE3sL3nkTKoml3bh8COBR+PyyapTuqryl0IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yu Lee <cylee12@realtek.com>,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/169] regmap: Fix race condition in hwspinlock irqsave routine
Date: Wed, 28 Jan 2026 16:22:27 +0100
Message-ID: <20260128145336.314387163@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Cheng-Yu Lee <cylee12@realtek.com>

[ Upstream commit 4b58aac989c1e3fafb1c68a733811859df388250 ]

Previously, the address of the shared member '&map->spinlock_flags' was
passed directly to 'hwspin_lock_timeout_irqsave'. This creates a race
condition where multiple contexts contending for the lock could overwrite
the shared flags variable, potentially corrupting the state for the
current lock owner.

Fix this by using a local stack variable 'flags' to store the IRQ state
temporarily.

Fixes: 8698b9364710 ("regmap: Add hardware spinlock support")
Signed-off-by: Cheng-Yu Lee <cylee12@realtek.com>
Co-developed-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Link: https://patch.msgid.link/20260109032633.8732-1-eleanor.lin@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 66b3840bd96e3..70cde1bd04000 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -408,9 +408,11 @@ static void regmap_lock_hwlock_irq(void *__map)
 static void regmap_lock_hwlock_irqsave(void *__map)
 {
 	struct regmap *map = __map;
+	unsigned long flags = 0;
 
 	hwspin_lock_timeout_irqsave(map->hwlock, UINT_MAX,
-				    &map->spinlock_flags);
+				    &flags);
+	map->spinlock_flags = flags;
 }
 
 static void regmap_unlock_hwlock(void *__map)
-- 
2.51.0



