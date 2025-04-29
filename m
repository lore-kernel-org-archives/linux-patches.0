Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48638FB0;
	Tue, 29 Apr 2025 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947633; cv=none; b=eCy24Vr28QxDRT+0B9PJ6ZQUwkYbevhnYiyCZozsU6GES87Km2gd2VDVauXf2FH9ZSeqAO9aGzmcwU9/Q/qYv0MHeQHqGnf87K7X/XNr0VSAJxNHjhb/hYuxBQ9s1spn5NRpaMmopziszEcklv3Vk5W/S9SniJI5htdTgmlSStk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947633; c=relaxed/simple;
	bh=LlPmK/I+772LHL2II9mCsv9+WjG8Mdh3DPkGeT54B8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfvqCZXPAX2zwEpmKV/6w6VPT+pIz6efAoVeWw1DKqE+1JB6Isezfg5bGJcZf+A9xtXvWXG8UFkf3OYyZE5vcMZX1WLhIDWKInHgUNcWfYqQZPTHgX45lYBrCh9cUzRUGR/6RcRb8v1UB6nZ6WBGFNk8y7+HSN/NV/5vVi1tI2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNT/au8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNT/au8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C184C4CEE3;
	Tue, 29 Apr 2025 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947632;
	bh=LlPmK/I+772LHL2II9mCsv9+WjG8Mdh3DPkGeT54B8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNT/au8FzIO7YzwGMVW4LxOIgUQEevohBc5HwZZw3WbUWAVdYd5p54mBsLWfTDdW8
	 AXLjcugehoSYmEbeEJfG7J+DG1JG9dCElHFzr7TjfxTVOe8az4im6tjzxHnGf1GblZ
	 lCQFL8qGJI7zxuAknul4en13KWxVadlLPjTtZb7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/280] cpufreq: cppc: Fix invalid return value in .get() callback
Date: Tue, 29 Apr 2025 18:39:58 +0200
Message-ID: <20250429161117.450159070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index c1cdf0f4d0ddd..36ea181260c7e 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -767,7 +767,7 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpu)
 	int ret;
 
 	if (!policy)
-		return -ENODEV;
+		return 0;
 
 	cpu_data = policy->driver_data;
 
-- 
2.39.5



