Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30DA194A67;
	Tue, 27 May 2025 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364788; cv=none; b=QhJu3RRuXGhEjUBDkc+E2bFcnH5M97JDvIxPC8mTOLnkLts8TrWpjTW6CTnBcqpJMW6lc7mf/vNXc64FJDDSr/i/FTe2uaY+2nvjnbYnGjYVbzTdxxlVs5NAlt69XOoLxAjiDaXSaUzcNheN4rH8QJ+TQE1kMo34QrkxZCgbI0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364788; c=relaxed/simple;
	bh=PNAt+WIHmbne9SNTTV/sT0F1kCX03IbOnU1bVBdMkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnS1PrAz4XVZpacXucpuiP1rb1beVV3gO6mjkyctQoTDCxcn9yCgiiEJg1wfFNWyraPefxOgH3gYJYRWeXZdLlA8lItuxTzfSX/kvjnwTLjiPwtuD+3TEKp/pIZ9H3H20s8Ui17PcgIOSGvOlfygxPQ4Q03+Ma6ZlbtS9U5D4N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXHgZvW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXHgZvW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCC5C4CEE9;
	Tue, 27 May 2025 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364788;
	bh=PNAt+WIHmbne9SNTTV/sT0F1kCX03IbOnU1bVBdMkNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXHgZvW3Xy5qzN986rZz3WUyLCBSGqap2YhCdUyHQfsJnBim4g420VI8z6B9xb3Qb
	 YGTiwU7AOoeX1Gu4TaxhvcXQxf8+XpofyEqBa81jiL1eeWcPn4Du9XCW3PdT2QPVYR
	 vZeaEyrtZyYHz9/KB9WacLfk8NG9ju4jwHt2TZLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/626] posix-timers: Add cond_resched() to posix_timer_add() search loop
Date: Tue, 27 May 2025 18:20:59 +0200
Message-ID: <20250527162451.770328513@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f2909c6cd13564a07ae692a95457f52295c4f22 ]

With a large number of POSIX timers the search for a valid ID might cause a
soft lockup on PREEMPT_NONE/VOLUNTARY kernels.

Add cond_resched() to the loop to prevent that.

[ tglx: Split out from Eric's series ]

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/20250214135911.2037402-2-edumazet@google.com
Link: https://lore.kernel.org/all/20250308155623.635612865@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 4576aaed13b23..896ff735034ce 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -118,6 +118,7 @@ static int posix_timer_add(struct k_itimer *timer)
 			return id;
 		}
 		spin_unlock(&hash_lock);
+		cond_resched();
 	}
 	/* POSIX return code when no timer ID could be allocated */
 	return -EAGAIN;
-- 
2.39.5



