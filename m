Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33432F261C;
	Wed, 28 Jan 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615695; cv=none; b=AX82T+zYwWUkrofaeCHAqkUalO7oA1bUWWPbvaZAF8Yiv0tEJ3Z2zOcrH0f0RRCp1n1J30oiWpIR6CkWFavvJCUAa2HjGDarphoPwcR6pipQ1iPEr8AFZsCNV7OA00vTCCKYCVkPMTNmQY+TUbv+FZUtO9RMnOz0DxT6giYjTTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615695; c=relaxed/simple;
	bh=q7ge7uwmmzagxiJVTeaiUHhTdV/HJZbnCiYhN52B+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqTot9Fn0eJjHm0jNYDQ2P1MbJboWPpsDci58JJ6i4sS3vzqPxJvOKgpcG+wLyLfz56gbGb0DiVvusD93/ypTmm22c5YVPijtW2c1TTwQ5akeUjGDPkpiboHYU+LRYSB8C0ICBleCNBX7XU7ocjUk8iD9peLAMLa+zSspCq7Xxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCp/2Qjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCp/2Qjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5907DC4CEF1;
	Wed, 28 Jan 2026 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615694;
	bh=q7ge7uwmmzagxiJVTeaiUHhTdV/HJZbnCiYhN52B+VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCp/2QjwTRV1N63o27bsTiJmdGmDAsB9AStbWl+nC5v1AUk1U/lJjZiHD+ZWqfJyv
	 LserMy7oYp2/eUzZCcihiP/7HcZt+3nshGaSsAfCktpbzcq52j2C4bDpBdcB9ciGj/
	 U8gJDY4eliyY5d8K8Z0FSLEur5WPu0hdX9fW9Tqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yu Lee <cylee12@realtek.com>,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/227] regmap: Fix race condition in hwspinlock irqsave routine
Date: Wed, 28 Jan 2026 16:22:11 +0100
Message-ID: <20260128145347.433305926@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
index ce9be3989a218..ae2215d4e61c3 100644
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



