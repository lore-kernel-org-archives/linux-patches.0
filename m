Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716DD17CA12;
	Mon, 10 Mar 2025 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629066; cv=none; b=GVJFo5CAx930nHms7Vd92Gy8WfBVRm7dptMV16s4/Ld6RCYG3++KAug+b20T6ljwaiZpE29L69tvJEFVimFKhWdrQ0kkGZcE7dKY4pvKBbqqlmMKCgtmgQD5aRTC8k+62zN2uwIuF/PN3N3T0vKzoF7evh2emMwSVGf6002WZWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629066; c=relaxed/simple;
	bh=4n1HEHpN55C7bQkCmyKDm60yK/qjW6fKH/9NO64qdVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSgg/T/KMB2zGhqJEsyw2lRSjrnyh0VryU7NcbieEngL9IhSkrldIPbLipToiIkySoDbix34qJH4vAQOu+Huejb9LC9Oo4+c6ybrOhnf0Z/AqPYoA9QBm9SgYHPssyjv/6RGOJRBRGsjLc3XpLC8pm8pKMsjsxROQxh04VMxPyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFxu8FmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFxu8FmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBA6C4CEE5;
	Mon, 10 Mar 2025 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629066;
	bh=4n1HEHpN55C7bQkCmyKDm60yK/qjW6fKH/9NO64qdVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFxu8FmH2njpxx39DWBTsYKQLgy7VFP1yTVBvbdCpnBfjufGTFbcAjUGHSnJSVYzA
	 F8fhDe1lzCjUPLIHpVlSDAo2Xse7T68ebCXi/4TzhBILI4WoKjcpuiDWu1TCpL7sBn
	 0Znsk9rSJgI8itq5lxiGMlL/mNuRdkhC18WsFzV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/620] PM: hibernate: Add error handling for syscore_suspend()
Date: Mon, 10 Mar 2025 18:00:11 +0100
Message-ID: <20250310170552.134750996@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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
index 9abc73d500fbf..747c856411e39 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -593,7 +593,11 @@ int hibernation_platform_enter(void)
 
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
@@ -605,6 +609,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+ Enable_irqs:
 	system_state = SYSTEM_RUNNING;
 	local_irq_enable();
 
-- 
2.39.5



