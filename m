Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340011E1A05;
	Mon, 23 Jun 2025 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715019; cv=none; b=SXVsCU4+tTA3m7NuOs5kxRAKWKhqHWugWNWK8+ebV+veRqoZpL3b5oND2Zot8EOTGE7q7BiXFwu4Hcz7v93NdoCf7lrr1NZi8jxTLfPdV9ev17BA64BOmgDASZGPEg49Vxr1Tvbc0q5Wkc3glgQePSKto+7Lh7Wt8+1BU/d7tPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715019; c=relaxed/simple;
	bh=YXPkIjaKo18GCwllx+9+n5VzIh9ZiU6PrzNHSXndLJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYCA7O5aLq8PRqwSUsw/9BdaUmhMQirC0az+NSWlXGqUhAC2OFnqjwwIOE0VP+4YDDkMA4HVWFx6MlVMbKysXsxBEkGZu+ayukov84+JYulnXTk9SxGRQwDgfsGSBNwy3nW2mdUMxL2iYGPTR14p32SiCfZymQJYNvgmOkLB7VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvto9Fd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvto9Fd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE91C4CEEA;
	Mon, 23 Jun 2025 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715019;
	bh=YXPkIjaKo18GCwllx+9+n5VzIh9ZiU6PrzNHSXndLJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvto9Fd8IZQneXzqcZFHE8WHaRorhaZrz75/Ph+fKt3jW86cwXyd1PKkDVU4Z0brJ
	 /oi3VHKIv2EFL6jx4rxMOfTLGyvSS5NQ7IZL90RK4bj480PRTx7Sypo+lLX109ZXlZ
	 cZZ7s7D43gjATvf8/wtHNNZgIB67GvsJtm2fR9aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/355] cpufreq: Force sync policy boost with global boost on sysfs update
Date: Mon, 23 Jun 2025 15:07:28 +0200
Message-ID: <20250623130634.177670277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 121baab7b88ed865532dadb7ef1aee6e2bea86f5 ]

If the global boost flag is enabled and policy boost flag is disabled, a
call to `cpufreq_boost_trigger_state(true)` must enable the policy's
boost state.

The current code misses that because of an optimization. Fix it.

Suggested-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/852ff11c589e6300730d207baac195b2d9d8b95f.1745511526.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d13139497da44..6294e10657b46 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2637,8 +2637,10 @@ int cpufreq_boost_trigger_state(int state)
 	unsigned long flags;
 	int ret = 0;
 
-	if (cpufreq_driver->boost_enabled == state)
-		return 0;
+	/*
+	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
+	 * make sure all policies are in sync with global boost flag.
+	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver->boost_enabled = state;
-- 
2.39.5



