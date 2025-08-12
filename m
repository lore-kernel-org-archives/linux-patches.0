Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6EF1EF38C;
	Tue, 12 Aug 2025 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023535; cv=none; b=X4n7/4WAcerloD2ildm/t/9O2Xf+wUiymx1f1b8YAHFNnIij5rseSqjWRE5GMFzkjiocDVT+7OebYKCHJr5r20XwNB25ajCsi8Mcrf2E7vG7NZqTY50rVHwcyz8Koi5dLUao2xhBVTwDJRGQAM6SG6AaxFR4LMxT7PXZ4b5IV4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023535; c=relaxed/simple;
	bh=qgQBW8R8EAfgE/1RcjTzVuwXTDUs8aqH2kKxVI8aSdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4PkqnTqxwQRvlSDVzCnQ7WtUCuG1CXYVlZ2VsgSkye06ql39P1ClR+jLRYUkaVsoAAd/UsvVb6aPz8QAYknCfPlblirqAKH8rbkxG8ubFYZjI56Lrj99u4EMtXpdOBrkzc/l6RjDsi4FdGauiYFTOsGG/hEeBBNCZ2y2kaenAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpijITnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpijITnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AE9C4CEF1;
	Tue, 12 Aug 2025 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023535;
	bh=qgQBW8R8EAfgE/1RcjTzVuwXTDUs8aqH2kKxVI8aSdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpijITnGoaWktRd6sE5hc/JF3tMSzs81WQEk82gy/+R7CmzilYv1HFxCib0eGDfn1
	 jcnazAM2gWTPoXLF83lxca2eArQKDxHXbIBaQJVoyRQlte3dX1LH5SUZ6LY5cgKKy9
	 7dxcMZRXSNw5IuCT908ITHwN7hv163fjeebubjEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 109/627] cpufreq: Initialize cpufreq-based frequency-invariance later
Date: Tue, 12 Aug 2025 19:26:44 +0200
Message-ID: <20250812173423.459382063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d7426e1d8bdd..189e2166ddef 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2944,15 +2944,6 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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
 
@@ -2983,6 +2974,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
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



