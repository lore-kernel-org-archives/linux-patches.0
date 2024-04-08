Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2818481727;
	Mon,  8 Apr 2024 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582644; cv=none; b=NK3Ev+w77j7ASgOlflqTyhZzsjUgCOVdTV0Q6SXhKVqOHs4pCiceZfW2oCZDnkyr5ME4ozyA+haUjA2wYZOlShjv9oYgVaau1aVXrkdTZjf1KPKUbWaG1k2BC8kwekc619PJs6RKIi3J87SYFWYMToK8THCOQhZ16sWcKbwUYgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582644; c=relaxed/simple;
	bh=lQRrEymx/ZGGLTHP5WcDNrprJnEimmlgBRh+xfnKVXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO1wYuBsH0IDaWIyAZ5fSPW4l+iqindehe+WteGZuSl5w2ia2xARaRUax6fdtvssdbuXhx59odfaYpHiQsVG6cv+asuz/StvmrNLKmNp++K4ckzsyKv5iQukiVhAnkjqMxUXletVfrGFrwPNdArcpqxgb7pLUK/GezMkrBvvKuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFhaoHsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFhaoHsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B06C433F1;
	Mon,  8 Apr 2024 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582644;
	bh=lQRrEymx/ZGGLTHP5WcDNrprJnEimmlgBRh+xfnKVXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFhaoHsM0i5jYiD2ADyQmaMDs/iKOqVVIpQ8MKa3GP7rks9rEdgdw4w0fUvXN4mYL
	 JGP6PzVx4edwVi3YxyUC89HUQ4/nfOtMyPgxxIHssJbQT1P2FmvkbQB1OyRWXqiMcp
	 qqI5HsENnY5sPXlACRHrDvvulGP4NS1CZmD9goI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/690] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Mon,  8 Apr 2024 14:50:12 +0200
Message-ID: <20240408125404.802434525@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 8076972468584d4a21dab9aa50e388b3ea9ad8c7 ]

console_trylock_spinning() may takeover the console lock from a
schedulable context. Update @console_may_schedule to make sure it
reflects a trylock acquire.

Reported-by: Mukesh Ojha <quic_mojha@quicinc.com>
Closes: https://lore.kernel.org/lkml/20240222090538.23017-1-quic_mojha@quicinc.com
Fixes: dbdda842fe96 ("printk: Add console owner and waiter logic to load balance console writes")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/875xybmo2z.fsf@jogness.linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index df4d07af6d1e2..323931ff61191 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1908,6 +1908,12 @@ static int console_trylock_spinning(void)
 	 */
 	mutex_acquire(&console_lock_dep_map, 0, 1, _THIS_IP_);
 
+	/*
+	 * Update @console_may_schedule for trylock because the previous
+	 * owner may have been schedulable.
+	 */
+	console_may_schedule = 0;
+
 	return 1;
 }
 
-- 
2.43.0



