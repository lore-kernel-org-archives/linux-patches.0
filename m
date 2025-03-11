Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F825DD02;
	Tue, 11 Mar 2025 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705524; cv=none; b=d72JJOVgJCxYNoBu/G2JsxGbebBel453u1m/j3m9WVpzStIEKlJatw57Xtlr0gALfFdu0U5opmKXLZ+lpr+tIGq6FAN52cDr23PJPf90WMva+W/rkv1tTp3GSHjULv/yjtbFoO01usT581IMzk7oQj7KFBtF3AbsIldBLCOCR+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705524; c=relaxed/simple;
	bh=vVdj862RCQXQkATd2/EYlbE8UcY5raQmKSZd7buo2GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qg6T8/JO6L9QegEDFhe+6Itijv/erfhOIvvPLFuceaT0Vusq6a+eNzKVGyxiRjpcTI6q8VpanbYWLSNHM3SVAFLH/inRHWCQBDjqFxnPRnbtCU2GbwZNMFiXkqnERpYDpb40RxLz/YdBHinY5Bmf3pqs+it4JYAu7OV0v/ZnGr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCvBaB7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCvBaB7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6EDC4CEE9;
	Tue, 11 Mar 2025 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705524;
	bh=vVdj862RCQXQkATd2/EYlbE8UcY5raQmKSZd7buo2GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCvBaB7uckla+caqHd3lUMudoJx5gv44OQ9M7VlIADJeoqAwy2TTlfepWn1f62mn8
	 DymRElI7M7/LNOHK2tZhiQh3+TWePVGkK/qWC1ZWD+zD/pcmWHYa7KR1R01tgZyeOs
	 HWJY2Xd/lqRkksOjNzB8KY017eXmetsRXoYrFP3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/328] PM: hibernate: Add error handling for syscore_suspend()
Date: Tue, 11 Mar 2025 15:57:15 +0100
Message-ID: <20250311145717.476002794@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f8934f9746e66..78d913a082bee 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -578,7 +578,11 @@ int hibernation_platform_enter(void)
 
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
@@ -590,6 +594,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+ Enable_irqs:
 	system_state = SYSTEM_RUNNING;
 	local_irq_enable();
 
-- 
2.39.5



