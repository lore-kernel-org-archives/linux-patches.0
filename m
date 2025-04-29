Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D763B25228D;
	Tue, 29 Apr 2025 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945764; cv=none; b=Ww9MvgAnjYQKqdHu5dWnJC++ORGCwC4+Kldxu4IoCCYg7udweFXewIa2d0LQQtxZQrqxR9vv6uAoWYK10nuGz0zd6fSLhu1d1KLpwGmW31sYNjmvCUHun43uQks/oZpKp3JHo46ql7y1qFP7hw5SEFfqRuMvI09SVxztsEWwZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945764; c=relaxed/simple;
	bh=hM6kCd0JEMomFqVPLkQHZHy9e9LSvD93d/j3Ycj3W9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3n6KnZTUzSigWpEC/QW0h6Vth8c9iHb+kg3RUAp36Zx8OmeIPcWhMgBAi2cIjMvCnJAQYCyTJa9NMeARUDPNhrrhiJARiFxC2IGtMFHv4ks8SpqI9eBd3Sie/Lt1RS41UMKVPGtzCF7qv/JwgM3OehvoLNGyQPMLl42Jb23tgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqoxWesk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqoxWesk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685AEC4CEE3;
	Tue, 29 Apr 2025 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945764;
	bh=hM6kCd0JEMomFqVPLkQHZHy9e9LSvD93d/j3Ycj3W9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqoxWeskMpFvBTr2FwfBgHFLQmDBBMaM9W8Fw2fSbyPY678Lw5FkWo5AtNW+U1WCB
	 3vABbwYP7+BpCoO0TaMXyLT4lhTDNbvoNemh9MjjlXiENIzk5MoqdH8WwQo8sipdBZ
	 KOlCTAOFtjCCj5TM6jKjtyvSVIv8avc3waJeJmxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 041/311] cpufreq: cppc: Fix invalid return value in .get() callback
Date: Tue, 29 Apr 2025 18:37:58 +0200
Message-ID: <20250429161122.708870767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 8f512448382f4..ba7c16c0e4756 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -749,7 +749,7 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 	int ret;
 
 	if (!policy)
-		return -ENODEV;
+		return 0;
 
 	cpu_data = policy->driver_data;
 
-- 
2.39.5



