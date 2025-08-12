Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5B023182D;
	Tue, 12 Aug 2025 19:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025469; cv=none; b=WWZYc5HN4t21Vz0ZBCvQb5HBq65BypjBUMESkw9NzVnsFJBstgT92YTlYSvs6Rx/0WHVkfAwpQCkEMSf7wTV/zIJIMiWPoOlPOtk4bxA5ePZh+n97hjgdqEV3PLMFVumc+X2kKXZPyfVNgOWhiTYM1w8GuBvNTOAUlAJoRJ67Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025469; c=relaxed/simple;
	bh=D6gqBQk6ART6OHbx9S6SNhBrsLV/+2TNgk6RHYu3tZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dF83cv7ONCnjXr+2p3JkGSM3rtgWc++E3C5XlvVIPuu08KeoeIgNEl2W08dATxo+BBhUft3CB59lUhypqacXCOEMP67+GIlX3YeXhVdD5BkICt3dwUJMT/IsRrWMh7ZNoSJHi8XT5C9CipRqhAUkoQxg/8iTRLy+aCWcBa/Nq8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNoDMl0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNoDMl0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4E2C4CEF0;
	Tue, 12 Aug 2025 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025469;
	bh=D6gqBQk6ART6OHbx9S6SNhBrsLV/+2TNgk6RHYu3tZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNoDMl0suJ5YFadQ42l8JMkSCGacpDHaiLKIigPeJIU/MJnkHXv/mJULwryP5d6DC
	 06etmKPUiR87AcqmYB1xATEP54ExGve9er4Dg18q/0Z8e6Q8Gh6DN+RpaSBNqVuJVk
	 xD7wNWCToGjZaCN4YH8bDHhFwao6gBAVhL9bMDYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 051/480] cpufreq: armada-8k: make both cpu masks static
Date: Tue, 12 Aug 2025 19:44:19 +0200
Message-ID: <20250812174359.510977754@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b1b41bc072baf7301b1ae95fe417de09a5ad47e2 ]

An earlier patch marked one of the two CPU masks as 'static' to reduce stack
usage, but if CONFIG_NR_CPUS is large enough, the function still produces
a warning for compile testing:

drivers/cpufreq/armada-8k-cpufreq.c: In function 'armada_8k_cpufreq_init':
drivers/cpufreq/armada-8k-cpufreq.c:203:1: error: the frame size of 1416 bytes is larger than 1408 bytes [-Werror=frame-larger-than=]

Normally this should be done using alloc_cpumask_var(), but since the
driver already has a static mask and the probe function is not called
concurrently, use the same trick for both.

Fixes: 1ffec650d07f ("cpufreq: armada-8k: Avoid excessive stack usage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-8k-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/armada-8k-cpufreq.c b/drivers/cpufreq/armada-8k-cpufreq.c
index 5a3545bd0d8d..006f4c554dd7 100644
--- a/drivers/cpufreq/armada-8k-cpufreq.c
+++ b/drivers/cpufreq/armada-8k-cpufreq.c
@@ -132,7 +132,7 @@ static int __init armada_8k_cpufreq_init(void)
 	int ret = 0, opps_index = 0, cpu, nb_cpus;
 	struct freq_table *freq_tables;
 	struct device_node *node;
-	static struct cpumask cpus;
+	static struct cpumask cpus, shared_cpus;
 
 	node = of_find_matching_node_and_match(NULL, armada_8k_cpufreq_of_match,
 					       NULL);
@@ -154,7 +154,6 @@ static int __init armada_8k_cpufreq_init(void)
 	 * divisions of it).
 	 */
 	for_each_cpu(cpu, &cpus) {
-		struct cpumask shared_cpus;
 		struct device *cpu_dev;
 		struct clk *clk;
 
-- 
2.39.5



