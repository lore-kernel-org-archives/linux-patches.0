Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB6934C990;
	Fri, 21 Nov 2025 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732415; cv=none; b=otVIQjQdJK9MEjp24g1N/aXAVoE4yEEIfDqHFDuHVECKuBPOhMfMadYQPd63fpEmHHoTgw2pOncOFJrJ91zIqAxoemG+BMUrDQx+ILqkORiF0FVVEajD85oYJeuXdgltrHqZ4Fu2WDR81X2c1gvv20hHvvdNckHSlE9FCrzkwvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732415; c=relaxed/simple;
	bh=4arBIfOSL30BudKCKTYT2FnLpg8QJo3wWJorgCIG51A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJ9uUximyKs73kkTwB0iwoj7K8fiMPQk+kfD40rIN32JdCjwKnYEnEgNJv5V0yRbh/Sn6qH5xTHzAgu9ek3ZapO7GnawXqhDsWF/aB6OLz4zjBUflagg23LCmuppaWqjlG4hh04NNS88rsHZrUucsvCJjiK/GM9DCk0JmkP+71s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9ySpIVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9ySpIVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AB0C4CEF1;
	Fri, 21 Nov 2025 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732415;
	bh=4arBIfOSL30BudKCKTYT2FnLpg8QJo3wWJorgCIG51A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9ySpIVWGLoEeAf/Q/V+UWS8gg52ecAg6CNtbUfAm9AdI6w6Z9JCU61ZT/PGsyN8r
	 iTqAxXwKKYPbwOb4+pCUayBwOU0G7RIZNgS+9r1uClQTCAWhKAfcBABemaddCkZhcT
	 rJ/ErVxTySlSqNjRefcnBuQ8MaFpesYiQjMky6kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/529] cpuidle: Fail cpuidle device registration if there is one already
Date: Fri, 21 Nov 2025 14:06:35 +0100
Message-ID: <20251121130234.443233745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7b1b7961170e4fcad488755e5ffaaaf9bd527e8f ]

Refuse to register a cpuidle device if the given CPU has a cpuidle
device already and print a message regarding it.

Without this, an attempt to register a new cpuidle device without
unregistering the existing one leads to the removal of the existing
cpuidle device without removing its sysfs interface.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 737a026ef58a3..6704d610573ad 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -634,8 +634,14 @@ static void __cpuidle_device_init(struct cpuidle_device *dev)
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	unsigned int cpu = dev->cpu;
 	int i, ret;
 
+	if (per_cpu(cpuidle_devices, cpu)) {
+		pr_info("CPU%d: cpuidle device already registered\n", cpu);
+		return -EEXIST;
+	}
+
 	if (!try_module_get(drv->owner))
 		return -EINVAL;
 
@@ -647,7 +653,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states_usage[i].disable |= CPUIDLE_STATE_DISABLED_BY_USER;
 	}
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
+	per_cpu(cpuidle_devices, cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 
 	ret = cpuidle_coupled_register_device(dev);
-- 
2.51.0



