Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFF926F2A7;
	Mon, 18 Aug 2025 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521891; cv=none; b=RfYoJbJGHOlEe1G0cWepZ8D+M2h8OiKDJOG/etn9McZgHrnztzWnUyv8XeOdfrJqixYxB4r1z4gYXx0N9t8+otA1rUeBRk3bV97Zh7XfNPJCZpMmJa/VGpJAYUQUdB6BXIfl5DT3sqAXAk5VXnRQTi74F8g5KjSyRD4yPsZYGDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521891; c=relaxed/simple;
	bh=1CdeQAkF6YBMXg96O2iw7r3eOFGsUG+FipFz+Ri6ftg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0Xa6qL19wJZrHdIOdTpk2DZhtkd/kSeSBTLILhYfO+oIpbpzBxqWiOzKzml1gFcZgm+dUGk0mZqe+T9na0wDAFJro/QkJOU0cbCs1Tsx7S747KmQdmUFrNz09MHQ2+IixqAG8XIqWLTAbIHHXsXZBduVITDXUhIFczG3lOkaxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Plo0suiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Plo0suiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E020BC4CEEB;
	Mon, 18 Aug 2025 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521891;
	bh=1CdeQAkF6YBMXg96O2iw7r3eOFGsUG+FipFz+Ri6ftg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Plo0suiT+VK4ujdRAqRq55dx9eBXKd5RWHJUjBor4uq+fJM4haKTfpYH26yOOnjcz
	 xXrNebdqD9SSrEV2mHghk/GWlR9FQpwtlICjFkGSYzGzKdPxtG2Qhj+ZavkQArRbAU
	 Dg2rzTBq3HIltyo/M5aHaiD8rzmJHNLIFbwfIGfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/444] cpufreq: Exit governor when failed to start old governor
Date: Mon, 18 Aug 2025 14:42:16 +0200
Message-ID: <20250818124453.060406903@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 0ae204405095abfbc2d694ee0fbb49bcbbe55c57 ]

Detect the result of starting old governor in cpufreq_set_policy(). If it
fails, exit the governor and clear policy->governor.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-5-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fab94ffcb22c..bd55c2356303 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2724,10 +2724,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("starting governor %s failed\n", policy->governor->name);
 	if (old_gov) {
 		policy->governor = old_gov;
-		if (cpufreq_init_governor(policy))
+		if (cpufreq_init_governor(policy)) {
 			policy->governor = NULL;
-		else
-			cpufreq_start_governor(policy);
+		} else if (cpufreq_start_governor(policy)) {
+			cpufreq_exit_governor(policy);
+			policy->governor = NULL;
+		}
 	}
 
 	return ret;
-- 
2.39.5



