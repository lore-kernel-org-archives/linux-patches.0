Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3411D3BAD9C;
	Thu, 17 Sep 2026 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665388; cv=none; b=lnilJZVk0sGlRL3JfAzgeD8ieUkl8+Ek9dqf/8Svn6fsOHfWhiQobNWh8Qxjfo0ZdJyG3k+numQzzzAPWoJ98QTWkxU5ODFfPowg5Hbx7sOEHVl2rmPdLH8D5SxWvvJBcsZyGQDwtC1rejpTgDbs6Xw8PofkMEbLJHolFSzjQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665388; c=relaxed/simple;
	bh=D1cbQHm/wr4+rG1zm2UV51uxia48Riym6XUH8QmUDuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHNDYLr6Oxw4ym+EThWrKwmhD5PbhUttF0BYVuuEADRtjyrO35l5CUw/bA2STDRSxRsK8T18+7+c/t/eWzk0x9WcQa0eT7DnIA/pdz5bhErN5ddlSD4eoe5O37qzTfQZgltHNKJsT3L1Uxj7eKkJ/+fr5pvN0pubJw3BfjYzvaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQRA6Lyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQRA6Lyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED1B1F000FF;
	Thu, 17 Sep 2026 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665386;
	bh=XK/qwiRhRHpBAnIRjCjLWhyOc67Q8Wb7uG79UK4rEcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQRA6Lyb01S9dIH9HbqTorgmkCXY39UM1bxCdW4b25y1KYGnT/rFKxu4Fpb+fj6Oo
	 vWGZl60HXH6b0kirmTXOlf6iVa35cobWBaEeA8O2VFxn2Tehk1Vn6A/GSaBcsq5DsF
	 2i7940LamDLmErLIAM6SH4E/S7OjlwEB6gQD7uas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0651/1250] s390/vtime: Use __this_cpu_read() / get rid of READ_ONCE()
Date: Thu, 17 Sep 2026 16:07:26 +0100
Message-ID: <20260917151609.542239762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit e282ccd308de7b2a65eb4596da8030c18b543071 ]

do_account_vtime() runs always with interrupts disabled, therefore use
__this_cpu_read() instead of this_cpu_read() to get rid of a pointless
preempt_disable() / preempt_enable() pair.

Also there are no concurrent writers to the cpu time accounting fields
in lowcore. Therefore get rid of READ_ONCE() usages.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: ca1f4a5ecab0 ("s390/time: Use jiffies instead of jiffies_64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vtime.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 122d30b104401..4111ff4d727cc 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -137,23 +137,16 @@ static int do_account_vtime(struct task_struct *tsk)
 		lc->system_timer += timer;
 
 	/* Update MT utilization calculation */
-	if (smp_cpu_mtid &&
-	    time_after64(jiffies_64, this_cpu_read(mt_scaling_jiffies)))
+	if (smp_cpu_mtid && time_after64(jiffies_64, __this_cpu_read(mt_scaling_jiffies)))
 		update_mt_scaling();
 
 	/* Calculate cputime delta */
-	user = update_tsk_timer(&tsk->thread.user_timer,
-				READ_ONCE(lc->user_timer));
-	guest = update_tsk_timer(&tsk->thread.guest_timer,
-				 READ_ONCE(lc->guest_timer));
-	system = update_tsk_timer(&tsk->thread.system_timer,
-				  READ_ONCE(lc->system_timer));
-	hardirq = update_tsk_timer(&tsk->thread.hardirq_timer,
-				   READ_ONCE(lc->hardirq_timer));
-	softirq = update_tsk_timer(&tsk->thread.softirq_timer,
-				   READ_ONCE(lc->softirq_timer));
-	lc->steal_timer +=
-		clock - user - guest - system - hardirq - softirq;
+	user = update_tsk_timer(&tsk->thread.user_timer, lc->user_timer);
+	guest = update_tsk_timer(&tsk->thread.guest_timer, lc->guest_timer);
+	system = update_tsk_timer(&tsk->thread.system_timer, lc->system_timer);
+	hardirq = update_tsk_timer(&tsk->thread.hardirq_timer, lc->hardirq_timer);
+	softirq = update_tsk_timer(&tsk->thread.softirq_timer, lc->softirq_timer);
+	lc->steal_timer += clock - user - guest - system - hardirq - softirq;
 
 	/* Push account value */
 	if (user) {
-- 
2.53.0



