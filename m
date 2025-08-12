Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D78279DB6;
	Tue, 12 Aug 2025 19:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025700; cv=none; b=Fwgl16iWjYFfMbHFHpUObnJwq6meeJmt4oaTkRHofFLH3qtm4adsn7zIflHvtNsNK2Fw2HbJ/h8kxPUbuzTj9cNtGm0sE/QZm+OAa8SW3RvcT9BixL5r3m6AbhbA3oU4mt7nS6dSDiF/lHtKptsZ1Ia0QTBwhJoOmwGpHZigXBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025700; c=relaxed/simple;
	bh=zprLKZoGswFLgnnbT9UPOmotydSpSK3vNWI9jekZJRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpfdpPyRu0/H2krCXotbMQRMBuHTYVuQSC4PNkog999wgSzHHSs0st219i7GR2q4hpKteNQ/6C0jYe8pp/F3LnoUGWsbk0IQk+umFtaHE25agpwpSUn6aFYoDC5uoG2jXZCITr0DiAgF64QEovXFWCYhy4gNKintk5w5OJKUOUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3iRsHsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3iRsHsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8758C4CEF0;
	Tue, 12 Aug 2025 19:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025700;
	bh=zprLKZoGswFLgnnbT9UPOmotydSpSK3vNWI9jekZJRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3iRsHsFNWg/G/zRwcRdDmsCwXFevciA78M5HdXutEMoGiukzwUXOmIfOoYCub055
	 UMXNhp/0AoOBdTWmKI13UxgbpbpW3HB20CA9bvReFwCJZh2RQIk9CicWuPtMY0T9Gw
	 ZBkHsMQLD5EPh8QhvKDYbNa9p7XQmnbEcyK8pYRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 085/480] cpufreq: Initialize cpufreq-based frequency-invariance later
Date: Tue, 12 Aug 2025 19:44:53 +0200
Message-ID: <20250812174400.955063007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 2a6c727387062a2ea79eb6cf5004820cb1b0afe2 ]

The cpufreq-based invariance is enabled in cpufreq_register_driver(),
but never disabled after registration fails. Move the invariance
initialization to where all other initializations have been successfully
done to solve this problem.

Fixes: 874f63531064 ("cpufreq: report whether cpufreq supports Frequency Invariance (FI)")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-2-zhenglifeng1@huawei.com
[ rjw: New subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f45ded62b0e0..ea2a8d86d640 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -3009,15 +3009,6 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	/*
-	 * Mark support for the scheduler's frequency invariance engine for
-	 * drivers that implement target(), target_index() or fast_switch().
-	 */
-	if (!cpufreq_driver->setpolicy) {
-		static_branch_enable_cpuslocked(&cpufreq_freq_invariance);
-		pr_debug("supports frequency invariance");
-	}
-
 	if (driver_data->setpolicy)
 		driver_data->flags |= CPUFREQ_CONST_LOOPS;
 
@@ -3048,6 +3039,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	hp_online = ret;
 	ret = 0;
 
+	/*
+	 * Mark support for the scheduler's frequency invariance engine for
+	 * drivers that implement target(), target_index() or fast_switch().
+	 */
+	if (!cpufreq_driver->setpolicy) {
+		static_branch_enable_cpuslocked(&cpufreq_freq_invariance);
+		pr_debug("supports frequency invariance");
+	}
+
 	pr_debug("driver %s up and running\n", driver_data->name);
 	goto out;
 
-- 
2.39.5



