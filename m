Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F26C1C5D77;
	Wed,  4 Feb 2026 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216385; cv=none; b=P4Qxp2sVrt+55JMW1flkp9suIRn4EJELjSUrXyYwKGIptW5hiabGCPcX6Dgazx6LWX81t8P8JTni32BDT72QMfxeDzFPw8LvlioCMUhhom79GAVJFcNJXvcMexv4PAhffqDeq1uhUWXcU2Ngb58wPqYzr0rVXYWOsTkm5N16+vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216385; c=relaxed/simple;
	bh=o92B/yqS1lxIG+o+TL8n6MziA97xKsRiBjvruLZ1r4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0px5XFRw9o772jeQZTsyeLhsa6xavR7W6ZEau0jsrFTbkiYsU6eobXyEOqBw121AvfRYlY4VaT0Twerni5DrV6V9GkWaGOvmxke7oSFOxH4iz5lt0Jx65NuR4fiuqBEFTEAzLvhDf02eQcE+/B74x12503/zdsTX7WGDpe9U20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP7mv1Dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP7mv1Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47D2C4CEF7;
	Wed,  4 Feb 2026 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216385;
	bh=o92B/yqS1lxIG+o+TL8n6MziA97xKsRiBjvruLZ1r4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP7mv1DpNcAbS1crtPDKvVhVHvVj6y+Krqx9QnW4FqEfKDijuNS9v1AFG7+P+IW5p
	 ro+pDBAYjGV5YLWH+WfQ6bV3AP/NXPV9fzr0bvBrBz4LPY/Fdn2bacq3d16jqIdB6o
	 vHhF/A3cJSg2PpAJo2nAcpEwJRCXT8nDtXOfULF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yu Lee <cylee12@realtek.com>,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/161] regmap: Fix race condition in hwspinlock irqsave routine
Date: Wed,  4 Feb 2026 15:38:56 +0100
Message-ID: <20260204143854.381852715@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02c21fce457c1..e86d069894c06 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -463,9 +463,11 @@ static void regmap_lock_hwlock_irq(void *__map)
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



