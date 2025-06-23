Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A34B2C9D;
	Mon, 23 Jun 2025 21:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713679; cv=none; b=avaRIdA4UJmj/nX0KDMVajCDfSvuImiCa3nIxei+ZQkSNaA4DiHtVV38SPK4kOUA3cZM0i1oANgmwdXAnNaQa4VTUk6YGC743nNFb7s9EKMjhoZUskARV2AiojVT+TydNFiEQjev9D/1+6qtRjm31ggKWOdifuMAm6VBqXdZDFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713679; c=relaxed/simple;
	bh=JyJKooyiatvjPRSEOVTDOOVxtNCkpFj9YVZ3Ym2Bs/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKfcl4VnVUYni5al3pQ2vdOBUDQY+0M8phmGpKZGQv6lNHl6Q3itCZsP3DnJ6wBQvzYfOSnVGn8c8AqNI6VVUTOwic5Kagj1Nx5qRrs+BRFqewTv8zeeEX+IxFPIdLRukJjg9SrOcphronLybdRISA7bh0c+Bl22Zt/wWoS5+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxCSzTwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxCSzTwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65550C4CEEA;
	Mon, 23 Jun 2025 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713677;
	bh=JyJKooyiatvjPRSEOVTDOOVxtNCkpFj9YVZ3Ym2Bs/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxCSzTwS+3MTDK2aa6I4x7mrNgR7E+gV+ds5djJV1t58s/80tkkgmj44P2vxC+9+y
	 aBFowJ+yYF9RT3dEb2px0vUv6ZfyORP8Oe+QAY646bVDFM7q4NrkFmhnwB3Owu9a3P
	 oKaANEInD1aadzX/icgU/ioJc8KQj7vfpjhWIX8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/411] ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()
Date: Mon, 23 Jun 2025 15:04:44 +0200
Message-ID: <20250623130637.121569450@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b336c12bb6976..f57ed0dd0aa40 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -87,17 +87,7 @@ static inline int queue_cnt(const struct timestamp_event_queue *q)
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
 
 extern struct class *ptp_class;
-- 
2.39.5



