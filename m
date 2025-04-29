Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2864319F424;
	Tue, 29 Apr 2025 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950300; cv=none; b=OmsOIXbjSl78iJonVxSXRnIQaZx97gCiqwBDHihH8lrQnpOByQqRaYdxCsw9XXWJ8tl7BL+mn8LUa+K2A5Yw5g4F8WuRTULeXtKswIuDMQbbiclkQTvVfA9RXNQDwczxQflsAoY+261WYhv8k5rqVCwZxcsb6d2+R2cskNbv3Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950300; c=relaxed/simple;
	bh=oTzly1BH05WRmprmrep8WtfAUMAvi9kVsBbqjEEtjts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBnnhm7DlC+fu3LUcCBojkEvo2ZhOTkK0xFSgZs/rFmm0iQ3TyduCg7eMEr40KNfVTbdBQQUyNgHb+iYxBhgRVvG4qv8CTUZwtXVOkpJOMn21nXI5URlyMPUn88vo7XTB0ZkbipSZi3J5gVdsMZ3K9saPcOnEBzGxGojERhKlJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCr1JveV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCr1JveV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3952C4CEE9;
	Tue, 29 Apr 2025 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950300;
	bh=oTzly1BH05WRmprmrep8WtfAUMAvi9kVsBbqjEEtjts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCr1JveV3n086qR8VYoCqxwHdKA98azrZEqc71EDQrz8QBc0fCTttzJ0OPykF/hG2
	 auxVXS7Oz5V5OqIH9dpMhqm7stimHALzi5FEUPQiOO5o4AUVdu0G/3FEXJfwhjODMG
	 HHnc3qKQe6R5Ji6gkrcR4oTK4ubCFlhIDgZfTCi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/204] cpufreq: cppc: Fix invalid return value in .get() callback
Date: Tue, 29 Apr 2025 18:42:19 +0200
Message-ID: <20250429161101.491173890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 2b8e6b58889c672e1ae3601d9b2b070be4dc2fbc ]

Returning a negative error code in a function with an unsigned
return type is a pretty bad idea. It is probably worse when the
justification for the change is "our static analisys tool found it".

Fixes: cf7de25878a1 ("cppc_cpufreq: Fix possible null pointer dereference")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index c8447ecad797e..aa34af940cb53 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -773,7 +773,7 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 	int ret;
 
 	if (!policy)
-		return -ENODEV;
+		return 0;
 
 	cpu_data = policy->driver_data;
 
-- 
2.39.5



