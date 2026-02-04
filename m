Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04BE41C305;
	Wed,  4 Feb 2026 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217140; cv=none; b=DBqaqIevIJBBniKGzKGcTVCfiQNQ536KQhX/PW3oCk7o+8mlxoPZ+S7pDEr/5YjkLJGCnRoYzdYh7v8WszeAIjFeFk4qvpZG+FYPU2hRX6xiT85ba9KZEzk3ZJaGvuYmIKijbG4Ry9xaN4M/DMU4dOfy5L/vmblpLFOaPxpG2xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217140; c=relaxed/simple;
	bh=ViaJJA8cS9Zn15SPF0Ps2e+ezusPp5sKmnY6qkL5JLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEXViib/cjRdEnb3hBDTgaHFIizQvBWX9Zi3xD/SUPNzjuYrdb7MEUDDjwrP2+68Z79F1r0MrzQXSplz3ccnOSfYOFp5ZeXa3vBW7QRXO1CWhhjLhpjM2G/O1kUBXKAiGhkHfGGi3KitICf63FLB5otSQF+VVICqkIshnVj/KDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdNiuk7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdNiuk7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C4CC4CEF7;
	Wed,  4 Feb 2026 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217140;
	bh=ViaJJA8cS9Zn15SPF0Ps2e+ezusPp5sKmnY6qkL5JLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdNiuk7A3KDe+KhhgjeeY58WsmYCdIdUZMibUMJkjUQK5frAtInqTqnHX7JX255yL
	 Psz9V3dXGisuCID5B6Tb7RuZiXlj7iEukp5bbdJv39FuhqofPe/eKjTbF4mGtrCIlw
	 VyEY/L/gwWlPgOuDyZJBpCFBgQlW2zQRK0zxSuP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yu Lee <cylee12@realtek.com>,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/206] regmap: Fix race condition in hwspinlock irqsave routine
Date: Wed,  4 Feb 2026 15:38:43 +0100
Message-ID: <20260204143901.521872302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35cfbec6bf9ac..e1380b08685f4 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -473,9 +473,11 @@ static void regmap_lock_hwlock_irq(void *__map)
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



