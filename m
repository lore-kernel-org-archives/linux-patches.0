Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F171684AC;
	Tue, 11 Mar 2025 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706599; cv=none; b=j6uJtIDJHcf2/3AYRgJyPBbpUO4l+U/mQU3L07Q170wfUoCt+HLzIhzAxOAPF0Jn0yTwYCjMI2PF3lg2KotqzOQA7vVV6C6nQM8PDxaVVmPtahSV6dkTc4xPar3W5ZD9iS2/FxltDbmK9Bns/icO2nVofLhHBCr7mcymuXGqLa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706599; c=relaxed/simple;
	bh=ygmjU0NQ7AOM6BdPw+AXZ27S5jEdTIw2Tg1o6wFzxYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WB83QCkTlAZHmGNUqP3h3OztxUG4/suctnGi4vQ/P/YfYqn/fKrohN0t3sa9XNroVui7mv4YsUbXSfHwL86hogmaxWbLyjreuuyTyx+v779f2pG8gf7RH/VexJBJQKI80hmOCe376UDTaRWrGj3IQEhTe3g3DftSVqMcTY3/0MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/LSxLJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/LSxLJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A5EC4CEE9;
	Tue, 11 Mar 2025 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706599;
	bh=ygmjU0NQ7AOM6BdPw+AXZ27S5jEdTIw2Tg1o6wFzxYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/LSxLJew315aEFCzXjkXTZWga7yLZFQzatXK0ljoQUnuA/e+2PcRe2F7MXtqt4zC
	 7eaRDr4Gd4DGMvwYhCEndwxFir3yhCExkBr4hIKpg+ty6IPR4YLahxfwXq2E0hUkGK
	 chmF3g0ug4ajRI8X8RHMFUe0qw3xX7+crvUzF2Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/462] PM: hibernate: Add error handling for syscore_suspend()
Date: Tue, 11 Mar 2025 15:56:09 +0100
Message-ID: <20250311145802.433734400@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 59a1b126c369b..f2b2a2dcdb87b 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -590,7 +590,11 @@ int hibernation_platform_enter(void)
 
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
@@ -602,6 +606,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+ Enable_irqs:
 	system_state = SYSTEM_RUNNING;
 	local_irq_enable();
 
-- 
2.39.5



