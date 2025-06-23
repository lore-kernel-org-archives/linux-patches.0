Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D35270838;
	Mon, 23 Jun 2025 21:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712975; cv=none; b=XIuuPmAeKe82brXx+FfN57NGkErm7jksWpykBJ39ALU2m+CgW9rVfoH3SKZGupXphGYrzPFtMQdTzw7NxYRJ7S7NFLd4zgPot5iSnDWpyI78hMYoDa3MH/QZk0g7D/MtntVsTDr9Dc3TAzubPqpx/q2lTcM1OThI7qh75Kp76CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712975; c=relaxed/simple;
	bh=MIHAvzo1JtF5w3hQdS/wIF5VWkqrpUewSb/kKAmJ9ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6zEQjYlGsFIk4Axn6PXMTI8LBA754K/CG/I+bd8ab/1VZ6btEGdobUSCbiO7vlB+BbqkisRNpRan9M8TNDN6/WrxedaQ9LnxrzKnOo5UdqxTdh0gD4XyD2iJ4NBA7lN1OU8eanVO+IqjxYvxcgbQYnqiE+lqZLBUoXJ3J5gYBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnzEj4Jv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnzEj4Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F343AC4CEEA;
	Mon, 23 Jun 2025 21:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712975;
	bh=MIHAvzo1JtF5w3hQdS/wIF5VWkqrpUewSb/kKAmJ9ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnzEj4JvDcEVxG7KyLD+3qJC19WWIzXK9gx5MVMCvsJUTr3jTdo6RE/rtKrGRJjye
	 NHkz3bX0udfP5b6wmGZ8hOd7F2s7igIFV7VQe4mLqKFv9ICmRVd+DQirdpvrytWNG1
	 S9ocMzdRhNGsTPJM5kVR3GpWwGEGuNGQPZU+xTFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/222] cpufreq: Force sync policy boost with global boost on sysfs update
Date: Mon, 23 Jun 2025 15:08:13 +0200
Message-ID: <20250623130616.834189642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 09510ff16ee2f..2a2fea6743aa6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2580,8 +2580,10 @@ int cpufreq_boost_trigger_state(int state)
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



