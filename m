Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3D4173;
	Tue, 30 Sep 2025 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244561; cv=none; b=fbHnJ/MZ5WdTs+8MXD630BIerNh4A4An+ujvWhg7ranWFx6devCiFlTpE+DJ4AKT8wnhISx1Dw6kPY/jQW3y8zk2yrbnKaa4oOb7aYeIEQu0mghup1IoqsKCMjIu47yMrgE224Pz5d9HXvew/gikNv76KumJrOId5ujck0OukDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244561; c=relaxed/simple;
	bh=m/DjoQew7AmbsFqmkFdYFWIHvtMJ2kW2CJrof4Py/Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpQaDc1DLZzt7j+aDrg2wzd+EwiKjDIeQH7m6cphcJqIZOl7xDfyuIb6cjGHEIVI5x/+cXIjUsQ/6/jX1SuqQhWexz++qaPiAjPKnZUrRWFoCT1Ce9w9fc9SyrUmEGwF9WSQYTyCK6wgqasrboAP1zmFu3vbp6Fxp8ACmKtxLCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8IopciC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8IopciC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E1C4CEF0;
	Tue, 30 Sep 2025 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244560;
	bh=m/DjoQew7AmbsFqmkFdYFWIHvtMJ2kW2CJrof4Py/Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8IopciCyyMVU1XN9Ybd4PQ64Tu+ROmB3/KoYSuCen9Dcpa19rzNkAImsu1A74WLj
	 JkpSz1RLOf1GfZ8fPQWZ91mCFgwg4ZHKIx65KvlN3om/1fOk6Td21rtsdDBswDCyiH
	 0gVcmP5GhOM0rTXQdEuM+Mcc813E4o5A2riV3z8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 044/143] cpufreq: Initialize cpufreq-based invariance before subsys
Date: Tue, 30 Sep 2025 16:46:08 +0200
Message-ID: <20250930143832.992769329@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 8ffe28b4e8d8b18cb2f2933410322c24f039d5d6 ]

commit 2a6c72738706 ("cpufreq: Initialize cpufreq-based
frequency-invariance later") postponed the frequency invariance
initialization to avoid disabling it in the error case.
This isn't locking safe, instead move the initialization up before
the subsys interface is registered (which will rebuild the
sched_domains) and add the corresponding disable on the error path.

Observed lockdep without this patch:
[    0.989686] ======================================================
[    0.989688] WARNING: possible circular locking dependency detected
[    0.989690] 6.17.0-rc4-cix-build+ #31 Tainted: G S
[    0.989691] ------------------------------------------------------
[    0.989692] swapper/0/1 is trying to acquire lock:
[    0.989693] ffff800082ada7f8 (sched_energy_mutex){+.+.}-{4:4}, at: rebuild_sched_domains_energy+0x30/0x58
[    0.989705]
               but task is already holding lock:
[    0.989706] ffff000088c89bc8 (&policy->rwsem){+.+.}-{4:4}, at: cpufreq_online+0x7f8/0xbe0
[    0.989713]
               which lock already depends on the new lock.

Fixes: 2a6c72738706 ("cpufreq: Initialize cpufreq-based frequency-invariance later")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 628f5b633b61f..b2da1cda4cebd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2956,6 +2956,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 			goto err_null_driver;
 	}
 
+	/*
+	 * Mark support for the scheduler's frequency invariance engine for
+	 * drivers that implement target(), target_index() or fast_switch().
+	 */
+	if (!cpufreq_driver->setpolicy) {
+		static_branch_enable_cpuslocked(&cpufreq_freq_invariance);
+		pr_debug("cpufreq: supports frequency invariance\n");
+	}
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_boost_unreg;
@@ -2977,21 +2986,14 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	hp_online = ret;
 	ret = 0;
 
-	/*
-	 * Mark support for the scheduler's frequency invariance engine for
-	 * drivers that implement target(), target_index() or fast_switch().
-	 */
-	if (!cpufreq_driver->setpolicy) {
-		static_branch_enable_cpuslocked(&cpufreq_freq_invariance);
-		pr_debug("supports frequency invariance");
-	}
-
 	pr_debug("driver %s up and running\n", driver_data->name);
 	goto out;
 
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_boost_unreg:
+	if (!cpufreq_driver->setpolicy)
+		static_branch_disable_cpuslocked(&cpufreq_freq_invariance);
 	remove_boost_sysfs_file();
 err_null_driver:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-- 
2.51.0



