Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FC76BB5B;
	Tue, 12 Aug 2025 18:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023515; cv=none; b=tNhM5Goh4XooCiB5Loj1N/rJfvkKai1I1Nkducd1PbUFAl+wbjY4PpDS1/Hh8dWfZpn/8wbMKYskpzW4lh+lVwGHcA1Tq2DanafBCHCg+AAS+H64/rmyAhZ/z0UzbvQhqE4wkK/iFlki5zPCb+Cec0MwcbpC5QDRMeoDuJ+HaUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023515; c=relaxed/simple;
	bh=4/0GI8UwVxhTxLIg7b8LMPXfHIbT9Hf77jYfjs0QlBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abnmlz146q0Qq1Js/+qTCi+1Q9zqH2HIHe9T5RHUbwpCue4GUNJaBizjOe/Sdx5nD/KKaAJfmlMGoEclLRx2q7IAylSK5DttOf7uTEckFDRvjSc6viMPSYkB8COpoYYlw+E4QdvNfe6cgHizuzzZ60sc8RTYllTAvllO5HoEaR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xznsroPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xznsroPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48229C4CEF0;
	Tue, 12 Aug 2025 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023514;
	bh=4/0GI8UwVxhTxLIg7b8LMPXfHIbT9Hf77jYfjs0QlBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xznsroPJrElMGtQOFoC9SwsNJmpK7UpEpexJjGJCDT+0fpT4BHjlk6NsL8WHlZ1bd
	 UVs7T6afb+C5jRg/kJ0mVnp17RwvWFVb0l8UXwI1w+vF3sqQEElNhan2O8AHAc38ZJ
	 jOQFqwHB4Xiy/EWvxnMgsKyBNV8OnqlNgZMmTiik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 059/627] cpufreq: armada-8k: make both cpu masks static
Date: Tue, 12 Aug 2025 19:25:54 +0200
Message-ID: <20250812173421.575065759@linuxfoundation.org>
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



