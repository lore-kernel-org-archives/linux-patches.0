Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3221F191F66;
	Wed,  5 Feb 2025 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767589; cv=none; b=Q4Uv/Fo8xXMrdy2YuGNSN6W1lPlZoJC6+b8bBtr/W7L3A6GPBDfUSv/QbUogLrYSx96qBOFHWnAQ+gOZkwZV8GEn2n1nLXvKx+uX589zXc+l/4fCPWCqPC6SX2qY4FR+QiBW76I1QYmAtpVtAj2XSWoj/L9R7a8Q2apuPm9+PdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767589; c=relaxed/simple;
	bh=rwTevFGTziIZ5tEzfTDcBHfGOK3HMfxoqh8k1vzhvfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIL9/1+KIouaE+QdXt5uPSHJJR3MdGbRGOIUyCQp9mqjDEg2WOLyMqBZyb36o1RekXcu3G+kpkqE5LXqkdFWWT+SjC47AHOeoj28jKeycUz9AZt1Z6ZLaqTuDOMvnUBaaEwVJqHAEQdpUp4oXigJumT50ecRfmYUcIi1W9O5VBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0R0quER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0R0quER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916D3C4CED1;
	Wed,  5 Feb 2025 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767589;
	bh=rwTevFGTziIZ5tEzfTDcBHfGOK3HMfxoqh8k1vzhvfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0R0quERZ3eP6VLqTLX4jVxqn+/uEbUhiicRhhKsflmKCDikRi3qkouqJkAToRFUO
	 5gU3pUCGodRNoFkdBl9goFgf1SN4f0RgnK8l7HhFFl+uHvDCkm+LNmXCsv4UJPJcam
	 W1Pin65IvTlJIOIldP9uVFb9NhjP+yXhOSunoxCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/590] PM: hibernate: Add error handling for syscore_suspend()
Date: Wed,  5 Feb 2025 14:43:54 +0100
Message-ID: <20250205134513.587698373@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index e35829d360390..b483fcea811b1 100644
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



