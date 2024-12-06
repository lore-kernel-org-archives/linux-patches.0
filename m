Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA2953A7;
	Fri,  6 Dec 2024 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497621; cv=none; b=q64az0BRrgz2J2lpghonvfupkSVnjLfTBwjMRt6MLL77Tz/E58A0FaJL0OF/LEtv9QE5HVjZNh1N/AQePpRgyXwaR5xdIdfqI0f2FfEieSDRKtkX3AYmpCZHAQYQh1XQldWIE8AMNPvwrdIuLq6V3jpXgJU1LWZth5o8Wfs9WC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497621; c=relaxed/simple;
	bh=KVl3FwJ0mHmKUrHfRYPmB+Kgtni3IC9xV4uPItqrmu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6ZI0hfpVXLO7QsUeI1p11FeGRvN8WlAPto9v8QXXoSZiOXl8+y2KVurNuJPzJ/f4VWPttsLJ6GK9lQHpG0033NBloPtG8vKACxwsWhj4GdNmS/tbp4NKDlquMmhrNAk5byOGwGJxXTm+1WwehU8Ne1Vqojn1qUYRNuVPzDwAHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR2rVJQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR2rVJQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9A6C4CED1;
	Fri,  6 Dec 2024 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497621;
	bh=KVl3FwJ0mHmKUrHfRYPmB+Kgtni3IC9xV4uPItqrmu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JR2rVJQ2mTWUxb+qXKKwpi7Bco+mT69m09GfwBfDi3DJ+abfjVTr091GefP31ttLv
	 5n/ABTqc3Bwe8wD/84m1yNp44+7TXTEcR4LqF6u5Zihdnj4dDP28JYihr5sXEzq7rN
	 SAVhvsJKuM+eChLCge5rKrPJdCuBiR6jriIN4b5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/676] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_cost()
Date: Fri,  6 Dec 2024 15:32:14 +0100
Message-ID: <20241206143705.640819218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit be392aa80f1e5b0b65ccc2a540b9304fefcfe3d8 ]

cppc_get_cpu_cost() return 0 if the policy is NULL. Then in
em_compute_costs(), the later zero check for cost is not valid
as cost is uninitialized. As Quentin pointed out, kernel energy model
core check the return value of get_cost() first, so if the callback
failed it should tell the core. Return -EINVAL to fix it.

Fixes: 1a1374bb8c59 ("cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/c4765377-7830-44c2-84fa-706b6e304e10@stanley.mountain/
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 866a0538ca896..05a8418485079 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -499,7 +499,7 @@ static int cppc_get_cpu_cost(struct device *cpu_dev, unsigned long KHz,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



