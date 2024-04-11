Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D913AD0C;
	Thu, 11 Apr 2024 10:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829847; cv=none; b=LHJ/YpPEpHJkIV549qHNcIJoFlWCTZoYTBdJZ2A66QT2hauBgbMZC3gWg21YlNN1B5AFKkj5IGBGmKwaKAzr+x/c23ozWiaM2IKKFZKq9NVivDRS6qlkYOaFQsXPXNhOKNn8ZOO2Vjk86dIVD8LwKfisWgvK0pJklE2LaCkR+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829847; c=relaxed/simple;
	bh=Lf3Ec4GdDwyTtG+/K8uNbpuSbZ9keSRNSvGORemGxkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeM70SKePS34Avq6PqqV//cuyJdYp+qEvQ1ls8WrHWQ37lyyEVY/hE4hXlWYY38YQonokHfrwmXs53r6w42NmaTV2fARfBiClGZSleR6d/S89Lvga4dzU1LKkzG3Bm8Mcja6sQcZSZ5d4ALe96XaZ5VXdjiZ/jUlo1ti9kpUpo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CENSAMwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CENSAMwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616A7C433F1;
	Thu, 11 Apr 2024 10:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829847;
	bh=Lf3Ec4GdDwyTtG+/K8uNbpuSbZ9keSRNSvGORemGxkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CENSAMwKld4z/19iSQvOmG64DNrtvO/ku2z6EFghZXXKDYCcezwyzVO+Ri/i8e6j0
	 On1gwIctTEH92DgnClUISOZ25UvSjXl5B3py5i79lY00oHlRvDjqz4pgb54yyAdKsq
	 O+4PbZww3fgLfWwPoVoWxtQLC0i+IRGdVfa1SrQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/175] printk: Update @console_may_schedule in console_trylock_spinning()
Date: Thu, 11 Apr 2024 11:55:10 +0200
Message-ID: <20240411095422.181466343@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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
index 2ba16c426ba5d..66c78dfd17925 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1732,6 +1732,12 @@ static int console_trylock_spinning(void)
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



