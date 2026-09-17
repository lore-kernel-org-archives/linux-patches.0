Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19F73B3BE7;
	Thu, 17 Sep 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668800; cv=none; b=f3bPlzOCVfAT+hWBhjYgMNyL71RN0XDQ9sVjyOzGMmAfKM6YE/zjs1vqlOknkpldJml51bkGvfoYeOJF10yN/GGRWyIipckfZ1/InPzg3ss+ORf5xshdro1PvL8juMECmAlMHOMmXmQY3TpBK+W+PsDleln+VTH0cf38tY3xcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668800; c=relaxed/simple;
	bh=huZ9KBTo/RiMZVOU3Rvny5CsGj95z61p0v3cnaPt0q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUa656XM85XAMz3z6vm+zfNVS2kuYT6hu+u5OQWeL6yjxC+VKFnBMwY2fewOCJPQOjj00wJ/uPx78g1oJzqiTWJtDk/mK8fMDpCoLN2j8F46sHISqVwPofGCNS5dR+Q6UQLICvTvPCveGTF8SWYTzP1JwI1rHuX+7bDkRM7A5yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLi1cna3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLi1cna3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9BC1F000FF;
	Thu, 17 Sep 2026 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668797;
	bh=5h+WB9w+aRXyQO6oJnVziJ00uv4H/y6AUeNljCbU/mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLi1cna3waxCkBzJbWtSbp5tD/+JLVZbzvfvmqrkzt3vdUbMEHsCUtChN6VjkIZ2x
	 IgxaLwXmrq3dD5o9eOzJTz4ngzZCbBNbQrLoyGKkksd2XJ1NRZwcW9ty7DvEuZwwN+
	 iOB0AiUCKvx/GcP1kZsjLOA3Sa2Mni115MN+WKac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0543/1102] s390/time: Use jiffies instead of jiffies_64
Date: Thu, 17 Sep 2026 16:08:06 +0100
Message-ID: <20260917151553.456612468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit ca1f4a5ecab084af7f405baa902edbed171b57e6 ]

Christoph Schlameuss and Alexander Egorenkov reported a data-race
reported by KCSAN when jiffies_64 is read:

==================================================================
BUG: KCSAN: data-race in do_account_vtime / tick_do_update_jiffies64

write to 0x0000016599ea8600 of 8 bytes by interrupt on cpu 6:
 tick_do_update_jiffies64+0x140/0x250
=============================================================>
BUG: KCSAN: data-race in do_account_vtime / tick_do_update_ji>

write to 0x0000016599ea8600 of 8 bytes by interrupt on cpu 6:
 tick_do_update_jiffies64+0x140/0x250
 tick_nohz_handler+0x2e6/0x300
 __run_hrtimer+0x156/0x4d0
 __hrtimer_run_queues+0xd2/0x150
...
 system_call+0x72/0x90

read to 0x0000016599ea8600 of 8 bytes by interrupt on cpu 12:
 do_account_vtime+0x7d6/0x860
 vtime_flush+0x26/0xe0
 update_process_times+0x32/0x160
 tick_nohz_handler+0x12a/0x300
...
 system_call+0x72/0x90

value changed: 0x00000000ffffaa6c -> 0x00000000ffffaa6d
...
=============================================================>

Problem is that jiffies_64 instead of jiffies is used. Both are at the
same address, but only jiffies is of volatile type, which prevents this
warning.

Change the vtime code so jiffies instead of jiffies_64 is used
everywhere. This addresses also the inconsistency that both jiffies and
jiffies_64 were used in the original patch which introduced this.

Fixes: f341b8dff982 ("s390/vtime: limit MT scaling value updates")
Reported-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vtime.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 4111ff4d727cc..4591f4765e6bc 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -31,7 +31,7 @@ static atomic64_t virt_timer_elapsed;
 DEFINE_PER_CPU(u64, mt_cycles[8]);
 static DEFINE_PER_CPU(u64, mt_scaling_mult) = { 1 };
 static DEFINE_PER_CPU(u64, mt_scaling_div) = { 1 };
-static DEFINE_PER_CPU(u64, mt_scaling_jiffies);
+static DEFINE_PER_CPU(unsigned long, mt_scaling_jiffies);
 
 static inline void set_vtimer(u64 expires)
 {
@@ -81,7 +81,7 @@ static void update_mt_scaling(void)
 		memcpy(cycles_old, cycles_new,
 		       sizeof(u64) * (smp_cpu_mtid + 1));
 	}
-	__this_cpu_write(mt_scaling_jiffies, jiffies_64);
+	__this_cpu_write(mt_scaling_jiffies, jiffies);
 }
 
 static inline u64 update_tsk_timer(unsigned long *tsk_vtime, u64 new)
@@ -137,7 +137,7 @@ static int do_account_vtime(struct task_struct *tsk)
 		lc->system_timer += timer;
 
 	/* Update MT utilization calculation */
-	if (smp_cpu_mtid && time_after64(jiffies_64, __this_cpu_read(mt_scaling_jiffies)))
+	if (smp_cpu_mtid && time_after(jiffies, __this_cpu_read(mt_scaling_jiffies)))
 		update_mt_scaling();
 
 	/* Calculate cputime delta */
-- 
2.53.0



