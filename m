Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC03101C8;
	Thu,  2 Jul 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010827; cv=none; b=PEPqCzHf2XRYtobodCkbToDsud8TcrSI8o1AwBFoQl1fNJS260PMq7eJ7IylT53HoJTgdY6e7vBdp7icvAuxYli1nMdcOSXOl0QaI/E156BZoNewbNkhDCW4ueVrd0qNxkKOtaDzUgHJcjZ2h+NcoM9bGGUlOu7qz5jLO83LaPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010827; c=relaxed/simple;
	bh=2LeEiVDd13HzFwSkwPg/XqCETUDdQnTu1Y9yPqqcaaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqYCTdaAhemXe1svaESzJHGioVuWNHVipoSP3CAjgNFVJEYNvjxAl1SFEyXp6U8DlqpjNn6a4sEThNw9Hm1m1QqceBUoQypS41WWELs21zPCLeDm3o4TXRW9LSqHUOLU3gZT2cGhha6EuT152U+8fh/rkmBxNvxa3jI7vFlkk0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IL2LWanE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IL2LWanE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4030D1F000E9;
	Thu,  2 Jul 2026 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010826;
	bh=pLcPMyVFCbah2Nn54qiQSSFBlr3yf/mg9Tg4CQ9mYSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IL2LWanE2URiAMkRCDqWv96+aHoZPbU+sxCh9+ALwogUKOnB2zuqFNF3wzlUsTVzI
	 hgFdwgDNLtaJM5W2ZHevnqx5O+NrKZ6C9Qx27FOvsuXhfH6NN6P4aZlz+PmBQqSAjd
	 O6pbdV3tFSX4Kz+yvEZbaHIkOcT8RYdjChtSBQps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/175] debugobjects: Use LD_WAIT_CONFIG instead of LD_WAIT_SLEEP
Date: Thu,  2 Jul 2026 18:18:30 +0200
Message-ID: <20260702155115.966071543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 37de2dbc318ee10577c1c2704de5a803e75e55a2 upstream.

fill_pool_map is used to suppress nesting violations caused by acquiring
a spinlock_t (from within the memory allocator) while holding a
raw_spinlock_t. The used annotation is wrong.

LD_WAIT_SLEEP is for always sleeping lock types such as mutex_t.
LD_WAIT_CONFIG is for lock type which are sleeping while spinning on
PREEMPT_RT such as spinlock_t.

Use LD_WAIT_CONFIG as override.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251127153652.291697-3-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 5b462a45a9c17b..bebc00aacafedd 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -608,10 +608,10 @@ static void debug_objects_fill_pool(void)
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible() || system_state < SYSTEM_SCHEDULING) {
 		/*
 		 * Annotate away the spinlock_t inside raw_spinlock_t warning
-		 * by temporarily raising the wait-type to WAIT_SLEEP, matching
+		 * by temporarily raising the wait-type to LD_WAIT_CONFIG, matching
 		 * the preemptible() condition above.
 		 */
-		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_SLEEP);
+		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_CONFIG);
 		lock_map_acquire_try(&fill_pool_map);
 		fill_pool();
 		lock_map_release(&fill_pool_map);
-- 
2.53.0



