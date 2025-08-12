Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5868268C73;
	Tue, 12 Aug 2025 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021115; cv=none; b=g11YMb3cUTc6f6WGroP/cOgjlMbNaPYENVtMJOYSdOOVREmmerlv1dkr/6GYeG8dpwiJ8QR/a9dnSNL1PIR6nk4JWIJG9g7pjsv550YEFPG3/NHDeAZbW0etMaXYGgFKy7ytsmLR/IM7zxQoOQkC8IevieqxwUHMLg2evUOBZRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021115; c=relaxed/simple;
	bh=1HIeY0ZEevQ8/40Hjis282DocBF+fekN+82GQphtYKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjivNfGRvTIdaQ3lOe02XawaillAzuK3UlGV+cji4/VqANSxoL8hnohTJ28RB9lHxTzGZ9EuOYn7N7sZv6aBYFu6Y+7smtlm5AbEqekzN/xfNI1eGpThD2lXxvi6uzqp+/McGrN31XQ3jYCCZurEkctyv3OMENbTPxmRCZWHY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXESs8rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXESs8rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578C6C4CEF0;
	Tue, 12 Aug 2025 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021114;
	bh=1HIeY0ZEevQ8/40Hjis282DocBF+fekN+82GQphtYKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXESs8rU3KFGqSmm9VlcCf+A6hN3YuLwa+9kK3gq1mchXnHFT6J6uMEnO/XFr8TSh
	 PjjSm8A/z8aQKHxdufiphkuwlR6dsam0iHd7cCmiTojM2zne3QPpQDDz2hqICycN5H
	 VYXndUOC8KZWw7x1AUZGOekS0RiuN4/flSmCeWEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/262] cpufreq: Initialize cpufreq-based frequency-invariance later
Date: Tue, 12 Aug 2025 19:27:08 +0200
Message-ID: <20250812172954.666881664@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6682f422cadd..d48a7feba54d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2938,15 +2938,6 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
 
@@ -2977,6 +2968,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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



