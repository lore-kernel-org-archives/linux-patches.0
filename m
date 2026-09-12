Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB430AAD8;
	Sat, 12 Sep 2026 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223288; cv=none; b=obNWf8UeU3hM1FSmh71SiEe4DCL9PlxBLgNO8evz9tSr1cwo2twQWpgT3PcCBmkEkSBVBEqQNaj8BFJiJIZbHcDJe9O/O0fmlHVjq5X01EOnhq+o+0oKahwwIUWtGiI2w9Yq96TrdpN5cgFnx6JgBSgyFRue7scl4atiKuMpcKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223288; c=relaxed/simple;
	bh=7ZPL1N+r1mqDQCj9MDWJ1z384hQFI4UQNsgzP1EPwUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAjozv3cPmEs1ag1BkROHnN2sln4Av3Pu93wH6CeMoLneZ5eSnFVmyH9souquRKaX1njBkiccCD08ZAYofoOknW3BQTazAhYyzk1gwe3N7Y60U3yybWpVWFwH51jAOYhuG9aQKaQKgMXtk5JsEuLV0AJAwDngjDQskNXQo6202I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzrzrbT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzrzrbT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F511F000FF;
	Sat, 12 Sep 2026 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223286;
	bh=ra2U5FgqbQZEOOk9az8QfyY60ID/SErsR5IfZdlwJtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzrzrbT0SINF7PMz58YVJtdLoCr6qWHtuaQfhNHx92Kv+GjAhdbJV8kRZ6fIZq55+
	 YhPjsMqd5L9nwapB/G/djvSV/r7B0ghiCf7cBBOwYRWz6DqUZWMKZKQw8Zj/Jk/PMB
	 lI0R4KQqykIGXRECMSkYikDAIG7pdTLNzaq3BhtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0758/1424] cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()
Date: Sat, 12 Sep 2026 08:53:10 +0200
Message-ID: <20260912065624.272914908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 6a9e0e0f7592313ace66303cf5eca68e04c10f30 ]

The clk_get_parent() function doesn't return error pointers, it returns
NULL on error.  Update the error checking to match.

Fixes: 420993221175 ("cpufreq: SPEAr: Add CPUFreq driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/spear-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 78b875db6b669..c4d3ec2eafa83 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -79,9 +79,9 @@ static int spear1340_set_cpu_rate(struct clk *sys_pclk, unsigned long newfreq)
 	int ret = 0;
 
 	sys_clk = clk_get_parent(spear_cpufreq.clk);
-	if (IS_ERR(sys_clk)) {
+	if (!sys_clk) {
 		pr_err("failed to get cpu's parent (sys) clock\n");
-		return PTR_ERR(sys_clk);
+		return -EINVAL;
 	}
 
 	/* Set the rate of the source clock before changing the parent */
-- 
2.53.0



