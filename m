Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED04C1548C;
	Tue,  8 Jul 2025 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992498; cv=none; b=SLEBf6qahuI0LpQ4WQy4wAB8w3yoUWBjgV3iNd/Q0VWP5wEJidetR/1pxhVMOBsHNN2sT2wDlQ9w2c8RPe45fygFlS4T5RmwFLCOO/VRPx8MhMuBEHYnLGyIHOJe3EPre9sEFgsdEkXFx9uWU4ddq4bUDAXfPws9oqtAEgq6XyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992498; c=relaxed/simple;
	bh=kcIFitZO8C81v/lWUGIldg1QGutfV185fnRvkBW2Arw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=if/VoUDQINEGnJ16qZHY6ktS3HHwqtzQQHk/i/PdRiuvu00QU9O53/m/IPi6NMgOcf/20qm2vSNkLYiYMfTZT3DW/fBritqcI04+cQ57i+RixRXDvtW+om9khxrx3l35GHDQAgKZun5Ub5q7LHMQGzotbx1P4JfGGTbBEokV9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbJuUlDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbJuUlDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8AC4CEED;
	Tue,  8 Jul 2025 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992497;
	bh=kcIFitZO8C81v/lWUGIldg1QGutfV185fnRvkBW2Arw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbJuUlDOEywEzuCDbiB8/gx6K3V0qAKVEz+DDVTw2rF0qBSkkNjrQE6N5G1XiSId8
	 vZIOoBiON94ZybdFWv6PftP0GSg3/0DRtximxlh2fS6yoVgGeGXIlGtrijm00Cd/Tx
	 od2SdCvHp8nAsLeP6BovkbZkWnIoGQNM1VlnGQmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/132] drm/i915/dp_mst: Work around Thunderbolt sink disconnect after SINK_COUNT_ESI read
Date: Tue,  8 Jul 2025 18:23:12 +0200
Message-ID: <20250708162233.004888582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Li (Intel) <xin@zytor.com>

[ Upstream commit 9cb15478916e849d62a6ec44b10c593b9663328c ]

Due to a problem in the iTBT DP-in adapter's firmware the sink on a TBT
link may get disconnected inadvertently if the SINK_COUNT_ESI and the
DP_LINK_SERVICE_IRQ_VECTOR_ESI0 registers are read in a single AUX
transaction. Work around the issue by reading these registers in
separate transactions.

The issue affects MTL+ platforms and will be fixed in the DP-in adapter
firmware, however releasing that firmware fix may take some time and is
not guaranteed to be available for all systems. Based on this apply the
workaround on affected platforms.

See HSD #13013007775.

v2: Cc'ing Mika Westerberg.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13760
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14147
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250519133417.1469181-1-imre.deak@intel.com
(cherry picked from commit c3a48363cf1f76147088b1adb518136ac5df86a0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3390814de0a54..cc1bbf70477b0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2215,9 +2215,6 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
 
 #endif	/* CONFIG_X86_64 */
 
-/*
- * Clear all 6 debug registers:
- */
 static void initialize_debug_regs(void)
 {
 	/* Control register first -- to make sure everything is disabled. */
-- 
2.39.5



