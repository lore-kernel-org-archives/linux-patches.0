Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84272D3A75;
	Wed, 28 Jan 2026 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614505; cv=none; b=pxS/6SYVCInLDtCR9DBpBcaTo+A4sP97de0Hbv4b1OxA7PHrjP5WVyA69jEoXf4NCZmtarPud3/Sd5+OfQ+duNDgZIRF2NQ8LDPyTbcXNYB7o7L5duPdHJaNnj9ZzcFXWEqksnMTq10muQoBnEa49qX4HU4gOatKL2Tt+FHINKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614505; c=relaxed/simple;
	bh=6Jj8DBswAHLzr9n/2DLnD6yLAQmrECmTpqFX6ZMmPLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPpmq11oT9090eSRS9yWt0MRol6a7rOvOw6oSEBRBfKHugUM86ZrY1GLZGEHTBvROxm1+XRkdMwITQvx8JQaBfvVtAZBXeAl0UIzSAX9rWi4qeUu/fQGNW9xgYk0PqxHH1W3ruSJyEO2FDwruStc3zOSfF4zuxAFCIfOYAmKPxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eB1hjFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eB1hjFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB80C4CEF1;
	Wed, 28 Jan 2026 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614505;
	bh=6Jj8DBswAHLzr9n/2DLnD6yLAQmrECmTpqFX6ZMmPLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eB1hjFsvB9ubSWb6JcVuYNUtG/F8JQ3iGt7LUclBnKj2BY4TLWyj8pg58qXygGtV
	 9oB/YqExTNg3xf1bQcq/vTCBW6gs16qrzQEpa0H/Lai0aEhZZW4YdnQqTg9fO/t9GU
	 NK2GEbXC899p+dfyWjKl8AfRZ5CIGnVr/1VNf1ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yu Lee <cylee12@realtek.com>,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/254] regmap: Fix race condition in hwspinlock irqsave routine
Date: Wed, 28 Jan 2026 16:22:13 +0100
Message-ID: <20260128145350.461629441@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9603c28a3ed82..48860beff95c9 100644
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



