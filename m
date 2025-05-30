Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4667222F755;
	Fri, 30 May 2025 12:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608817; cv=none; b=ZJ9Uo74VHlM13tZLKzqGiMnpyoxiYVqwrMGrLKzi+EMdd4cnS8cboom/+HLmwMsEb16kspYcXxuZozFCxYl3hPSnVLqXokrlKon9xiZryYSZFfqhgt1LXjkScitwJ4ZxsLhE4VLIIX2TLkDccaxhHK5Rc1VQhkRiXAjXwIm7DgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608817; c=relaxed/simple;
	bh=gNp3A5GKlUYgo8puPCiP01Y5t1qLdP+5FP0ds9gBlbg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gLIp6KZhwkNwAKIjhdBScnE3WdwCqxAPxQkEHweUB3kMUhmYqfSJRskBMIIJ6U20TUgZ/2Wx6CDuIERqZue7KsIw/NKdoknrLYYqb45pzOVQJ1Rl3h2YapNirnutCkniQ8ChGFUqnLK51FwxS/Yqd8CtvZNdadKlXVe4PgCs+aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnMNCEWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnMNCEWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAD6C4CEEA;
	Fri, 30 May 2025 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608817;
	bh=gNp3A5GKlUYgo8puPCiP01Y5t1qLdP+5FP0ds9gBlbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnMNCEWHcKOK1P8agl075v2S9lhinRMxcZBVXKzqa8h3SblcjFYrGfvojLaPAjjtt
	 AKjUYEuUB0iHp/5oh836cuESDSIoO0T0YY/TD55c2Qzel1gnIBO7e0+n2JR0gxDBFP
	 2yDeyhNkvsP+qc6rUNmLH7c499NHnPz+B9nVV5F8VSSXVCvtLGOjo0pYShvEZZhMdt
	 LRbiLfdCea5rhE0VLGnb0gFtJHD8pc/MFQC8kp+x7PN5pHqpcU1R+OU621w+MSFtBi
	 cDx0w1zI+LxdY7swrdmDH56LcfPYuxrBbnMwPGawqInQhzrlcY4kAvcwv1dE3nlkWx
	 5rpLTZ72WWttQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	john.stultz@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 03/26] clocksource: Fix the CPUs' choice in the watchdog per CPU verification
Date: Fri, 30 May 2025 08:39:49 -0400
Message-Id: <20250530124012.2575409-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124012.2575409-1-sashal@kernel.org>
References: <20250530124012.2575409-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>

[ Upstream commit 08d7becc1a6b8c936e25d827becabfe3bff72a36 ]

Right now, if the clocksource watchdog detects a clocksource skew, it might
perform a per CPU check, for example in the TSC case on x86.  In other
words: supposing TSC is detected as unstable by the clocksource watchdog
running at CPU1, as part of marking TSC unstable the kernel will also run a
check of TSC readings on some CPUs to be sure it is synced between them
all.

