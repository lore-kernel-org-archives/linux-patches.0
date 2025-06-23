Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043493FD4;
	Mon, 23 Jun 2025 21:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715297; cv=none; b=BqDT3vnPFzOGTHLk3td6yFdHh7dPP5BaIcHTQ4VPnDB4y6g/zQ6LBGmRK1SWg1py16G45qrDU5JbzsBv3KuSWq+MZ6tXh21i469a6XJLDzNDJDbV9o2gPGFqwDejyBxMdVsX0xAKGTIajJY9KC3g2UGstGcT0HQM1v/n5aEL91I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715297; c=relaxed/simple;
	bh=zHNqFGGQJsYnoyx32bWW64xgYJDga/hhCUnvZIkrJWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMd+Plc9Tu+I4unIU0NJVjKiznG1gjytzeyhZOfw2s7vxS/0J1pUN62oAElAL5bF74dog9v1vGJEZoLsqedrrKQ7VOq2n+o8cQtxfwa48XWD2HsCnOmk7yzOn+PhTnCh56STBbJesKrQ0AtgQFNISZouuaKdsKeJ8+mY62O8bxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDa06PxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDa06PxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91742C4CEEA;
	Mon, 23 Jun 2025 21:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715296;
	bh=zHNqFGGQJsYnoyx32bWW64xgYJDga/hhCUnvZIkrJWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDa06PxS8vKQ7A0sJf9Ynr5k2s0YaIPFYlIY53diwowVkHJ+amEAibO/4M5wztBCY
	 B4Laa5K8NbOLP6Hg1dzDNpziSx5/Y4rnQg1W0Wae7cQc+ROLz7OU5E/PPc+mM9QEoH
	 a242rnu1OEDKdol9fHmbBCzCpq81KqV5mAo9yBts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/508] ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()
Date: Mon, 23 Jun 2025 15:04:31 +0200
Message-ID: <20250623130650.823517053@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 87f7ce260a3c838b49e1dc1ceedf1006795157a2 ]

There is no disagreement that we should check both ptp->is_virtual_clock
and ptp->n_vclocks to check if the ptp virtual clock is in use.

However, when we acquire ptp->n_vclocks_mux to read ptp->n_vclocks in
ptp_vclock_in_use(), we observe a recursive lock in the call trace
starting from n_vclocks_store().

============================================
WARNING: possible recursive locking detected
6.15.0-rc6 #1 Not tainted
--------------------------------------------
syz.0.1540/13807 is trying to acquire lock:
ffff888035a24868 (&ptp->n_vclocks_mux){+.+.}-{4:4}, at:
 ptp_vclock_in_use drivers/ptp/ptp_private.h:103 [inline]
ffff888035a24868 (&ptp->n_vclocks_mux){+.+.}-{4:4}, at:
 ptp_clock_unregister+0x21/0x250 drivers/ptp/ptp_clock.c:415

but task is already holding lock:
ffff888030704868 (&ptp->n_vclocks_mux){+.+.}-{4:4}, at:
 n_vclocks_store+0xf1/0x6d0 drivers/ptp/ptp_sysfs.c:215

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ptp->n_vclocks_mux);
  lock(&ptp->n_vclocks_mux);

 *** DEADLOCK ***
....
============================================

The best way to solve this is to remove the logic that checks
ptp->n_vclocks in ptp_vclock_in_use().

The reason why this is appropriate is that any path that uses
ptp->n_vclocks must unconditionally check if ptp->n_vclocks is greater
than 0 before unregistering vclocks, and all functions are already
written this way. And in the function that uses ptp->n_vclocks, we
already get ptp->n_vclocks_mux before unregistering vclocks.

Therefore, we need to remove the redundant check for ptp->n_vclocks in
ptp_vclock_in_use() to prevent recursive locking.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20250520160717.7350-1-aha310510@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index b8d4f61f14be4..d0eb4555720eb 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -89,17 +89,7 @@ static inline int queue_cnt(const struct timestamp_event_queue *q)
 /* Check if ptp virtual clock is in use */
 static inline bool ptp_vclock_in_use(struct ptp_clock *ptp)
 {
-	bool in_use = false;
-
-	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
-		return true;
-
-	if (!ptp->is_virtual_clock && ptp->n_vclocks)
-		in_use = true;
-
-	mutex_unlock(&ptp->n_vclocks_mux);
-
-	return in_use;
+	return !ptp->is_virtual_clock;
 }
 
 /* Check if ptp clock shall be free running */
-- 
2.39.5



