Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE60439341;
	Sat, 12 Sep 2026 10:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209769; cv=none; b=KHxOg12/mw5dZzr+dFCJvRIvEbnVLGNVdWFL/sMF2dBnkSsOqXqdZDsa2Z23TnZmKgKLRUTwfUGwp5sZHM3HmtOkGVFpqsFBDkUF2WKBeCx3tfZ+kSnvNlt6FGqHdPnmxjQuHQ9k8hqILavIRBqs6MeryIxkPTHJneks5I6/fKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209769; c=relaxed/simple;
	bh=YzhBPzoU3i5clHoJdEo+hIHLqD7tsd9KU/sApoaHO9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJc2cx8cBvQWuHn8hGrDbl8AcsepMoVXKDy5kx+BgiKFDrDkDuPaS1WR16wzfsgksHxQ1m7WvJHkWkkVBESDngHC6hpLFlOFRzFtDCd6FWWSspKadc71Ek4ztVGT+FmDcLnWzwQqMRiGRJBOnvUIRBHrrfWsKAC11gHIs33oH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncQKW4pX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncQKW4pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B81F00893;
	Sat, 12 Sep 2026 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209765;
	bh=xQI2A3BIo2oeFPRxFBBXxrju4ywyN+M938+O/cW18Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncQKW4pX3Z2v1W0JX9M/3nRxlcXMPqvqxXNWwjL1aTMrEqGJPoOkBOjkQseSBJ5BI
	 xXxNX9+R4ciDv958sY0mdzO5Lkc3ONaR5aQCUrHB1KfIS/78SeYoM0Wdku6iEr7Qgo
	 NtNMJXbq1U6wu8DaQ/CCuDCX/RMiG7eOdsA4ie2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0889/1518] intel_idle: Initialize sysfs after cpuidle driver initialization
Date: Sat, 12 Sep 2026 08:50:58 +0200
Message-ID: <20260912065643.560135880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit ff24f314447a25164bac85cb310c382e289afdbe ]

Reorder initialization calls to initialize the internal driver data before
sysfs:

Was:
intel_idle_sysfs_init();
intel_idle_cpuidle_driver_init();

Now:
intel_idle_cpuidle_driver_init();
intel_idle_sysfs_init();

Follow the general principle that drivers should initialize internal state
before registering external interfaces like sysfs, avoiding potential usage
before full initialization.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Link: https://patch.msgid.link/20251216080402.156988-2-dedekind1@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9eadbed788df ("intel_idle: Avoid using deep idle states during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 9ba83954c2555..45903685fe680 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -2485,12 +2485,12 @@ static int __init intel_idle_init(void)
 	if (!intel_idle_cpuidle_devices)
 		return -ENOMEM;
 
+	intel_idle_cpuidle_driver_init(&intel_idle_driver);
+
 	retval = intel_idle_sysfs_init();
 	if (retval)
 		pr_warn("failed to initialized sysfs");
 
-	intel_idle_cpuidle_driver_init(&intel_idle_driver);
-
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
 		struct cpuidle_driver *drv = cpuidle_get_driver();
-- 
2.53.0