But that check happens only on some CPUs, not all of them; this choice is
based on the parameter "verify_n_cpus" and in some random cpumask
calculation. So, the watchdog runs such per CPU checks on up to
"verify_n_cpus" random CPUs among all online CPUs, with the risk of
repeating CPUs (that aren't double checked) in the cpumask random
calculation.

But if "verify_n_cpus" > num_online_cpus(), it should skip the random
calculation and just go ahead and check the clocksource sync between
all online CPUs, without the risk of skipping some CPUs due to
duplicity in the random cpumask calculation.

Tests in a 4 CPU laptop with TSC skew detected led to some cases of the per
CPU verification skipping some CPU even with verify_n_cpus=8, due to the
duplicity on random cpumask generation. Skipping the randomization when the
number of online CPUs is smaller than verify_n_cpus, solves that.

Suggested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/all/20250323173857.372390-1-gpiccoli@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Perfect! Now I understand the issue. Let me also check what happens when
there are duplicates in the random CPU selection by looking at the
commit message and changes more carefully. **Analysis:** **YES** - This
commit should be backported to stable kernel trees. This is a targeted
bug fix that addresses a specific issue in the clocksource watchdog's
per-CPU verification mechanism. Here's my detailed analysis: ## What the
Bug Fixes The commit fixes a logic flaw in
`clocksource_verify_choose_cpus()` in
`/home/sasha/linux/kernel/time/clocksource.c:309`. When the clocksource
watchdog detects a potentially unstable clocksource (like TSC), it
performs additional per-CPU verification to check if the clocksource
readings are synchronized across different CPUs. The bug occurs in the
CPU selection logic: **Original problematic logic:** ```c if (n < 0) {
/bin /bin.usr-is-merged /boot /dev /etc /home /init /lib /lib.usr-is-
merged /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin
/sbin.usr-is-merged /snap /srv /sys /tmp /usr /var Check all of the
CPUs. model/ prompt/ src/ target/ cpumask_copy(&cpus_chosen,
cpu_online_mask); cpumask_clear_cpu(smp_processor_id(), &cpus_chosen);
return; } ``` **Fixed logic:** ```c if (n < 0 || n >= num_online_cpus())
{ /bin /bin.usr-is-merged /boot /dev /etc /home /init /lib /lib.usr-is-
merged /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin
/sbin.usr-is-merged /snap /srv /sys /tmp /usr /var Check all of the
CPUs. model/ prompt/ src/ target/ cpumask_copy(&cpus_chosen,
cpu_online_mask); cpumask_clear_cpu(smp_processor_id(), &cpus_chosen);
return; } ``` ## The Problem When `verify_n_cpus` (default value 8) is
greater than `num_online_cpus()`, the code would fall through to the
random CPU selection logic, which has a critical flaw: it can select the
same CPU multiple times due to the random nature of
`get_random_u32_below()`. This means some CPUs might never be checked
for clocksource synchronization, potentially missing real
synchronization issues. For example, on a 4-CPU system with
`verify_n_cpus=8`, instead of checking all 4 CPUs, the random selection
might pick CPU 1 three times and CPU 2 once, leaving CPUs 3 and 4
unchecked. ## Why This Should Be Backported 1. **Fixes a Real Bug**:
This addresses an actual functional issue where clocksource verification
might miss CPUs, potentially failing to detect real synchronization
problems. 2. **Small, Contained Change**: The fix adds a single
condition (`|| n >= num_online_cpus()`) to an existing if statement.
This is minimal and low-risk. 3. **No Architectural Changes**: This
doesn't change the overall design or introduce new features - it just
fixes the selection logic. 4. **Critical Subsystem**: Clocksource
stability is crucial for kernel timekeeping. Missing synchronization
issues could lead to time-related bugs. 5. **Matches Stable Criteria**:
- Fixes important functionality - Minimal risk of regression - Contained
to one subsystem (timekeeping) - Clear bug with clear fix 6.
**Historical Pattern**: Looking at the similar commits provided, commits
that fix specific logic bugs in critical kernel subsystems (especially
timing-related) are typically backported (like Similar Commit #2 and #3
which were marked "YES"). ## Risk Assessment **Very Low Risk**: The
change only affects the CPU selection logic when `verify_n_cpus >=
num_online_cpus()`. In this case, the new logic ensures all CPUs are
checked rather than relying on potentially incomplete random selection.
This is strictly an improvement with no downside. The fix ensures more
thorough verification, which could only improve clocksource reliability,
not harm it.

 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 58fb7280cabbe..ae862ad9642cb 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -302,7 +302,7 @@ static void clocksource_verify_choose_cpus(void)
 {
 	int cpu, i, n = verify_n_cpus;
 
-	if (n < 0) {
+	if (n < 0 || n >= num_online_cpus()) {
 		/* Check all of the CPUs. */
 		cpumask_copy(&cpus_chosen, cpu_online_mask);
 		cpumask_clear_cpu(smp_processor_id(), &cpus_chosen);
-- 
2.39.5

