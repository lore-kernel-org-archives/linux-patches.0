Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4DC13DDD8;
	Thu, 13 Jun 2024 11:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278746; cv=none; b=Wi2AOouUu3b87Wy4NFJwrXJQvVYA3lMwmsRnnKQTJz8GAg7PtbuknQBCPYRLG1fHSljqDx88J+Uo9m12QoKNwMRHeySFyu/c889rN5I1t70vg0NoC2oCwGxZWuOMFG4Ua0/ae8G6ro8aEtWXgcaAnJAoRvQcFnk9dPvrYrybzcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278746; c=relaxed/simple;
	bh=X1v/SMK/l9EYklRxXEUu6pzDRUOy8B8GoaXC6l5OEzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu/H5zcnFg8boyxDh9tFH2eAoSKdI2GtxZjYWIdNGu0JX60RcCNlYegBVOW9qBJ3Gu3XUG6bc221yDy2crSrVSbcXyljeAjXNhs2mhGa8+dHIh2VN7PvZOhGLLoUjWTZ8xc3sCvvGDi5+Ml6NwWJF7/nP8wC/lhYD8C1iB4lIe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5vyv0Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5vyv0Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EBFC4AF50;
	Thu, 13 Jun 2024 11:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278745;
	bh=X1v/SMK/l9EYklRxXEUu6pzDRUOy8B8GoaXC6l5OEzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5vyv0Txg1uKgIMB+W+vduWCsg1AqmoKImC+eor/anvVXPwrorvOGV6jD3ybtyTIY
	 /wpV6PjsgP736TtZyF8QfpVWJa/YpWccw1mTXnBqPGcTqGEysXYlJoN/vUum47Cu4l
	 LdATJ4FHi8YO+bMxdrT4GJzF8IcGwraQoycc76Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@telegraphics.com.au>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/213] m68k/mac: Use 030 reset method on SE/30
Date: Thu, 13 Jun 2024 13:31:44 +0200
Message-ID: <20240613113230.170120446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 9c0e91f6b701dce6902408d50c4df9cebe4744f5 ]

The comment says that calling the ROM routine doesn't work. But testing
shows that the 68030 fall-back reset method does work, so just use that.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Stable-dep-of: 265a3b322df9 ("m68k: mac: Fix reboot hang on Mac IIci")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/misc.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index 1b083c500b9a1..3848ff15c59f7 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -462,9 +462,8 @@ void mac_poweroff(void)
 
 void mac_reset(void)
 {
-	if (macintosh_config->adb_type == MAC_ADB_II) {
-		unsigned long flags;
-
+	if (macintosh_config->adb_type == MAC_ADB_II &&
+	    macintosh_config->ident != MAC_MODEL_SE30) {
 		/* need ROMBASE in booter */
 		/* indeed, plus need to MAP THE ROM !! */
 
@@ -474,17 +473,8 @@ void mac_reset(void)
 		/* works on some */
 		rom_reset = (void *) (mac_bi_data.rombase + 0xa);
 
-		if (macintosh_config->ident == MAC_MODEL_SE30) {
-			/*
-			 * MSch: Machines known to crash on ROM reset ...
-			 */
-		} else {
-			local_irq_save(flags);
-
-			rom_reset();
-
-			local_irq_restore(flags);
-		}
+		local_irq_disable();
+		rom_reset();
 #ifdef CONFIG_ADB_CUDA
 	} else if (macintosh_config->adb_type == MAC_ADB_EGRET ||
 	           macintosh_config->adb_type == MAC_ADB_CUDA) {
-- 
2.43.0



