Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9781E0B73;
	Wed, 19 Feb 2025 09:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956560; cv=none; b=rSoqumNIAsn/9oQB9wmwITs0Y50R+iVan+5MgQh3rRvUaIH7Yhidfrew9yUjSRL1iaynppshFmwo4twFhiOeioOeLfIQPMj2rdFeJaYCVxzq7mXdD/Z+cU7p08iZ52PRR1xeQhAxWSaZZLBvLTh/3pKIO9QeT4/TUnrGST5PqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956560; c=relaxed/simple;
	bh=maTp7UX1UZ+cAA0o3021D/zHLtqv3UeYLVW4lXD7kBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMXpHHQn+BApF+2ljdHECLqmzSEE2tpZuDwdbAagzEi/kCIVNKi3GXxeA+ObAcdTX4i2iLmjYZuF81jBQdXr5AZZ9Y3ldc2fqwTcio2xozvmVwvgPtiav5zpr8ktyzwJngIAG9h/y9C7d3VF7HXvWb83Sb6UIEyo4h/XlKFqaoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBUXeMKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBUXeMKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EADC4CEE7;
	Wed, 19 Feb 2025 09:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956560;
	bh=maTp7UX1UZ+cAA0o3021D/zHLtqv3UeYLVW4lXD7kBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBUXeMKs7rkavRjkshG0EiBqY99ffxX4Hw2UiZ3vqZYLYOZSQekPdMPhYSLOK6R/9
	 +8ygVn5tRsW8h2yPDfinhTwDMGNtGthK+jaAGuwhI+d7/tO+icoggOURKeGuQfsGlT
	 Ww8XIdotQ97mzdnMXE0zFuKbquK2v4jT0Gm+lVBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/578] PM: hibernate: Add error handling for syscore_suspend()
Date: Wed, 19 Feb 2025 09:23:45 +0100
Message-ID: <20250219082701.747764604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 30d1274f03f62..ec34c96514b36 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -599,7 +599,11 @@ int hibernation_platform_enter(void)
 
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
@@ -611,6 +615,7 @@ int hibernation_platform_enter(void)
 
  Power_up:
 	syscore_resume();
+ Enable_irqs:
 	system_state = SYSTEM_RUNNING;
 	local_irq_enable();
 
-- 
2.39.5



