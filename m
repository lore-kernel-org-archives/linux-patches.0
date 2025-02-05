Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA2A1519B4;
	Wed,  5 Feb 2025 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768192; cv=none; b=Sr3fLjDwavpROyCtFCGOak9SubI/U4JfgcC+IzSeoBwqgEaXmuIsdMtNG8fTvuRqmaest3a+qe6kL9v+CLgck1W+/Vk+xANzyYWggHCAtcf0wZTgrH8m8d0UgjVEVcDgHFnGTqUR6IwLNbZ7AO1TtMQOgAMgKFnGpODHYOHeQus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768192; c=relaxed/simple;
	bh=Wmn4HasTM0+YutRiicjEH4E4mSU9eWPNqN7mrTUu2oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBxtXqC0v+LhEyajEiv1GF+NfLK1CrJ/nt4Qc4L/oklUXfFPOPvLlVltK4Ulyko95Zswee5IZwgwH6/TdgcnssQSd/ryXX3PJZJLBYVv1rZgWk0NP0OK0HzzxHrbihWQYNBi9u7vVfInmkxaPotE0wR6MnpDE6bR7L/wXUJBRQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7aOdYq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7aOdYq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D1AC4CED1;
	Wed,  5 Feb 2025 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768192;
	bh=Wmn4HasTM0+YutRiicjEH4E4mSU9eWPNqN7mrTUu2oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7aOdYq9bCVZQXbJKvbmOb5TUQo6CE3I497nWhrk3Gco2rAbBonXfylvyyW+s4BCc
	 UkQ84THfndXM5Tf2EH+KIFa5yi0sNSLdNRqlr7trjtoIB2TEpu/ZgXThMkFu966mXa
	 KnU0oLmp/HrI+EN9ZwE627E/aBVGjD/+0GlL4du4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 510/623] PM: hibernate: Add error handling for syscore_suspend()
Date: Wed,  5 Feb 2025 14:44:12 +0100
Message-ID: <20250205134515.730331887@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e20a70c572539a486dbd91b225fa6a194a5e2122 ]

In hibernation_platform_enter(), the code did not check the
return value of syscore_suspend(), potentially leading to a
situation where syscore_resume() would be called even if
syscore_suspend() failed. This could cause unpredictable
behavior or system instability.

Modify the code sequence in question to properly handle errors returned
by syscore_suspend(). If an error occurs in the suspend path, the code
now jumps to label 'Enable_irqs' skipping the syscore_resume() call and
only enabling interrupts after setting the system state to SYSTEM_RUNNING.

Fixes: 40dc166cb5dd ("PM / Core: Introduce struct syscore_ops for core subsystems PM")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250119143205.2103-1-vulab@iscas.ac.cn
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 1f87aa01ba44f..10a01af63a807 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -608,7 +608,11 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	system_state = SYSTEM_SUSPEND;
-	syscore_suspend();
+
+	error = syscore_suspend();
+	if (error)
+		goto Enable_irqs;
+
 	if (pm_wakeup_pending()) {
 		error = -EAGAIN;
 		goto Power_up;
@@ -620,6 +624,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+ Enable_irqs:
 	system_state = SYSTEM_RUNNING;
 	local_irq_enable();
 
-- 
2.39.5



