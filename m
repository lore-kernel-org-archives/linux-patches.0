Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B328B282E1;
	Tue, 12 Aug 2025 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022141; cv=none; b=NCQ8O13f2GgYoeGSDSTNgA0j38sbw9syXbbEqWGM4xZ8mnYU5FF1L5AJnDhPmWLzHHa7QpZCxvDTC1pC2Fe8UkFbcBAQQy5BNV3eGQgsaJ0rQuW1F/E8VEbSDkKcSfXO7aSAtBGFFuh/v7lLsNgqGsNTTEnJQtVv5J6a7azpTLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022141; c=relaxed/simple;
	bh=MRANuy0rcoT4SxOZv2PgwQz1b8vS+R2Ioua9U/klHio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9R7UuMIVV4qg1ucyBRw8ujq2dV1JQG7bsZBd9tHnCAqZC5nEte9WT1fzVUB6OxBE2WwKRwgWZYrewhDZR7Mochq8y5Qy7LmA9i/N0+HewF/s7Oz+Gp0+KZrYOZ0ECNhaFlMK5pk3ncEljT4LJsbzmFpVpHgJAbjh8MA1ggJEuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRQ2kBqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRQ2kBqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1618AC4CEF6;
	Tue, 12 Aug 2025 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022141;
	bh=MRANuy0rcoT4SxOZv2PgwQz1b8vS+R2Ioua9U/klHio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRQ2kBqFVRZOMA3mRYgzNfLsn1FsD1A2ed9af2OPn18tHEQoDiZdJrlRlsyIiHfN2
	 O/vK4KLW6RHJV9P7s9tIYY1SBvv84BKby90sLlXHu5duKqMTTBNVb5thWvW8Hvhxd6
	 aOtNXdhgCJO9S/LgnGrCpN2EhrjZ1H92gdo7ZL2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/369] cpufreq: armada-8k: make both cpu masks static
Date: Tue, 12 Aug 2025 19:25:31 +0200
Message-ID: <20250812173016.035327166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 7a979db81f09..ccbc826cc4c0 100644
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



